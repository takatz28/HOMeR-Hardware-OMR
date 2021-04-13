function OMR(inputImg, fid1, fid2)
    
    debug = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%         PHASE ONE: PREPROCESSING         %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [img_bw, lineHeight, spaceHeight] = preprocess(inputImg);
%     spaceHeight
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%   PHASE TWO: MUSIC SYMBOLS RECOGNITION   %%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Part 2.1: Staff detection, removal, and division
    [staffLines, staffHeights] = staffDetect(img_bw);
    dividers = staffDivider(img_bw, staffLines, lineHeight, spaceHeight);
    img_no_staff = staffRemove(img_bw, staffLines, staffHeights, spaceHeight);
    [sections, newStaffLines] = scoreToSections(img_no_staff, ...
        staffLines, dividers);

    % Part 2.2: Importing dataset for template matching
    [clef, key, timeSig, wholeNotes, rest, dot, other, tieslur] = readDataset;
    combined = [key; rest; other];
    %
    figure;
    totalTimeSignature = [];
    for i = 1:length(sections)
        fprintf("-----------------------------------------------------------------\n");
        fprintf("    Section %d symbols: \n", i);
        imshow(sections{i});

        % Part 2.3: Clef detection
        [clefs, clefBound]  = detectClefs(sections{i}, spaceHeight, ... 
            newStaffLines{i}, clef, debug);
        disp(clefs);
    
        % Part 2.4: Key signature detection
        if (i == 1)
            [keySignature, keys, keyTemp] = detectKeySig(sections{i}, ...
                spaceHeight, i, newStaffLines{i}, clefBound, ...
                clefBound+10*spaceHeight, key, debug);
            keySigBound = keyTemp;
            fprintf('\tKey signature: %s\n\n', keySignature);
        else
            [keySignature, keys, keyTemp] = detectKeySig(sections{i},...
                spaceHeight, i, newStaffLines{i}, clefBound, ...
                keySigBound, key, debug);
            keySigBound = keyTemp;
            fprintf('\tKey signature: %s\n\n', keySignature);
        end

        % Part 2.5: Time signature detection
        [timeSignature, timeSigBound] = detectTimeSig(sections{i}, ...
            spaceHeight, keySigBound, timeSig, debug);

        totalTimeSignature =  [totalTimeSignature; timeSignature];

        if(isempty(timeSignature))
            nextBound = keySigBound;
        else
            nextBound = timeSigBound;
        end
        disp(timeSignature); pause;
        % Part 2.6: Section sorting to unbeamed/beamed notes, and other symbols
        [unbeamedSec, beamedSec, otherSymsSec] = noteSorter(sections{i}, ...
            nextBound, spaceHeight, lineHeight);
%         imshowpair(sections{i}, unbeamedSec); pause;
%         imshowpair(sections{i}, beamedSec); pause;
%         imshowpair(sections{i}, otherSymsSec); pause;

        % Part 2.7: Unbeamed note detection
        if(~isequal(zeros(size(sections{i})), unbeamedSec))
            [unbeamedNotes, ledgerLineLocs1] = detectUnbeamedNotes(unbeamedSec, ...
                spaceHeight, lineHeight, wholeNotes, debug);    
        end    
        % Part 2.8: Beamed note detection
        if(~isequal(zeros(size(sections{i})), beamedSec))
            [beamedNotes, ledgerLineLocs2] = detectBeamedNotes(...
                beamedSec, spaceHeight, debug);
        end
        
        % Part 2.9: Other symbol detection (rests, dots, ties, slurs, barlines)
        [otherSymbols, ledgerLineLocs3] = detectOtherSymbols(otherSymsSec, ...
            spaceHeight, lineHeight, newStaffLines{i}, combined, dot, ...
            tieslur, debug);

        % Part 2.10: Combining symbols sorted by horizontal location for next
        % phase
        totalSyms = [unbeamedNotes; beamedNotes; otherSymbols];
        totalSyms = sortrows(totalSyms, 6);
        disp(totalSyms);    
%         pause;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%   PHASES 3/4: MUSIC NOTATION RECONSTRUCTION   %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        % Part 3.1 Calculating ledger/staff lines and staff space locations,
        % and assigning appropriate pitches
        ledgerLineLocs = sort([ledgerLineLocs1; ledgerLineLocs2; ...
            ledgerLineLocs3]);
        [ledgerStaffSpace, pitch, note, pitchPreKS, staffCenters, keyType, ...
            keySigIdx, grandStaffDivider] = finalStaffPitchAssignment(...
            sections{i}, newStaffLines{i}, ledgerLineLocs, clefs, keys);

        % Part 3.2 
        if (isempty(grandStaffDivider))
            SoloSheetMusicGenerator(totalSyms, totalTimeSignature, ledgerStaffSpace, ...
                pitch, note, pitchPreKS, staffCenters, keyType, keySigIdx, spaceHeight, ...
                lineHeight, fid1, fid2);
        else
            PianoSheetMusicGenerator(totalSyms, totalTimeSignature, ledgerStaffSpace, ...
                pitch, note, pitchPreKS, staffCenters, keyType, keySigIdx, spaceHeight, ...
                lineHeight, fid1, fid2);        
        end
        %}
        pause;
    end
    %
end