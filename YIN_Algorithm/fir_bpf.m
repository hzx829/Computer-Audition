function [y]=fir_bpf(x,fs,fs2,fp2,fp1,fs1)
%�ú�������blackman��ʵ�ִ�ͨ�˲�
%xΪ�����źţ�fs��Ϊ����Ƶ��
%fs2,fp2�ֱ�Ϊ����Ͻ���Ƶ�ʺ�ͨ���Ͻ���Ƶ��
%fp1��fs1�ֱ�Ϊͨ���½�ֹƵ�ʺ�����½���Ƶ��
%ps������ʱ�����ĸ��˲��������Ӵ�С���뼴��


%%%%%%%%%%%%%%%%%%%%I learn it from CSDN%%%%%%%%%%%%%%%%%%%%%%%%%%%


%���Ӧ��Ƶ��
ws2=fs2*2*pi/fs;
wp2=fp2*2*pi/fs;
wp1=fp1*2*pi/fs;
ws1=fs1*2*pi/fs;


%���˲����Ľ���
B=min(ws2-wp2,wp1-ws1);   %����ɴ���
N=ceil(12*pi/B);


%�����˲���ϵ��
wc2=(ws2+wp2)/2;
wc1=(ws1+wp1)/2;
wp=[wc1,wc2];
hn=fir1(N-1,wp,blackman(N));
y=filter(hn,1,x);





