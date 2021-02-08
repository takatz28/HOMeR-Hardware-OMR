% function [clefs, bound] = findClefs(section, spaceHeight, staffLines)
function [clefs, bound] = detectClefs(section, spaceHeight, staffLines, clefSyms)

%     figure;
    tempImg = ones(size(section));
%     clefSyms = readDataset('clefs');
    boundary = 1:40*spaceHeight;
    tempImg(:,boundary) = section(:,boundary);
    
    if ((max(staffLines) - min(staffLines)) > 10*spaceHeight)
        project_V = sum(~tempImg,1);    
        firstBarLine = (project_V >= 0.9 * (max(staffLines) - min(staffLines)));
        tempImg(:,firstBarLine) = 1;
    end
%     imshow(tempImg); impixelinfo; pause;

%     pause;
    
    z = imclose(~tempImg, strel('rectangle', [5 6])); % 6 8
%     imshow(z); pause;
%     z = imopen(z, strel('square',1));
    stats = regionprops(z, 'BoundingBox');
    
    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {};
    line = {};
    
    edge = [];
%     hold on;
    symCount = 1;
    for j = 1:numel(stats)
        z = stats(j).BoundingBox;
        if (z(1) < 1)
            z(1) = 1;
        elseif (z(2) < 1)
            z(2) = 1;
        elseif (z(3) > size(section,1))
            z(3) = size(section,1);
        elseif (z(4) > size(section,2))
            z(4) = size(section,2);
        end
        h = ceil(z(2))+ceil(z(4));
        w = ceil(z(1))+ceil(z(3));
        boxHeight2 = floor(z(2)):(h-1);
        boxWidth2 = floor(z(1)):(w-1);
        corr_val = [];

        if ((z(3) >= 2*spaceHeight && z(3) <= 4.5*spaceHeight) ...
            && (z(4) >= 3*spaceHeight && z(4) <= 9.5*spaceHeight))
            symTmp = tempImg(boxHeight2, boxWidth2);
%                 pause;
            for jj = 1:length(clefSyms)
                clefTmp = imresize(clefSyms{jj},[length(boxHeight2) ...
                        length(boxWidth2)]);
                corr_val = [corr_val corr2(symTmp, clefTmp)];
%                 corr2(symTmp, clefTmp)
%                 imshowpair(symTmp, clefTmp, 'montage');
%                 pause;
            end
            [corrPct, idx] = max(corr_val);
            if (corrPct >= 0.5)
                rectangle('Position',stats(j).BoundingBox, ...
                    'EdgeColor','m', 'LineWidth',2);
                symbol{symCount} = symTmp;
                loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                category(symCount) = clefSyms(idx,2);
                type(symCount) = clefSyms(idx,3);
                edge(symCount) = w;
                if (strcmp(cell2mat(clefSyms(idx,3)),'treble'))
                    value(symCount) = {'G4'};
                    line(symCount) = {4};
                elseif (strcmp(cell2mat(clefSyms(idx,3)),'bass'))
                    value(symCount) = {'F3'};
                    line(symCount) = {2};
                elseif (strcmp(cell2mat(clefSyms(idx,3)),'alto'))
                    value(symCount) = {'C4'};
                    line(symCount) = {3};
                end  
% loc{symCount,4}
                symCount = symCount + 1;                
            end
%         else
%             z(3)
%             z(4)
%             tempImg(boxHeight2, boxWidth2) = 1;
%         pause;
        end
    end
%     max(loc(4))
    bound = max(edge);
%     bound
%     imshow(tempImg); pause;
    clefs = [symbol', loc', category', type', value', line'];
%     close;
end