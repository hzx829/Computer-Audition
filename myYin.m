function [pitch, ap_pwr, rms] = myYin(wavData, fs, tHop, tW, f0Min, f0Max, dp_th)
% My YIN implementation of Step 1-5.
% The first estimate is performed at time 0 (i.e. the first integration
% window is from the first sample to time tW, which means the window is
% centered at tW/2) and the following estimates are spaced by tHop.
%
% Input
%   - wavData       : input single-channel audio wave (a column vector)
%   - fs            : sampling rate of wavData
%   - tHop          : time interval between two adjacent estimates in second (default 0.01)
%   - tW            : integration window size in second (default 0.025)
%   - f0Min         : lowest possible F0 in Hz (default 40)
%   - f0Max         : highest possible F0 in Hz (default 400)
%   - dp_th         : the threshold of dips of d_prime(default 0.1)
% Output
%   - pitch         : estimated pitches (a row vector)
%   - ap_pwr        : the corresponding d_prime, which is approximatedly
%                       the aperiodic power over the total signal power. 
%                       It can be used as the salience of this pitch
%                       estimate.
%   - rms           : the RMS value of the signal in the integration
%                       window, which can also be used to determine if
%                       there is a pitch in the signal or not.
%
% Author: Zhixian
% Created: Zhiyao


% default parameters for speech
if nargin<7 dp_th=0.1; end
if nargin<6 f0Max=400; end
if nargin<5 f0Min=40; end
if nargin<4 tW=0.025; end
if nargin<3 tHop=0.01; end

% Start your implementation here

%step2
%lag_min = f0Min;
lag_min = 0;
lag_max = floor(fs/f0Min);
lag = lag_min:lag_max;
% [d_2_tHop,RMS] = d_tHop(wavData,lag,fs,tHop,tW);%col vector is t_lag,row vector is W shifting 

%step3
disp('Waiting seconds ');
d_3_tHop = d_tHop_3_fast(wavData,lag,fs,tHop,tW);
% d_3_tHop = d_tHop_3(wavData,lag,fs,tHop,tW);
%d_3_tHop = d_tHop_n(wavData,lag,fs,tHop,tW);

%step 4
[row,col] = size(d_3_tHop);
pitch_4 = zeros(1,row);
for i = 1:row
    for j = 2:col %except lag = 0
        if d_3_tHop(i,j) < dp_th && (j>ceil(fs/f0Max))
            pitch_4(i) = fs/j;
            break;
        end
    end
end

%step 5 
pitch_max =zeros(1,row);
% d3_min = 1;
for i = 1:row
    for  j = 2:col-1 %except lag = 0
        if (d_3_tHop(i,j) < dp_th) && (j > 40)
            x_inter_p = [fs/(j-1),fs/j,fs/(j+1)];
            y_inter_p = [d_3_tHop(i,j-1),d_3_tHop(i,j),d_3_tHop(i,j+1)];
            pitch_max(i) = interp_p(y_inter_p,x_inter_p);
            break;
        end
%         if d_3_tHop(i,j) <d3_min
%             d3_min = d_3_tHop(i,j);
%         end
    end
%     d3_min = 1;
%     pitch_max(i) = interp_p(y_inter_p,x_inter_p);
end

ap_pwr = zeros(1,row);
for i = 1:length(ap_pwr)
    if pitch_4(i) == 0
        ap_pwr(i) = -1;
    else
        ap_pwr(i) = d_3_tHop(i,round(fs/pitch_4(i)));
    end
end

pitch = pitch_4;
%pitch = pitch_max

row_t_e_W = floor((length(wavData)- max(lag)-ceil(tW*fs) + tHop*fs)/fs/tHop);
RMS_tHop = zeros(1,row_t_e_W);
for i = 2:row_t_e_W 
    RMS_tHop(i) = sqrt(sum(wavData( round((i-1)*tHop*fs) : round((i-1/fs)*tHop*fs) ).^2)/(tHop*fs)); 
end
rms = RMS_tHop;
    
