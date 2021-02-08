function [beamedNotes, ledgerLineLocs] = detectBeamedNotes(section, spaceHeight, lineHeight)

    sectionBuf = section;
    sectionStats = regionprops(~sectionBuf, 'BoundingBox');
    
    % removes adjacent noteheads before beam counting
    for i = 1:numel(sectionStats)
        tempImg = ones(size(section));
        z = sectionStats(i).BoundingBox;
        h = ceil(z(2))+z(4);
        w = ceil(z(1))+z(3);
        boxHeight = ceil(z(2)):h-1;
        boxWidth = ceil(z(1)):w-1;
        tempImg(boxHeight, boxWidth) = section(boxHeight, boxWidth);
%         imshow(tempImg); pause;

        project_V = sum(~tempImg,1);
        [~, idx] = max(project_V);
        tempImg(:,idx-2:idx+2) = 1;
        
        tempImg2 = imclose(~tempImg, strel('line', spaceHeight, 0));
        tempImg2 = imerode(tempImg2, strel('diamond', floor(spaceHeight/2.125)));
        tempImg2 = imdilate(tempImg2, strel('diamond', floor(spaceHeight/2.125)));
%         imshow(or(~tempImg2, tempImg)); pause;

        beamStats = regionprops(tempImg2, 'BoundingBox', 'Eccentricity');
        for j = 1:numel(beamStats)
            z2 = beamStats(j).BoundingBox;
            h2 = ceil(z2(2))+z2(4);
            w2 = ceil(z2(1))+z2(3);
            boxHeight2 = ceil(z2(2))-8:h2+8;
            boxWidth2 = ceil(z2(1))-spaceHeight:w2+spaceHeight;
            if ((z2(3) <= 1.5*spaceHeight) && (z2(4) > 0.7*spaceHeight))
                sectionBuf(boxHeight2, boxWidth2) = 1;
            end
        end
    end

    % Extract ledger lines for subsequent pitch assignment
    ledgerLines = imclose(~xor(sectionBuf, section), strel('line', ...
        floor(spaceHeight * 2), 0));
    lineExt = imdilate(~ledgerLines, strel('line', ...
        2*size(section,2), 0));
    ledgerLineLocs = find(sum(lineExt, 2) ~= 0);
%     imshowpair(lineExt, section); pause;

    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {};
    symIdx = {};
    symCount = 1;

    for i = 1:numel(sectionStats)
        tempImg = ones(size(section));
        tempImg2 = ones(size(section));
        z = sectionStats(i).BoundingBox;
        h = ceil(z(2))+z(4);
        w = ceil(z(1))+z(3);
        boxHeight = ceil(z(2)):h-1;
        boxWidth = ceil(z(1)):w-1;
        tempImg(boxHeight, boxWidth) = sectionBuf(boxHeight, boxWidth);
        project_V = sum(~tempImg,1);
        [~, idx] = max(project_V);
        tempImg(:,idx-1:idx+1) = 1;
%         imshow(tempImg); pause;
        
        cutBeamLines = imclose(~tempImg, strel('line', floor(spaceHeight/2), 0));
        beamLines = imerode(cutBeamLines, strel('disk', floor(spaceHeight/8)));
        beamStats = regionprops(beamLines);
        beamStatsCount = numel(beamStats);
%         imshow(~beamLines); pause;
        
        tempImg2(boxHeight, boxWidth) = section(boxHeight, boxWidth);
%         imshow(tempImg2); pause;
        noteHead = imerode(~tempImg2, strel('diamond', ...
            floor((spaceHeight+lineHeight)*0.3)));
        noteHead = imopen(noteHead, strel('disk', 2));
        noteHead = imerode(noteHead, strel('square', 2));
%         imshow(noteHead); pause;
        cc = bwconncomp(noteHead);
        noteHeadStats = regionprops(cc, 'BoundingBox');
        
        
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
                boxHeight2 = ceil(z2(2)):h2-1;
                boxWidth2 = ceil(z2(1)):w2-1;
                
                chordNote = ismember(labelmatrix(cc),ii);
%                 imshow(~chordNote); pause;
                            
                symbol{symCount} = ~chordNote(boxHeight2, boxWidth2);
                loc(symCount) = {[ceil(z2(2)) h2-1 ceil(z2(1)) w2-1]};
                category(symCount) = {'note'};
                type(symCount) = {noteType};
                value(symCount) = {noteVal};
                symIdx(symCount) = {ceil(z2(1))};
                symCount = symCount + 1;
    %             end
                rectangle('Position',noteHeadStats(ii).BoundingBox, ...
                    'EdgeColor', '#4DBEEE', 'LineWidth',2)
            end
        end
    end
    
    beamedNotes = [symbol', loc', category', type', value', symIdx'];
end