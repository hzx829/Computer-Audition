function [y]=fir_hpf(x,Fs,As,fp,fs)
%�ú�������kaiser����Ƹ�ͨ�˲���
%���룺x �����ź�
%      Fs ����Ƶ��
%      As �����С˥�� 
%      fpͨ����ֹƵ�� fs�����ֹƵ�ʣ���λHz��

%%%%%%%%%%%%%%%%%%%%I learn it from CSDN%%%%%%%%%%%%%%%%%%%%%%%



b=fp-fs;                               % ���ɴ�
M0=round((As-7.95)/(14.36*b/Fs))+2;    % ����
M=M0+mod(M0+1,2);                      % ��֤����Ϊ����
wp=2*fp/Fs*pi; ws=2*fs/Fs*pi;          
wc=(wp+ws)/2;                          % ���ֹƵ��


%��kaiser����ϵ��beta��ֵ
if As>50
    beta=0.1102*(As-8.7);
  elseif As>=21&&As<=50
    beta=0.5842*(As-21)^0.4+0.07886*(As-21);
  else
    beta=0;
end




%�趨�˲�������
N=M-1;                                 %�趨�˲�������
hd=fir1(N,wc,'high',kaiser(M,beta));


%�˲�
x=x-mean(x);                            % ����ֱ������
                           
y=filter(hd,1,x);  



