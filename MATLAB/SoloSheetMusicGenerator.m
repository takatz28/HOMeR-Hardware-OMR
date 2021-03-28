%-------------------------------------------------------------------------
% Function name:    SoloSheetMusicGenerator
% Input arg(s):     ledger/staff/space locations, pre/post-key pitches and
%                   notes, total symbol list, space/line heights, time and 
%                   key signature array, note/beat file IDs
% Description:      Produces a note and beat array based on the recon-
%                   struction of the musical symbols on a solo section
%-------------------------------------------------------------------------
function SoloSheetMusicGenerator(totalSyms, totalTimeSignature, ...
    ledgerStaffSpace, pitch, note, pitchPreKS, staffCenters, keyType, ...
    keySigIdx, spaceHeight, lineHeight, fid1, fid2)

    % Generate reference indices for subsequent symbol locations
    totalSymsIdx = 1:length(totalSyms);
    totalSymType = string(totalSyms(:,3));
    % Get indices of note/rest/barline symbols
    noteRestBarIdx = find(strcmp(totalSymType,"note") | ...
         strcmp(totalSymType,"rest") | ...
         strcmp(totalSymType,"barline"));
    % Get indices of symbols that are not note/rest/barline
    nonNoteIdx = totalSymsIdx(~ismember(totalSymsIdx, noteRestBarIdx));
    nonNoteSyms = totalSyms(nonNoteIdx,:);

    % Calculate reference centroids
    symbolLocs = cell2mat(totalSyms(:,2));
    h1 = symbolLocs(:,1);
    h2 = symbolLocs(:,2);
    w1 = symbolLocs(:,3);
    w2 = symbolLocs(:,4);
    cent_x = (w1+w2)./2;
    cent_y = (h1+h2)./2;

    % Modifiable buffers for pitch and note
    measurePitch = pitch;
    measureNote = note;

    % Array initializers
    tiePresent = [];
    visited = [];
    totalNotes = [];

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
            % In the case of solo sheets, a maximum of three notes can 
            % be played simultaneously
            noteBuf = string(zeros(1,3));
            % Add current symbol index to visited array
            visited = [visited; j];
            %------------------------------------------------------
            % Note/rest check: Assigns pitch(es) and beat based on 
            % adjacencies (other notes/dot/accidental/fermata)
            %------------------------------------------------------
            if (isNote || isRest)
                % Calculate location of staff/ledger/space closest to
                % symbol centroid
                [~, idx] = min(abs(ledgerStaffSpace - cent_y(j)));
                if (isNote)
                    % If symbol is a note, temporary pitch/note is based 
                    % on buffer values, while beat is based on default 
                    tempPitch = measurePitch(idx);
                    tempNote = measureNote(idx);
                    tempBeat = cell2mat(totalSyms(j,5));
                elseif (isRest)
                    % If symbol is a rest, pitch is set to 0,
                    tempPitch = 0;
                    tempNote = string(pitchTranslator(tempPitch));
                    % In the case of whole/half rest, beat value is
                    % assigned based on location
                    if (strcmp(string(totalSyms(j,4)), "wholehalf"))
                        [~, idx2] = min(abs(staffCenters - cent_y(j)));
                        % If the location is the third staffline, the rest
                        % is a half rest
                        if (idx2 == 3)
                            tempBeat = 0.5;
                        % On the other hand, if location is second staff-
                        % line, the rest if a whole rest
                        elseif (idx2 == 2)
                            temp = strsplit(string(totalTimeSignature(1,4)),'/');
                            tempBeat = str2double(temp(1))/str2double(temp(2));
                        end
                    % For the rest of the staff lines, use the default 
                    % value    
                    else
                        tempBeat = cell2mat(totalSyms(j,5));
                    end
                end

                %------------------------------------------------------
                % Accidental locator and pitch re-assignment
                % - Accidentals are typically located on the left-hand 
                %   side of notes
                % - Modifies the note's pitch based on conditions
                %------------------------------------------------------
                % Find possible accidental on the note's LHS
                accidentalIdx = find((...
                    abs(cent_x(nonNoteIdx) - cent_x(j)) < 4*spaceHeight) & ...
                    (abs(cent_y(nonNoteIdx) - cent_y(j)) < 7*lineHeight) & ...
                    (cent_x(nonNoteIdx) < cent_x(j)));
                % Checks if the symbol located is indeed an accidental
                if (strcmp(string(nonNoteSyms(accidentalIdx,3)), ...
                        "accidental"))
                    % Returns the index of the staff/space/ledger 
                    % centroid closest to the accidental
                    [~, tempIdx] = min(abs(ledgerStaffSpace - cent_y(...
                        nonNoteIdx(accidentalIdx))));
                    % Natural accidental case: its value depends on current
                    % line pitch 
                    if (strcmp(string(nonNoteSyms(accidentalIdx, 4)), ...
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
                accentDotIdx = find(...
                    (abs(cent_x(nonNoteIdx) - cent_x(j)) <= 2.5*spaceHeight) & ...
                    (cent_y(j) - cent_y(nonNoteIdx) <= 0.75*spaceHeight) & ...
                    (cent_y(j) - cent_y(nonNoteIdx) >= -3*lineHeight) & ...
                    (cent_x(nonNoteIdx) > cent_x(j)));
                % Second pass: Checks if the located symbol is a dot
                accentDotIdx = find(strcmp(string(nonNoteSyms(accentDotIdx,3)),...
                    "dot"));
                 
                %------------------------------------------------------
                % Vertical symbol locator:
                % - Locates symbols that are on top or bottom of the 
                %   current symbol, such as other notes, staccato
                %   dots, fermatas, or edges of ties/slurs
                %------------------------------------------------------
                % First pass: Check for any vertical symbols regardless
                %     of type
                verticalSyms = find((cent_y(totalSymsIdx) ~= cent_y(j)) & ...
                    (abs(cent_x(j) - cent_x(totalSymsIdx)) <= 3*lineHeight)); 

                % Fermata case: Locate symbols matching the type
                fermataIdx = find(strcmp(string(totalSyms(verticalSyms,4)),...
                    "fermata"));

                % Second pass: Check for any vertical symbols that are 
                %     close to the x-axis of the current note 
                verticalSyms2 = find(...
                    (abs(cent_y(nonNoteIdx) - cent_y(j)) <= 3*spaceHeight) & ...
                    (abs(cent_x(j) - cent_x(nonNoteIdx)) <= 3*lineHeight));
                % Staccato dot case: Locate symbols matching description
                staccatoIdx = find(strcmp(string(nonNoteSyms(verticalSyms2,4)),...
                    "augmentation"));

                
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

                % If a tie/slur starting edge is detected, note break is 
                % set to 0
                if (~isempty(tieSlurStartIdx))
                    tiePresent = [tiePresent; tieSlurStartIdx];
                    noteBreak = 0;
                % If end edge is detected, add a note break (set to 1)
                elseif(~isempty(tieSlurEndIdx) && ~isempty(tiePresent))
                    tiePresent = [];
                    noteBreak = 1;
                % If note is in between tie edges, note break is also 
                % set to 0
                elseif (~isempty(tiePresent) && (cent_x(j) > tiePresent(1)))
                    noteBreak = 0;
                % If above conditions are not met, set note break to 1
                else
                    noteBreak = 1;
                end

                % Third pass: Check for any vertical symbols that are notes
                %     (maximum of 2)
                doubleStops = verticalSyms(strcmp(string(totalSyms(...
                    verticalSyms,3)), "note"));
                % If they are detected, add indices to the visited array
                visited = [visited; doubleStops];

                % Process each double/triple stop note similar to previous
                % note
                if (~isempty(doubleStops))
                    % Add previous note to total notes array
                    totalNotes = [totalNotes; tempNote];

                    for jj = 1:length(doubleStops)
                        % Calculate location of staff/ledger/space closest to
                        % symbol centroid
                        [~, idx] = min(abs(ledgerStaffSpace - cent_y(...
                            doubleStops(jj))));
                        
                        % Pitch/note assignment based on buffers
                        tempPitch = measurePitch(idx);
                        tempNote = measureNote(idx);

                        % Accidental locator
                        accidentalIdx = find((abs(cent_x(nonNoteIdx) - ...
                            cent_x(doubleStops(jj))) < 4*spaceHeight) & ...
                            (abs(cent_y(nonNoteIdx) - cent_y(doubleStops(...
                            jj))) < 7*lineHeight) & (cent_x(nonNoteIdx) <...
                            cent_x(doubleStops(jj))));
                        if (strcmp(string(nonNoteSyms(accidentalIdx,3)), ...
                                "accidental"))
                            [~, tempIdx] = min(abs(ledgerStaffSpace - ...
                                cent_y(nonNoteIdx(accidentalIdx))));
                            if (strcmp(string(nonNoteSyms(accidentalIdx,...
                                4)), "natural"))
                                if ((ismember(tempIdx, keySigIdx) && ...
                                    strcmp(keyType, "sharp")) || ...
                                    (measurePitch(tempIdx) > pitchPreKS(...
                                    tempIdx)))
                                    tempPitch = tempPitch - 1;
                                elseif ((ismember(tempIdx, keySigIdx) &&...
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
                        totalNotes = [totalNotes; tempNote];

                        % Vertical symbol locator
                        verticalSyms2 = find((abs(cent_y(nonNoteIdx) - ...
                            cent_y(doubleStops(jj))) <= 3*spaceHeight) & ...
                            (abs(cent_x(j) - cent_x(nonNoteIdx)) <= ...
                            3*lineHeight));
                        % Staccato dot locator
                        staccatoIdx2 = find(strcmp(string(nonNoteSyms(...
                            verticalSyms2,4)), "augmentation"));
                        % Fermata locator
                        fermataIdx = find(strcmp(string(totalSyms(...
                            verticalSyms,4)), "fermata"));
                    end
                    
                    %---------------------------------------------
                    % Final beat assignment based on exisiting
                    %     symbols
                    %---------------------------------------------
                    % If accent dot exists, original beat is increase by 
                    % a factor of 1.5
                    if (~isempty(accentDotIdx))
                        tempBeat = tempBeat * 1.5;
                    % If accent dot doesn't exist and staccato dot exist, 
                    % original beat is deacreased in half
                    elseif (~isempty(staccatoIdx) || ~isempty(staccatoIdx2))
                        tempBeat = tempBeat * 0.5;
                    % If fermata exists, add 4 beats in the original beat
                    elseif (~isempty(fermataIdx))
                        tempBeat = tempBeat + cell2mat(nonNoteSyms(...
                            fermataIdx,5));
                    end
                    
                    %-----------------------------------------------------
                    % File writing procedure: THe format is as 
                    % follows:
                    % - {note1, note2, note3, 0, 0, 0, 0, 0, note break}
                    % - {..., beat, ...} 
                    %-----------------------------------------------------
                    noteBuf(1:length(totalNotes)) = totalNotes;
                    fprintf(fid1,'\t{%s, %s, %s, 0, 0, 0, 0, 0, %d},\n',...
                        noteBuf, noteBreak);
                    fprintf(fid2,'%.3f, ', tempBeat);
                    % If fermata is detected, silence is added afterwards,
                    % with the beat equiavalent to previous beat
                    if (~isempty(staccatoIdx))
                        fprintf(fid1,'\t{0, 0, 0, 0, 0, 0, 0, 0, %d},\n', ...
                            noteBreak);
                        fprintf(fid2,'%.3f, ', tempBeat);                        
                    end
                    totalNotes = [];
                else
                    %---------------------------------------------
                    % Final beat assignment based on exisiting
                    %     symbols
                    %---------------------------------------------
                    % If staccato exists, cut the original beat in half
                    if (~isempty(staccatoIdx))
                        tempBeat = tempBeat * 0.5;
                    % If accent dot exists, beat increases by a factor 
                    % of 1.5
                    elseif (~isempty(accentDotIdx))
                        tempBeat = tempBeat * 1.5;
                    % IF fermata exists, add 4 beats in the original beat
                    elseif (~isempty(fermataIdx))
                        tempBeat = tempBeat + cell2mat(nonNoteSyms(...
                            fermataIdx,5));
                    end
                    
                    %-----------------------------------------------------
                    % File writing procedure: THe format is as 
                    % follows:
                    % - {note, 0, 0, 0, 0, 0, 0, 0, note break}
                    % - {..., beat, ...} 
                    %-----------------------------------------------------
                    fprintf(fid1,'\t{%s, 0, 0, 0, 0, 0, 0, 0, %d},\n',...
                        tempNote, noteBreak);
                    fprintf(fid2,'%.3f, ', tempBeat);
                    % If fermata is detected, silence is added afterwards,
                    % with the beat equiavalent to previous beat
                    if (~isempty(staccatoIdx))
                        fprintf(fid1,'\t{0, 0, 0, 0, 0, 0, 0, 0, %d},\n',...
                            noteBreak);
                        fprintf(fid2,'%.3f, ', tempBeat);                        
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