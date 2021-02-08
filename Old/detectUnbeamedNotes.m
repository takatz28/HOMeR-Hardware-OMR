    function [unbeamedNotes, ledgerLineLocs] = detectUnbeamedNotes(section, spaceHeight, lineHeight, wholeNotes, closedNotes)

        % Extract ledger lines for subsequent pitch assignment
        ledgerLines = imclose(section, strel('line', ...
            floor(spaceHeight * 2), 0));
        lineExt = imdilate(~ledgerLines, strel('line', ...
            2*size(section,2), 0));
        ledgerLineLocs = find(sum(lineExt, 2) ~= 0);
    %     imshowpair(lineExt, section); pause;

        symbol = {};
        loc = {};
        category = {};
        type = {};
        value = {};
        symIdx = {};
        symCount = 1;

        section = imopen(section, strel('line', 3, 0));
%         imshow(section); pause;
        noteStats = regionprops(~section, 'BoundingBox');    
        for i = 1:numel(noteStats)
            corr_val = [];

            tempImg = ones(size(section));
            unbeamedNoteHeads = ones(size(section));
            z = noteStats(i).BoundingBox;
            h = ceil(z(2))+z(4);
            w = ceil(z(1))+z(3);
            boxHeight = ceil(z(2)):h-1;
            boxWidth = ceil(z(1)):w-1;
            tempImg(boxHeight, boxWidth) = section(boxHeight, boxWidth);

            % stem detection
            stemChecker = imerode(~tempImg, strel('line', ...
                (3*spaceHeight + 5*lineHeight), 90));
            stemChecker = imdilate(stemChecker, strel('line', ...
                (3*spaceHeight + 5*lineHeight), 90));
            stemStats = regionprops(stemChecker);
%             imshow(~stemChecker); pause;

            % notehead detection 
            noteHead = imdilate(~tempImg, strel('square', 1));
    %             imshow(~tempImg); pause;
            noteHead = imerode(noteHead, strel('diamond', ...
                floor((spaceHeight+lineHeight)*0.3)));
            noteHead = imopen(noteHead, strel('disk', 2));
            noteHead = imerode(noteHead, strel('square', 2));
    %             imshowpair(section, ~noteHead); pause;
            noteHeadStats = regionprops(noteHead, 'BoundingBox');
            % notes other than a whole note
            if ((z(3) > spaceHeight && z(4) >= 2.5*spaceHeight))
                % solo notes (half - 64th)
                if (numel(stemStats) == 1) 
                    % quarter - 64th
                    if (numel(noteHeadStats) == 1)% ~=0) 
                        symTmp = section(boxHeight, boxWidth);
        %                 imshow(symTmp); pause;
                        for jj = 1:length(closedNotes)
                            closed = imresize(closedNotes{jj},[z(4) z(3)]);
                            corr_val = [corr_val corr2(symTmp, closed)];
                        end
                        [corrPct, idx] = max(corr_val);
        %                 imshowpair(symTmp, closedNotes{idx}, 'montage');
        %                 pause;
    %                     figure; imshow(~noteHead(boxHeight, boxWidth)); pause;
                        if (corrPct >= 0.5)
                            z2 = noteHeadStats(1).BoundingBox;
                            h2 = ceil(z2(2))+z2(4);
                            w2 = ceil(z2(1))+z2(3);
                            boxHeight2 = ceil(z2(2)):h2-1;
                            boxWidth2 = ceil(z2(1)):w2-1;
                            rectangle('Position',noteHeadStats(1).BoundingBox, ...
                                'EdgeColor','#EDB120', 'LineWidth',2)
    %                         symbol{symCount} = symTmp;
                            symbol{symCount} = ~noteHead(boxHeight2, boxWidth2);
                            loc(symCount) = {[ceil(z2(2)) h2-1 ceil(z2(1)) w2-1]};
                            category(symCount) = closedNotes(idx,2);
                            type(symCount) = closedNotes(idx,3);
                            value(symCount) = closedNotes(idx,4);
                            symIdx(symCount) = {ceil(z2(1))};
                            symCount = symCount + 1;                
                        end
                    % chords (quarter - 64th)
                    elseif (numel(noteHeadStats) > 1)
                        unbeamedNoteHeads(boxHeight, boxWidth) = ~noteHead(boxHeight, boxWidth);
%                         imshow(unbeamedNoteHeads); pause;
                        filled = imopen(~tempImg, strel('disk', floor(spaceHeight/2)));
                        filled = imerode(filled, strel('square', 1));
    %                     imshow(filled); pause;
                        flagStem = imerode(~xor(filled,tempImg), ...
                            strel('rectangle', [floor(spaceHeight/2.5), ...
                            floor(spaceHeight/3)]));
    %                     imshow(~flagStem); pause;
                        flags = imdilate(flagStem,strel('line',10,0));
    %                     imshow(~flags); pause;
                        flagStats = regionprops(flags);
                        flagCount = numel(flagStats);
    %                     imshow(~flagStem); pause;

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

                            cc2 = bwconncomp(~unbeamedNoteHeads);
                            singleNote = regionprops(cc2, 'BoundingBox');
%                             numel(singleNote)
                            for ii = 1:numel(singleNote)
                                z2 = noteHeadStats(ii).BoundingBox;
                                h2 = ceil(z2(2))+z2(4);
                                w2 = ceil(z2(1))+z2(3);
                                boxHeight2 = ceil(z2(2)):h2-1;
                                boxWidth2 = ceil(z2(1)):w2-1;                            

                                chordNote = ismember(labelmatrix(cc2),ii);
                                symbol{symCount} = ~chordNote(boxHeight2, boxWidth2);
                                loc(symCount) = {[ceil(z2(2)) h2-1 ceil(z2(1)) w2-1]};
                                category(symCount) = {'note'};
                                type(symCount) = {noteType};
                                value(symCount) = {noteVal};
                                symIdx(symCount) = {ceil(z2(1))};
                                symCount = symCount + 1;   
                                rectangle('Position',noteHeadStats(ii).BoundingBox, ...
                                    'EdgeColor','#EDB120', 'LineWidth',2)
                            end
                        end
                    % half notes
                    else
                        [~, cc, holeStats] = detectOpenNoteheads(tempImg, spaceHeight);
                        for ii = 1:numel(holeStats)
                            z2 = holeStats(ii).BoundingBox;
                            h2 = ceil(z2(2))+z2(4);
                            w2 = ceil(z2(1))+z2(3);
                            boxHeight2 = ceil(z2(2)):h2-1;
                            boxWidth2 = ceil(z2(1)):w2-1;                        

                            singleHole = ismember(labelmatrix(cc),ii);
    %                         figure; imshow(~singleHole(boxHeight, boxWidth)); pause;
    %                         imshow(~singleHole); pause;
                            symbol{symCount} = ~singleHole(boxHeight2, boxWidth2);
                            loc(symCount) = {[ceil(z2(2)) h2-1 ceil(z2(1)) w2-1]};
                            category(symCount) = {'note'};
                            type(symCount) = {'half'};
                            value(symCount) = {2};
                            symIdx(symCount) = {ceil(z2(1))};
                            symCount = symCount + 1;
                            rectangle('Position',holeStats(ii).BoundingBox, ...
                                'EdgeColor','#EDB120', 'LineWidth',2)
                        end
                    end
                % whole note chords 
                elseif (numel(stemStats) ~= 1)
                    [~, cc, holeStats] = detectOpenNoteheads(tempImg, spaceHeight); 
                    for ii = 1:numel(holeStats)
                        z2 = holeStats(ii).BoundingBox;
                        h2 = ceil(z2(2))+z2(4);
                        w2 = ceil(z2(1))+z2(3);
                        boxHeight2 = ceil(z2(2)):h2-1;
                        boxWidth2 = ceil(z2(1)):w2-1;                        

                        singleHole = ismember(labelmatrix(cc),ii);
    %                     figure; imshow(~singleHole(boxHeight, boxWidth)); pause;
                        symbol{symCount} = ~singleHole(boxHeight2, boxWidth2);
                        loc(symCount) = {[ceil(z2(2)) h2-1 ceil(z2(1)) w2-1]};
                        category(symCount) = {'note'};
                        type(symCount) = {'whole'};
                        value(symCount) = {4};
                            symIdx(symCount) = {ceil(z2(1))};
                        symCount = symCount + 1;   
                        rectangle('Position',holeStats(ii).BoundingBox, ...
                            'EdgeColor','#EDB120', 'LineWidth',2)
                    end
                end
            % whole note detection
            else
                [wholeNoteHole, ~, holeStats] = detectOpenNoteheads(tempImg, spaceHeight); 
                symTmp = section(boxHeight, boxWidth);
    %             imshow(symTmp); pause;
                for jj = 1:length(wholeNotes)
                    whole = imresize(wholeNotes{jj},[z(4) z(3)]);
                    corr_val = [corr_val corr2(symTmp, whole)];
    %                 corr2(symTmp, whole)
    %                 imshowpair(symTmp, whole, 'montage');
    %                 pause;                
                end
                [corrPct, idx] = max(corr_val);
                if (corrPct >= 0.5)
                    z2 = holeStats(1).BoundingBox;
                    h2 = ceil(z2(2))+z2(4);
                    w2 = ceil(z2(1))+z2(3);
                    boxHeight2 = ceil(z2(2)):h2-1;
                    boxWidth2 = ceil(z2(1)):w2-1;                        

    %                 figure; imshow(~wholeNoteHole(boxHeight, boxWidth)); pause;
                    symbol{symCount} = ~wholeNoteHole(boxHeight2, boxWidth2);
                    loc(symCount) = {[ceil(z2(2)) h2-1 ceil(z2(1)) w2-1]};
                    category(symCount) = wholeNotes(idx,2);
                    type(symCount) = wholeNotes(idx,3);
                    value(symCount) = wholeNotes(idx,4);
                    symIdx(symCount) = {ceil(z2(1))};
                    symCount = symCount + 1;    
                    rectangle('Position',holeStats(1).BoundingBox, ...
                        'EdgeColor','#EDB120', 'LineWidth',2);
%                 else
%                     section(boxHeight, boxWidth) = 1;
                end
            end
        end

        unbeamedNotes = [symbol', loc', category', type', value', symIdx'];
    end