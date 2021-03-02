%-------------------------------------------------------------------------
% Function name:    detectBeamedNotes
% Input arg(s):     beamed section, staff spaceheights
% Outputs arg(s):   beamed notes and ledger line locations
% Description:      Detects single and chord beamed notes from 8th to
%                   64th
%-------------------------------------------------------------------------
function [beamedNotes, ledgerLineLocs] = detectBeamedNotes(section, ...
    spaceHeight, debug)

    %-----------------------------------------------------------------
    % Preprocessing: Ledger removal and beam/stem isolation 
    %-----------------------------------------------------------------
    % Using a diamond structuring element, note heads are temporarily 
    % detected, then removed.
    tempOpen = imopen(~section, strel('diamond', floor(0.5*spaceHeight)));
    tempOpen = imdilate(tempOpen, strel('square', 1));
    tempOpen = xor(section, ~tempOpen);
    
    % Perform an opening to isolate only the beams with the stems attached
    % and small leftover components from the first part
    beamBuf = imopen(tempOpen, strel('line', floor(0.5*spaceHeight), 90));
    cc = bwconncomp(beamBuf);
	stats = regionprops(beamBuf, 'BoundingBox', 'Area'); 
    % Remove the small components from the image
	idx = find([stats.Area] > 2*spaceHeight);
    % Only the beam/stems are used for next calculation
    beamStems = ismember(labelmatrix(cc), idx);
    
    % Partial notehead detection (removing beam/stems)
    noteHeads = imopen(xor(section, beamStems), strel('line', 3, 0)); 
    % Ledger line detection similar to unbeamed note function
    ledgerLines = imclose(noteHeads, strel('rectangle', ...
        [2, floor(spaceHeight * 2)]));
%     imshow(ledgerLines); pause;
    cc2 = bwconncomp(~ledgerLines);
    stats = regionprops(cc2, 'Area');
    % Ensures that only ledger lines are being removed and not segments
    % of adjacent notes
    idx2 = find([stats.Area] <= 12*spaceHeight);
    ledgerLines = ismember(labelmatrix(cc2), idx2);   
%     imshow(ledgerLines); pause;
    % Extends the ledger lines for location calculation
    lineExt = imdilate(ledgerLines, strel('line', ...
        2*size(section,2), 0));
    ledgerLineLocs = find(sum(lineExt, 2) ~= 0);
    
    % If ledger lines are detected, they will be removed to keep only the 
    % noteheads, otherwise, invert the notehead image
    if(~isempty(ledgerLineLocs))
        newNoteHeads = ~ledgerRemove(noteHeads, ledgerLineLocs);
    else
        newNoteHeads = ~noteHeads;
    end
    
    %-----------------------------------------------------------------
    % Beam segmentation: spaces will be added in between notes in the
    %     same beam so that each note(s) can be processed separately
    %-----------------------------------------------------------------
    cutBeamStems = zeros(size(section));
    for i=1:length(idx)
        % Isolate individual beamstem, then extract the stems for distance
        % calculation
        beamStems2 = ismember(labelmatrix(cc), idx(i));
        tempImg2 = imopen(beamStems2, strel('line', spaceHeight, 90));
        % Get the centroid of each stem and only use the x value
        beamRefPts = regionprops(tempImg2, 'Centroid');
        beamCenters = cat(1,beamRefPts.Centroid);
        beamCenters = beamCenters(:,1);
        % Calculate the midpoints between existing stems
        beamDiff = floor(beamCenters(1:end-1) + (diff(beamCenters/2)));

        % Set three pixels to the left and right of the midpoints to 0 
        % to segment notes
        for k = 1:length(beamDiff)
            beamStems2(:,beamDiff(k)-3:beamDiff(k)+3) = 0;
        end
        cutBeamStems = xor(cutBeamStems, beamStems2);
    end
    % The updated beams are reattached to the noteheads for next step
    % detection
    newSection = or(~noteHeads, cutBeamStems);
    cc = bwconncomp(newSection);
    sectionStats = regionprops(cc, 'BoundingBox', 'Area');

    symbol = {};
    loc = {};
    category = {};
    type = {};
    value = {};
    symIdx = {};
    symCount = 1;

    for j = 1:numel(sectionStats)    
        % Isolate individual note/chord
        tempImg = ismember(labelmatrix(cc), j);
        
        %------------------------------------------------------------
        % Beam counting: determines the type of note (8th-64th) 
        %------------------------------------------------------------
        % Extract the beam/stem part of the note
        beamTemp = and(cutBeamStems, tempImg); 
        % Remove the stem, leaving only flags
        stem = imopen(beamTemp, strel('line', spaceHeight, 90));
        % Slightly erode the flags to ensure disconnect among flags
        beamTemp = imerode(xor(stem, beamTemp), strel('disk', 1));
        % Close distance between flags that were cut during stem removal
        beamTemp = imclose(beamTemp, strel('line', floor(spaceHeight...
            * 0.5), 0));
        beamStats = regionprops(beamTemp, 'BoundingBox');
        % Return the number of existing flags in the current note
        beamStatsCount = numel(beamStats);
        
        if (debug == 1)
            for jj = 1:beamStatsCount
                rectangle('Position',beamStats(jj).BoundingBox, ...
                    'EdgeColor', 'b', 'LineWidth',2)            
            end
        end
        
        %------------------------------------------------------------
        % Notehead counting: Similar to the unbeamed note function 
        %------------------------------------------------------------
        % Isolate noteheads from segmented note image
        noteHeadTemp = and(newNoteHeads, tempImg); 
        % Detect individual notehead using a line structuring element
        % with length of spaceHeight, angled at 30 degrees 
        noteHead = imerode(noteHeadTemp, strel('line', spaceHeight, 30));
        % Detected noteheads are enhanced in order to be counted properly
        % *Second condition is added as a failsafe for smaller sheets
        if (spaceHeight > 10)
            noteHead = imopen(noteHead, strel('disk', 3));
        else
            noteHead = imopen(noteHead, strel('disk', 2));           
        end
        cc3 = bwconncomp(noteHead);
        noteHeadStats = regionprops(cc3, 'BoundingBox', 'Area');
        % If side-adjacent notes are present, they have to be broken 
        % further for correct detection
        idx = find([noteHeadStats.Area] > 10*spaceHeight);
        % Isolate the partially detected notes
        tempImg2 = ismember(labelmatrix(cc3), idx);
        % Remove isolated component from complete notehead image
        noteHead = xor(noteHead, ismember(labelmatrix(cc3), idx));

        % Adjacent note segmentation
        if (~isequal(tempImg2, zeros(size(noteHead))))
            % The stem is extended horizontally and vertically
            stemExt = imdilate(stem, strel('line', 2*spaceHeight, 90));
            stemExt = imdilate(stemExt, strel('line', floor(0.5*...
                spaceHeight), 0));
            % By extending the stems, it ensures complete separation
            % between connected noteheads
            tempImg2 = or(~tempImg2, stemExt);
            noteHead = or(noteHead, ~tempImg2); 
            noteHeadStats = regionprops(noteHead, 'BoundingBox');
        end
        
        % Determine the note type based on flag count
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
        
            % Count the number of noteheads detected in the isolated 
            % note/chord
            for ii = 1:numel(noteHeadStats)
                % Every notehead's boundaries are extracted
                z2 = noteHeadStats(ii).BoundingBox;
                h2 = ceil(z2(2))+z2(4);
                w2 = ceil(z2(1))+z2(3);
                boxHeight2 = ceil(z2(2)):h2;
                boxWidth2 = ceil(z2(1)):w2;
                
                % Each notehead's parameters are saved
                chordNote = ismember(labelmatrix(cc3),ii);                            
                symbol{symCount} = chordNote(boxHeight2, boxWidth2);
                loc(symCount) = {[ceil(z2(2)) h2 ceil(z2(1)) w2]};
                category(symCount) = {'note'};
                type(symCount) = {noteType};
                value(symCount) = {noteVal};
                symIdx(symCount) = {ceil(z2(1))};
                symCount = symCount + 1;

                if (debug == 1)
                    rectangle('Position',noteHeadStats(ii).BoundingBox, ...
                        'EdgeColor', '#4DBEEE', 'LineWidth',2);
                end
            end
        end
    end
    
    % Combine parameters for complete beamed note definitions
    beamedNotes = [symbol', loc', category', type', value', symIdx'];
end