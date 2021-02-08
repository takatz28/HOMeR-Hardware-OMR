function [timeSignature, bound] = detectTimeSig(section, spaceHeight, initBound, timeSigSyms)
% function [timeSignature, bound] = findTimeSig(section, spaceHeight, initBound)

%     figure;
    tempImg = ones(size(section));
%     timeSigSyms = readDataset('timeSignatures');
    boundary = initBound:(initBound+4*spaceHeight);
%     max(boundary)
    tempImg(:,boundary) = section(:,boundary);
%     imshow(tempImg); pause;
    z = imclose(~tempImg, strel('rectangle', [6 8]));
%     imshow(~z); pause;
    stats = regionprops(z, 'BoundingBox');
    
    symbol = {};
    loc = {};
    category = {};
    type = {};
    beat = {};
%     hold on;
    edge = [];
    symCount = 1;
    for j = 1:numel(stats)
        z = stats(j).BoundingBox;
        h = ceil(z(2))+z(4);
        w = ceil(z(1))+z(3);
        boxHeight2 = ceil(z(2)):h-1;
        boxWidth2 = ceil(z(1)):w-1;
        corr_val = [];

        if ((z(3) >= 1.375*spaceHeight && z(3) <= 3.5*spaceHeight) && ... 
            (z(4) >= 3*spaceHeight && z(4) <= 6*spaceHeight))
            symTmp = tempImg(boxHeight2, boxWidth2);
%                 rectangle('Position',stats(j).BoundingBox, ...
%                     'EdgeColor','r', 'LineWidth',2);
%                 pause;
            for jj = 1:length(timeSigSyms)
                timeTmp = imresize(timeSigSyms{jj},[z(4) z(3)]);
                corr_val = [corr_val corr2(symTmp, timeTmp)];
%                 corr2(symTmp, timeTmp)
%                 imshowpair(symTmp, timeTmp, 'montage');
%                 pause;
            end
            [corrPct, idx] = max(corr_val);
            if (corrPct >= 0.65)
                rectangle('Position',stats(j).BoundingBox, ...
                    'EdgeColor','#D95319', 'LineWidth',2);
                	
                symbol{symCount} = symTmp;
                loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                category(symCount) = timeSigSyms(idx,2);
                type(symCount) = timeSigSyms(idx,3);
                beat(symCount) = timeSigSyms(idx,4);
                edge(symCount) = w;
%                 loc{symCount,4}
                symCount = symCount + 1;                
            end
%         pause;
        else
            tempImg(boxHeight2, boxWidth2) = 1;
        end
    end
%     holds off;
%     max(loc(4))
    bound = max(edge);
%     imshow(tempImg); pause;
    timeSignature = [symbol', loc', category', type', beat'];
%     close;
end