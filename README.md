# 1.Implenmentation of YIN algorithm
YIN algorithm is a method to detect the fundamental frequency in an audio signal
http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf
# 2.Onset Detection And Beat Tracking
I achieve both energy-based and spectral-based onset detection.
For beat tracking, first we can get BPM through observing spectrogram( the frequency component which appears at every time intervals).
Now we get both onset and BPM. We use dynamic programming to track beats.
http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.94.8773&rep=rep1&type=pdf
# 3.Non-negative matrix factorization(NMF) algorithm for audio modeling
We take magnitude spectrogram as V, and fatorize it into two matrices W and H, with no negative elements in V,W,H.(V = W*H)
V is m*n, W is m*r, H is r*n. For every column in W, it represents a sound's frequency distribution. For every row in H, it represents a sound's activation in every time frame. For example, for a piece music of piano, W can represent the notes, and Hcan represent these notes' intensity in each time frames.(in this case, r is the numbers of notes in this music piece)We initialize W and H with noise.
We actually can use NMF to do surprivised learning. For a mix audio, we want to seperate it. We learn W1 and W2 from training data, and concancate them into W_mix. 
Now for V_mix, we have V_mix = W_mix * Hmix. 
We do not update W_mix when optimize.
Finally we can get H_mix. 
W1 * H_mix[:r1,:] is magnitude spectrogram of sound 1. 
W2 * H_mix[r1:,:] is magnitude spectrogram of sound 2.
That is what i do in the homework.
# 4.Hidden Markov Model for audio modeling

