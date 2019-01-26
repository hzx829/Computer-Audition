function [S,beats] = opt_beat(beats,beat_num,lambda,tempoExpected,onsetStrength)
%calculate S(B) by recursion
% - beats           :beats sequence
% - frame_num       :which frame is now
% - lambda          :penalty coefficient
% - tempoExpected   :the rough beat speacing(frame unit£©
% - onsetStrength   :spectral onsetStrength

frame = length(onsetStrength);
    if beat_num == 1
    %     p_final = 0;
        p_max = 0;
        for i = 1 : frame
            if onsetStrength(i) > p_max
                p_max = onsetStrength(i);
                beats(beat_num) = i;
            end
        end
        S = p_max;
    end
    
    if beat_num == 2
        p_max = 0;
        [d ,beats] = opt_beat(beats(1),1,lambda,tempoExpected,onsetStrength);

        for i = 1 : frame
            if isempty(beats(beats == i))%make sure that every beats doesn't overlap
                S = onsetStrength(i) + max([0,lambda*(-(log2(abs(i-beats(1))/tempoExpected))^2)+d ]) ;
                if S > p_max
                    p_max = S;
                    beats(beat_num) = i;
                end
            else
                continue;
            end
        end
        S = p_max;
    end


if beat_num > 2
    p_max = 0;
    [d ,beats] = opt_beat(beats(1:beat_num-2),beat_num-2,lambda,tempoExpected,onsetStrength);


    if beats(1) - 1 > tempoExpected
        
        for i = 1 : beats(1)
            if isempty(beats(beats == i))%make sure that every beats doesn't overlap
                S = onsetStrength(i) + max([0,lambda*(-(log2(abs(i-beats(1))/tempoExpected))^2)+d ]) ;
                if S > p_max
                    p_max = S;
                    beats(beat_num-1) = i;
                end
            else
                continue;
            end
        end
    else
        for i = beats(beat_num-1): frame
            if isempty(beats(beats == i))%make sure that every beats doesn't overlap
                S = onsetStrength(i) + max([0,lambda*(-(log2(abs(i-beats(beat_num-1))/tempoExpected))^2)+d ]) ;
                if S > p_max
                    p_max = S;
                    beats(beat_num-1) = i;
                end
            else
                continue;
            end
        end
    end
    beats = sort(beats);
    d = p_max;
    
    if frame - beats(beat_num-1) > tempoExpected
        for i = beats(beat_num-1): frame
            if isempty(beats(beats == i))%make sure that every beats doesn't overlap
                S = onsetStrength(i) + max([0,lambda*(-(log2(abs(i-beats(beat_num-1))/tempoExpected))^2)+d ]) ;
                if S > p_max
                    p_max = S;
                    beats(beat_num) = i;
                end
            else
                continue;
            end
        end
    else
        for i = 1 : beats(1)
            if isempty(beats(beats == i))%make sure that every beats doesn't overlap
                S = onsetStrength(i) + max([0,lambda*(-(log2(abs(i-beats(1))/tempoExpected))^2)+d ]) ;
                if S > p_max
                    p_max = S;
                    beats(beat_num) = i;
                end
            else
              continue;
            end
        end
    end
    beats = sort(beats);
    S = p_max;
    

end

end




