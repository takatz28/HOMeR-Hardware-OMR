function [otherSyms, ledgerLineLocs] = detectOtherSymbols(section, bound, spaceHeight, staffLines, ...
    combinedSyms, dotSyms)

    tempImg = ones(size(section));
    boundary = bound:size(section,2);
    tempImg(:,boundary) = section(:,boundary);
    staffHeight = max(staffLines) - min(staffLines);
%     symLen = size([combinedSyms; dotSyms], 1);

    tempErode = imerode(~tempImg,strel('rectangle', [staffHeight-5, 2]));
    tempDilate = imdilate(tempErode,strel('rectangle', [staffHeight-5, 2]));
%     imshow(tempDilate); pause;% (barline detection)
    noBarLines = xor(tempImg,tempDilate);
    barSection = ~tempDilate;
%     figure; imshow(barSection); pause;
    
    tempClose = imclose(~noBarLines, strel('line', spaceHeight, 90));
%     imshow(~tempClose); pause;
    stats = regionprops(tempClose, 'BoundingBox', 'Area');
    
    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {}; 
    symIdx = {};
    otherSyms = {};
    symCount = 1;
%     figure;
%     hold on;
    tempImg1 = ones(size(section));
    for j = 1:numel(stats)
        z = stats(j).BoundingBox;
        h = ceil(z(2))+z(4);
%         if (h > size(section,1))
%             h = size(section,1);
%         end
        w = ceil(z(1))+z(3);
%         if (w > size(section,2))
%             w = size(section,2);
%         end
        boxHeight1 = ceil(z(2)):h;
        boxWidth1 = ceil(z(1)):w;
        corr_val = [];
        if ((z(3) > 3 && z(3) <= 3.5*spaceHeight) && ...
            (z(4) > 3 && z(4) <= 6*spaceHeight))
%             z(3)
%             z(4)
%                pause;
            symTmp = section(boxHeight1, boxWidth1);
            if(((z(3)-z(4) == 1) || (z(3)-z(4) == -1) || ...
                (z(3)-z(4) == 0)) && ...
                    (z(3) < 10 && z(4) < 10))
                    for jj = 1:length(dotSyms)
                    temp = imresize(dotSyms{jj},[z(4)+1 z(3)+1]);
                    corr_val = [corr_val corr2(symTmp, temp)];
%                     corr2(symTmp, temp)
%                     imshowpair(symTmp, temp, 'montage');
%                     pause;
                    end
                [corrPct, idx] = max(corr_val);
                if (corrPct >= 0.55)
    %                 if (strcmpi(combinedSyms(idx,3), 'dot') && ...
    %                     ~isequal(size(symTmp,1),size(symTmp,2))) 
    %                     continue;
    %                 else
    
                        rectangle('Position',stats(j).BoundingBox, ...
                                    'EdgeColor','#77AC30', 'LineWidth',2);
                        symbol{symCount} = symTmp;
                        loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                        category(symCount) = dotSyms(idx,2);
                        type(symCount) = dotSyms(idx,3);
                        value(symCount) = dotSyms(idx,4);
                        symIdx(symCount) = {ceil(z(1))};
                        symCount = symCount + 1;                

                        tempImg1(boxHeight1, boxWidth1) = section(boxHeight1, boxWidth1);
    %                 end


                end     
            else
                for jj = 1:length(combinedSyms)
                    temp = imresize(combinedSyms{jj},[z(4)+1 z(3)+1]);
                    corr_val = [corr_val corr2(symTmp, temp)];                    
%                     corr2(symTmp, temp)
%                     imshowpair(symTmp, temp, 'montage');
%                     pause;
                end
            
                [corrPct, idx] = max(corr_val);
                if (corrPct >= 0.55)
%                     cell2mat(combinedSyms(idx,3))
                    tempImg1(boxHeight1, boxWidth1) = section(boxHeight1, boxWidth1);
                    if (strcmp(cell2mat(combinedSyms(idx,3)), 'flat'))
                        flatImg = ones(size(tempImg1));
                        flatImg(boxHeight1, boxWidth1) = section(boxHeight1, boxWidth1);
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
                    rectangle('Position',stats(j).BoundingBox, ...
                        'EdgeColor','#77AC30', 'LineWidth',2);

                    symbol{symCount} = symTmp;
                    loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                    category(symCount) = combinedSyms(idx,2);
                    type(symCount) = combinedSyms(idx,3);
                    value(symCount) = combinedSyms(idx,4);
                    symIdx(symCount) = {ceil(z(1))};
                    symCount = symCount + 1;
                end
            end
            
%             end     
        end
    end
%     pause;
%     hold off;
    
    % Pass 2: find possible horizontal symbols missed by first pass
    imgNoSyms1 = ~xor(noBarLines,tempImg1);
%     imshow(imgNoSyms1); pause;
    
    tempClose2 = imclose(~imgNoSyms1, strel('rectangle', [2, 5]));
%     imshow(~tempClose2); pause;
    stats2 = regionprops(tempClose2, 'BoundingBox');
%     hold on;

    tempImg2 = ones(size(section));
    for k = 1:numel(stats2)
        z = stats2(k).BoundingBox;
        h = ceil(z(2))+z(4);
%         if (h > size(section,1))
%             h = size(section,1)+1;
%         end
        w = ceil(z(1))+z(3);
%         if (w > size(section,2))
%             w = size(section,2)+1;
%         end
        boxHeight1 = ceil(z(2)):h;
        boxWidth1 = ceil(z(1)):w;
        corr_val = [];
        %
        if ((z(3) > 3) &&... %z(3) <= 3.5*spaceHeight) && ...
            (z(4) > 3 && z(4) <= 4*spaceHeight))

%                pause;
            %
            symTmp = ~tempClose2(boxHeight1, boxWidth1);

            if(((z(3)-z(4) == 1) || (z(3)-z(4) == -1) || ...
                (z(3)-z(4) == 0)) && ...
                    (z(3) < 10 && z(4) < 10))
                for jj = 1:length(dotSyms)
                    temp = imresize(dotSyms{jj},[z(4)+1 z(3)+1]);
                    corr_val = [corr_val corr2(symTmp, temp)];
%                     corr2(symTmp, temp)
%                     imshowpair(symTmp, temp, 'montage');
%                     pause;
                end
                   [corrPct, idx] = max(corr_val);
                if (corrPct >= 0.55)
                    rectangle('Position',stats2(k).BoundingBox, ...
                        'EdgeColor','#77AC30', 'LineWidth',2);
                    symbol{symCount} = symTmp;
                    loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                    category(symCount) = dotSyms(idx,2);
                    type(symCount) = dotSyms(idx,3);
                    value(symCount) = dotSyms(idx,4);
                    symIdx(symCount) = {ceil(z(1))};
                    symCount = symCount + 1;                

                    tempImg2(boxHeight1, boxWidth1) = symTmp;
                else
                    imgNoSyms1(boxHeight1, boxWidth1) = 1;
    %                 end
                end     
            else
                for jj = 1:length(combinedSyms)
                    temp = imresize(combinedSyms{jj},[z(4)+1 z(3)+1]);
%                     size(temp)
%                     size(symTmp)
                    corr_val = [corr_val corr2(symTmp, temp)];                    
%                     corr2(symTmp, temp)
%                     imshowpair(symTmp, temp, 'montage');
%                     pause;
                end
            
                [corrPct, idx] = max(corr_val);
                if (corrPct >= 0.55)
                    tempImg2(boxHeight1, boxWidth1) = symTmp;
                    if (strcmp(cell2mat(combinedSyms(idx,3)), 'flat'))
                        flatImg = ones(size(tempImg1));
                        flatImg(boxHeight1, boxWidth1) = section(boxHeight1, boxWidth1);
                        flatImg = ~xor(imfill(~flatImg, 'holes'), flatImg);
                        flatStats = regionprops(flatImg, 'BoundingBox');
                        z = flatStats(1).BoundingBox;
                        stats2(k).BoundingBox = z;
                        h = ceil(z(2))+z(4);
                        w = ceil(z(1))+z(3);
                        boxHeight1 = ceil(z(2)):h;
                        boxWidth1 = ceil(z(1)):w;
                        symTmp = ~flatImg(boxHeight1, boxWidth1);
                    end
                    rectangle('Position',stats2(k).BoundingBox, ...
                        'EdgeColor','#77AC30', 'LineWidth',2);

                    symbol{symCount} = symTmp;
                    loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                    category(symCount) = combinedSyms(idx,2);
                    type(symCount) = combinedSyms(idx,3);
                    value(symCount) = combinedSyms(idx,4);
                    symIdx(symCount) = {ceil(z(1))};
                    symCount = symCount + 1;
                end
            end
        end   
    end
%     hold off;
%     ledgerBarline = ;
    ledgerBarline = xor(imgNoSyms1,tempImg2);
%     imshow(ledgerBarline); pause;
    cc = bwconncomp(ledgerBarline);
    ledgerStats = regionprops(cc, 'Area');
    idx = find([ledgerStats.Area] <= (20*spaceHeight));
    ledgerBarline2 = ~ismember(labelmatrix(cc), idx);

    % Extract ledger lines for subsequent pitch assignment
    ledgerLines = imclose(ledgerBarline2, strel('line', ...
        floor(spaceHeight * 2), 0));
%     imshow(ledgerLines); pause;
    lineExt = imdilate(~ledgerLines, strel('line', ...
        2*size(section,2), 0));
%     imshow(lineExt); pause;
    ledgerLineLocs = find(sum(lineExt, 2) ~= 0);
%     imshowpair(~lineExt, tempImg); pause;


    %%%%% add barline check here
    barClose = imclose(~barSection, strel('line', spaceHeight, 0));
    barStats = regionprops(barClose, 'BoundingBox');
%     imshow(~barClose); pause;
%     hold on;

    for jjj = 1:numel(barStats)
        tempImg3 = ones(size(section));
        z3 = barStats(jjj).BoundingBox;
        h3 = ceil(z3(2))+z3(4);
%         if (h3 > size(section,2))
%             h3 = size(section,2);
%         end
        w3 = ceil(z3(1))+z3(3);
%         if (w3 > size(section,1))
%             w3 = size(section,1);
%         end
        boxHeight3 = ceil(z3(2)):h3;
        boxWidth3 = ceil(z3(1)):w3;
        tempImg3(boxHeight3, boxWidth3) = section(boxHeight3, boxWidth3);
        barStats2 = regionprops(~tempImg3);
        barlineCount = numel(barStats2);

        if (barlineCount == 1 || barlineCount == 2) 
            if (barlineCount == 1)
                barLineType = 'single';
            else
                barLineType = 'double';
            end
            
            symbol{symCount} = tempImg3(boxHeight3, boxWidth3);
            loc(symCount) = {[ceil(z3(2)) h3 ceil(z3(1)) w3]};
            category(symCount) = {'barline'};
            type(symCount) = {barLineType};
            value(symCount) = {0};
            symIdx(symCount) = {ceil(z3(1))};
            symCount = symCount + 1;   

        end
        rectangle('Position',barStats(jjj).BoundingBox, ...
            'EdgeColor','#77AC30', 'LineWidth',2)
%         pause;
    end
    
    if (~isempty(symbol))
        otherSymsTmp = [symbol', loc', category', type', value', symIdx'];
        otherSyms = sortrows(otherSymsTmp,6);
%         otherSyms = otherSymsTmp(:,1:5);
    end
%     hold off;

%     pause;
    
end