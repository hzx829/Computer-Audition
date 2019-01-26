warning off all;

wavData =audioread('violin.wav');
wavData_n = audioread('violin_noise.wav');
wavData_p = audioread('violin_bassoon.wav');
load('violin_gt_pitch.mat','pitch_gt');
fs = 22100;
fs_p = 44100;
tHop = 0.01;
tW = 0.0464;
f0Min = 40;
f0Max = 2000;
dp_th = 0.1;



[pitch, ap_pwr, rms] = myYin(wavData, fs, tHop, tW, f0Min, f0Max, dp_th);

[Acc, Pre, Rec] = evalSinglePitch(pitch, pitch_gt);
disp('%%%%%%%%%%%%%%%');
disp(['accuracy of pitch :' , num2str(Acc)]);
disp(['precision of pitch :' , num2str(Pre)]);
disp(['recall of pitch:' , num2str(Rec)]);


t = 0:0.01:(length(pitch)-1)*0.01;
figure(1);
plot(t,pitch);
title('pitch vs time');
xlabel('time');
ylabel('pitch');


figure(2);
plot(t,ap_pwr);
title('ap-pwr vs time');
xlabel('time');
ylabel('ap_pwr');


figure(3);
plot(t,rms);
title('rms vs time');
xlabel('time');
ylabel('rms');

%set some pitch to 0
pitch_f = pitch;
for i = 1:length(rms)
    if ~(rms(i) > 0.0112)% Threshold is from observation
        pitch_f(i) = 0;
    end
end


figure(4);
plot(t,pitch_f);
title('pitch(final) vs time');
xlabel('time');
ylabel('pitch');


[pitch_n, ap_pwr_n, rms_n] = myYin(wavData_n, fs, 0.01, 0.0464, 40, 2000, 0.55);%0.55 thr
[Acc_n, Pre_n, Rec_n] = evalSinglePitch(pitch_n, pitch_gt);
disp('%%%%%%%%%%%%%%%');
disp(['accuracy of pitch_noise :' , num2str(Acc_n)]);
disp(['precision of pitch :' , num2str(Pre_n)]);
disp(['recall of pitch:' , num2str(Rec_n)]);


t = 0:0.01:(length(pitch_n)-1)*0.01;
figure(5);
plot(t,pitch_n);
title('pitch-noise vs time');
xlabel('time');
ylabel('pitch');


figure(6);
plot(t,ap_pwr_n);
title('ap-pwr-noise vs time');
xlabel('time');
ylabel('ap_pwr');


figure(7);
plot(t,rms_n);
title('rms-noise vs time');
xlabel('time');
ylabel('rms');

%set some pitch to 0
pitch_n_f = pitch_n;
for i = 1:length(rms_n)
    if ~(rms_n(i) > 0.05544)% Threshold is from observation
        pitch_n_f(i) = 0;
    end
end


figure(8);
plot(t,pitch_n_f);
title('pitch-noise(final) vs time');
xlabel('time');
ylabel('pitch');

disp('%%%%%%%%%%%%%%%');


disp('the performance of myYin function drops significantly from the noiseless violin recording to the noisy recording')
disp('%%%%%%%%%%%%%%%');

disp('I can hear melody clearly with noise.');
disp('I can see where the pitches are through sepctrogram');
disp('To get better estimation,I think we can use high-pass filter to deal with wavData');
disp('The results show high-pass filter works');
figure(9);
spectrogram(wavData_n,hamming(tW*fs),tHop*fs,'yaxis')
% 
% figure(10);
% spectrogram(wavData,hamming(tW*fs),tHop*fs,'yaxis')
% 
% 
wavData_n_fir = fir_hpf(wavData_n,fs,18,2000,45);
% figure(11);
% spectrogram(wavData_n_fir,hamming(tW*fs),tHop*fs,'yaxis')
% audiowrite('violin_noise_filter.wav',wavData_n_fir,fs);
% 
[pitch_fi, ap_pwr_fi, rms_fi] = myYin(wavData_n_fir, fs, 0.01, 0.0464, 40, 2000, 0.4);

[Acc_fi, Pre_fi, Rec_fi] = evalSinglePitch(pitch_fi, pitch_gt);
disp('%%%%%%%%%%%%%%%');

disp(['accuracy of pitch_noise with filter :' , num2str(Acc_fi)]);
disp(['precision of pitch with filter:' , num2str(Pre_fi)]);
disp(['recall of pitch with filter:' , num2str(Rec_fi)]);
disp('the figures are coming');

% wavData_n_fir = fir_bpf(wavData_n,fs,3000,2000,100,60);
% figure(11);
% spectrogram(wavData_n_fir,hamming(tW*fs),tHop*fs,'yaxis')
% audiowrite('violin_noise_filter.wav',wavData_n_fir,fs);
% 
% [pitch_fi, ap_pwr_fi, rms_fi] = myYin(wavData_n_fir, fs, 0.01, 0.0464, 40, 2000, 0.4);
% 
% [Acc_fi, Pre_fi, Rec_fi] = evalSinglePitch(pitch_fi, pitch_gt);


[pitch_p, ap_pwr_p, rms_p] = myYin(wavData_p, fs_p, 0.01, 0.0464, 40, 2000, 0.1);

% set some pitch to 0
pitch_p_f = pitch_p;
for i = 1:length(rms_p)
    if ~(rms_p(i) > 0.03277)% Threshold is from observation
        pitch_p_f(i) = 0;
    end
end

t = 0:0.01:(length(pitch_p)-1)*0.01;
figure(12);
plot(t,pitch_p_f);
title('pitch poly vs time');
xlabel('time');
ylabel('pitch');
disp('%%%%%%%%%%%%%%%');
disp('the pitch contour is reasonable,and the algorithm detects bassoon');
disp('It is very hard to change some parameters to detect diffrent instruments,because k*T_bassoon = n*T_violin');


disp('%%%%%%%%%%%%%%%');
disp('I use the method which is mentioned in the YIN paper Section VI part D');
disp('I assume that pitchs of violin are alaways higher than bassoon,so I can get pitches contour directly.')
disp('To estimate pitches from both instruments.It will cost some time to run');
pitch_v = zeros(1,length(pitch_p));
lag_min = floor(fs_p/f0Max);
lag_max = floor(fs_p/f0Min);
lag = lag_min:lag_max;
threshold = 0.1;%maybe i can find a better one,but i have no time to do it
frame_num = length(pitch_p);
for i = 1:frame_num
    frame_d_cross = d_tHop_cross(wavData_p,lag,fs_p,tHop,tW,i);
    [row,col] = find(frame_d_cross < threshold,1,'first');
    if isempty(row)
        pitch_v(i) = 0;
    else
        if row > col
            pitch_v(i) = pitch_p(i)*row/col;
        else
            pitch_v(i) = pitch_p(i)*col/row;
        end
    end
end



