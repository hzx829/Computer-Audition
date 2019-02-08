# @author Yujia Yan

from __future__ import print_function, division, absolute_import, unicode_literals
import six
import numpy as np
from scipy.io import wavfile
import scipy.signal 

from matplotlib import pyplot as plt

def wavread(filepath):
    fs, x = wavfile.read(filepath)
    if (len(x.shape)) == 1:
        x = x.reshape(-1,1)
    # print(x.shape)

    if x.dtype != np.float32:
        x = x/np.iinfo(x.dtype).max

    return x,fs

def wavwrite(filepath, x, fs):
    wavfile.write(filepath, fs, x)


def stft_real(x, blockSize, hopSize, window='hamming'):
    # print(x.shape)
    _,_, S = scipy.signal.stft(
            x,
            window = window,
            nperseg=blockSize,
            noverlap = blockSize-hopSize,
            return_onesided=True)
    # print(S.shape)
    return S

def istft_real(S, blockSize, hopSize, window='hamming'):
    _,x = scipy.signal.istft(S, window= window, noverlap= blockSize- hopSize, input_onesided=True)
    return x


if __name__ == "__main__":
    #examples:

    #read a wav file
    x, fs = wavread('piano.wav')
    #downmix to single channel
    x = np.mean(x, axis= -1)
    #stft
    S = stft_real(x, blockSize = 2048, hopSize= 1024)
    print(S.shape)
    #inverse stft
    y = istft_real(S, blockSize = 2048, hopSize= 1024)
    # plt.plot(x-y)
    # plt.show()

    #write to file
    print(y.shape)
    print(x.shape)
    wavwrite("test.wav", y, fs)

