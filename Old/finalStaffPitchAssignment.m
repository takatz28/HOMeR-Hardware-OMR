function [ledgerStaffSpace, pitch, note, pitchPreKeySig, staffCenters, ...
    keyType, keySigIdx, staffDivider] = finalStaffPitchAssignment(...
    section, staffLines, ledgerLineLocs, clefs, keys)

    % Part 1: Calculate staff and ledger line centroids
    staffCopy = ones(size(section));
    staffCopy(staffLines,10:end-10) = 0;
    staffRefPts = regionprops(~staffCopy, 'Centroid');
    staffCenters = cat(1,staffRefPts.Centroid);
    staffCenters = staffCenters(:,2);
    
    ledgerCopy = ones(size(section));
    ledgerCopy(ledgerLineLocs,10:end-10) = 0;
    ledgerRefPts = regionprops(~ledgerCopy, 'Centroid');
    ledgerCenters = cat(1,ledgerRefPts.Centroid);
    if (~isempty(ledgerCenters))
        ledgerCenters = ledgerCenters(:,2);
    end    
    centers = sort([staffCenters; ledgerCenters]);
    
%     figure;
%     hold on
%     imshowpair(xor(staffCopy, ledgerCopy), section); %pause;

    % Part 2: Generate reference note array
    noteRefArr = [];
    for ii = 88:-1:1
        [note] = pitchTranslator(ii);
        if (length(note) ~= 2)
            continue;
        else
            noteRefArr = [noteRefArr; [ii, string(note)]];
        end
    end
    
    % Part 3: Assigning staff/ledger/space pitches
    % If staffCenters == 5, the section is solo
    if (length(staffCenters) == 5)
        staffDivider = size(section,1);
        symbolLocs = cell2mat(clefs(:,2));
        clefIdx = find(symbolLocs(:,2) < staffDivider);         
        % Part 3.1: Assigning pitch based on clef only
        [ledgerStaffSpace, pitch, note] = staffPitchAssignment(centers, ...
            staffCenters, clefs, clefIdx, noteRefArr);
        
%         baseLedgerStaffSpace = ledgerStaffSpace
        pitchPreKeySig = pitch;
%         notePreKeySig = note;

        % Part 3.2: Assigning pitch based on key signature
        if(~isempty(keys))
            keyType = string(cell2mat(keys(1,4)));
            keySigLocs = cell2mat(keys(:,2));
            visited = [];
            for j = 1:size(keys, 1)
%                 sectionCopy = ones(size(sections{i}));
                h1 = keySigLocs(j,1);
                h2 = keySigLocs(j,2);
%                 w1 = keySigLocs(j,3);
%                 w2 = keySigLocs(j,4);
%                 cent_x = mean([w1, w2]);
                cent_y = mean([h1, h2]);
%                 sectionCopy(h1:h2, w1:w2) = cell2mat(keys(j,1));
%                 [~, idx] = min(abs(ledgerStaffSpace - cent_y));
%                 noteTemp1 = char(note);
%                 tempNote1 = find(noteTemp1(:,1) == noteTemp1(idx,1));
%                 for k = 1:length(tempNote1)
%                     pitch(tempNote1(k)) = pitch(tempNote1(k))...
%                         + cell2mat(keys(j,5));
%                     note(tempNote1(k)) = pitchTranslator(pitch(tempNote1(k)));
%                 end
                [~, idx] = min(abs(ledgerStaffSpace - cent_y));
                noteTemp = char(note);
                tempNote = find((noteTemp(:,1) == noteTemp(idx,1)));
                tempNote = tempNote(~ismember(tempNote, visited));
                visited = sort([visited; tempNote]);
                for k = 1:length(tempNote)
                    pitch(tempNote(k)) = pitch(tempNote(k))...
                        + cell2mat(keys(j,5));
                    note(tempNote(k)) = pitchTranslator(pitch(tempNote(k)));
                end
            end
            keySigIdx = visited;
        else
            keyType = [];
            keySigIdx = [];
        end
%         visited
        staffDivider = [];
%         [pitch, note]
    % If staffCenters ~= 5, the sheet is piano
    else
        staffDivider = (staffCenters(5)+staffCenters(6))/2;
        
        % Part 3.1.1: Assigning pitch based on top clef
        symbolLocs = cell2mat(clefs(:,2));
        clefIdx1 = find(symbolLocs(:,2) < staffDivider);
        grandStaffCenters1 = centers(centers < staffDivider);
        staffCenters1 = staffCenters(1:5);        
        [ledgerStaffSpace1, pitch1, note1] = staffPitchAssignment(...
            grandStaffCenters1, staffCenters1, clefs, clefIdx1, noteRefArr);
        
        % Part 3.1.2: Assigning pitch based on bottom clef
        clefIdx2 = find(symbolLocs(:,2) > staffDivider);
        grandStaffCenters2 = centers(centers > staffDivider);
        staffCenters2 = staffCenters(6:10);        
        [ledgerStaffSpace2, pitch2, note2] = staffPitchAssignment(...
            grandStaffCenters2, staffCenters2, clefs, clefIdx2, noteRefArr);

        pitchPreKeySig = [pitch1;pitch2];
%         notePreKeySig = [note1; note2];

        
        ledgerStaffSpace = [ledgerStaffSpace1; ledgerStaffSpace2];
        if(~isempty(keys))
            keyType = string(cell2mat(keys(1,4)));
            keySigLocs = cell2mat(keys(:,2));
            visited1 = [];
            visited2 = [];
            for j = 1:size(keys, 1)
%                 sectionCopy = ones(size(sections{i}));
                h1 = keySigLocs(j,1);
                h2 = keySigLocs(j,2);
%                 w1 = keySigLocs(j,3);
%                 w2 = keySigLocs(j,4);
%                 cent_x = mean([w1, w2]);
                cent_y = mean([h1, h2]);
%                 sectionCopy(h1:h2, w1:w2) = cell2mat(keys(j,1));
                
                if (cent_y < staffDivider)
                    [~, idx] = min(abs(ledgerStaffSpace1 - cent_y));
                    noteTemp1 = char(note1);
                    tempNote1 = find((noteTemp1(:,1) == noteTemp1(idx,1)));
                    tempNote1 = tempNote1(~ismember(tempNote1, visited1));
                    visited1 = sort([visited1; tempNote1]);
                    for k = 1:length(tempNote1)
                        pitch1(tempNote1(k)) = pitch1(tempNote1(k))...
                            + cell2mat(keys(j,5));
                        note1(tempNote1(k)) = pitchTranslator(pitch1(tempNote1(k)));
                    end
                else
                    [~, idx] = min(abs(ledgerStaffSpace2 - cent_y));
                    noteTemp2 = char(note2);
                    tempNote2 = find((noteTemp2(:,1) == noteTemp2(idx,1)));
                    tempNote2 = tempNote2(~ismember(tempNote2, visited2));
                    visited2 = sort([visited2; tempNote2]);
                    for k = 1:length(tempNote2)
                        pitch2(tempNote2(k)) = pitch2(tempNote2(k))...
                            + cell2mat(keys(j,5));
                        note2(tempNote2(k)) = pitchTranslator(pitch2(tempNote2(k)));
                    end
                end
            end
            keySigIdx = [visited1; visited2];
        else
            keyType = [];
            keySigIdx = [];
        end
        pitch = [pitch1; pitch2];
        note = [note1; note2];
    end
end
