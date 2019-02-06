[female_fac,fs] = audioread('female_factory.wav');
load('pitchdata.mat');
frame = size(loglikeMat,2);
estimate_pitch = zeros(1,frame);
%Estimate the pitch in each frame,choosing the pitch hypothesis that
%achieves the maximum log-likelihood in that frame.
for i = 1 : frame 
    [~,estimate_pitch(i)] = max(loglikeMat(:,i));
    estimate_pitch(i) = index2hz(estimate_pitch(i));

end

[s,f,t]= stft(female_fac,1024,160,4*1024,fs);
mag_s= log(abs(s));
imagesc(t,f,mag_s);

 hold on
 plot(t,estimate_pitch,'-');%As you can, the result is not smooth, which not fit the true human talking
 
 
%Use a HMM to get better (smoother) pitch estimates.
viterbi_es = myViterbi(transMat,loglikeMat,initProb);
for i = 1 : frame
    viterbi_es(i) = index2hz(viterbi_es(i));
end



hold on 
plot(t,viterbi_es,'.')%Much more smooth estimation
