from __future__ import print_function, division, absolute_import, unicode_literals
import six

import os
import numpy as np
import Model_fcn#Model
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
    model = Model_fcn.ModelSingleStep(blockSize)
    #load the pretrained model
    model.load_state_dict(torch.load("Modelfcn.pt",map_location=lambda storage, loc:storage))
    #switch to eval mode
    model.eval()
    
    ###################################
    #Run your Model here to obtain a mask
    ###################################
    spectro_pred = model.process(magnitude)


    ###################################

    #perform reconstruction
    y = util.istft_real(spectro_pred* np.exp(1j* angle), blockSize=blockSize, hopSize=hopSize)

    #save the result
    util.wavwrite(sys.argv[2], y,fs)

