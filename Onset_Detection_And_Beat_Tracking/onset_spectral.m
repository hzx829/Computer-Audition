function [onsets,onsetStrength] = onset_spectral(x,win,hop,th,gamma)
%Spectral-based onset decetion(spectral flux).The spectral flux calculation
%is based on compressed magnitude spectrogram:spectrogram_compressed =
%log(1+ gamma*spectrogram).This is to reduce the dynamic range of the
%spectrogram.
%
%Input
% - x       :audio waveform
% - win     :window function
% - hop     :window hop size(in samples)
% - th      :threshold to determine onsets
% - gamma   :parameter for spectrogram compression
%Output
% - onsets          :frame indices of the onsets
% - onsetStrength:  :normalized onset strength curve,one value per
% frame,range in [0,1]

nff = max(256,2^nextpow2(length(win)));
spec_x = spectrogram(x,win,hop,nff,'yaxis');
spec_x = abs(spec_x);%use magnitude spectro when performing compression
log_sep = log(1+ gamma*spec_x);
[~,col_s] = size(spec_x);
diff_sep = [col_s-1,1];

for i = 1:col_s-1
    diff_sep(i) = abs(sum(log_sep(:,i+1) - log_sep(:,i)));
end
    
mean_diff = mean(diff_sep);
norm_diff = diff_sep - mean_diff;
norm_diff(norm_diff<0) = 0;

onsetStrength = norm_diff/max(norm_diff);
onsets = zeros(col_s-1,1);
for i = 1:col_s-1
    if onsetStrength(i) >th
        onsets(i) = 1;
    end
end

    



end