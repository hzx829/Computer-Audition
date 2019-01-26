function y = synth_onset(x,frameLen,frameHop,onsets)
%Synthesize each onset as a 1-frame long white noise signal, and add it to
%the original audio signal
%
%Inpu
% - x          : input audio waveform
% - frameLen   : frame length(in samples)
% - frameHop   : frame hop size(in samples)
% - onsets     : detected onsets(in frames)
%Output
% - y          : output audio waveform which is the mixture of x and
%synthesized onset impulses.

noise = zeros(length(x),1);
w_noise = wgn(frameLen,1,0);
L_onsets = length(onsets);

for i = 1 : L_onsets
    noise((i- 1)*frameHop+ 1 : (i-1)*frameHop +frameLen) = onsets(i)* w_noise;
end

y = x + noise;

end
