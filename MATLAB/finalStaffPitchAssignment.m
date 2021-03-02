%-------------------------------------------------------------------------
% Function name:    finalStaffPitchAssignment
% Input arg(s):     Sheet music section, staff/ledger line locations, 
%                   clef and key signature parameters
% Outputs arg(s):   Staff/ledger/space locations, current/pre-key sig-
%                   nature pitches and notes
% Description:      Assigns the final pitches and notes of a given staff
%                   based on key signature
%-------------------------------------------------------------------------
function [ledgerStaffSpace, pitch, note, pitchPreKeySig, staffCenters, ...
    keyType, keySigIdx, staffDivider] = finalStaffPitchAssignment(...
    section, staffLines, ledgerLineLocs, clefs, keys)
    
    %-----------------------------------------------------------------
    % Part 1: Reference centroid calculations (staff/ledger lines)
    %-----------------------------------------------------------------
    % Stafflines are placed in a blank image, then centroids are 
    % calculated
    staffCopy = ones(size(section));
    staffCopy(staffLines,10:end-10) = 0;
    staffRefPts = regionprops(~staffCopy, 'Centroid');
    staffCenters = cat(1,staffRefPts.Centroid);
    staffCenters = staffCenters(:,2);
    % Ledger lines are placed in a blank image, then centroids are 
    % calculated
    ledgerCopy = ones(size(section));
    ledgerCopy(ledgerLineLocs,10:end-10) = 0;
    ledgerRefPts = regionprops(~ledgerCopy, 'Centroid');
    ledgerCenters = cat(1,ledgerRefPts.Centroid);
    % If ledger lines exist, take the y-component of the centroids
    if (~isempty(ledgerCenters))
        ledgerCenters = ledgerCenters(:,2);
    end
    % Sort the concatenated staff and ledger centroids
    centers = sort([staffCenters; ledgerCenters]);
   
    %-----------------------------------------------------------------
    % Part 2: Generate reference note array without sharps or flats
    %-----------------------------------------------------------------
    noteRefArr = [];
    % Higher pitches are set on top, therefore, the reference array
    % is in reverse order
    for ii = 88:-1:1
        [note] = pitchTranslator(ii);
        % Notes with sharps or flats have a length of 3
        if (length(note) ~= 2)
            continue;
        else
            noteRefArr = [noteRefArr; [ii, string(note)]];
        end
    end
    
    %-----------------------------------------------------------------
    % Part 3: Assigning overall pitches based on staff type
    %-----------------------------------------------------------------
    % If staffCenters == 5, the staff type is solo
    if (length(staffCenters) == 5)
        staffDivider = size(section,1);
        symbolLocs = cell2mat(clefs(:,2));
        % Checks for the clef present in the staff
        clefIdx = find(symbolLocs(:,2) < staffDivider);         
        % Assigns preliminary pitch based on clef only
        [ledgerStaffSpace, pitch, note] = staffPitchAssignment(centers, ...
            staffCenters, clefs, clefIdx, noteRefArr);
        pitchPreKeySig = pitch;

        % Assigns final key based on key signature
        if(~isempty(keys))
            % Check the location and type of keys
            keyType = string(cell2mat(keys(1,4)));
            keySigLocs = cell2mat(keys(:,2));
            visited = [];
            for j = 1:size(keys, 1)
                % Key centroid calculation
                h1 = keySigLocs(j,1);
                h2 = keySigLocs(j,2);
                cent_y = mean([h1, h2]);
                % Returns the staff/space location closest to the key
                % centroid
                [~, idx] = min(abs(ledgerStaffSpace - cent_y));
                noteTemp = char(note);
                % Ensures that all instances of the note is adjusted
                % basd on key
                tempNote = find((noteTemp(:,1) == noteTemp(idx,1)));
                tempNote = tempNote(~ismember(tempNote, visited));
                visited = sort([visited; tempNote]);                
                for k = 1:length(tempNote)
                    pitch(tempNote(k)) = pitch(tempNote(k))...
                        + cell2mat(keys(j,5));
                    note(tempNote(k)) = pitchTranslator(pitch(tempNote(k)));
                end
            end
            % Ensures that after a pitch was modified once, it will not be 
            % modified further
            keySigIdx = visited;
        else
            keyType = [];
            keySigIdx = [];
        end
        staffDivider = [];
    % If staffCenters ~= 5, the staff type is grand
    else
        % Calculate center divider between two staves
        staffDivider = (staffCenters(5)+staffCenters(6))/2;
        
        % Top staff preliminary pitch assignment clef
        symbolLocs = cell2mat(clefs(:,2));
        clefIdx1 = find(symbolLocs(:,2) < staffDivider);
        grandStaffCenters1 = centers(centers < staffDivider);
        staffCenters1 = staffCenters(1:5);        
        [ledgerStaffSpace1, pitch1, note1] = staffPitchAssignment(...
            grandStaffCenters1, staffCenters1, clefs, clefIdx1, noteRefArr);
        
        % Bottom staff preliminary pitch assignment based on clef
        clefIdx2 = find(symbolLocs(:,2) > staffDivider);
        grandStaffCenters2 = centers(centers > staffDivider);
        staffCenters2 = staffCenters(6:10);        
        [ledgerStaffSpace2, pitch2, note2] = staffPitchAssignment(...
            grandStaffCenters2, staffCenters2, clefs, clefIdx2, noteRefArr);

        % Initial pitches and ledger/staff lines and spaces of both
        % staves are combined
        pitchPreKeySig = [pitch1 ; pitch2];
        ledgerStaffSpace = [ledgerStaffSpace1; ledgerStaffSpace2];

        % Assigns final key based on key signature0
        if(~isempty(keys))
            % Check the location and type of keys
            keyType = string(cell2mat(keys(1,4)));
            keySigLocs = cell2mat(keys(:,2));
            visited1 = [];
            visited2 = [];
            for j = 1:size(keys, 1)
                % Key centroid calculation
                h1 = keySigLocs(j,1);
                h2 = keySigLocs(j,2);
                cent_y = mean([h1, h2]);

                % Final pitch assignment for top staff
                if (cent_y < staffDivider)
                    % Returns the staff/space location closest to the key
                    % centroid
                    [~, idx] = min(abs(ledgerStaffSpace1 - cent_y));
                    noteTemp1 = char(note1);
                    % Ensures that all instances of the note is adjusted
                    % basd on key
                    tempNote1 = find((noteTemp1(:,1) == noteTemp1(idx,1)));
                    tempNote1 = tempNote1(~ismember(tempNote1, visited1));
                    visited1 = sort([visited1; tempNote1]);
                    for k = 1:length(tempNote1)
                        pitch1(tempNote1(k)) = pitch1(tempNote1(k))...
                            + cell2mat(keys(j,5));
                        note1(tempNote1(k)) = pitchTranslator(pitch1(...
                            tempNote1(k)));
                    end
                % Final pitch assignment for bottom staff
                else
                    % Returns the staff/space location closest to the key
                    % centroid
                    [~, idx] = min(abs(ledgerStaffSpace2 - cent_y));
                    noteTemp2 = char(note2);
                    % Ensures that all instances of the note is adjusted
                    % basd on key
                    tempNote2 = find((noteTemp2(:,1) == noteTemp2(idx,1)));
                    tempNote2 = tempNote2(~ismember(tempNote2, visited2));
                    visited2 = sort([visited2; tempNote2]);
                    for k = 1:length(tempNote2)
                        pitch2(tempNote2(k)) = pitch2(tempNote2(k))...
                            + cell2mat(keys(j,5));
                        note2(tempNote2(k)) = pitchTranslator(pitch2(...
                            tempNote2(k)));
                    end
                end
            end
            % Ensures that after a pitch was modified once, it will not be 
            % modified further
            keySigIdx = [visited1; visited2];
        else
            keyType = [];
            keySigIdx = [];
        end
        % Combine the pitch and note from both staves to generate complete
        % pitch/note arrays
        pitch = [pitch1; pitch2];
        note = [note1; note2];
    end
end
