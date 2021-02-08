function [beamedNotes, ledgerLineLocs] = detectBeamedNotes(section, spaceHeight)

    tempOpen = imopen(~section, strel('diamond', floor(0.5*spaceHeight)));
    tempOpen = imdilate(tempOpen, strel('square', 1));
    tempOpen = xor(section, ~tempOpen);
%     imshow(tempOpen); pause;

    beamBuf = imopen(tempOpen, strel('line', floor(0.5*spaceHeight), 90));
    cc = bwconncomp(beamBuf);
	stats = regionprops(beamBuf, 'BoundingBox', 'Area'); 
	idx = find([stats.Area] > 2*spaceHeight);
    beamStems = ismember(labelmatrix(cc), idx);
%     imshow(beamStems); pause;
%     cc = bwconncomp(~beamStems);
    
    noteHeads = imopen(xor(section, beamStems), strel('line', 3, 0)); 
    ledgerLines = imclose(noteHeads, strel('line', ...
        floor(spaceHeight * 2), 0));
    lineExt = imdilate(~ledgerLines, strel('line', ...
        2*size(section,2), 0));
    ledgerLineLocs = find(sum(lineExt, 2) ~= 0);
    
    if(~isempty(ledgerLineLocs))
        newNoteHeads = ~ledgerRemove(noteHeads, ledgerLineLocs);
%         section = ledgerRemove(section, ledgerLineLocs);
    else
        newNoteHeads = ~noteHeads;
    end
%     imshow(newNoteHeads); pause;
%     imshowpair(beamStems, newNoteHeads); pause

    cutBeamStems = zeros(size(section));
    for i=1:length(idx)
        beamStems2 = ismember(labelmatrix(cc), idx(i));
        tempImg2 = imopen(beamStems2, strel('line', spaceHeight, 90));
        beamRefPts = regionprops(tempImg2, 'Centroid');
        beamCenters = cat(1,beamRefPts.Centroid);
        beamCenters = beamCenters(:,1);
%         imshowpair(tempImg2, section); pause;
        beamDiff = floor(beamCenters(1:end-1) + (diff(beamCenters/2)));
%         
        for k = 1:length(beamDiff)
            beamStems2(:,beamDiff(k)-2:beamDiff(k)+2) = 0;
        end
        cutBeamStems = xor(cutBeamStems, beamStems2);
    end
    newSection = or(~noteHeads, cutBeamStems);
%     imshow(newSection); pause;
    cc = bwconncomp(newSection);
%     tempImg = labelmatrix(cc)
    sectionStats = regionprops(cc, 'BoundingBox', 'Area');
%     idx = find([sectionStats.Area] > 1);
    %     cutBeamStats = regionprops(cutBeamStems, 'BoundingBox');

    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {};
    symIdx = {};
    symCount = 1;
%     idx(1)
%     idx(2)
    % removes adjacent noteheads before beam counting
    for j = 1:numel(sectionStats)
        
        tempImg = ismember(labelmatrix(cc), j);
%         imshow(tempImg3); pause;
%         imshow(tempImg); pause;
%         noteHeadTemp = zeros(size(section));
%         z = sectionStats(j).BoundingBox;
%         h = ceil(z(2))+z(4);
%         w = ceil(z(1))+z(3);
%         boxHeight = ceil(z(2)):h;
%         boxWidth = ceil(z(1)):w;
        noteHeadTemp = and(newNoteHeads, tempImg); 
%         imshow(noteHeadTemp); pause;
%         beamTemp = zeros(size(section));
%         z2 = cutBeamStats(j).BoundingBox;
%         h2 = ceil(z2(2))+z2(4);
%         w2 = ceil(z2(1))+z2(3);
%         boxHeight2 = ceil(z2(2)):h2;
%         boxWidth2 = ceil(z2(1)):w2;
        
        % flag type detection
%         beamTemp(boxHeight, boxWidth) = cutBeamStems(boxHeight, boxWidth);
%         imshow(beamTemp); pause;
        beamTemp = and(cutBeamStems, tempImg); 
%         imshow(beamTemp); pause;
        stem = imopen(beamTemp, strel('line', spaceHeight, 90));
        beamTemp = imerode(xor(stem, beamTemp), strel('disk', 1));
        beamTemp = imclose(beamTemp, strel('line', floor(spaceHeight * 0.5), 0));
%         imshowpair(newSection, beamTemp); pause;
%         cc2 = bwconncomp(beamTemp);
%         flagStats = regionprops(beamTemp, 'Area');
%         idx = find([flagStats.Area] > 2*spaceHeight);
%         flagTemp = ismember(labelmatrix(cc2), idx);
        beamStats = regionprops(beamTemp, 'BoundingBox');
        beamStatsCount = numel(beamStats);
        
        for jj = 1:beamStatsCount
            rectangle('Position',beamStats(jj).BoundingBox, ...
                'EdgeColor', 'b', 'LineWidth',2)            
        end
%         imshowpair(beamTemp, section); pause;

        
        %note counter
%         noteHeadTemp(boxHeight, boxWidth) = newNoteHeads(boxHeight, boxWidth);
%         imshowpair(newSection, noteHeadTemp); pause;
        noteHead = imerode(noteHeadTemp, strel('line', spaceHeight, 30));
        noteHead = imopen(noteHead, strel('disk', 3));
%         imshow(noteHead); pause;
        cc3 = bwconncomp(noteHead);
        noteHeadStats = regionprops(cc3, 'BoundingBox');
        
        if (beamStatsCount >= 1 && beamStatsCount <= 4)
            if (numel(beamStats) == 1)
                noteType = '8th';
                noteVal = 0.5;
            elseif (numel(beamStats) == 2)
                noteType = '16th';
                noteVal = 0.25;
            elseif (numel(beamStats) == 3)
                noteType = '32nd';
                noteVal = 0.125;
            elseif (numel(beamStats) == 4)
                noteType = '64th';
                noteVal = 0.0625; 
            end
        
            for ii = 1:numel(noteHeadStats)
                z2 = noteHeadStats(ii).BoundingBox;
                h2 = ceil(z2(2))+z2(4);
                w2 = ceil(z2(1))+z2(3);
                boxHeight2 = ceil(z2(2)):h2;
                boxWidth2 = ceil(z2(1)):w2;
                
                chordNote = ismember(labelmatrix(cc3),ii);
%                 imshow(chordNote); pause;
                            
                symbol{symCount} = chordNote(boxHeight2, boxWidth2);
                loc(symCount) = {[ceil(z2(2)) h2 ceil(z2(1)) w2]};
                category(symCount) = {'note'};
                type(symCount) = {noteType};
                value(symCount) = {noteVal};
                symIdx(symCount) = {ceil(z2(1))};
                symCount = symCount + 1;
    %             end
                rectangle('Position',noteHeadStats(ii).BoundingBox, ...
                    'EdgeColor', '#4DBEEE', 'LineWidth',2)
            end
        end%         imshow(noteHead); pause;
    end
    beamedNotes = [symbol', loc', category', type', value', symIdx'];
%     imshowpair(noteHead, ~newNoteHeads); pause;
%     pause;
end