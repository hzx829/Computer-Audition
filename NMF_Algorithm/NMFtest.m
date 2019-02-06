function dictionary = NMFtest(audio_name, r , iter, win_len, hop, nfft, bUpdateW,bUpdateH)
% Input
%   - audio_name        : the name of input audio
%   - r         : #columns of W (i.e., #rows of H)
%   - nIter     : #iterations
%   - win_len   : window length(default: 1024)
%   - hop       : hop size(default: 512)
%   - nfft      : the point numbers of fft(default: 1024)
%   - bUpdateW  : update W (bUpdateW==1) or not (bUpdateW==0) (default: 1)
%   - bUpdateH  : update H (bUpdateH==1) or not (bUpdateH==0) (default: 1)
%
% Output
%   - dictionary         : learned W, which can be dictionary of training
%   audio
%   Author :Zhixian Huang
if nargin<8 bUpdateH=1; end
if nargin<7 bUpdateW=1; end
if nargin<6 nfft=1024; end    
if nargin<5 hop=512; end     
if nargin<4 win_len=1024; end   

[input_audio,fs] = audioread(audio_name);

figure(1);
spectrogram(input_audio,win_len,hop,nfft,fs,'yaxis')
title('original input')

[V,~,~] = stft(input_audio, win_len, hop, nfft, fs);
V_amp = abs(V);
V_pha = angle(V);
[m,n] = size(V);
initW = 1+rand(m,r);
initH = 1+rand(r,n);
[W,H,KL] = myNMF(V_amp,r,iter,initW,initH,bUpdateW,bUpdateH); 

dictionary = W;

V_re = W*H.*(exp(1j*V_pha));
[input_rec,t_re] = istft(V_re, win_len, hop, nfft, fs);

figure(2);
spectrogram(input_rec,win_len,hop,nfft,fs,'yaxis')
title('reconstract input')

re_name = char(strcat("re_",audio_name));

show_n = 5;
for i = 1 : show_n
    figure(3);
    subplot(1,show_n,i);
    plot(abs(W(:,i)));
%     view(-90,90)
    axis([0,500,0,0.5]);
    xlabel('Frequency');
    ylabel('Amplitude');
    title(['W',num2str(i)])
    figure(4);
    subplot(show_n,1,i);
    plot(abs(H(i,:)));
    title(['H',num2str(i)])
    xlabel('Frame');
    ylabel('Activation');
end

audiowrite(re_name,input_rec,fs);
