function [ Wn,Hs] = normWH( W,H )
%normalize W and scale accordingly H
%input
% - W : m*r , nonnegative
% - H : r*n , nonnegative
%output
% - Wn ; m*r ,normalized
% - Hs : r*n .scaled 

[~,r] = size(W);
Wn = W;
Hs = H;
for i = 1 :r
    S = sum(abs(W(:,i)));
    Wn(:,i) = W(:,i)/S;
    Hs(i,:) = H(i,:)*S;
end

end

