function [Acc, Pre, Rec] = evalSinglePitch(pEst, pGT, freqDevTh)
% Evaluate single pitch detection results
%
% Input
%   - pEst      : the pitch estimate in Hz (a row vector)
%   - pGT       : the ground-truth pitch in Hz (a row vector)
%   - freqDevTh : the maximal percentage of Hz that an estimated pitch can be
%                   deviated from the ground-truth pitch such that the
%                   estimated pitch is still judged as a correct estimate.
%                   (Default: 0.03)
% Output
%   - Acc       : estimation accuracy: nC/(nG+nE-nC), i.e. among all
%                   estimated and ground-truth non-zero pitches, what
%                   percentage are correct. 
%   - Pre       : estimation precision: nC/nE, i.e. among all estimated
%                   non-zero pitches, what percentage are correct.
%   - Recall    : estimation recall: nC/nG, i.e. among all ground-truth
%                   non-zero pitches, what percentage are correctly
%                   estimated. 
%
% Author: XXX
% Created: XXX
% Last modified: XXX

if nargin<3 freqDevTh=0.03; end

% Start your implementation here
nE = length(pEst);
nC = 0;
nG = length(pGT);

if nG > nE
    pGT_c = pGT(1:nE);
else
    pGT_c = pGT;
end
Diff = zeros(1,length(pGT_c));
for i=1:length(pGT_c)
    if pGT_c(i) == 0
        if pEst(i) == 0
            Diff(i) = 0;
        end
    else
        Diff(i) = abs((pEst(i) - pGT_c(i)))./abs(pGT_c(i));
    end
end

for i = 1:nE
    if ~(Diff(i) > freqDevTh)
        nC = nC + 1;
    end
end

Acc = nC/(nG+nE-nC);
Pre = nC/nE;
Rec = nC/nG;

        
