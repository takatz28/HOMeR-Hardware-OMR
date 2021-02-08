function [noteHole, cc, holeStats] = detectOpenNoteheads(img, spaceHeight)    
    
    % remove ledger lines 
    tempImg = img;
    ledgerLines = imopen(~tempImg, strel('line', ...
        floor(spaceHeight * 1.75), 0));
    ledgerLines2 = imerode(ledgerLines, strel('line', ...
        floor(2*spaceHeight), 0));
    noLedgerLines = xor(~ledgerLines2, tempImg);

    % isolate holes
    filledHoles = imfill(~tempImg, 'holes');
    noteHoles = xor(filledHoles, noLedgerLines);
    cc = bwconncomp(noteHoles);
    stats = regionprops(cc,'Area'); 
    idx = find([stats.Area] > 5*spaceHeight); 
    noteHole = ismember(labelmatrix(cc),idx);

    cc = bwconncomp(noteHole);
    holeStats = regionprops(cc, 'BoundingBox');

end

