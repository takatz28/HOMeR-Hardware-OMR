%-------------------------------------------------------------------------
% Function name:    detectTimeSig
% Input arg(s):     section, staffspace height, ROI boundary, TS dataset
% Outputs arg(s):   time signature definition, next part boundary
% Description:      Detects time signature in the lefthand side of sec-
%                   tions, and returns the starting column value for 
%                   next step detection
%-------------------------------------------------------------------------
function [timeSignature, bound] = detectTimeSig(section, spaceHeight, ...
    initBound, timeSigSyms, debug)

    % ROI is between righthand edge of keys and four times the spaceheight
    % distance after it
    tempImg = ones(size(section));
    boundary = initBound:(initBound+4*spaceHeight);
    tempImg(:,boundary) = section(:,boundary);

    % Applying closing to combine the two numbers
    z = imclose(~tempImg, strel('rectangle', [6 8]));
    stats = regionprops(z, 'BoundingBox');
    
    symbol = {};
    loc = {};
    category = {};
    type = {};
    beat = {};
    edge = [];
    symCount = 1;
    for j = 1:numel(stats)
        % Extract component boundaries
        z = stats(j).BoundingBox;
        h = ceil(z(2))+z(4);
        w = ceil(z(1))+z(3);
        boxHeight = ceil(z(2)):h;
        boxWidth = ceil(z(1)):w;

        % Potential time signature symbols are chosen based on symbol 
        % height and width
        if ((z(3) >= 1.375*spaceHeight && z(3) <= 4*spaceHeight) && ... 
            (z(4) >= 1.75*spaceHeight && z(4) <= 6*spaceHeight))
            % Copy symbol in a temporary image holder
            symTmp = tempImg(boxHeight, boxWidth);
            % Perform template matching with time signature dataset            
            corr_val = [];
            for jj = 1:length(timeSigSyms)
                timeTmp = imresize(timeSigSyms{jj},[length(boxHeight),...
                    length(boxWidth)]); %z(3)]);
                % calculate 2-D correlation between potential TS and 
                % dataset
                corr_val = [corr_val corr2(symTmp, timeTmp)];
            end
            % If the maximum correlation coefficient is >= 0.6, clef
            % parameters are saved
            [corrPct, idx] = max(corr_val);
            if (corrPct >= 0.6)                	
                symbol{symCount} = symTmp;
                loc(symCount) = {[ceil(z(2)) h ceil(z(1)) w]};
                category(symCount) = timeSigSyms(idx,2);
                type(symCount) = timeSigSyms(idx,3);
                beat(symCount) = timeSigSyms(idx,4);
                edge(symCount) = w;
                symCount = symCount + 1;                
                if (debug == 1)
                    rectangle('Position',stats(j).BoundingBox, ...
                        'EdgeColor','#D95319', 'LineWidth',2);
                end
            end
        end
    end
    % Bound is the starting point of the note sorter part
    bound = max(edge);
    % Combine parameters for complete time signature definitions
    timeSignature = [symbol', loc', category', type', beat'];
end