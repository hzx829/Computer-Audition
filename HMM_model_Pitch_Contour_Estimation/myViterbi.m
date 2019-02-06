function path = myViterbi(transMat, loglikeMat, initProb)
% Implementation of the Viterbi algorithm to find the path of states that has the
% highest posterior probability in a finite-state hidden Markov model
% (HMM).
%
% Input
%   - transMat      : the transition probability matrix, P(S_n | S_n-1).
%                       Rows correspond to the starting states; columns
%                       corresond to the ending states. Each row sums to 1.
%                       (size: nState * nState)
%   - loglikeMat    : the log-likelihood matrix of each state to explain
%                       each observation, log( P(O_n | S_n) ) Rows
%                       correspond to states; columns correspond to
%                       observations. (size: nState * nObserv)
%   - initProb      : the initial probability of all states, P(S_0). A
%                       column vector with nState elements.
%
% Output
%   - path          : the best path of states (S_1, ..., S_N) that gives
%                       the maximal posterior probability, P(S_1, ..., S_N
%                       | O_1, ... O_N). A column vector with nObserv elements.
%
% Author: ZHIXIAN HUANG
% Created: 10.10.2018


if nargin<3     % use a uniform distribution if the initial probability is not given
    initProb = ones(size(transMat,1),1)/size(transMat,1); 
end
if size(transMat,1) ~= size(loglikeMat, 1) || size(transMat,1) ~= length(initProb)
    error('The number of states is not consistent in the transition matrix, the likelihood matrix, and the initial probability!');
end


nObserv = size(loglikeMat,2);
path = zeros(1,nObserv);
[~,path] = viterbi(transMat,loglikeMat,path,nObserv,initProb);
end