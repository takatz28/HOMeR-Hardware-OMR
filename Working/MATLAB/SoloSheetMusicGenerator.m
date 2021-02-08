 function SoloSheetMusicGenerator(totalSyms, totalTimeSignature, ledgerStaffSpace, ...
    pitch, note, pitchPreKS, staffCenters, keyType, keySigIdx, spaceHeight, lineHeight,...
    fid1, fid2)

    totalSymsIdx = 1:length(totalSyms);
    totalSymType = string(totalSyms(:,3));
    noteRestBarIdx = find(strcmp(totalSymType,"note") | ...
         strcmp(totalSymType,"rest") | ...
         strcmp(totalSymType,"barline"));
    nonNoteIdx = totalSymsIdx(~ismember(totalSymsIdx, noteRestBarIdx));
    nonNoteSyms = totalSyms(nonNoteIdx,:);

    symbolLocs = cell2mat(totalSyms(:,2));
%     centroidX = repmat((size(sections{i}, 2)/2),...
%     centroidX = repmat((size(section, 2)/2),...
%         length(ledgerStaffSpace),1);
    h1 = symbolLocs(:,1);
    h2 = symbolLocs(:,2);
    w1 = symbolLocs(:,3);
    w2 = symbolLocs(:,4);
    cent_x = (w1+w2)./2;
    cent_y = (h1+h2)./2;

    measurePitch = pitch;
    measureNote = note;

    tiePresent = [];
    visited = [];

    for j = 1:size(totalSyms, 1)
        isNote = strcmp(cell2mat(totalSyms(j,3)),'note');
        isRest = strcmp(cell2mat(totalSyms(j,3)),'rest');
        isBar = strcmp(cell2mat(totalSyms(j,3)),'barline');

        if(ismember(j, sort(visited)))
            continue;
        else
            visited = [visited; j];
            if (isNote || isRest)
                %---------- set measure temp pitch array ------------

                %---------- debugging purposes ------------
%                 hold on
%                 plot(centroidX, ledgerStaffSpace, 'c*'); %pause;
%                 hold on
%                 plot(cent_x(j), cent_y(j), 'y+'); 
%                 hold off
                %---------- debugging purposes ------------
                [~, idx] = min(abs(ledgerStaffSpace - cent_y(j)));
                if (isNote)
                    tempPitch = measurePitch(idx);
                    tempNote = measureNote(idx);
                    tempBeat = cell2mat(totalSyms(j,5));                            
                elseif (isRest)
                    tempPitch = 0;
                    tempNote = string(pitchTranslator(tempPitch));
%                     timeSignature(1,5)
                    if (strcmp(string(totalSyms(j,4)), "wholehalf"))
                        [~, idx2] = min(abs(staffCenters - cent_y(j)));
                        if (idx2 == 3)
                            tempBeat = 2;
                        elseif (idx2 == 2)
%                             double(timeSignature(:,5))                              
                            tempBeat = cell2mat(totalTimeSignature(:,5));                                
                        end
%                             pause;
                    else
                        tempBeat = cell2mat(totalSyms(j,5));
                    end
                end

                %----- accidental locator -------
                % always @ left, centroid must be about the same height, and located
                % about 15-20 pixels away from the left
                accidentalIdx = find((abs(cent_x(nonNoteIdx) - cent_x(j)) < 2.5*spaceHeight) & ...
                    (abs(cent_y(nonNoteIdx) - cent_y(j)) < 3*lineHeight) & ...
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
                %----- accent dot locator -------
                accentDotIdx = find((abs(cent_x(nonNoteIdx) - cent_x(j)) <= 2.5*spaceHeight) & ...
                    (cent_y(j) - cent_y(nonNoteIdx) <= 0.75*spaceHeight) & ...
                    (cent_y(j) - cent_y(nonNoteIdx) >= -3*lineHeight) & ...
                    (cent_x(nonNoteIdx) > cent_x(j)));
                accentDotIdx = find(strcmp(string(nonNoteSyms(accentDotIdx,4)),...
                    "dot"));
                verticalSyms = find((cent_y(totalSymsIdx) ~= cent_y(j)) & ...
                    (abs(cent_x(j) - cent_x(totalSymsIdx)) <= 3*lineHeight)); %& ...
%                 doubleStopIdx = find();
%                 staccatoIdx = find(strcmp(string(totalSyms(verticalSyms,3)),...
%                     "augmentation"));
                fermataIdx = find(strcmp(string(totalSyms(verticalSyms,4)),...
                    "fermata"));
%                     j
                tieSlurStart = find(abs(w1(nonNoteIdx) - cent_x(j)) < 0.5*spaceHeight);
                tieSlurEnd = find(abs(w2(nonNoteIdx) - cent_x(j)) < 0.5*spaceHeight);
                tieSlurStartIdx = find(strcmp(string(nonNoteSyms(tieSlurStart,4)),...
                    "tie") | strcmp(string(totalSyms(tieSlurStart,4)),...
                    "slur"));
                tieSlurEndIdx = isempty(find(strcmp(string(nonNoteSyms(tieSlurEnd,4)),...
                    "tie") | strcmp(string(totalSyms(tieSlurEnd,4)),...
                    "slur"),1));

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
%                     noteBreak
                if (~isempty(accentDotIdx))
                    tempBeat = tempBeat * 1.5;
                end

%                 doubleStops = verticalSyms(strcmp(string(totalSyms(verticalSyms,3)),...
%                     "note"));
%                 visited = [visited; doubleStops];

%                 if (~isempty(doubleStops))
%                     [~, idx] = min(abs(ledgerStaffSpace - cent_y(doubleStops)));
% 
% %                     tempPitch2 = pitch(idx);
%                     tempNote2 = note(idx);
%                     tempBeat2 = cell2mat(totalSyms(doubleStops,5));
% 
%                     accidentalIdx = find((abs(cent_x(nonNoteIdx) - ...
%                         cent_x(doubleStops)) < 2.5*spaceHeight) & ...
%                         (abs(cent_y(nonNoteIdx) - cent_y(doubleStops)) ...
%                         < 3*lineHeight) & (cent_x(nonNoteIdx) < ...
%                         cent_x(doubleStops)));
%                     if (~isempty(accidentalIdx))
%                         [~, tempIdx] = min(abs(ledgerStaffSpace - cent_y(nonNoteIdx(accidentalIdx))));
%                         if (strcmp(string(nonNoteSyms(accidentalIdx, 4)), "natural"))
%                             if ((ismember(tempIdx, keySigIdx) && strcmp(keyType, "sharp")) || ...
%                                 (measurePitch(tempIdx) > pitchPreKS(tempIdx)))
%                                 tempPitch = tempPitch - 1;
%                             elseif ((ismember(tempIdx, keySigIdx) && strcmp(keyType, "flat")) || ...
%                                 (measurePitch(tempIdx) < pitchPreKS(tempIdx)))
%                                 tempPitch = tempPitch + 1;
%                             end
%                         else
%                             tempPitch = tempPitch + cell2mat(nonNoteSyms(accidentalIdx,5));
%                         end
%                         measurePitch(tempIdx) = tempPitch;
%                         tempNote = string(pitchTranslator(tempPitch));
%                         measureNote(tempIdx) = tempNote;
%                     end
% 
%                     %----- accent dot locator -------
%                     accentDotIdx2 = isempty(find((abs(cent_x(nonNoteIdx) - cent_x(doubleStops)) <= 2.5*spaceHeight) & ...
%                         (cent_y(doubleStops) - cent_y(nonNoteIdx) <= 0.75*spaceHeight) & ...
%                         (cent_y(doubleStops) - cent_y(nonNoteIdx) >= -3*lineHeight) & ...
%                         (cent_x(doubleStops) < cent_x(nonNoteIdx)),1));
%                     if (~isempty(accentDotIdx2))
%                         tempBeat2 = tempBeat2 * 1.5;
%                     end
%                     if (~isempty(staccatoIdx) && isempty(accentDotIdx))
%                         tempBeat = tempBeat * 0.5;
%                     elseif (~isempty(fermataIdx))
%                         tempBeat = tempBeat + cell2mat(nonNoteSyms(fermataIdx,5));
% %                         else
% %                             tempBeat = tempBeat + cell2mat(totalSyms(j,5));                            
%                     end
% %                         [tempNote, tempNote2, tempBeat]                    
% %                         noteBreak = 1;
%                     fprintf(fid1,'\t{%s, %s, 0, 0, 0, 0, 0, 0, %d},\n',tempNote, ...
%                         tempNote2, noteBreak);
%                     fprintf(fid2,'%.3f, ', tempBeat);
%                 else
%                     if (~isempty(staccatoIdx) && isempty(accentDotIdx))
% %                         tempBeat = tempBeat * 0.5;
%                     else
                if (~isempty(fermataIdx))
                    tempBeat = tempBeat + cell2mat(nonNoteSyms(fermataIdx,5));
%                         else
                end
%                 [tempNote, tempBeat]
%                         noteBreak = 1;
                fprintf(fid1,'\t{%s, 0, 0, 0, 0, 0, 0, 0, %d},\n',tempNote, ...
                    noteBreak);
                fprintf(fid2,'%.3f, ', tempBeat);                        
%                 end
%                 if (~isempty(staccatoIdx))
%                     fprintf(fid1,'\t{0, 0, 0, 0, 0, 0, 0, 0, %d},\n', noteBreak);
%                     fprintf(fid2,'%.3f, ', tempBeat);                        
%                 end
%                 pause;
            elseif(isBar)
                measurePitch = pitch;
                measureNote = note;
                fprintf(fid1, '\n');
                fprintf(fid2, '\n\t');
            end
        end
    end
end