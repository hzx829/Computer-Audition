# 1.Implenmentation of YIN algorithm
YIN algorithm is a method to detect the fundamental frequency in an audio signal
http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf
# 2.Onset Detection And Beat Tracking
I achieve both energy-based and spectral-based onset detection.
For beat tracking, first we can get BPM through observing spectrogram( the frequency component which appears at every time intervals).
Now we get both onset and BPM. We use dynamic programming to track beats.
http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.94.8773&rep=rep1&type=pdf

