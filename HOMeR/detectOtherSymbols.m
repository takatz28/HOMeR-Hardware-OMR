%-------------------------------------------------------------------------
% Function name:    detectOtherSymbols
% Input arg(s):     non-note section, staff space/line heights, rest/acci-
%                   dental/dot/tie/slur dataset
% Outputs arg(s):   other symbols and ledger line locations
% Description:      Detects relevant non-note symbols such as rests, aug-
%                   mentation dots, among others
%-------------------------------------------------------------------------
function [otherSyms, ledgerLineLocs] = detectOtherSymbols(section, ...
    spaceHeight, lineHeight, staffLines, combinedSyms, dotSyms, ...
    tieSlurSyms, debug)

    % Calculate the height of the entire staff
    staffHeight = max(staffLines) - min(staffLines);
    % Preliminary barline detection: Removal of lines that are almost the 
    % same height as the staff
    tempErode = imerode(~section,strel('rectangle', [staffHeight-5, 2]));
    tempDilate = imdilate(tempErode,strel('rectangle', [staffHeight-5,...
        2]));
    noBarLines = xor(section,tempDilate);
    barSection = ~tempDilate;

    %---------------------------------------------------------------
    % First pass: Detecting symbols after vertical connection
    % - Before template matching, potential symbols are connected
    %   vertically to ensure that symbols with multiple components
    %   (such as fermata) will be detected properly
    % - All but the tie/slur dataset will be used
    %---------------------------------------------------------------
    % Connect symbols with a line of lenght spaceHeight
    tempClose = imclose(~noBarLines, strel('line', spaceHeight, 90));
    stats = regionprops(tempClose, 'BoundingBox', 'Area');
    % Call vertical symbols detection function
    [otherSyms1, tempImg1] = otherSymsVert(section, stats, spaceHeight, ...
        combinedSyms, dotSyms, debug);

    % Remove symbols that have been already detected from the non-barline 
    % image
    imgNoSyms1 = ~xor(noBarLines,tempImg1);
    
    % Perform run-length encoding on the image with only barlines to 
    % get maximum barline width; if there are no barlines, the default
    % width is three times the lineHeight
    len = encodeRL(barSection');
    barWidth = len(1:2:end);
    barWidth = max(barWidth(barWidth ~= 0));    
    if(isempty(barWidth))
        barWidth = 3*lineHeight;        
    end
    
    %---------------------------------------------------------------
    % Second pass: Detection of ties/slurs and other symbols missed
    %     by the first pass
    %---------------------------------------------------------------
    % Temporarily connect the symbols horizontally for reference
    tempClose2 = imclose(~imgNoSyms1, strel('line', barWidth+2, 0));
    % Get and add the gaps that were produced by the barline removal
    barGap = and(~barSection, tempClose2);
    % Connect the symbols using the generated gaps 
    tempClose2 = or(~imgNoSyms1, barGap);
    stats2 = regionprops(tempClose2, 'BoundingBox', 'Area');
    % Call horizontal symbols detection function    
    [otherSyms2, tempImg2] = otherSymsHorz(section, stats2, ...
        spaceHeight, combinedSyms, dotSyms, tieSlurSyms, debug);

    % Remove symbols that have already been detected from the non-barline 
    % image, leaving potential ledger lines 
    ledgerBarline = xor(imgNoSyms1,tempImg2);
    cc = bwconncomp(ledgerBarline);
    ledgerStats = regionprops(cc, 'Area');
    % Remove bigger components that might be treated as ledger lines
    % such as dynamic markings
    idx = find([ledgerStats.Area] <= (20*spaceHeight));
    ledgerBarline2 = ~ismember(labelmatrix(cc), idx);

    % Extract ledger line locations similar to the note detections
    ledgerLines = imclose(ledgerBarline2, strel('line', ...
        floor(spaceHeight * 2), 0));
    lineExt = imdilate(~ledgerLines, strel('line', ...
        2*size(section,2), 0));
    ledgerLineLocs = find(sum(lineExt, 2) ~= 0);

    
    %---------------------------------------------------------------
    % Third pass: Detection of barlines (single/double)
    %---------------------------------------------------------------
    % Temporarily connect lines horizontally for bounding box calculation
    barClose = imclose(~barSection, strel('line', spaceHeight, 0));
    barStats = regionprops(barClose, 'BoundingBox');

    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {}; 
    symIdx = {};
    symCount = 1;
    for jjj = 1:numel(barStats)
        % Extract bounding box parameters
        tempImg3 = ones(size(section));
        z3 = barStats(jjj).BoundingBox;
        h3 = ceil(z3(2))+z3(4);
        w3 = ceil(z3(1))+z3(3);
        boxHeight3 = ceil(z3(2)):h3;
        boxWidth3 = ceil(z3(1)):w3;

        % Copy section based on bounding box parametters
        tempImg3(boxHeight3, boxWidth3) = section(boxHeight3, boxWidth3);
        barStats2 = regionprops(~tempImg3);
        barlineCount = numel(barStats2);

        % Determine barline type based on the number of vertical lines
        if (barlineCount == 1 || barlineCount == 2) 
            if (barlineCount == 1)
                barLineType = 'single';
            else
                barLineType = 'double';
            end
            
            % Each barline's parameters are saved
            symbol{symCount} = tempImg3(boxHeight3, boxWidth3);
            loc(symCount) = {[ceil(z3(2)) h3 ceil(z3(1)) w3]};
            category(symCount) = {'barline'};
            type(symCount) = {barLineType};
            value(symCount) = {0};
            symIdx(symCount) = {ceil(z3(1))};
            symCount = symCount + 1;   

        end
        if (debug == 1)
            rectangle('Position',barStats(jjj).BoundingBox, ...
                'EdgeColor','g', 'LineWidth',2);
        end
    end
    
    % Combine parameters for complete non-note symbol definitions
    if (~isempty(symbol))
        otherSymsTmp = [symbol', loc', category', type', value', symIdx'];
        % Sort symbols based on x-axis locations
        otherSyms = sortrows([otherSyms1; otherSyms2; otherSymsTmp],6);
    end
end