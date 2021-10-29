%-------------------------------------------------------------------------
% Function name:    otherSymsHorz
% Input arg(s):     non-note section, staff space/line heights, rest/acci-
%                   dental/dot/tie/slur dataset
% Outputs arg(s):   other symbols and section with detected symbols
% Description:      Detects non-note symbols missed by the vertical symbol
%                   detection
%-------------------------------------------------------------------------
function [otherSymsArr, newSection] = otherSymsHorz(section, stats, ...
    spaceHeight, combinedSyms, dotSyms, tieSlurSyms, debug)
    
    newSection = ones(size(section));
    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {}; 
    symIdx = {};
    symCount = 1;
    
    % Goes through the image based on individual bounding boxes
    for j = 1:numel(stats)
        % Extract component boundaries
        z = stats(j).BoundingBox;
        h = ceil(z(2))+ceil(z(4));
        w = ceil(z(1))+ceil(z(3));
        % Limits the boundaries when it reaches upper/lower bounds
        if (h < 1)
            h = 1;
        elseif (w < 1)
            w = 1;
        elseif (h >= size(section,1))
            h = size(section,1)-1;
        elseif (w >= size(section,2))
            w = size(section,2)-1;
        end
        boxHeight1 = ceil(z(2)):h;
        boxWidth1 = ceil(z(1)):w;
        
        % Isolate component before template matching
        symTmp = section(boxHeight1, boxWidth1);
        % Checks for potential tie/slur first
        if (z(3) > 2*spaceHeight)
            corr_val = [];
            % 2-D correlation template matching with tie/slur dataset
            for jj = 1:length(tieSlurSyms)
                temp = imresize(tieSlurSyms{jj},[length(boxHeight1), ...
                    length(boxWidth1)]);
                corr_val = [corr_val corr2(symTmp, temp)];
            end
            % If the maximum correlation coefficient is >= 0.5, tie/slur
            % parameters are saved                        
            [corrPct, idx] = max(corr_val);
            if (corrPct >= 0.5)
                symbol{symCount} = symTmp;
                loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                category(symCount) = tieSlurSyms(idx,2);
                type(symCount) = tieSlurSyms(idx,3);
                value(symCount) = tieSlurSyms(idx,4);
                symIdx(symCount) = {ceil(z(1))};
                symCount = symCount + 1;    
                if (debug == 1)
                    rectangle('Position',stats(j).BoundingBox, ...
                        'EdgeColor','#77AC30', 'LineWidth',2);
                end
                newSection(boxHeight1, boxWidth1) = symTmp;
            end
        % If not detected as a tie/slur, perform detection similar to 
        % vertical symbol detection
        elseif ((z(3) >= 3 && z(3) <= 3.5*spaceHeight) && ...
            (z(4) >= 3 && z(4) <= 6*spaceHeight))
            % Potential dots
            if(((z(3)-z(4) == 1) || (z(3)-z(4) == -1) || ...
                (z(3)-z(4) == 0)) && ...
                (z(3) < floor(spaceHeight * 0.9) && z(4) < ...
                    floor(spaceHeight * 0.9)))
                corr_val = [];
                % 2-D correlation template matching with dot dataset
                for jj = 1:length(dotSyms)
                    temp = imresize(dotSyms{jj},[length(boxHeight1), ...
                        length(boxWidth1)]); %z(4)+1, z(3)+1]);
                    corr_val = [corr_val corr2(symTmp, temp)];
                end
                % If the maximum correlation coefficient is >= 0.5, dot
                % parameters are saved            
                [corrPct, idx] = max(corr_val);
                if (corrPct >= 0.5)
                    symbol{symCount} = symTmp;
                    loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                    category(symCount) = dotSyms(idx,2);
                    type(symCount) = dotSyms(idx,3);
                    value(symCount) = dotSyms(idx,4);
                    symIdx(symCount) = {ceil(z(1))};
                    symCount = symCount + 1;    
                    if (debug == 1)
                        rectangle('Position',stats(j).BoundingBox, ...
                            'EdgeColor','#77AC30', 'LineWidth',2);
                    end
                    newSection(boxHeight1, boxWidth1) = symTmp;
                end
            % Potential rest/accidental/fermata
            else
                corr_val = [];
                % 2-D correlation template matching with combined dataset
                % (rest/accidental/fermata)
                for jj = 1:length(combinedSyms)
                    temp = imresize(combinedSyms{jj},[length(...
                        boxHeight1), length(boxWidth1)]);
                    corr_val = [corr_val corr2(symTmp, temp)];                    
                end
                % If the maximum correlation coefficient is >= 0.6, symbol
                % parameters are saved
                [corrPct, idx] = max(corr_val);
                if (corrPct >= 0.6)
                    newSection(boxHeight1, boxWidth1) = section(...
                        boxHeight1, boxWidth1);
                    % In the case of flat symbol, the hole is extracted 
                    % to be used in phase 3
                    if (strcmp(cell2mat(combinedSyms(idx,3)), 'flat'))
                        flatImg = ones(size(section));
                        flatImg(boxHeight1, boxWidth1) = section(...
                            boxHeight1, boxWidth1);
                        flatImg = ~xor(imfill(~flatImg, 'holes'), flatImg);
                        flatStats = regionprops(flatImg, 'BoundingBox');
                        z = flatStats(1).BoundingBox;
                        stats(j).BoundingBox = z;
                        h = ceil(z(2))+z(4);
                        w = ceil(z(1))+z(3);
                        boxHeight1 = ceil(z(2)):h;
                        boxWidth1 = ceil(z(1)):w;
                        symTmp = ~flatImg(boxHeight1, boxWidth1);
                    end
                    symbol{symCount} = symTmp;
                    loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                    category(symCount) = combinedSyms(idx,2);
                    type(symCount) = combinedSyms(idx,3);
                    value(symCount) = combinedSyms(idx,4);
                    symIdx(symCount) = {ceil(z(1))};
                    symCount = symCount + 1;
                    if (debug == 1)
                        rectangle('Position',stats(j).BoundingBox, ...
                            'EdgeColor','#77AC30', 'LineWidth',2);
                    end  
                end
            end
        end     
    end
    
    % If they exist, combine parameters for non-note definitions
    if (~isempty(symbol))
        otherSymsTmp = [symbol', loc', category', type', value', symIdx'];
        otherSymsArr = sortrows(otherSymsTmp,6);
    else
        otherSymsArr = [];
    end
end