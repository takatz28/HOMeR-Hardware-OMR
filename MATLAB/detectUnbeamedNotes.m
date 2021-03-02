%-------------------------------------------------------------------------
% Function name:    detectUnbeamedNotes
% Input arg(s):     unbeamed section, staff space/line heights, whole
%                   note dataset
% Outputs arg(s):   unbeamed notes and ledger line locations
% Description:      Detects single and chord unbeamed notes from whole
%                   to 64th
%-------------------------------------------------------------------------
function [unbeamedNotes, ledgerLineLocs] = detectUnbeamedNotes(...
    section, spaceHeight, lineHeight, wholeNotes, debug)

    % Extract ledger lines for subsequent pitch assignment
    ledgerLines = imclose(section, strel('rectangle', ...
        [2, floor(spaceHeight * 2)]));
    cc = bwconncomp(~ledgerLines);
    stats = regionprops(cc, 'Area');
    % Ensures that only ledger lines are being removed and not segments
    % of adjacent notes
    idx = find([stats.Area] <= 12*spaceHeight);
    ledgerLines = ismember(labelmatrix(cc), idx);
    % Extends the ledger lines for location calculation
    lineExt = imdilate(ledgerLines, strel('line', ...
        2*size(section,2), 0));
    ledgerLineLocs = find(sum(lineExt, 2) ~= 0);

    % If ledger lines exist in the section, they are to be removed before
    % detection
    if(~isempty(ledgerLineLocs))
        section = ledgerRemove(section, ledgerLineLocs);
    end

    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {};
    symIdx = {};
    symCount = 1;

    % Perform a small opening to ensure that note edges are connected
    section = imopen(section, strel('line', 3, 0));
    noteStats = regionprops(~section, 'BoundingBox');  
    % Examine individual component
    for i = 1:numel(noteStats)
        % Extract component boundaries
        tempImg = ones(size(section));
        unbeamedNoteHeads = ones(size(section));
        z = noteStats(i).BoundingBox;
        h = ceil(z(2))+z(4);
        w = ceil(z(1))+z(3);
        boxHeight = ceil(z(2)):h-1;
        boxWidth = ceil(z(1)):w-1;
        % Copy note in temporary holder
        tempImg(boxHeight, boxWidth) = section(boxHeight, boxWidth);
%         imshow(tempImg); pause;
        %--------------------------------------------------------
        % Stem detection: Determines if the symbol is either:
        % - (half-64th) note/chord         - whole note chords
        % - single whole notes
        %--------------------------------------------------------
        % Checks for (half-64th) notes/chords:
        stemChecker = imerode(~tempImg, strel('line', ...
            (3*spaceHeight + 2*lineHeight), 90));
        stemChecker = imdilate(stemChecker, strel('line', ...
            (3*spaceHeight + 2*lineHeight), 90));
        stemStats = regionprops(stemChecker);
        % Checks for (half-64th) chords that were missed by first check:
        if (numel(stemStats) > 1)
            stemChecker = imopen(stemChecker, strel('line', ...
                4.25*spaceHeight, 90));
            stemStats = regionprops(stemChecker);
        % Checks for whole notes/chords:
        elseif (numel(stemStats) == 0)
            stemChecker = imopen(~tempImg, strel('line', ...
                1.75*spaceHeight, 90));
            stemStats = regionprops(stemChecker);
        end
        
        %--------------------------------------------------------
        % Notehead detection: Section step to determine note type
        % - One or more: (quarter-64th) notes
        % - Zero: whole/half notes
        %--------------------------------------------------------
        % Because of the notehead's geometry, the structuring element
        % used is a line of length (spaceHeight), angled at 30 degrees
        noteHead = imerode(~tempImg, strel('line', ...
            spaceHeight, 30));
        % Detected noteheads are enhanced in order to be counted properly
        % *Second condition is added as a failsafe for smaller sheets
        if (spaceHeight > 10)
            noteHead = imopen(noteHead, strel('disk', 3));
        else            
            noteHead = imopen(noteHead, strel('disk', 2));           
        end
        cc = bwconncomp(noteHead);
        noteHeadStats = regionprops(noteHead, 'BoundingBox', 'Area');
        % If side-adjacent notes are present, they have to be broken 
        % further for correct detection
        idx = find([noteHeadStats.Area] > 8*spaceHeight);
        % Isolate the partially detected notes
        tempImg2 = ismember(labelmatrix(cc), idx);
        % Remove isolated component from complete notehead image
        noteHead = xor(noteHead, ismember(labelmatrix(cc), idx));

        % Adjacent note segmentation
        if (~isequal(tempImg2, zeros(size(noteHead))))
            % The stem is extended horizontally and vertically
            stemExt = imdilate(stemChecker, strel('line', 2*lineHeight,...
                90));
            stemExt = imdilate(stemExt, strel('line', floor(0.5*...
                spaceHeight), 0));
            % By extending the stems, it ensures complete separation
            % between connected noteheads
            tempImg2 = or(~tempImg2, stemExt);
            noteHead = or(noteHead, ~tempImg2); 
            noteHeadStats = regionprops(noteHead, 'BoundingBox');
        end
        
        %--------------------------------------------------------
        % Non-whole single note detection
        %--------------------------------------------------------
        if ((z(3) > spaceHeight && z(4) >= 2*spaceHeight))
            %--------------------------------------------------------
            % Closed note detection: quarter-64th notes
            %--------------------------------------------------------
            if (numel(stemStats) == 1) 
                % If noteheads are detected, potential note falls on
                % (quarter-64)
                if (numel(noteHeadStats) ~= 0)
                    % Isolate the detected noteheads for counting
                    unbeamedNoteHeads(boxHeight, boxWidth) = ~noteHead(...
                        boxHeight, boxWidth);
                    % Increase the size of noteheads
                    noteHead2 = imdilate(noteHead, strel('disk', floor(...
                        spaceHeight*0.3)));
                    %--------------------------------------------------
                    % Flag detection: Because of its geometry, once the 
                    %     noteheads are removed, flags are detected w/ 
                    %     a structuring element with length 1.25x of 
                    %     staff spaceheight, leaning at an angle of -45 
                    %     degrees
                    %--------------------------------------------------
                    filled1 = imopen(xor(~noteHead2, tempImg), strel(...
                        'line', floor(spaceHeight*1.25), -45));
                    cc1 = bwconncomp(filled1);
                    % Returns the total number of flags detected 
                    flagCount = numel(regionprops(cc1));
                    % If there are no flags detected initially, it is 
                    % possible that the note is upside down
                    if(flagCount == 0)
                        % With an upside down note, the flags are angled
                        % at 45 degrees
                        filled2 = imopen(xor(~noteHead2, tempImg), ...
                            strel('line', floor(spaceHeight*1.25), 45));
                        cc2 = bwconncomp(filled2);
                        % Returns the total number of flags detected 
                        flagCount = numel(regionprops(cc2));
                    end
                    % Determine the note type based on flag count
                    if (flagCount >= 0 && flagCount <= 4)
                        if (flagCount == 0)
                            noteType = 'quarter';
                            noteVal = 1;
                        elseif (flagCount == 1)
                            noteType = '8th';
                            noteVal = 0.5;
                        elseif (flagCount == 2)
                            noteType = '16th';
                            noteVal = 0.25;
                        elseif (flagCount == 3)
                            noteType = '32nd';
                            noteVal = 0.125;
                        elseif (flagCount == 4)
                            noteType = '64th';
                            noteVal = 0.0625;         
                        end
                        % Count the number of noteheads detected in
                        % the isolated note/chord
                        cc2 = bwconncomp(~unbeamedNoteHeads);
                        singleNote = regionprops(cc2, 'BoundingBox');
                        for ii = 1:numel(singleNote)
                            % Every notehead's boundaries are extracted
                            z2 = noteHeadStats(ii).BoundingBox;
                            h2 = ceil(z2(2))+z2(4);
                            w2 = ceil(z2(1))+z2(3);
                            boxHeight2 = ceil(z2(2)):h2-1;
                            boxWidth2 = ceil(z2(1)):w2-1;
                            
                            % Each notehead's parameters are saved
                            chordNote = ismember(labelmatrix(cc2),ii);
                            symbol{symCount} = ~chordNote(boxHeight2, ...
                                boxWidth2);
                            loc(symCount) = {[ceil(z2(2)) h2-1 ceil(...
                                z2(1)) w2-1]};
                            category(symCount) = {'note'};
                            type(symCount) = {noteType};
                            value(symCount) = {noteVal};
                            symIdx(symCount) = {ceil(z2(1))};
                            symCount = symCount + 1;   
                            if (debug == 1)
                                rectangle('Position',noteHeadStats(...
                                ii).BoundingBox, 'EdgeColor',...
                                '#EDB120', 'LineWidth',2);
                            end
                        end
                    end
                %--------------------------------------------------------
                % Half note detection: Detection based on holes
                %--------------------------------------------------------
                else
                    % Returns the number of holes detected in the note or
                    % chord
                    [~, cc, holeStats] = detectOpenNoteheads(tempImg,...
                        spaceHeight);
                    
                    for ii = 1:numel(holeStats)
                        % Every note hole's boundaries are extracted
                        z2 = holeStats(ii).BoundingBox;
                        h2 = ceil(z2(2))+z2(4);
                        w2 = ceil(z2(1))+z2(3);
                        boxHeight2 = ceil(z2(2)):h2;
                        boxWidth2 = ceil(z2(1)):w2;    
                        
                        % Each note hole's parameters are saved
                        singleHole = ismember(labelmatrix(cc),ii);
                        symbol{symCount} = ~singleHole(boxHeight2, ...
                            boxWidth2);
                        loc(symCount) = {[ceil(z2(2)) h2 ceil(z2(1)) ...
                            w2]};
                        category(symCount) = {'note'};
                        type(symCount) = {'half'};
                        value(symCount) = {2};
                        symIdx(symCount) = {ceil(z2(1))};
                        symCount = symCount + 1;
                        if (debug == 1)
                            rectangle('Position',holeStats(ii). ...
                                BoundingBox, 'EdgeColor','#EDB120', ...
                                'LineWidth',2);
                        end
                    end
                end
            %--------------------------------------------------------
            % Whole note chord detection: The detection process is 
            %     similar to half note detection
            %--------------------------------------------------------
            else
                % Returns the number of holes detected in the chord
                [~, cc, holeStats] = detectOpenNoteheads(tempImg, ...
                    spaceHeight); 
                for ii = 1:numel(holeStats)
                    % Every note hole's boundaries are extracted
                    z2 = holeStats(ii).BoundingBox;
                    h2 = ceil(z2(2))+z2(4);
                    w2 = ceil(z2(1))+z2(3);
                    boxHeight2 = ceil(z2(2)):h2;
                    boxWidth2 = ceil(z2(1)):w2;                        

                    % Each note hole's parameters are saved
                    singleHole = ismember(labelmatrix(cc),ii);
                    symbol{symCount} = ~singleHole(boxHeight2, boxWidth2);
                    loc(symCount) = {[ceil(z2(2)) h2 ceil(z2(1)) w2]};
                    category(symCount) = {'note'};
                    type(symCount) = {'whole'};
                    value(symCount) = {4};
                        symIdx(symCount) = {ceil(z2(1))};
                    symCount = symCount + 1;   
                    if (debug == 1)
                        rectangle('Position',holeStats(ii).BoundingBox, ...
                            'EdgeColor','#EDB120', 'LineWidth',2);
                    end
                end
            end
        %--------------------------------------------------------
        % Single whole note detection: The only note type that 
        %     undergoes template matching to distinguish it from 
        %     non-note symbols that might have been included in 
        %     the section
        %--------------------------------------------------------
        else
            % Detects the number of holes, which in this case, just 1
            [wholeNoteHole, ~, holeStats] = detectOpenNoteheads(...
                tempImg, spaceHeight); 
            % Isolate whole note
            symTmp = section(boxHeight, boxWidth);
            corr_val = [];
            % 2-D correlation template matching with whole note dataset
            for jj = 1:length(wholeNotes)
                whole = imresize(wholeNotes{jj},[length(boxHeight), ...
                    length(boxWidth)]);
                corr_val = [corr_val corr2(symTmp, whole)];
            end
            % If the maximum correlation coefficient is >= 0.5, note
            % parameters are saved            
            [corrPct, idx] = max(corr_val);
            if (corrPct >= 0.5)
                % For phase 3 assignment, the note hole bounds will be 
                % extracted
                z2 = holeStats(1).BoundingBox;
                h2 = ceil(z2(2))+z2(4);
                w2 = ceil(z2(1))+z2(3);
                boxHeight2 = ceil(z2(2)):h2;
                boxWidth2 = ceil(z2(1)):w2;                        

                % Each note hole's parameters are saved
                symbol{symCount} = ~wholeNoteHole(boxHeight2, boxWidth2);
                loc(symCount) = {[ceil(z2(2)) h2 ceil(z2(1)) w2]};
                category(symCount) = wholeNotes(idx,2);
                type(symCount) = wholeNotes(idx,3);
                value(symCount) = wholeNotes(idx,4);
                symIdx(symCount) = {ceil(z2(1))};
                symCount = symCount + 1;    
                if (debug == 1)
                    rectangle('Position',holeStats(1).BoundingBox, ...
                        'EdgeColor','#EDB120', 'LineWidth',2);
                end
            end
        end
    end
    
    % Combine parameters for complete unbeamed note definitions
    unbeamedNotes = [symbol', loc', category', type', value', symIdx'];
end