%-------------------------------------------------------------------------
% Function name:    PianoSheetMusicGenerator
% Input arg(s):     ledger/staff/space locations, pre/post-key pitches and
%                   notes, total symbol list, space/line heights, time and 
%                   key signature array, note/beat file IDs
% Description:      Produces a note and beat array based on the recon-
%                   struction of the musical symbols on a piano section
%-------------------------------------------------------------------------
function PianoSheetMusicGenerator(totalSyms, totalTimeSignature, ...
    ledgerStaffSpace, pitch, note, pitchPreKS, staffCenters, keyType, ...
    keySigIdx, spaceHeight, lineHeight, fid1, fid2)


    % Generate reference indices for subsequent symbol locations
    totalSymsIdx = 1:length(totalSyms);
    symbolLocs = cell2mat(totalSyms(:,2));
    symbolCat = string(totalSyms(:,3));
    % Get indices of note/rest/barline symbols
    noteRestBarIdx = find(strcmp(symbolCat,"note") | ...
        strcmp(symbolCat,"rest") | ...
        strcmp(symbolCat,"barline"));
    noteRestBars = totalSyms(noteRestBarIdx,:);
    % Get indices of symbols that are not note/rest/barline
    nonNoteIdx = totalSymsIdx(~ismember(totalSymsIdx, noteRestBarIdx));
    nonNoteSyms = totalSyms(nonNoteIdx,:);
    
    % Calculate reference centroids    
    h1 = symbolLocs(:,1);
    h2 = symbolLocs(:,2);
    w1 = symbolLocs(:,3);
    w2 = symbolLocs(:,4);
    cent_x = (w1+w2)./2;
    cent_y = (h1+h2)./2;

    %------------------------------------------------------------------
    % Preprocessing: single whole rest in a measure is removed from
    % note/rest assignment; if two whole rests in one measure, keep the
    % first one and remove the second one
    %------------------------------------------------------------------
    wholeCount = 0;
    wholeArr = [];
    visited = [];
    for ii = 1:length(noteRestBarIdx)
        if (strcmp(cell2mat(noteRestBars(ii,4)),'wholehalf'))
            [~, wholeHalfIdx] = min(abs(staffCenters - cent_y(...
                noteRestBarIdx(ii))));
            if (wholeHalfIdx == 2 || wholeHalfIdx == 7)
                if (isempty(totalTimeSignature))
                    totalSyms(noteRestBarIdx(ii),5) = {1};
                else                        
                    temp = strsplit(string(totalTimeSignature(1,4)),'/');
                    temp2 = str2double(temp(1))/str2double(temp(2));
                    totalSyms(noteRestBarIdx(ii),5) = {temp2};
                end
                wholeCount = wholeCount + 1;
                wholeArr = [wholeArr; noteRestBarIdx(ii)];
            elseif (wholeHalfIdx == 3 || wholeHalfIdx == 8)
                totalSyms(noteRestBarIdx(ii),5) = {0.5};
            end
        elseif (strcmp(cell2mat(noteRestBars(ii,3)),'barline'))
            if (wholeCount == 1)
                visited = [visited; wholeArr(1)];
            elseif (wholeCount == 2)
                visited = [visited; wholeArr(2)];
            end
            wholeCount = 0;
            wholeArr = [];
        end
    end

    % Modifiable buffers for pitch and note
    measurePitch = pitch;
    measureNote = note;

    % Array initializers
    tiePresent = [];
    totalNotes = [];
    totalBeat = [];

    % Process individual symbol detected by phase 2
    for j = 1:size(totalSyms, 1)
        % Performs a type check if the symbol is either a note, rest, 
        % or barline        
        isNote = strcmp(cell2mat(totalSyms(j,3)),'note');
        isRest = strcmp(cell2mat(totalSyms(j,3)),'rest');
        isBar = strcmp(cell2mat(totalSyms(j,3)),'barline');

        % If current symbol has already been processed, skip processing    
        if(ismember(j, sort(visited)))
            continue;
        else
            % In the case of piano sheets, a maximum of eight notes can 
            % be played simultaneously
            noteBuf = string(zeros(1,8));
            % Add current symbol index to visited array
            visited = [visited; j];
            if (isNote || isRest)
                % Calculate location of staff/ledger/space closest to
                % symbol centroid
                [~, idx] = min(abs(ledgerStaffSpace - cent_y(j)));
                if (isNote)
                    % If symbol is a note, temporary pitch/note is based 
                    % on buffer values, while beat is based on default 
                    tempPitch = measurePitch(idx);
                    tempNote = measureNote(idx);
                elseif (isRest)
                    % If symbol is a rest, pitch is set to 0,
                    tempPitch = 0;
                    tempNote = string(pitchTranslator(tempPitch));
                end
                % Set beat to default/assigned value
                tempBeat = cell2mat(totalSyms(j,5));


                %------------------------------------------------------
                % Accidental locator and pitch re-assignment
                % - Accidentals are typically located on the left-hand 
                %   side of notes
                % - Modifies the note's pitch based on conditions
                %------------------------------------------------------
                % Find possible accidental on the note's LHS
                accidentalIdx = find((...
                    abs(cent_x(nonNoteIdx) - cent_x(j)) < 5*spaceHeight) & ...
                    (abs(cent_y(nonNoteIdx) - cent_y(j)) < 7*lineHeight) & ...
                    (cent_x(nonNoteIdx) < cent_x(j)));
                % Ensures that the located symbol is indeed an 
                % accidental
                accidentalIdx = accidentalIdx(find(strcmp(string(...
                    nonNoteSyms(accidentalIdx,3)), "accidental")));
                if (~isempty(accidentalIdx))
                    % Returns the index of the staff/space/ledger 
                    % centroid closest to the accidental
                    [~, tempIdx] = min(abs(ledgerStaffSpace - cent_y(...
                        nonNoteIdx(accidentalIdx))));
                    % Natural accidental case: its value depends on current
                    % line pitch 
                    if (strcmp(string(nonNoteSyms(accidentalIdx, 4)),...
                            "natural"))
                        % if natural is found in a line with a sharp key,
                        % or buffered pitch is higher than original pitch, 
                        % current pitch will be decreased by 1
                        if ((ismember(tempIdx, keySigIdx) && strcmp(...
                            keyType, "sharp")) || (measurePitch(...
                            tempIdx) > pitchPreKS(tempIdx)))
                            tempPitch = tempPitch - 1;
                        % if natural is found in a line with a flat key,
                        % or buffered pitch is lower than original pitch, 
                        % current pitch will be increased by 1
                        elseif ((ismember(tempIdx, keySigIdx) && strcmp(...
                            keyType, "flat")) || (measurePitch(...
                            tempIdx) < pitchPreKS(tempIdx)))
                            tempPitch = tempPitch + 1;
                        end
                    % For flat/sharp, use default value
                    else
                        tempPitch = tempPitch + cell2mat(nonNoteSyms(...
                            accidentalIdx,5));
                    end
                    % Pitch/note buffers will be modified based on changes
                    % made by accidentals
                    measurePitch(tempIdx) = tempPitch;
                    tempNote = string(pitchTranslator(tempPitch));
                    measureNote(tempIdx) = tempNote;
                end
                %------------------------------------------------------
                % Accent dot locator and beat re-assignment
                % - These are dots that are located on the right-hand
                %   side of notes/rests 
                % - If found, increases the beat value by a factor of 
                %   1.5
                %------------------------------------------------------
                % First pass: Checks for symbols meeting the location
                %     requirements
                accentDotIdx = find((...
                    abs(cent_x(nonNoteIdx) - cent_x(j)) <= 2.5*spaceHeight) & ...
                    (cent_y(j) - cent_y(nonNoteIdx) <= 0.75*spaceHeight) & ...
                    (cent_y(j) - cent_y(nonNoteIdx) >= -0.25*spaceHeight) & ...
                    (cent_x(nonNoteIdx) > cent_x(j)));
                % Second pass: Checks if the located symbol is a dot
                accentDotIdx = find(strcmp(string(nonNoteSyms(accentDotIdx,3)),...
                    "dot"));
                % If accent dot exists, increase current note/rest's 
                % beat value by 1.5
                if (~isempty(accentDotIdx))
                    tempBeat = tempBeat * 1.5;
                end

                
                %------------------------------------------------------
                % Vertical symbol locator:
                % - Compared to the solo sheets, only other notes and 
                %   rests are considered as vertical symbols
                %------------------------------------------------------
                verticalSyms = find((cent_y(totalSymsIdx) ~= cent_y(j)) & ...
                    (abs(cent_x(j) - cent_x(totalSymsIdx)) <= 2*spaceHeight)); 
                chordNoteIdx = verticalSyms(strcmp(string(totalSyms(...
                    verticalSyms,3)), "note") | strcmp(string(totalSyms(...
                    verticalSyms,3)), "rest"));
                % If the vertical note/chord has been already visited,
                % the index is cleared
                chordNoteIdx(ismember(chordNoteIdx, visited)) = [];

                %------------------------------------------------------
                % Tie/slur locator and 'note break' assignment
                % - Note break is a parameter which determines if 
                %   a note/s should be played without breaks
                %------------------------------------------------------
                % First pass: checks for left or right edges which are  
                %     found above or below a note                
                tieSlurStart = find(abs(w1(nonNoteIdx) - cent_x(j)) < ...
                    0.5*spaceHeight);
                tieSlurEnd = find(abs(w2(nonNoteIdx) - cent_x(j)) < ...
                    0.5*spaceHeight);
                % Second pass: check if symbol type is a tie or a slur
                tieSlurStartIdx = find(strcmp(string(nonNoteSyms(...
                    tieSlurStart,4)), "tie") | strcmp(string(totalSyms(...
                    tieSlurStart,4)), "slur"));
                tieSlurEndIdx = isempty(find(strcmp(string(nonNoteSyms(...
                    tieSlurEnd,4)), "tie") | strcmp(string(totalSyms(...
                    tieSlurEnd,4)), "slur"),1));

                % If it exists, process each note/rest similar to current
                % symbol
                if (~isempty(chordNoteIdx))
                    % Add previous note to total notes array
                    totalNotes = [totalNotes; tempNote];
                    totalBeat = [totalBeat; tempBeat];
                    
                    for jj = 1:length(chordNoteIdx)
                        % Add current note to visited array
                        visited = [visited; chordNoteIdx(jj)];
                        % Type check (note/rest)
                        isNote2 = strcmp(string(totalSyms(chordNoteIdx(...
                            jj),3)),'note');
                        isRest2 = strcmp(string(totalSyms(chordNoteIdx(...
                            jj),3)),'rest');
                        % Calculate location of staff/ledger/space closest to
                        % symbol centroid
                        [~, idx] = min(abs(ledgerStaffSpace - cent_y(...
                            chordNoteIdx(jj))));
                        % If symbol is note, buffered pitch/note and beat 
                        % values are used
                        if (isNote2)
                            tempPitch = measurePitch(idx);
                            tempNote = measureNote(idx);
                            tempBeat = cell2mat(totalSyms(chordNoteIdx(...
                                jj),5));
                        % For the case of rest, pitch is set to 0, and 
                        % beat is set to default
                        elseif (isRest2)
                            tempPitch = 0;
                            tempNote = string(pitchTranslator(tempPitch));
                            tempBeat = cell2mat(totalSyms(chordNoteIdx(...
                                jj),5));
                        end
                        
                        % Accidental locator
                        accidentalIdx = find((...
                            abs(cent_x(nonNoteIdx) - cent_x(chordNoteIdx(...
                                jj))) < 5*spaceHeight) & ...
                            (abs(cent_y(nonNoteIdx) - cent_y(chordNoteIdx(...
                                jj))) < 7*lineHeight) & ...
                            (cent_x(nonNoteIdx) < cent_x(chordNoteIdx(jj))));
                        accidentalIdx = accidentalIdx(find(strcmp(string(...
                            nonNoteSyms(accidentalIdx,3)), "accidental")));
                        if (~isempty(accidentalIdx))
                            [~, tempIdx] = min(abs(ledgerStaffSpace - ...
                                cent_y(nonNoteIdx(accidentalIdx))));
                            if (strcmp(string(nonNoteSyms(accidentalIdx,...
                                    4)), "natural"))
                                if ((ismember(tempIdx, keySigIdx) && ...
                                    strcmp(keyType, "sharp")) || ...
                                    (measurePitch(tempIdx) > pitchPreKS(...
                                    tempIdx)))
                                    tempPitch = tempPitch - 1;
                                elseif ((ismember(tempIdx, keySigIdx) && ...
                                    strcmp(keyType, "flat")) || ...
                                    (measurePitch(tempIdx) < pitchPreKS(...
                                    tempIdx)))
                                    tempPitch = tempPitch + 1;
                                end
                            else
                                tempPitch = tempPitch + cell2mat(...
                                    nonNoteSyms(accidentalIdx,5));
                            end
                            measurePitch(tempIdx) = tempPitch;
                            tempNote = string(pitchTranslator(tempPitch));
                            measureNote(tempIdx) = tempNote;
                        end
                        % Accent dot locator
                        accentDotIdx = find((...
                            abs(cent_x(nonNoteIdx) - cent_x(chordNoteIdx(...
                                jj))) <= 2.5*spaceHeight) & ...
                            (cent_y(chordNoteIdx(jj)) - cent_y(nonNoteIdx)...
                                <= 0.75*spaceHeight) & ...
                            (cent_y(chordNoteIdx(jj)) - cent_y(nonNoteIdx)...
                                >= -0.5*spaceHeight) & ...
                            (cent_x(nonNoteIdx) > cent_x(chordNoteIdx(jj))));
                        accentDotIdx = find(strcmp(string(nonNoteSyms(...
                            accentDotIdx,3)), "dot"));
                        % If accent dot exists, increase current beat by 
                        % a factor of 1.5
                        if (~isempty(accentDotIdx))
                            tempBeat = tempBeat * 1.5;
                        end
                        
                        % Add current note/beat values in note and beat
                        % arrays
                        totalNotes = [totalNotes; tempNote];
                        totalBeat = [totalBeat; tempBeat];
                    end
                    % If total beat values are the same, there is no
                    % need for further processing
                    if (numel(unique(totalBeat)) == 1)                            
                        % Write beat value to file
                        fprintf(fid2,'%.3f, ', min(totalBeat));                        
                        % Copy total notes in buffer
                        noteBuf(1:length(totalBeat)) = totalNotes;
                        
                        % If a tie/slur starting edge is detected, note 
                        % break is set to 0
                        if (~isempty(tieSlurStartIdx))
                            tiePresent = [tiePresent; tieSlurStartIdx];
                            noteBreak = 0;
                        % If end edge is detected, add a note break 
                        % (set to 1)
                        elseif(~isempty(tieSlurEndIdx) && ~isempty(...
                                tiePresent))
                            tiePresent = [];
                            noteBreak = 1;
                        % If note is in between tie edges, note break is 
                        % also set to 0
                        elseif (~isempty(tiePresent) && (cent_x(j) > ...
                                tiePresent(1)))
                            noteBreak = 0;
                        % If above conditions are not met, set note 
                        % break to 1
                        else
                            noteBreak = 1;
                        end
                        
                        % Clear total notes and total beats, and write
                        % current notes and note break value to file
                        totalNotes = [];
                        totalBeat = [];
                        fprintf(fid1,'\t{%s, %s, %s, %s, %s, %s, %s, %s, %d},\n', ...
                            noteBuf, noteBreak);
                    else
                        % If multiple beats are present, the minimum value
                        % will be taken as current beat
                        [offset, ~] = min(totalBeat);
                        minIdx = find(totalBeat == min(totalBeat));
                        fprintf(fid2,'%.3f, ', min(totalBeat));
                        % Once the value is written to file, the rest of
                        % the beat values will be decreased by the value of
                        % of the minimum beat (offset)
                        for ii = 1:length(totalBeat)
                            if (ii ~= minIdx)
                                totalBeat(ii) = totalBeat(ii) - offset;
                            end
                        end
                        % Copy total notes to buffer and write to file
                        noteBuf(1:length(totalBeat)) = totalNotes;
                        fprintf(fid1,'\t{%s, %s, %s, %s, %s, %s, %s, %s, 0},\n', ...
                            noteBuf);
                        % Remove minimum beat, note from total note/beat
                        % arrays
                        totalNotes(minIdx) = [];
                        totalBeat(minIdx) = [];
                    end
                else
                    % Add current note/beat values in note and beat
                    % arrays
                    totalNotes = [totalNotes; tempNote];
                    totalBeat = [totalBeat; tempBeat];
                    % If total beat values are the same, there is no
                    % need for further processing                   
                    if (numel(unique(totalBeat)) == 1)                        
                        % If a tie/slur starting edge is detected, note 
                        % break is set to 0
                        if (~isempty(tieSlurStartIdx))
                            tiePresent = [tiePresent; tieSlurStartIdx];
                            noteBreak = 0;
                        % If end edge is detected, add a note break 
                        % (set to 1)
                        elseif(~isempty(tieSlurEndIdx) && ~isempty(...
                                tiePresent))
                            tiePresent = [];
                            noteBreak = 1;
                        % If note is in between tie edges, note break is 
                        % also set to 0
                        elseif (~isempty(tiePresent) && (cent_x(j) > ...
                                tiePresent(1)))
                            noteBreak = 0;
                        % If above conditions are not met, set note 
                        % break to 1
                        else
                            noteBreak = 1;
                        end
                        
                        % Write beat value to file
                        fprintf(fid2,'%.3f, ', min(totalBeat));
                        % Copy total notes in buffer
                        noteBuf(1:length(totalBeat)) = totalNotes;
                        % Clear total notes and total beats, and write
                        % current notes and note break value to file                        
                        fprintf(fid1,'\t{%s, %s, %s, %s, %s, %s, %s, %s, %d},\n', ...
                            noteBuf, noteBreak);
                        totalNotes = [];
                        totalBeat = [];
                    else
                        % If multiple beats are present, the minimum value
                        % will be taken as current beat
                        [offset, ~] = min(totalBeat);
                        minIdx = find(totalBeat == min(totalBeat));
                        fprintf(fid2,'%.3f, ', min(totalBeat));                        
                        % Once the value is written to file, the rest of
                        % the beat values will be decreased by the value of
                        % of the minimum beat (offset)
                        for ii = 1:length(totalBeat)
                            if (ii ~= minIdx)
                                totalBeat(ii) = totalBeat(ii) - offset;
                            end
                        end
                        % Copy total notes to buffer and write to file
                        noteBuf(1:length(totalBeat)) = totalNotes;
                        fprintf(fid1,'\t{%s, %s, %s, %s, %s, %s, %s, %s, 0},\n', ...
                            noteBuf);
                        % Remove minimum beat, note from total note/beat
                        % arrays
                        totalNotes(minIdx) = [];
                        totalBeat(minIdx) = [];
                    end
                end
            %---------------------------------------------
            % Barline symbol check
            %---------------------------------------------
            elseif(isBar)
                % If barline is found, reset the pitch and note buffers
                measurePitch = pitch;
                measureNote = note;
                % Add new lines to both note and beat input files
                fprintf(fid1, '\n');
                fprintf(fid2, '\n\t');
            end
        end
    end
end