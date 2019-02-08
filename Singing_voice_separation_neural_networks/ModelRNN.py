


from __future__ import print_function, division, absolute_import, unicode_literals
import six

import os

import numpy as np

import Data
import torch
import torchvision.transforms as transforms 
import torch.nn as nn
import torch.nn.functional as F

import matplotlib.pyplot as plt


class ModelSingleStep(torch.nn.Module):
    def __init__(self, blockSize):
        super(ModelSingleStep, self).__init__()
        self.blockSize = blockSize


        ###################################
        #define layers here
        ###################################
        self.fc1 = torch.nn.Linear(2049,1000)
        self.fc2 = torch.nn.Linear(1000,400)
        self.grucell = torch.nn.GRUCell(400,200)
        self.fc_fuse1 = torch.nn.Linear(600,800)
        self.fc_fuse2 = torch.nn.Linear(800,400)
        self.fc3 = torch.nn.Linear(400,1000)
        self.fc4 = torch.nn.Linear(1000,2049)


        ###################################

        self.initParams()

    def initParams(self):
        for param in self.parameters():
             if len(param.shape)>1:
                 torch.nn.init.xavier_normal_(param)


    def encode(self, x):
        ###################################
        #implement the encoder
        ###################################
        x1 = F.leaky_relu(self.fc1(x))
        x2 = F.leaky_relu(self.fc2(x1))
        h = x2


        ###################################
        return h

    def decode(self, h,h_pre):
        ###################################
        #implement the decoder
        ###################################
        r_output = self.grucell(h,h_pre)
        m1= torch.cat((h,r_output),1)
        m2 = F.leaky_relu(self.fc_fuse1(m1))
        m3 = F.leaky_relu(self.fc_fuse2(m2))
        m4 = F.leaky_relu(self.fc3(m3))
        m5 = torch.sigmoid(self.fc4(m4))
        o = m5
        

        ###################################
        return o,r_output
    
    def forward(self, x,h_pre):
        #glue the encoder and the decoder together
        h = self.encode(x)
        o,r_output = self.decode(h,h_pre)
        return o,r_output

    

    def process(self, magnitude):
        #process the whole chunk of spectrogram at run time
        result= magnitude.copy()
        with torch.no_grad():
            nFrame = magnitude.shape[1]
            for i in range(nFrame):
                result[:,i] = magnitude[:,i]*self.forward(torch.from_numpy(magnitude[:,i].reshape(1,-1))).numpy()
        return result 



if __name__ == "__main__":
    blockSize = 4096
    hopSize = 2048

    #Path to the dataset, modify it accordingly
    PATH_DATASET = '/Users/huangzhixian/Desktop/computer audition/DSD100/'
    
    #how many audio files to process fetched at each time, modify it if OOM error
    batchSize= 8 

    #path to save the model
    savedFilename = "ModelRNN.pt"

    #initialize dataloader, every sample loaded will go thourgh the following preprocessing pipeline
    transform = transforms.Compose([
        #Randomly rescale the training data
        Data.Transforms.Rescale(0.8, 1.2),

        #Randomly shift the beginning of the training data, because we always do chunking for training in this case
        Data.Transforms.RandomShift(44100*30),

        #transform the raw audio into spectrogram
        Data.Transforms.MakeMagnitudeSpectrum(blockSize=4096, hopSize = 2048),

        #shuffle all frames of a song for training the single-frame model , remove this line for training a temporal sequence model
        Data.Transforms.ShuffleFrameOrder()]
        )


    #initialize the dataset 
    #workers will restart after each epoch, which takes a lot of time. repetition =8  repeats the dataset 8 times in order to reduce the waiting time
    dataset = Data.DSD100Dataset(PATH_DATASET, testSet = False, mono =True, transform = transform, repetition = 8)

    #initialize the data loader
    #num_workers means how many workers are used to prefetch the data, reduce num_workers if OOM error
    dataloader = torch.utils.data.DataLoader(dataset, batch_size = batchSize,shuffle=False, num_workers = 2, collate_fn = Data.collate_fn)

    #initialize the Model
    model = ModelSingleStep(blockSize)


    #if you want to restore your previous saved model
    if os.path.exists(savedFilename):
        model.load_state_dict(torch.load(savedFilename))

    #determine if cuda is available
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    #device = torch.device("cpu")
    model.to(device)
    


    #initialize the optimizer for paramters
    optimizer = torch.optim.Adam(model.parameters(), lr = 1e-4)

    model.train(mode=True)

    #################################### 
    #Implement your training loop here
    #################################### 

    for epoc in range(100):

        #Each time we fetch a batch of samples from the dataloader
        for idx, sample in enumerate(dataloader):
            #the progress of training in the current epoch
            print("percent",idx/len(dataloader))
            #Remember to clear the accumulated gradient each time you perfrom optimizer.step()
            model.zero_grad()

            #read the input and the fitting target into the device
            mixture = sample['mixture'].to(device)
            target = sample['vocal'].to(device)

            #mixture and target now both have the same shape (batchSize, window length, sequenceLength)
            seqLen = mixture.shape[2]
            winLen = mixture.shape[1]
            currentBatchSize = mixture.shape[0]

            #store the result for the first one for debugging purpose
            result = torch.zeros((winLen, seqLen), dtype=torch.float32)

            #And more......
            #You can use mixture[:, :, stepBegin: stepEnd] to assess a range of frames
            mixture=mixture.view(seqLen,currentBatchSize,winLen)
            output = []#list
            GRUout = []
            #loss = torch.zeros((seqLen,currentBatchSize),device=device)
            loss_sum =[]
            #print(output.device)
            #print(GRUout.device)
            #print(mixture.device)
            for i in  range(seqLen):
                flag_detach = i%50
                
                if i == 0:
                    outp,GRUo = model.forward(mixture[i,:,:],None)
                    output.append(outp)
                    GRUout.append(GRUo)
                else:
                    outp,GRUo = model.forward(mixture[i,:,:],GRUout[i-1])
                    output.append(outp)
                    GRUout.append(GRUo)
                    if flag_detach==49:
                        x = target[:,:,i]
                        y = output[i][:,:]*mixture[i,:,:]
                        loss_t=(x+1e-6)*(torch.log(x+1e-6)-torch.log(y+1e-6))-x+y
                        
                        loss = torch.sum(loss_t)
                        loss.backward()
                        optimizer.step()
                        model.zero_grad()
                        for k in range(50):

                            GRUout[i-k].detach_()
                
                
                
                #if i % 1000 == 0 and i!=0:
                #open("file_lossRNN.txt",'a')
                #np.savetxt("file_lossRNN.txt",loss.detach().numpy(),delimiter=',')
                print("i %d"%(i))

                    


        #plot the first one in the batch for debuging purpose
        # plt.subplot(3,1,1)
        # plt.pcolormesh(np.log(1e-4+result), vmin=-300/20, vmax = 10/20)
        # plt.title('estimated')

        # plt.subplot(3,1,2)
        # plt.pcolormesh(np.log(1e-4+target.cpu()[0,:,:].numpy()), vmin=-300/20, vmax =10/20)
        # plt.title('vocal')
        # plt.subplot(3,1,3)

        # plt.pcolormesh(np.log(1e-4+mixture.cpu()[0,:,:].numpy()), vmin=-300/20, vmax = 10/20)
        # plt.title('mixture')

        # plt.savefig("result_feedforward.png")
        # plt.gcf().clear()

        #save the model to savedFilename
        torch.save(model.state_dict(), savedFilename)


