function [keySig, keys, newTermBound] = detectKeySig(section, spaceHeight, ...
    sectionCount, newStaffLines, initBound, termBound, keySyms)
    
    tempImg = ones(size(section));
%     keySyms = readDataset('keys');
    boundary = initBound:termBound;
    tempImg(:,boundary) = section(:,boundary);
    
%     imshow(tempImg); pause;

    z = imclose(~tempImg, strel('line', 3, 90));
%     imshow(~z);  impixelinfo; pause;
    cc = bwconncomp(z);
    stats = regionprops(cc, 'BoundingBox');
%     imshow(z); pause;
    
    
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
        z = stats(j).BoundingBox;
        h = ceil(z(2))+z(4);
        w = ceil(z(1))+z(3);
        boxHeight = ceil(z(2)):h;
        boxWidth = ceil(z(1)):w;
        corr_val = [];

        % checks for flats and sharps (key signature)
        if ((z(3) >= 0.75*spaceHeight && z(3) <= 2.25*spaceHeight) && ... 
            (z(4) >= 2*spaceHeight && z(4) <= 3.75*spaceHeight))
%             rectangle('Position',stats(j).BoundingBox, ...
%                 'EdgeColor','r', 'LineWidth',2)
%             pause;
            tempImg = ismember(labelmatrix(cc),j);
%             imshow(tempImg); pause;
            symTmp = ~tempImg(boxHeight, boxWidth);
            for jj = 1:length(keySyms)
                keyTmp = imresize(keySyms{jj},[z(4)+1 z(3)+1]);
                corr_val = [corr_val corr2(symTmp, keyTmp)];
%                 corr2(symTmp, keyTmp)
%                 imshowpair(symTmp, keyTmp, 'montage');
%                 pause;
            end
            [corrPct, idx] = max(corr_val);
            if (corrPct >= 0.5)
                edgeW = w;
                if (strcmp(cell2mat(keySyms(idx,3)), 'flat'))
                    flatImg = ones(size(tempImg));
                    flatImg(boxHeight, boxWidth) = section(boxHeight, boxWidth);
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
                
                rectangle('Position',stats(j).BoundingBox, ...
                    'EdgeColor','r', 'LineWidth',2);
                symbol{symCount} = symTmp;
                loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                category(symCount) = keySyms(idx,2);
                type(symCount) = keySyms(idx,3);
                value(symCount) = keySyms(idx,4);
                symIdx(symCount) = {ceil(z(1))};
                edge(symCount) = edgeW+3;
                symCount = symCount + 1;                
            end
        end
        
%                 hold on;
        % checks for time signature only for boundary calculation
        if (sectionCount == 1)
            if ((z(3) >= 1.5*spaceHeight && z(3) <= 3*spaceHeight) && ... 
                (z(4) >= 3*spaceHeight && z(4) <= 5*spaceHeight))
%                 rectangle('Position',stats(j).BoundingBox, ...
%                     'EdgeColor','r', 'LineWidth',2);
                leftBounds = [leftBounds ceil(z(1))];      
            end
%             pause;
        end
%         hold off;
    end
%     hold off;
%     isempty(symbol)
    if (sectionCount == 1 && isempty(symbol))
        newTermBound = min(leftBounds)-2; 
    elseif (isempty(symbol))
        newTermBound = initBound;
    else
        newTermBound = max(edge)-2;
    end
    
    if(isempty(symbol))
        keys = {};
    else
        keys = [symbol', loc', category' type', value', symIdx'];        
    end
    
    if (length(newStaffLines) >= 10 && max(newStaffLines) ...
        - min(newStaffLines) > 5*spaceHeight)
        totalKeys = (symCount-1)/2;
    else
        totalKeys = symCount-1;
    end
    
    if (totalKeys == 0)
        keySig = 'C/Am';
    else
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