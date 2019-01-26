function D = d_tHop_cross(wavData,lag,fs,tHop,tW,frame_num)
%EXTENSIONS D

t_e_W_1 = zeros(1,ceil(tHop*fs)); %%%%
t_e_W_2 = zeros(1,ceil((tW-tHop)*fs));
[row_t_e_W_1,col_t_e_W_1] = size(t_e_W_1);
[~,col_t_e_W_2] = size(t_e_W_2);
for i = 1:row_t_e_W_1
    t_e_W_1(i,:) = ((frame_num-1)*ceil(tHop*fs)+1):1:((frame_num-1)*ceil(tHop*fs) + col_t_e_W_1);%include the edge of window
    t_e_W_2(i,:) = ((frame_num-1)*ceil(tHop*fs)+1):1:((frame_num-1)*ceil(tHop*fs) + col_t_e_W_2);
end

D = zeros(row_t_e_W_1,length(lag),length(lag));

for i = 1:1
    for j = 1:length(lag)
        for k =1:length(lag)
             abandon = sum((wavData(t_e_W_1(i,:)) - wavData(t_e_W_1(i,:)+ lag(i)) - wavData(t_e_W_1(i,:)+ lag(j)) +wavData(t_e_W_1(i,:)+ lag(i) + lag(j)) ).^2);
             greuse = sum((wavData(t_e_W_2(i,:)) - wavData(t_e_W_2(i,:)+ lag(i)) - wavData(t_e_W_2(i,:)+ lag(j)) +wavData(t_e_W_2(i,:)+ lag(i) + lag(j)) ).^2);
             D(i,j,k) = abandon + reuse;
        end
    end
end


% for i = 2:row_t_e_W_1
%     for j = 1:length(lag)
%         for k = 1:length(lag)
%             add = sum((wavData(t_e_W_1(i,:)) - wavData(t_e_W_1(i,:)+ lag(i)) - wavData(t_e_W_1(i,:)+ lag(j)) +wavData(t_e_W_1(i,:)+ lag(i) + lag(j)) ).^2);
%             D(i,j,k) = D(i-1,j,k) - abandon + add;
%             abandon = sum((wavData(t_e_W_1(i,:)) - wavData(t_e_W_1(i,:)+ lag(i)) - wavData(t_e_W_1(i,:)+ lag(j)) +wavData(t_e_W_1(i,:)+ lag(i) + lag(j)) ).^2);
%         end
%     end
% end
% 
