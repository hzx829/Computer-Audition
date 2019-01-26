function [onset,onsetStrength] = onset_energy(x,win,hop,th)
%Energy-based onset detection
%
%Input
% - x   :       audio waveform
% - win :       window function
% - hop :       window hop size(in samples)
% - th  :       global.threshold to determine onsets
%Output
% - onset :         frame indices of the onsets
% - onsetStregth:   normalized onset strength curve,one value per
% frame,range in [0.1]

M = length(win); %length of window
L = length(x); %length of input audio signal
E_n = floor((L - M)/hop);%length of energy vector
E = zeros(E_n,1);
Deri_E = zeros(E_n- 1,1);
onsetStrength = zeros(E_n- 1,1);
onset = zeros(E_n- 1,1);

for i = 1: E_n
    E(i) = sum((x((i-1)*hop+ 1  :(i-1)*hop+ M ).* win ).^2);
end

for i = 1: E_n- 1
    Deri_E(i) = abs(E(i+1) - E(i));
end

max_de = max(Deri_E);

for i = 1: E_n- 1
    onsetStrength(i) = Deri_E(i)/max_de;
    if onsetStrength(i) > th
        onset(i) = 1;
    end
end
    

end

