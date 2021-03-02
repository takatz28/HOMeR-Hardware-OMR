%-------------------------------------------------------------------------
% Function name:    detectKeySig
% Input arg(s):     section, staffspace height, staff lines, key symbols,
%                   section count, ROI boundaries
% Outputs arg(s):   Key(s), key signature, next part boundary
% Description:      Detects the sheet music's key signature, and returns
%                   the keys for reconstruction
%-------------------------------------------------------------------------
function [keySig, keys, newTermBound] = detectKeySig(section, ...
    spaceHeight, sectionCount, newStaffLines, initBound, termBound, ...
    keySyms, debug)
    
    % Typical ROI is in between the clef(s) and time signature(s)
    tempImg = ones(size(section));
    boundary = initBound:termBound;
    tempImg(:,boundary) = section(:,boundary);
    
    % Close any symbols that might have been broken during staff removal
    z = imclose(~tempImg, strel('line', 3, 90));
    cc = bwconncomp(z);
    stats = regionprops(cc, 'BoundingBox');
    
    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {};
    symIdx = {};
    edge = [];
    leftBounds = [];
    symCount = 1;

    
    for j = 1:numel(stats)
        % Extract component boundaries
        z = stats(j).BoundingBox;
        h = ceil(z(2))+z(4);
        w = ceil(z(1))+z(3);
        boxHeight = ceil(z(2)):h;
        boxWidth = ceil(z(1)):w;

        % Checks for potential flats or sharps present based on height and
        % width
        if ((z(3) >= 0.75*spaceHeight && z(3) <= 2.25*spaceHeight) && ... 
            (z(4) >= 2*spaceHeight && z(4) <= 3.75*spaceHeight))
            % Each potential key is isolated and copied in a temporary 
            % image holder
            tempImg = ismember(labelmatrix(cc),j);
            symTmp = ~tempImg(boxHeight, boxWidth);
            % 2-D correlation template matching with key signature dataset
            corr_val = [];
            for jj = 1:length(keySyms)
                keyTmp = imresize(keySyms{jj},[length(boxHeight), ...
                    length(boxWidth)]); %z(3)+1]);
                corr_val = [corr_val corr2(symTmp, keyTmp)];
            end
            % If the maximum correlation coefficient is >= 0.5, key
            % parameters are saved
            [corrPct, idx] = max(corr_val);
            if (corrPct >= 0.5)
                % Every right-hand edge of the detected key is saved
                edgeW = w;
                % In the case of flat symbol, the hole is extracted to be
                % used in phase 3
                if (strcmp(cell2mat(keySyms(idx,3)), 'flat'))
                    flatImg = ones(size(tempImg));
                    flatImg(boxHeight, boxWidth) = section(boxHeight, ...
                        boxWidth);
                    flatImg = ~xor(imfill(~flatImg, 'holes'), flatImg);
                    flatStats = regionprops(flatImg, 'BoundingBox');
                    z = flatStats(1).BoundingBox;
                    stats(j).BoundingBox = z;
                    h = ceil(z(2))+z(4);
                    w = ceil(z(1))+z(3);
                    boxHeight = ceil(z(2)):h;
                    boxWidth = ceil(z(1)):w;
                    symTmp = ~flatImg(boxHeight, boxWidth);
                end
                symbol{symCount} = symTmp;
                loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                category(symCount) = keySyms(idx,2);
                type(symCount) = keySyms(idx,3);
                value(symCount) = keySyms(idx,4);
                symIdx(symCount) = {ceil(z(1))};
                edge(symCount) = edgeW+3;
                symCount = symCount + 1;                
                if (debug == 1)
                    rectangle('Position',stats(j).BoundingBox, ...
                        'EdgeColor','r', 'LineWidth',2);
                end
            end
        end
        
        % Checks for time signature or notes only for boudary sections 
        % of subsequent sections after 1
        if (sectionCount == 1)
            if ((z(3) >= 1.5*spaceHeight && z(3) <= 3*spaceHeight) && ... 
                (z(4) >= 1.75*spaceHeight && z(4) <= 5.5*spaceHeight))
                leftBounds = [leftBounds ceil(z(1))];      
            end
        end
    end
    
    % Next part boundary definition based on section status
    if (sectionCount == 1 && ~isempty(leftBounds))
        newTermBound = min(leftBounds)-2; 
    elseif (sectionCount == 1 && isempty(symbol))
        newTermBound = initBound;
    elseif (~(isempty(symbol) || ~isempty(leftBounds)))
        newTermBound = max(edge)-2;
    else
        newTermBound = initBound;
    end
    
    % Combine parameters for complete key definitions
    if(isempty(symbol))
        keys = [];
    else
        keys = [symbol', loc', category' type', value', symIdx'];        
    end
    
    % Sets the number of total keys based on staff type (solo/grand)
    if (length(newStaffLines) >= 10 && max(newStaffLines) ...
        - min(newStaffLines) > 5*spaceHeight)
        totalKeys = (symCount-1)/2;
    else
        totalKeys = symCount-1;
    end
    
    % Key signature definition based on total key count 
    if (totalKeys == 0)
        keySig = 'C/Am';
    else
        % Key signature with sharp(s)
        if (strcmpi(type{1},'sharp'))
            if (totalKeys == 1)
                keySig = 'G/Em';
            elseif (totalKeys == 2)
                keySig = 'D/Bm';
            elseif (totalKeys == 3)
                keySig = 'A/F#m';
            elseif (totalKeys == 4)
                keySig = 'E/C#m';
            elseif (totalKeys == 5)
                keySig = 'B/G#m';
            elseif (totalKeys == 6)
                keySig = 'F#/D#m';
            elseif (totalKeys == 7)
                keySig = 'C#/A#m';
            end
        % Key signature with flat(s)
        else
            if (totalKeys == 1)
                keySig = 'F/Dm';
            elseif (totalKeys == 2)
                keySig = 'Bb/Gm';
            elseif (totalKeys == 3)
                keySig = 'Eb/Cm';
            elseif (totalKeys == 4)
                keySig = 'Ab/Fm';
            elseif (totalKeys == 5)
                keySig = 'Db/Bbm';
            elseif (totalKeys == 6)
                keySig = 'Gb/Ebm';
            elseif (totalKeys == 7)
                keySig = 'Cb/Abm';
            end            
        end
    end
    
end