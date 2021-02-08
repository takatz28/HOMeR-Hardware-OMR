function [staffLines, staffHeights] = staffDetect(img_bw)

    % A staffline is detected if a row has black pixels which is 
    % at least half the maximum number of black pixels per row
    project_H = sum(img_bw, 2);
    thresh_H = 0.67 * size(img_bw, 2);
    staffLines = find(project_H >= thresh_H);

    % Once staff lines are detected, run-length encoding will be applied
    % to an image with only the stafflines to determine the height of each
    % line
    imgTemp = ones(size(img_bw,1),1);
    imgTemp(staffLines) = 0;
    len = encodeRL(imgTemp');
    staffHeights = len(1:2:end);
    staffHeights = staffHeights(staffHeights ~= 0);

end