# 1.Implementation of YIN algorithm
YIN algorithm is a method to detect the fundamental frequency in an audio signal
http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf
# 2.Onset Detection And Beat Tracking
I achieve both energy-based and spectral-based onset detection.
For beat tracking, first we can get BPM through observing spectrogram( the frequency component which appears at every time intervals).
Now we get both onset and BPM. We use dynamic programming to track beats.
http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.94.8773&rep=rep1&type=pdf
# 3.Non-negative matrix factorization(NMF) algorithm for audio modeling(Separation of mixture audio)
We take magnitude spectrogram as V, and fatorize it into two matrices W and H, with no negative elements in V,W,H.(V = W*H)
V is m*n, W is m*r, H is r*n. For every column in W, it represents a sound's frequency distribution. For every row in H, it represents a sound's activation in every time frame. For example, for a piece music of piano, W can represent the notes, and Hcan represent these notes' intensity in each time frames.(in this case, r is the numbers of notes in this music piece)We initialize W and H with noise.
We actually can use NMF to do surprivised learning. For a mix audio, we want to seperate it. We learn W1 and W2 from training data, and concancate them into W_mix. 
Now for V_mix, we have V_mix = W_mix * Hmix. 
We do not update W_mix when optimize.
Finally we can get H_mix. 
W1 * H_mix[:r1,:] is magnitude spectrogram of sound 1. 
W2 * H_mix[r1:,:] is magnitude spectrogram of sound 2.
That is what i do in the homework.
https://hal.inria.fr/hal-01631185/document
# 4.Hidden Markov Model for audio modeling(Viterbi algorithm for pitch counter estimation)
What we want to do is to estimate pitch contour.
The provided “female_factory.wav” is a female speech file corrupted by factory noise with SNR=0dB. 
The provided “pitchdata.mat” is an intermediate result of a single pitch estimation algorithm in estimating the female talker’s pitch. 
There are three variables.
“loglikeMat” is the variable that stores the log-likelihood of each pitch hypothesis (state) in each time frame (observation). Given "loglikeMat", one way to estimate the pitch in each frame is to choose the pitch hypothesis that achieves the maximum log-likelihood in that frame. But this method assume pitches in every two frame are indenpdent, which is not reasonable. In fact, the result of this method is not good.
"InitProb" and "TransMat" is other two given variables.The “initProb” is the initial probability of the pitch hypotheses learned from a lot of files of human speech. The “transMat” is the transition probability matrix learned from a lot of files of human speech. Given them, 
we can use Viterbi algorithm to find the best path of states (pitch hypotheses across frames) that gives you the highest posterior probability. In this case, we assume the current pitch is related to the last one pitch. As we expect, the result becomes much better.
# 5.Singing voice separation with neural networks
This homework is to do a traditional signal processing task:separating singing voice from single-channel mixture.First, we transform the singal into its STFT domain.Second, For the magnitude spectrum S_t at the t-th frame, we predict a mask M_t and then calculate the spectrum V_t of the singing voice as:
V_t = M_t·S_t(element-wised multiplication)
We then take such M_t as our generalized Wiener filtering to refine the estimated magnitude spectrogram of singing voice.Finally, we reconstruct the estimated singing voice using our estimated magnitude spectrum and the original mixture's phase with inverse STFT and overlap add. 
I achieve 3 neural network in this homework:1.fully-connected layers. 2.Gated Recurrent Unit(GRU). 3.GRU with delay.


