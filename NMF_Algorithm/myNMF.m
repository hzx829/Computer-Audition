function [W, H, KL] = myNMF(V, r, nIter, initW, initH, bUpdateW, bUpdateH)
% Implementation of the multiplicative update rule for NMF with K-L
% divergence(In fact, you can also use Euclidean Distance). W should always be normalized so that each column of W sums
% to 1. Scale H accordingly. This normalization step should be performed in
% each iteration, and in initialization as well. This is to deal with the
% non-uniqueness of NMF solutions.
%
% Input
%   - V         : a non-negative matrix (m*n) to be decomposed
%   - r         : #columns of W (i.e., #rows of H)
%   - nIter     : #iterations
%   - initW     : initial value of W (m*r) (default: a random non-negative matrix)
%   - initH     : initial value of H (r*n) (default: a random non-negative matrix)
%   - bUpdateW  : update W (bUpdateW==1) or not (bUpdateW==0) (default: 1)
%   - bUpdateH  : update H (bUpdateH==1) or not (bUpdateH==0) (default: 1)
%
% Output
%   - W         : learned W
%   - H         : learned H
%   - KL        : KL divergence after each iteration (a row vector with nIter+1
%               elements). KL(1) is the KL divergence using the initial W
%               and H.
%
% Created: Zhiyao Duan
% Modified :Zhixian Huang
% Last modified: 10/2/2018

[m,n] = size(V);
if nargin<7 bUpdateH=1; end
if nargin<6 bUpdateW=1; end
if nargin<5 initH = rand(r, n); end     % randomly initialize H
if nargin<4 initW = rand(m, r); end     % randomly initialize W
if r~=size(initW,2) || r~=size(initH,1)
    error('Parameter r and the size of W or H do not match!');
end

% Your implementation starts here...
[W,H] = normWH(initW,initH);
KL = zeros(nIter,1);
for Iter = 1:nIter
    if bUpdateW
        VH = V*H';
        WHH = W*(H*H');
        WH = W*H;
        for i = 1:m
            for a = 1:r
                
                %Euclidean distance
                %W(i,a) = W(i,a) * VH(i,a)/WHH(i,a);
                
                %KL divergence
                HV_WH = 0;
                for u = 1:n
                    HV_WH = HV_WH + H(a,u)*V(i,u)'/WH(i,u);
                end 
                W(i,a) = W(i,a) * HV_WH/sum(H(a,:));
            end
        end
    end
    
    if bUpdateH
        WV = W'*V;
        WWH = W'*W*H;
        WH = W*H;
        for a = 1:r
            for u = 1:n
                
                %Euclidean distance
                %H(a,u) = H(a,u) * WV(a,u)/WWH(a,u);
                
                %KL divergence
                WV_WH = 0;
                for i = 1:m
                    WV_WH = WV_WH + W(i,a)'*V(i,u)/WH(i,u);
                end
                H(a,u) = H(a,u) *WV_WH/sum(W(:,a));
            end
        end
    end
    [W,H] = normWH(W,H);
    WH = W*H;
    kl = V.*log(V./WH) - V +WH;
    KL(Iter) = sum(kl(:));
end



end
