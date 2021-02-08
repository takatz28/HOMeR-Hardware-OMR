function [noteHole, cc, holeStats] = detectOpenNoteheads(img, spaceHeight)    
    
    % remove ledger lines 
    tempImg = img;
    % isolate holes
    filledHoles = imfill(~tempImg, 'holes');
    noteHoles = ~xor(filledHoles, tempImg);
    
%     imshow(noteHoles); pause;
    
    cc1 = bwconncomp(noteHoles);
    stats = regionprops(cc1,'Area'); 
    idx1 = find([stats.Area] >= 4*spaceHeight); 
    noteHoles = ismember(labelmatrix(cc1),idx1);
    idx1_1 = find([stats.Area] < 4*spaceHeight);
    tempNoteHole1 = ismember(labelmatrix(cc1),idx1_1);
%     imshowpair(noteHoles, tempNoteHole1); pause;
    
    ledgerLines = imopen(~tempImg, strel('line', ...
        floor(spaceHeight * 1.375), 0));
% %     imshowpair(ledgerLines, img); pause;
    ledgerLines2 = imerode(ledgerLines, strel('line', ...
        floor(spaceHeight * 0.9), 0));
    
%     imshowpair(ledgerLines2, img); pause;
    tempNoteHole2 = xor(~ledgerLines2, ~tempNoteHole1);
%     imshow(tempNoteHole2); pause;
    cc2 = bwconncomp(tempNoteHole2);
    stats2 = regionprops(cc2,'Area'); 
    idx2 = find([stats2.Area] >= 5*spaceHeight); 
    tempNoteHole2 = ismember(labelmatrix(cc2),idx2);
%     imshowpair(noteHoles, tempNoteHole2); pause;
%     imshowpair(noteHoles, tempNoteHole1); pause;
    
    
%     imshow(noLedgerLines); pause;

    noteHoles = xor(noteHoles, tempNoteHole2);
    
    cc = bwconncomp(noteHoles);
    stats = regionprops(cc,'Area'); 
    idx = find([stats.Area] > 4*spaceHeight); 
    noteHole = ismember(labelmatrix(cc),idx);

    cc = bwconncomp(noteHole);
    holeStats = regionprops(cc, 'BoundingBox');

end

