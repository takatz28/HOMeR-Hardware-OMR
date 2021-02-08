function [lineHeight, spaceHeight]= getStaffParam(img)
        
    black_runs=[];
    white_runs=[];

    % perform vertical run-length encoding on the image 
    for i=1:size(img, 2)
        x=img(:,i)';
        len = encodeRL(x);
        black_runs = [black_runs len(1:2:end)];
        white_runs = [white_runs len(2:2:end)];
    end

    % Staffline height is determined by the black run with the most 
    % occurrence
    lines = histcounts(white_runs, 1:max(white_runs));
    [~, lineHeight] = max(lines);

    % Staffspace height is determined by the white run with the most 
    % occurrence
    spaces = histcounts(black_runs, 1:max(black_runs));
    [~, spaceHeight] = max(spaces);

end