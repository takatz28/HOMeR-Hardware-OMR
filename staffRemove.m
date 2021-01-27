function [imgNoStaff] = staffRemove(img_bw, staffLines, staffHeights, spaceHeight)

    img_new = ~img_bw;
    img_new = imerode(img_new, strel('disk',1));

    CC = bwconncomp(img_new, 4);
    stats = regionprops(CC, 'BoundingBox', 'Eccentricity', 'Circularity');
    tempImg2 = zeros(size(img_bw));
    
    for i = 1:numel(stats)
        % temporary image to hold open note hole
        tempImg = zeros(size(img_bw));

        % bounding box parameters
        z = stats(i).BoundingBox;
        h = ceil(z(2))+z(4);
        w = ceil(z(1))+z(3);
        
        boxHeight1 = ceil(z(2)):h;
        boxWidth1 = ceil(z(1)):w;
        
        boxHeight2 = ceil(z(2))-1:h+1;
        boxWidth2 = ceil(z(1))-1:w+1;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % whole/half notes inside staff heights are temporarily filled 
        % before staff removal to ensure noteheads will not be degraded  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if  ... % hole length and width based on staff space height ...
			((((z(3) >= (spaceHeight-4)) && z(3) <= (1.75*spaceHeight)) && ...
            (z(4) >= (spaceHeight-4) && z(4) <= spaceHeight)) && ...
            ... % half note hole is more eccentric and little less circular
            ((stats(i).Eccentricity >= 0.9 && stats(i).Eccentricity <= 1) && ...
            (stats(i).Circularity >= 0.6 && stats(i).Circularity < 0.9)) || ...
            ... % whole note hole is less eccentric and more circular
            ((stats(i).Eccentricity >= 0.6 && stats(i).Eccentricity <= 0.675) && ...
            (stats(i).Circularity >= 1.05 && stats(i).Circularity < 1.2)))

            tempImg(boxHeight1, boxWidth1) = img_new(boxHeight1, boxWidth1);
            tempImg = imerode(tempImg, strel('square', 3));
            tempImg = imdilate(tempImg, strel('square', 7));
%             imshow(tempImg); pause;
            tempImg2(boxHeight2, boxWidth2) = tempImg(boxHeight2, boxWidth2);

            rectangle('Position',stats(i).BoundingBox, ...
                    'EdgeColor','r', 'LineWidth',2)
%                 [stats(i).Eccentricity stats(i).Area ...
%                     stats(i).Circularity] 
%             pause
        end
    end
    imgNoStaff = or(tempImg2,img_bw);
%     imshow(imgNoStaff); pause;
    
    % Staff lines differences are calculated in order to uniquify the lines
    % just before removal.
    staffDiff = [diff(staffLines); 0];
    newSL = staffLines(staffDiff ~= 1);
    
    % Staff removal part: remove white pixel column with no symbol segment attached on 
    % either top or bottom of lines
    for i = 1:length(newSL)
        for j = 1:size(img_bw,2)
            if (unique(imgNoStaff(newSL(i)-staffHeights(i)+1:newSL(i),j)) == 1)            
                imgNoStaff(newSL(i)-staffHeights(i)+1:newSL(i),j) ...
                = ~(isequal(imgNoStaff(newSL(i)-staffHeights(i),j),0) && ...
                isequal(imgNoStaff(newSL(i)+1,j),0));
            end
        end
    end
    
    tempImg3 = imerode(tempImg2, strel('square',4));
    imgNoStaff = ~xor(imgNoStaff,tempImg3);

end