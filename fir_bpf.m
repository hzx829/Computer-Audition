function [y]=fir_bpf(x,fs,fs2,fp2,fp1,fs1)
%该函数采用blackman窗实现带通滤波
%x为输入信号，fs，为采样频率
%fs2,fp2分别为阻带上截至频率和通带上截至频率
%fp1，fs1分别为通带下截止频率和阻带下截至频率
%ps：输入时以上四个滤波参数按从大到小输入即可


%%%%%%%%%%%%%%%%%%%%I learn it from CSDN%%%%%%%%%%%%%%%%%%%%%%%%%%%


%求对应角频率
ws2=fs2*2*pi/fs;
wp2=fp2*2*pi/fs;
wp1=fp1*2*pi/fs;
ws1=fs1*2*pi/fs;


%求滤波器的阶数
B=min(ws2-wp2,wp1-ws1);   %求过渡带宽
N=ceil(12*pi/B);


%计算滤波器系数
wc2=(ws2+wp2)/2;
wc1=(ws1+wp1)/2;
wp=[wc1,wc2];
hn=fir1(N-1,wp,blackman(N));
y=filter(hn,1,x);





