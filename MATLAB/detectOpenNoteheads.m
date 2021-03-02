%-------------------------------------------------------------------------
% Function name:    detectOpenNoteHeads
% Input arg(s):     half/whole note image, spaceHeight
% Outputs arg(s):   note hole(s), connected components, note hole stats
% Description:      Counts the number of note holes that exist in whole
%                   and half notes
%-------------------------------------------------------------------------
function [noteHole, cc, holeStats] = detectOpenNoteheads(img, spaceHeight)    
    
    % After buffering the note, it will be filled, and after performing 
    % an XOR with the original note, only the hole(s) remain
    tempImg = img;
    % Ensures that vertical edges are completely connected
    tempImg = imopen(tempImg, strel('line', 2, 90));
    filledHoles = imfill(~tempImg, 'holes');
    noteHoles = ~xor(filledHoles, tempImg);

    % If no hole is detected, the note is not completely connected, thus,
    % an opening is applied to close any disconnect in the edges
    if (isequal(noteHoles, zeros(size(tempImg))))
        tempImg = imopen(img, strel('line', 3, -45));
        filledHoles = imfill(~tempImg, 'holes');
        noteHoles = ~xor(filledHoles, tempImg);
    end
    
    %---------------------------------------------------------------
    % First pass: Checks if the holes are partial(holes from notes
    %    with ledger lines) or complete
    %---------------------------------------------------------------
    cc1 = bwconncomp(noteHoles);
    stats = regionprops(cc1, 'Area'); 
    % Failsafe: If spaceheight is greater than the specified value, the
    % minimum/maximum area constraints are increased
    %    idx1: whole holes
    %    idx1_1: partial holes
    if (spaceHeight > 15)
        idx1 = find([stats.Area] >= 6*spaceHeight); 
        idx1_1 = find([stats.Area] < 6*spaceHeight);
    else
        idx1 = find([stats.Area] >= 4.5*spaceHeight); 
        idx1_1 = find([stats.Area] < 4.5*spaceHeight);
    end
    % Temporary holder that contains whole holes
    noteHoles = ismember(labelmatrix(cc1),idx1);    
    % Temporary holder that contains partial holes
    tempNoteHole1 = ismember(labelmatrix(cc1),idx1_1);  
    statsTmp = regionprops(tempNoteHole1);

    % Variation of the ledger line removal: Some part of the line is kept
    % to connect partial holes to form a 'complete' hole
    ledgerLines = imopen(~tempImg, strel('line', ...
        floor(spaceHeight * 1.375), 0));
    ledgerLines2 = imerode(ledgerLines, strel('line', ...
        floor(spaceHeight * 0.9), 0));
    
    %---------------------------------------------------------------
    % Second pass: Once the holes are fixed, this pass removes un-
    %    necessary lines from the ledger line detection part
    %---------------------------------------------------------------
    tempNoteHole2 = xor(~ledgerLines2, ~tempNoteHole1);
    cc2 = bwconncomp(tempNoteHole2);
    stats2 = regionprops(cc2,'Area'); 
    % Failsafe: For smaller sheets, the area constraint is reduced
    if (spaceHeight > 10)
        idx2 = find([stats2.Area] >= 5*spaceHeight); 
    else
        idx2 = find([stats2.Area] >= 2*spaceHeight); 
    end
    % If the constraint is met, the hole is passed through
    tempNoteHole2 = ismember(labelmatrix(cc2),idx2);
    noteHoles = xor(noteHoles, tempNoteHole2);

    
    % If only one partial hole is detected in a half note with ledger 
    % line, it is possible that the edges are open, thus, it is fixed
    % in this part
    if (numel(statsTmp) == 1)
        img = or(img, noteHoles);
        tempImg = imopen(img, strel('line', 3, -45));
        filledHoles = imfill(~tempImg, 'holes');
        noteHoles = ~xor(filledHoles, tempImg);
    end
    
    %---------------------------------------------------------------
    % Third pass: Ensures that only holes are detected and passed
    %---------------------------------------------------------------
    cc = bwconncomp(noteHoles);
    stats = regionprops(cc,'Area'); 
    idx = find([stats.Area] > 4*spaceHeight); 
    noteHole = ismember(labelmatrix(cc),idx);

    % Parameters that will be used in the unbeamed note detection
    cc = bwconncomp(noteHole);
    holeStats = regionprops(cc, 'BoundingBox');

end

