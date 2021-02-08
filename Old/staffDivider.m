function [dividers] = staffDivider(img, staffLines, lineHeight, spaceHeight)

    % Assume staves are grand staff:
    % - insert a divider after two staff pairs,
    %   then record indices of staff dividers
    staffLines(find(diff(staffLines) == 1)) = [];
    dividers(1) = max(staffLines(1)-(4*(spaceHeight+lineHeight)), 1);
    
    % if only one staff present, add divider at end
    if (length(staffLines) == 5)
        dividers(2) = max(staffLines(5)+(4*(spaceHeight+lineHeight)), 1);
    else
        for i=10:10:length(staffLines(:))-1
            dividers(end+1) = ceil(staffLines(i) ...
                + ((staffLines(i+1) - staffLines(i)) / 2));
        end
        % Add staff length to indices
        dividers(end+1) = length(img(:,1));

        % --------------------- Grand staff checker ---------------------
        % - if pair of staves is not a grand staff, add a divider 
        staff_thresh = staffLines(10) - staffLines(1);
        for i = 1:(length(staffLines) / 10)
            img_tmp = img(dividers(i):(dividers(i+1)-1),:);
            project_V = sum(img_tmp, 1);
            if (staff_thresh > max(project_V))
                dividers(end+1) = ceil(staffLines((i*10)-5) ...
                    + ((staffLines((i*10)-4) - staffLines((i*10)-5)) / 2));
            end
        end
    end
    
    % Indices must be sorted for subsequent use in other functions
    dividers = sort(dividers);
end