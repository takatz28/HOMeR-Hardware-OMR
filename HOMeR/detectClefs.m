%-------------------------------------------------------------------------
% Function name:    detectClefs
% Input arg(s):     section, staffspace height, staff lines, clef symbols
% Outputs arg(s):   clef(s) definition, key signature ROI LH boundary
% Description:      Detects clef(s) in the lefthand side of sections, and 
%                   returns the starting column value for key signature
%                   detection
%-------------------------------------------------------------------------
function [clefs, bound] = detectClefs(section, spaceHeight, ...
    staffLines, clefSyms, debug)

    % ROI is from the leftmost edge to 30 times the staff spaceheight
    tempImg = ones(size(section));
    boundary = 1:30*spaceHeight;
    tempImg(:,boundary) = section(:,boundary);
    
    % In the case of piano sheets, the brace is removed before template
    % matching
    if ((max(staffLines) - min(staffLines)) > 10*spaceHeight)
        project_V = sum(~tempImg,1);    
        braceLine = (project_V >= 0.9 * (max(staffLines) - min(...
            staffLines)));
        tempImg(:,braceLine) = 1;
    end

    % Apply closing to ROI to connect dots from bass clef
    z = imclose(~tempImg, strel('rectangle', [5, 6])); % 6 8
    stats = regionprops(z, 'BoundingBox');
    
    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {};
    line = {};    
    edge = [];
    symCount = 1;
    for j = 1:numel(stats)
        % Extract component boundaries
        z = stats(j).BoundingBox;
        h = ceil(z(2))+ceil(z(4));
        w = ceil(z(1))+ceil(z(3));
        if (h < 1)
            h = 1;
        elseif (w < 1)
            w = 1;
        elseif (h >= size(section,1))
            h = size(section,1)-1;
        elseif (w >= size(section,2))
            w = size(section,2)-1;
        end
        boxHeight = ceil(z(2)):h;
        boxWidth = ceil(z(1)):w;
        % Potential clef symbols are chosen based on symbol height 
        % and width
        if ((z(3) >= 2*spaceHeight && z(3) <= 4.5*spaceHeight) ...
            && (z(4) >= 3*spaceHeight && z(4) <= 9.5*spaceHeight))
            % Copy symbol in a temporary image holder
            symTmp = tempImg(boxHeight, boxWidth);
            % Perform template matching with clef dataset
            corr_val = [];
            for jj = 1:length(clefSyms)
                clefTmp = imresize(clefSyms{jj},[length(boxHeight) ...
                        length(boxWidth)]);
                % calculate 2-D correlation between potential clef and 
                % dataset
                corr_val = [corr_val corr2(symTmp, clefTmp)];
            end
            % If the maximum correlation coefficient is >= 0.5, clef
            % parameters are saved
            [corrPct, idx] = max(corr_val);
            if (corrPct >= 0.5)
                symbol{symCount} = symTmp;
                loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                category(symCount) = clefSyms(idx,2);
                type(symCount) = clefSyms(idx,3);
                edge(symCount) = w;
                % New parameters generated based on clef type to be used
                % in phase 3 (reconstruction)
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
                symCount = symCount + 1;
                if (debug == 1)
                    rectangle('Position',stats(j).BoundingBox, ...
                    'EdgeColor','m', 'LineWidth',2);
                end
            end
        end
    end
    % Bound is the starting point of the key signature detection
    bound = max(edge);
    % Combine parameters for complete clef definitions
    clefs = [symbol', loc', category', type', value', line'];
end