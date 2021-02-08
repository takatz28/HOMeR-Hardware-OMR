function PianoSheetMusicGenerator(totalSyms, totalTimeSignature, ledgerStaffSpace, ...
    pitch, note, pitchPreKS, staffCenters, keyType, keySigIdx, spaceHeight, lineHeight,...
    fid1, fid2)

    totalSymsIdx = 1:length(totalSyms);
    symbolLocs = cell2mat(totalSyms(:,2));
    symbolCat = string(totalSyms(:,3));
%     symbolType = string(totalSyms(:,4));
    noteRestBarIdx = find(strcmp(symbolCat,"note") | ...
        strcmp(symbolCat,"rest") | ...
        strcmp(symbolCat,"barline"));
    noteRestBars = totalSyms(noteRestBarIdx,:);
    nonNoteIdx = totalSymsIdx(~ismember(totalSymsIdx, noteRestBarIdx));
    nonNoteSyms = totalSyms(nonNoteIdx,:);
    h1 = symbolLocs(:,1);
    h2 = symbolLocs(:,2);
    w1 = symbolLocs(:,3);
    w2 = symbolLocs(:,4);
    cent_x = (w1+w2)./2;
    cent_y = (h1+h2)./2;


    %------------ debugging purposes --------------
%         centroidX = repmat((size(sections{i}, 2)/2),...
%             length(ledgerStaffSpace),1);

    %------------------------------------------------------------------
    % Preprocessing: single whole rest in a measure is removed from
    % note/rest assignment; if two whole rests in one measure, keep the
    % first one and remove the second one
    wholeCount = 0;
    wholeArr = [];
    visited = [];
    for ii = 1:length(noteRestBarIdx)
        if (strcmp(cell2mat(noteRestBars(ii,4)),'wholehalf'))
            [~, wholeHalfIdx] = min(abs(staffCenters - cent_y(noteRestBarIdx(ii))));
            if (wholeHalfIdx == 2 || wholeHalfIdx == 7)
                if (isempty(totalTimeSignature))
                    totalSyms(noteRestBarIdx(ii),5) = {4};
                else                        
                    totalSyms(noteRestBarIdx(ii),5) = totalTimeSignature(1,5);
                end
                wholeCount = wholeCount + 1;
                wholeArr = [wholeArr; noteRestBarIdx(ii)];
            elseif (wholeHalfIdx == 3 || wholeHalfIdx == 8)
                totalSyms(noteRestBarIdx(ii),5) = {2};
%                     noteRestBars(ii,:)
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
    %-------------------------- End preprocessing

    measurePitch = pitch;
    measureNote = note;
    tiePresent = [];

    totalNotes = [];
    totalBeat = [];
%         chordIdx = 1;
    for j = 1:size(totalSyms, 1)
        isNote = strcmp(cell2mat(totalSyms(j,3)),'note');
        isRest = strcmp(cell2mat(totalSyms(j,3)),'rest');
        isBar = strcmp(cell2mat(totalSyms(j,3)),'barline');
        if(ismember(j, sort(visited)))
            continue;
        else
            noteBuf = string(zeros(1,8));
            visited = [visited; j];
            if (isNote || isRest)
                %---------- debugging purposes ------------
%                     hold on
%                     plot(centroidX, ledgerStaffSpace, 'c*'); %pause;
%                     hold on
%                     plot(cent_x(j), cent_y(j), 'y+'); 
%                     hold off
                %------------------------------------------
                [~, idx] = min(abs(ledgerStaffSpace - cent_y(j)));
                if (isNote)
                    tempPitch = measurePitch(idx);
                    tempNote = measureNote(idx);
%                         tempBeat = cell2mat(totalSyms(j,5));                            
                elseif (isRest)
                    tempPitch = 0;
                    tempNote = string(pitchTranslator(tempPitch));
                end
                tempBeat = cell2mat(totalSyms(j,5));

                %----- accidental locator -------
                % always @ left, centroid must be about the same height, and located
                % about 15-20 pixels away from the left
                accidentalIdx = find((abs(cent_x(nonNoteIdx) - cent_x(j)) < 5*spaceHeight) & ...
                    (abs(cent_y(nonNoteIdx) - cent_y(j)) < 7*lineHeight) & ...
                    (cent_x(nonNoteIdx) < cent_x(j)));
                if (~isempty(accidentalIdx))
                    [~, tempIdx] = min(abs(ledgerStaffSpace - cent_y(nonNoteIdx(accidentalIdx))));
                    if (strcmp(string(nonNoteSyms(accidentalIdx, 4)), "natural"))
                        if ((ismember(tempIdx, keySigIdx) && strcmp(keyType, "sharp")) || ...
                            (measurePitch(tempIdx) > pitchPreKS(tempIdx)))
                            tempPitch = tempPitch - 1;
                        elseif ((ismember(tempIdx, keySigIdx) && strcmp(keyType, "flat")) || ...
                            (measurePitch(tempIdx) < pitchPreKS(tempIdx)))
                            tempPitch = tempPitch + 1;
                        end
                    else
                        tempPitch = tempPitch + cell2mat(nonNoteSyms(accidentalIdx,5));
                    end
                    measurePitch(tempIdx) = tempPitch;
                    tempNote = string(pitchTranslator(tempPitch));
                    measureNote(tempIdx) = tempNote;
                end
                accentDotIdx = find((abs(cent_x(nonNoteIdx) - cent_x(j)) <= 2.5*spaceHeight) & ...
                    (cent_y(j) - cent_y(nonNoteIdx) <= 0.75*spaceHeight) & ...
                    (cent_y(j) - cent_y(nonNoteIdx) >= -0.25*spaceHeight) & ...
                    (cent_x(nonNoteIdx) > cent_x(j)));
                accentDotIdx = find(strcmp(string(nonNoteSyms(accentDotIdx,4)),...
                    "dot"));
                if (~isempty(accentDotIdx))
                    tempBeat = tempBeat * 1.5;
                end

                verticalSyms = find((cent_y(totalSymsIdx) ~= cent_y(j)) & ...
                    (abs(cent_x(j) - cent_x(totalSymsIdx)) <= 5*lineHeight)); %& ...
                chordNoteIdx = verticalSyms(strcmp(string(totalSyms(verticalSyms,3)), "note") | ... 
                    strcmp(string(totalSyms(verticalSyms,3)), "rest"));

                tieSlurStart = find(abs(w1(nonNoteIdx) - cent_x(j)) < 0.5*spaceHeight);
                tieSlurEnd = find(abs(w2(nonNoteIdx) - cent_x(j)) < 0.5*spaceHeight);
                tieSlurStartIdx = find(strcmp(string(nonNoteSyms(tieSlurStart,4)),...
                    "tie") | strcmp(string(totalSyms(tieSlurStart,4)),...
                    "slur"));
                tieSlurEndIdx = isempty(find(strcmp(string(nonNoteSyms(tieSlurEnd,4)),...
                    "tie") | strcmp(string(totalSyms(tieSlurEnd,4)),...
                    "slur"),1));

                if (~isempty(chordNoteIdx))
                    totalNotes = [totalNotes; tempNote];
                    totalBeat = [totalBeat; tempBeat];
%                         chordIdx = 1:1:(chordIdx + length(chordNoteIdx));
                    for jj = 1:length(chordNoteIdx)
                        visited = [visited; chordNoteIdx(jj)];
                        isNote2 = strcmp(string(totalSyms(chordNoteIdx(jj),3)),'note');
                        isRest2 = strcmp(string(totalSyms(chordNoteIdx(jj),3)),'rest');
                        [~, idx] = min(abs(ledgerStaffSpace - cent_y(chordNoteIdx(jj))));
                        if (isNote2)
                            tempPitch = measurePitch(idx);
                            tempNote = measureNote(idx);
                            tempBeat = cell2mat(totalSyms(chordNoteIdx(jj),5));                            
                        elseif (isRest2)
                            tempPitch = 0;
                            tempNote = string(pitchTranslator(tempPitch));
                            tempBeat = cell2mat(totalSyms(chordNoteIdx(jj),5));
                        end

                        %----- accidental locator -------
                        accidentalIdx = find((abs(cent_x(nonNoteIdx) - cent_x(chordNoteIdx(jj))) < 5*spaceHeight) & ...
                            (abs(cent_y(nonNoteIdx) - cent_y(chordNoteIdx(jj))) < 7*lineHeight) & ...
                            (cent_x(nonNoteIdx) < cent_x(chordNoteIdx(jj))));
                        if (~isempty(accidentalIdx))
                            [~, tempIdx] = min(abs(ledgerStaffSpace - cent_y(nonNoteIdx(accidentalIdx))));
                            if (strcmp(string(nonNoteSyms(accidentalIdx, 4)), "natural"))
                                if ((ismember(tempIdx, keySigIdx) && strcmp(keyType, "sharp")) || ...
                                    (measurePitch(tempIdx) > pitchPreKS(tempIdx)))
                                    tempPitch = tempPitch - 1;
                                elseif ((ismember(tempIdx, keySigIdx) && strcmp(keyType, "flat")) || ...
                                    (measurePitch(tempIdx) < pitchPreKS(tempIdx)))
                                    tempPitch = tempPitch + 1;
                                end
                            else
                                tempPitch = tempPitch + cell2mat(nonNoteSyms(accidentalIdx,5));
                            end
                            measurePitch(tempIdx) = tempPitch;
                            tempNote = string(pitchTranslator(tempPitch));
                            measureNote(tempIdx) = tempNote;
                        end
                        accentDotIdx = find((abs(cent_x(nonNoteIdx) - cent_x(chordNoteIdx(jj))) <= 2.5*spaceHeight) & ...
                            (cent_y(chordNoteIdx(jj)) - cent_y(nonNoteIdx) <= 0.75*spaceHeight) & ...
                            (cent_y(chordNoteIdx(jj)) - cent_y(nonNoteIdx) >= -0.5*spaceHeight) & ...
                            (cent_x(nonNoteIdx) > cent_x(chordNoteIdx(jj))));
                        accentDotIdx = find(strcmp(string(nonNoteSyms(accentDotIdx,4)),...
                            "dot"));
                        if (~isempty(accentDotIdx))
                            tempBeat = tempBeat * 1.5;
                        end

                        totalNotes = [totalNotes; tempNote];
                        totalBeat = [totalBeat; tempBeat];
%                             [totalNotes, totalBeat]
                    end
% %                         [totalNotes; tempNote]
%                         numel(unique(totalBeat))
                    if (numel(unique(totalBeat)) == 1)                            
                        fprintf(fid2,'%.3f, ', min(totalBeat));                        
%                             [totalNotes, totalBeat]
                        noteBuf(1:length(totalBeat)) = totalNotes;
%                             min(totalBeat)
                        if (~isempty(tieSlurStartIdx))
                            tiePresent = [tiePresent; tieSlurStartIdx];
                            noteBreak = 0;
                        elseif(~isempty(tieSlurEndIdx) && ~isempty(tiePresent))
                            tiePresent = [];
                            noteBreak = 1;
                        elseif (~isempty(tiePresent) && (cent_x(j) > tiePresent(1)))
                            noteBreak = 0;
                        else
                            noteBreak = 1;
                        end
                        totalNotes = [];
                        totalBeat = [];
                        fprintf(fid1,'\t{%s, %s, %s, %s, %s, %s, %s, %s, %d},\n', ...
                            noteBuf, noteBreak);
                    else
                        [offset, ~] = min(totalBeat);
                        minIdx = find(totalBeat == min(totalBeat));
                        fprintf(fid2,'%.3f, ', min(totalBeat));                        
%                             [totalNotes, totalBeat]
                        for ii = 1:length(totalBeat)
                            if (ii ~= minIdx)
                                totalBeat(ii) = totalBeat(ii) - offset;
                            end
                        end
                        noteBuf(1:length(totalBeat)) = totalNotes;
%                             min(totalBeat)

                        fprintf(fid1,'\t{%s, %s, %s, %s, %s, %s, %s, %s, 0},\n', noteBuf);

                        totalNotes(minIdx) = [];
                        totalBeat(minIdx) = [];
                    end
%                         [totalNotes, totalBeat]
                else
                    totalNotes = [totalNotes; tempNote];
                    totalBeat = [totalBeat; tempBeat];
%                         [totalNotes, totalBeat]
%                         numel(unique(totalBeat))
                    if (numel(unique(totalBeat)) == 1)
                        if (~isempty(tieSlurStartIdx))
                            tiePresent = [tiePresent; tieSlurStartIdx];
                            noteBreak = 0;
                        elseif(~isempty(tieSlurEndIdx) && ~isempty(tiePresent))
                            tiePresent = [];
                            noteBreak = 1;
                        elseif (~isempty(tiePresent) && (cent_x(j) > tiePresent(1)))
                            noteBreak = 0;
                        else
                            noteBreak = 1;
                        end
                        fprintf(fid2,'%.3f, ', min(totalBeat));                        
%                             [totalNotes, totalBeat]
                        noteBuf(1:length(totalBeat)) = totalNotes;
%                             min(totalBeat)
                        fprintf(fid1,'\t{%s, %s, %s, %s, %s, %s, %s, %s, %d},\n', ...
                            noteBuf, noteBreak);
%                             fprintf(fid2,'%.3f, ', min(totalBeat));                        
                        totalNotes = [];
                        totalBeat = [];
                    else
                        [offset, ~] = min(totalBeat);
                        minIdx = find(totalBeat == min(totalBeat));
                        fprintf(fid2,'%.3f, ', min(totalBeat));                        
%                             [totalNotes, totalBeat]
                        for ii = 1:length(totalBeat)
                            if (ii ~= minIdx)
                                totalBeat(ii) = totalBeat(ii) - offset;
                            end
                        end
                        noteBuf(1:length(totalBeat)) = totalNotes;
%                             min(totalBeat)
                        fprintf(fid1,'\t{%s, %s, %s, %s, %s, %s, %s, %s, 0},\n', noteBuf);
%                             fprintf(fid2,'%.3f, ', min(totalBeat));                  
                        totalNotes(minIdx) = [];
                        totalBeat(minIdx) = [];
                    end
                end
%                     pause;
            elseif(isBar)
                measurePitch = pitch;
                measureNote = note;
                fprintf(fid1, '\n');
                fprintf(fid2, '\n\t');
            end
        end
    end
end