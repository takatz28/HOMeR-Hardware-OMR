clc, clear, close all;
tic 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%         PHASE ZERO: INPUT FILES          %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------- Flute/Violin (G) ---------------------------
inputImg =  imread('camptown.jpg');    
% inputImg =  imread('child.jpg');      
% inputImg =  imread('matilda.jpg');      
% inputImg =  imread('sunshine.jpg');   
% ----------------------------------------------------------------
%---------------------- Piano (G,F) ------------------------------
% inputImg =  imread('america2.jpg');       %/
% inputImg = imread('Burleske.jpg');        %/
% inputImg =  imread('canon1.jpg');         %/    
% inputImg =  imread('canon2.jpg');         %/
% inputImg =  imread('furelise.jpg');       %/
% inputImg =  imread('minuet.jpg');         %/
% inputImg =  imread('odePiano.jpg');       %/
% inputImg =  imread('mac.jpg');            %/
% inputImg =  imread('saints_.jpg');         %/
% inputImg =  imread('turk_Page_1.jpg');    %/
% inputImg =  imread('turk_Page_2.jpg');    %/
% inputImg =  imread('Grace2.jpg');      
% -----------------------------------------------------------------
%---------------------- Viola (C) ---------------------------------
% inputImg =  imread('patrol.jpg');
% inputImg =  imread('silent.jpg');     
% inputImg =  imread('twinkle.jpg');  
% ------------------------------------------------------------------
% ---------------------- Cello/Trombone (F) ------------------------
% inputImg = imread('sweetheart.jpg');
% inputImg = imread('jolly2.jpg');
% inputImg = imread('johnny.jpg');
%------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%         PHASE ONE: PREPROCESSING         %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[img_bw, lineHeight, spaceHeight] = preprocess(inputImg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%   PHASE TWO: MUSIC SYMBOLS RECOGNITION   %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 2.1: Staff detection, removal, and division
[staffLines, staffHeights] = staffDetect(img_bw);
dividers = staffDivider(img_bw, staffLines, lineHeight, spaceHeight);
img_no_staff = staffRemove(img_bw, staffLines, staffHeights, spaceHeight);
[sections, newStaffLines] = scoreToSections(img_no_staff, ...
    staffLines, dividers, spaceHeight);

% Part 2.2: Importing dataset for template matching
clef = readDataset('clefs');
key = readDataset('keys');
timeSig = readDataset('timeSignatures');
closedNotes = readDataset('closedNotes');
wholeNotes = readDataset('whole');
stemmedNotes = readDataset('stemmed'); 
accidental = readDataset('accidentals');
dot = readDataset('dots');
rest = readDataset('rests');
other = readDataset('others');
combinedSyms = [accidental; rest; other];


outFile1 = 'sheetNotes.h';
fullFile = strcat('C:\Projects\FinalProject\Working\AudioTest',...
    '\AudioTest.sdk\AudioTest_v1\src\', outFile1);
fid1 = fopen(fullFile, 'w');

outFile2 = 'sheetBeat.h';
fullFile = strcat('C:\Projects\FinalProject\Working\AudioTest',...
    '\AudioTest.sdk\AudioTest_v1\src\', outFile2);
fid2 = fopen(fullFile, 'w');

fprintf(fid1,'#include "notes.h"\n\n');
fprintf(fid1,'int noteArray[][9] = \n{\n');

% fprintf(fid,'#include "notes.h"\n\n');
fprintf(fid2,'double beatArray[] = \n{\n\t');

figure;
totalTimeSignature = [];
for i = 1:length(sections)
    fprintf("-----------------------------------------------------------------\n");
    fprintf("    Section %d symbols: \n", i);
    imshow(sections{i}); impixelinfo; 

    % Part 2.3: Clef detection
    [clefs, clefBound]  = detectClefs(sections{i}, spaceHeight, ... 
        newStaffLines{i}, clef);
    disp(clefs);

    % Part 2.4: Key signature detection
    if (i == 1)
        [keySignature, keys, keyTemp] = detectKeySig(sections{i}, spaceHeight, ...
            i, newStaffLines{i}, clefBound, clefBound+10*spaceHeight, key);
        keySigBound = keyTemp;
        fprintf('\tKey signature: %s\n\n', keySignature);
    else
        [keySignature, keys, keyTemp] = detectKeySig(sections{i}, spaceHeight, ...
            i, newStaffLines{i}, clefBound, keySigBound, key);
        keySigBound = keyTemp;
        fprintf('\tKey signature: %s\n\n', keySignature);
    end
    
    % Part 2.5: Time signature detection
    [timeSignature, timeSigBound] = detectTimeSig(sections{i}, ...
        spaceHeight, keySigBound, timeSig);
    
    totalTimeSignature =  [totalTimeSignature; timeSignature];
    
    if(isempty(timeSignature))
        nextBound = keySigBound;
    else
        nextBound = timeSigBound;
    end
    disp(timeSignature);
    
    % Part 2.6: Section sorting to unbeamed/beamed notes, and other symbols
    [unbeamedSec, beamedSec, otherSymsSec] = noteSorter(sections{i}, ...
        nextBound, spaceHeight, lineHeight);
%     noteSorter(sections{i}, nextBound, spaceHeight, lineHeight);
%     imshowpair(sections{i}, unbeamedSec); pause;
%     imshowpair(sections{i}, beamedSec); pause;
%     imshowpair(sections{i}, otherSymsSec); pause;

    %
    % Part 2.7: Unbeamed note detection
    [unbeamedNotes, ledgerLineLocs1] = detectUnbeamedNotes(unbeamedSec, ...
        spaceHeight, lineHeight, wholeNotes, closedNotes);    
    % Part 2.8: Beamed note detection
    [beamedNotes, ledgerLineLocs2] = detectBeamedNotes(beamedSec, ...
        spaceHeight, lineHeight);    
    % Part 2.9: Other symbol detection (rests, dots, ties, slurs, barlines)
    [otherSymbols, ledgerLineLocs3] = detectOtherSymbols(otherSymsSec, ...
        nextBound, spaceHeight, newStaffLines{i}, combinedSyms, dot);
    ledgerLineLocs = sort([ledgerLineLocs1; ledgerLineLocs2; ...
        ledgerLineLocs3]);
    
    % Part 2.9: Combining symbols sorted by horizontal location for next
    % phase
    totalSyms = [unbeamedNotes; beamedNotes; otherSymbols];
    totalSyms = sortrows(totalSyms, 6);
    disp(totalSyms);
    pause;
    %
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%    PHASES 3/4: MUSIC SYMBOL RECONSTRUCTION    %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Part 3.1 Calculating ledger/staff lines and staff space locations,
    % and assigning appropriate pitches
    %
    [ledgerStaffSpace, pitch, note, pitchPreKS, staffCenters, keyType, ...
        keySigIdx, staffDivider] = finalStaffPitchAssignment(...
        sections{i}, newStaffLines{i}, ledgerLineLocs, clefs, keys);

    if (isempty(staffDivider))
        SoloSheetMusicGenerator(totalSyms, totalTimeSignature, ledgerStaffSpace, ...
            pitch, note, pitchPreKS, staffCenters, keyType, keySigIdx, spaceHeight, ...
            lineHeight, fid1, fid2);
    else
        PianoSheetMusicGenerator(totalSyms, totalTimeSignature, ledgerStaffSpace, ...
            pitch, note, pitchPreKS, staffCenters, keyType, keySigIdx, spaceHeight, ...
            lineHeight, fid1, fid2);        
    end

%     pause;
    clc;
    hold off;
end

fprintf(fid1,'};');
fprintf(fid2,'\n};');
%}
close all
toc