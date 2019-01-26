function D = d_tHop_3_fast(wavData,lag,fs,tHop,tW)
%input 
%   - wavData       : input single-channel audio wave (a column vector)
%   - lag           : tau in YIN algorithm
%   - fs            : sampling rate of wavData
%   - tHop          : time interval between two adjacent estimates in second (default 0.01)
%   - tW            : integration window size in second (default 0.025)

% Output
%   - D             : ACF in YIN algorithm


t_e_W_1 = zeros(floor((length(wavData)- max(lag)-ceil(tW*fs) + tHop*fs)/fs/tHop),ceil(tHop*fs)); 
t_e_W_2 = zeros(floor((length(wavData)- max(lag)-ceil(tW*fs) + tHop*fs)/fs/tHop),ceil((tW-tHop)*fs));
[row_t_e_W_1,col_t_e_W_1] = size(t_e_W_1);
[~,col_t_e_W_2] = size(t_e_W_2);
for i = 1:row_t_e_W_1
    t_e_W_1(i,:) = ((i-1)*ceil(tHop*fs)+1):1:((i-1)*ceil(tHop*fs) + col_t_e_W_1);%include the edge of window
    t_e_W_2(i,:) = ((i-1)*ceil(tHop*fs)+1):1:((i-1)*ceil(tHop*fs) + col_t_e_W_2);
end

D = zeros(row_t_e_W_1,length(lag));
D_2 = zeros(row_t_e_W_1,length(lag));

for i = 1:length(lag)
    if lag(i) == 0 
        D(1,i) = 1;
        abandon = sum((wavData(t_e_W_1(1,:)) - wavData(t_e_W_1(1,:)+lag(i))).^2);
        reuse = sum((wavData(t_e_W_2(1,:)) - wavData(t_e_W_2(1,:)+lag(i))).^2);
        D_2(1,i) = abandon + reuse;
    else
        abandon = sum((wavData(t_e_W_1(1,:)) - wavData(t_e_W_1(1,:)+lag(i))).^2);
        reuse = sum((wavData(t_e_W_2(1,:)) - wavData(t_e_W_2(1,:)+lag(i))).^2);
        D_2(1,i) = abandon + reuse;
    end
end

for i = 1:length(lag)
    for j = 2:row_t_e_W_1
        if lag(i) == 0 
            D(j,i) = 1;
            add = sum((wavData(t_e_W_1(j,:)) - wavData(t_e_W_1(j,:)+lag(i))).^2);
            D_2(j,i) = D_2(j-1,i) - abandon + add;
            abandon = sum((wavData(t_e_W_1(j,:)) - wavData(t_e_W_1(j,:)+lag(i))).^2);
        else
            add = sum((wavData(t_e_W_1(j,:)) - wavData(t_e_W_1(j,:)+lag(i))).^2);
            D_2(j,i) = D_2(j-1,i) - abandon + add;
            abandon = sum((wavData(t_e_W_1(j,:)) - wavData(t_e_W_1(j,:)+lag(i))).^2);
            D(j,i) = D_2(j,i)*lag(i)/sum(D_2(j,1:i));
                
        end
    end

end



