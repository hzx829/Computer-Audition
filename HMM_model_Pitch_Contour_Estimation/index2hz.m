function hz = index2hz(index)
% input
% - index        :number ,index in given loglikeMat matrix
%output
% - hz          :number ,hz
if index>1
    midi = (index-2)*0.5+35.25;
    hz = 440*2^((midi-69)/12);
else
    hz = 0;
end


end

