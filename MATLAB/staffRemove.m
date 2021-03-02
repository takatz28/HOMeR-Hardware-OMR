%-------------------------------------------------------------------------
% Function name:    staffRemove
% Input arg(s):     Binarized image
% Outputs arg(s):   Staffline row locations and lengths
% Description:      Returns location of and thickness of stafflines 
%                   through horizontal projection
%-------------------------------------------------------------------------
function [imgNoStaff] = staffRemove(img_bw, staffLines, staffHeights, ...
    spaceHeight)

    % Invert image to have a white foreground, then eroding before next step
    img_new = ~img_bw;
    img_new = imerode(img_new, strel('disk',1));
    CC = bwconncomp(img_new, 4);
    stats = regionprops(CC, 'BoundingBox', 'Eccentricity', ...
        'Circularity', 'Area');
    idx = [];

    for i = 1:numel(stats)
        % bounding box parameters
        z = stats(i).BoundingBox;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % whole/half notes inside staff heights will be temporarily filled 
        % before staff removal to ensure noteheads will not be degraded  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if  ... % hole length and width based on staff space height ...
            ((((z(3) >= (0.7*spaceHeight)) && z(3) <= (1.75*spaceHeight)) && ...
            (z(4) >= (0.7*spaceHeight) && z(4) <= spaceHeight)) && ...
            ... % half note hole is more eccentric and little less circular
            ((stats(i).Eccentricity >= 0.9 && stats(i).Eccentricity <= 1) && ...
            (stats(i).Circularity >= 0.6 && stats(i).Circularity < 0.9)) || ...
            ... % whole note hole is less eccentric and more circular
            ((stats(i).Eccentricity >= 0.6 && stats(i).Eccentricity <= 0.675) && ...
            (stats(i).Circularity >= 1.05 && stats(i).Circularity < 1.2)))
        
            idx = [idx; i];
        end
    end
    tempImg2 = imdilate(ismember(labelmatrix(CC), idx), strel('disk', 1));
    imgNoStaff = or(tempImg2,img_bw);

    % Staff lines differences are calculated in order to uniquify the lines
    % just before removal.
    staffDiff = [diff(staffLines); 0];
    newSL = staffLines(staffDiff ~= 1);
    
    % Staff removal part: remove white pixel column with no symbol segment 
    % attached on either top or bottom of lines
    for i = 1:length(newSL)
        for j = 1:size(img_bw,2)
            if (unique(imgNoStaff(newSL(i)-staffHeights(i)+1:...
                    newSL(i),j)) == 1)            
                imgNoStaff(newSL(i)-staffHeights(i)+1:newSL(i),j) ...
                = ~(isequal(imgNoStaff(newSL(i)-staffHeights(i)...
                ,j),0) && isequal(imgNoStaff(newSL(i)+1,j),0));
            end
        end
    end
    
    % Put the holes back in the no-staff image
%     tempImg3 = imerode(tempImg2, strel('square',4));
    imgNoStaff = ~xor(imgNoStaff,tempImg2);

end