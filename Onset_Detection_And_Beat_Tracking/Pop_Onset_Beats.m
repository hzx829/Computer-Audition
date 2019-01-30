%i use a pop music as my example audio signal, you can change it what you want.
%Once you take other audio as input, you may need change the threshold and lambda, also the tempoExpected.

[pop,pop_fs] = audioread('Pop.wav');
win_len = 1024;
hop_size = win_len/2;
threshold_energy = 0.2
threshold_spectral = 0.4
gamma = 1%the defination is in function onset_spectral()

%onset detection based on energy
[onset_pop,onsetS_pop] = onset_energy(pop,hamming(win_len),hop_size,threshold_energy);
figure(1);
barh(onsetS_pop);
title('E_s pop');

%onset detection based on sepctrogram
[onset_spec,onsetS_spec] = onset_spectral(pop,hamming(win_len),hop_size,threshold_spectral,1);
figure(2);
barh(onsetS_spec);
title('S_s pop');


%beat tracking
lambda = 1;
tempoExpected = 135;
beats = beat_dp('Pop.wav',onsetS_spec,tempoExpected,lambda);
len_spec = length(onset_spec);
pop_beats = zeros(len_spec,1);
for i = 1 : len_spec
    if ~(isempty(beats(beats ==i)))
        pop_beats(i) = 1;
    end
end

figure(3);
plot(pop_beats);
title('pop beats');

pop_with_beats = synth_onset(pop,win_len,hop_size,pop_beats);
audiowrite('pop_beats.wav',pop_with_beats,pop_fs);





