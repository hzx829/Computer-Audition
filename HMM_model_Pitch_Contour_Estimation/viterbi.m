function [ v , prev ] = viterbi( transMat, loglikeMat, prev ,T ,initP)
% Input
%   - transMat      : the transition probability matrix, P(S_n | S_n-1).
%                       Rows correspond to the starting states; columns
%                       corresond to the ending states. Each row sums to 1.
%                       (size: nState * nState)
%   - loglikeMat    : the log-likelihood matrix of each state to explain
%                       each observation, log( P(O_n | S_n) ) Rows
%                       correspond to states; columns correspond to
%                       observations. (size: nState * nObserv)
%   - v_before       : v(t-1)
%   - T              : current time
%   - initP          : the initial probability of all states, P(S_0). A
%                       column vector with nState elements.
%
% Output :
%   - v              : the maximum probability when the current state is
%   set 
%   - prev           : the path according to v
%   Author: Zhixian Huang

nState = size(transMat,1);
prev_j = zeros(1,nState);

if T == 1
    v = zeros(1,nState);
    for state_c = 1:nState  %current state
        max_prevj = log(0);
        for state_p = 1:nState  % previous state
            log_p = log(initP(state_p))+ log( transMat(state_p,state_c)) ;
            if log_p > max_prevj
                max_prevj = log_p;
                argmax_prevj = state_p;
            end

        end
        prev_j(state_c) = argmax_prevj;
        v(state_c) = max_prevj + loglikeMat(state_c,T);
    end
    [~,argmax_v] = max(v);
    prev(T) = prev_j(argmax_v);
    
    
end

if T > 1
    [max_v_before,prev] = viterbi(transMat,loglikeMat,prev(1:T-1),T-1,initP);
    for state_c = 1:nState  %current state
        max_prevj = log(0);
        for state_p = 1:nState  % previous state
            
            log_p = max_v_before(state_p)+log(transMat(state_p,state_c));
            if log_p > max_prevj
                max_prevj = log_p;
                argmax_prevj = state_p;
            end
            
        end
        prev_j(state_c) = argmax_prevj;
        v(state_c) = max_prevj + loglikeMat(state_c,T);
    end
    [~,argmax_v] = max(v);
    prev(T) = prev_j(argmax_v);
    
    

end

end

