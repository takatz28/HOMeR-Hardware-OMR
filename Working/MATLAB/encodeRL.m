function [run] = rl_encode(col_in)

    % Return indices where unequal adjacent terms occur
    idx = [find(col_in(1:end-1) ~= col_in(2:end)), length(col_in)];
    % Return difference of adjacent indices
    run = diff([ 0 idx ]);
    
    % Since image is BW, if top pixel is white, let first value be 0
    if (col_in(1) == 1)
        run = [0 run];
    end
end