function beats = beat_dp(wavData,onsetStrength,tempoExpected,lambda)
%beat tracking by dynamic programming.
%
%input 
% - wavData         :the audio signal
% - onsetStrength   :onset strength in each audio frame
% - tempoExpected   :the expected tempo(in BPM)
% - lambda          :tradeoff between the onset strength objectve and beat
% regularity objective
%Output
% - beats           :the estimated beat sequence(in frame number)

[wavform,fs] = audioread(wavData);
frame_num = length(onsetStrength);
beats_len = floor(length(wavform)/fs*tempoExpected/60);
beats = zeros(beats_len,1);
tempoExpected_frame = floor(frame_num/beats_len);

[~,beats] = opt_beat(beats,beats_len,lambda,tempoExpected_frame,onsetStrength);


end
