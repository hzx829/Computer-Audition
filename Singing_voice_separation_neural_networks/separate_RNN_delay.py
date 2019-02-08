from __future__ import print_function, division, absolute_import, unicode_literals
import six

import os
import numpy as np
import Model_delay as model#Model
import torch
import util
import sys


if __name__=="__main__":
    blockSize = 4096
    hopSize = 2048

    if len(sys.argv) != 3:
        print("Usage:\n", sys.argv[0], "input_path output_path")
        sys.exit(1) 

    #read the wav file
    x, fs = util.wavread(sys.argv[1])
    #downmix to single channel
    x = np.mean(x,axis=-1)
    #perform stft
    S = util.stft_real(x, blockSize=  blockSize,hopSize=hopSize)
    magnitude = np.abs(S).astype(np.float32)
    angle = np.angle(S).astype(np.float32)

    #initialize the model
    model = Model_delay.ModelSingleStep(blockSize)
    #load the pretrained model
    model.load_state_dict(torch.load("ModelRNN_delay.pt",map_location=lambda storage, loc:storage))
    #switch to eval mode
    model.eval()

    output = []
    GRUout = []
    h_d = []
    
    
    mag_voice = magnitude.copy()
    with torch.no_grad():
        nFrame = magnitude.shape[1]
        GRUout = []
        for i in range(nFrame):
            h = model.encode(mixture[i,:,:])
            h_d.append(h)
            if i <5:#delay is 5
                    if i == 0:
                        outp,GRUo = model.forward(mixture[i,:,:],None,torch.zeros_like(h))
                        
                    else:
                        outp,GRUo = model.forward(mixture[i,:,:],GRUout[i-1],torch.zeros_like(h))     
            else:
                outp,GRUo = model.forward(mixture[i,:,:],GRUout[i-1],h_d[i-5])
            GRUout.append(GRUo)
            output.append(outp)
            mag_voice[:,i] = magnitude[:,i]* output[i].numpy()

    ###################################

    #perform reconstruction
    y = util.istft_real(mag_voice* np.exp(1j* angle), blockSize=blockSize, hopSize=hopSize)

    #save the result
    util.wavwrite(sys.argv[2], y,fs)

