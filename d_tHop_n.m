function D = d_tHop_n(wavData,lag,fs,tHop,tW)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
t_e_W = zeros(floor((length(wavData)- max(lag)-ceil(tW*fs) + tHop*fs)/fs/tHop),ceil(tW*fs)); %%%%
[row_t_e_W,col_t_e_W] = size(t_e_W);
for i = 1:row_t_e_W
    t_e_W(i,:) = ((i-1)*ceil(tHop*fs)+1):1:((i-1)*ceil(tHop*fs) + col_t_e_W);%include the edge of window
end

D = zeros(row_t_e_W,length(lag));
D_2 = zeros(row_t_e_W,length(lag));

for i = 1:length(lag)
    for j = 1:row_t_e_W
        if lag(i) == 0 
            D(j,i) = 1;
            D_2(j,i) =sum((wavData(t_e_W(j,:)) - wavData(t_e_W(j,:)+lag(i))).^2) + sum(wavData(t_e_W(j,:)) - wavData(t_e_W(j,:)+lag(i)))^2;
        else
            D_2(j,i) = sum((wavData(t_e_W(j,:)) - wavData(t_e_W(j,:)+lag(i))).^2)+ sum(wavData(t_e_W(j,:)) - wavData(t_e_W(j,:)+lag(i)))^2;
            D(j,i) = D_2(j,i)*lag(i)/sum(D_2(j,1:i));
                
        end
    end

end



