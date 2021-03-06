%Get every notes in piano.wav
r_pia = 5;
iter_pia = 50;
W_piano = NMFtest("piano.wav", r_pia , iter_pia);

%learn representation of words from speech_train.wav
disp('learning speech_train, pls wait...');
r_sp = 200;
iter_sp = 100;
W_sp = NMFtest('speech_train.wav',r_sp,iter_sp);

%learn representation of words from noise_train.wav
disp('learning noise_train, pls wait...');
r_noi = 200;
iter_noi = 100;
W_noi = NMFtest('noise_train.wav',r_noi,iter_noi);

% We will use learned W_sp and W_noi to seprate a mix of noise and
% speech. The noise and speech in test(sepration) are different from training. 
disp('separation start, pls wait...');
[noisyspeech,fs_ns] = audioread('noisyspeech.wav');
W_speech = W_sp;
W_noise = W_noi;
speech_col = size(W_speech,2);
noise_col = size(W_noise,2);
r = speech_col + noise_col;
iterations = 100;
win_len = 1024;
hop = 512;
nfft = win_len;
bUpdateW = 0;% we will not change W, since we have already learnt it from training data.
bUpdateH = 1;



[V,~,~] = stft(noisyspeech,win_len,hop,nfft,fs_ns);
V_amp = abs(V);
V_angle = angle(V);
[m,n] = size(V);
initW = [W_speech,W_noise];
initH = 1 + rand(r,n);
[W,H,KL] = myNMF(V_amp,r,iterations,initW,initH,bUpdateW,bUpdateH);
%W_s = W_speech .*(exp(1j*angle(angle_W_s))) *H(1:speech_col,:);


V_speech_r = W_speech * H(1:speech_col,:).*(exp(1j*angle(V)));
V_noise_r = W_noise * H(speech_col+1:speech_col+noise_col,:).*(exp(1j*angle(V)));


%[W_sr,~] = istft(W_s,win_len,hop,nfft,fs_ns);
[speech_s_r,~] = istft(V_speech_r,win_len,hop,nfft,fs_ns);
[noise_s_r,~] = istft(V_noise_r,win_len,hop,nfft,fs_ns);

figure
spectrogram(speech_s_r,win_len,hop,nfft,fs_ns,'yaixs')
title('reconstract speech')

figure
spectrogram(noise_s_r,win_len,hop,nfft,fs_ns,'yaxis')
title('reconstract noise')


audiowrite('speech_sep.wav',speech_s_r,fs_ns);
audiowrite('noise_sep.wav',noise_s_r,fs_ns);
disp('Done!');
%audiowrite('ws.wav',W_sr,fs_ns);