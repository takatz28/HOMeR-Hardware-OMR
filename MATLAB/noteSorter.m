%-------------------------------------------------------------------------
% Function name:    noteSorter
% Input arg(s):     section, ROI boundary, staff space/line heights
% Outputs arg(s):   unbeamed, beamed, and other symbol sections
% Description:      Sorts the components based on type (unbeamed notes, 
%                   beamed notes, or non-note symbols)
%-------------------------------------------------------------------------
function [unbeamedSec, beamedSec, otherSymsSec] = noteSorter(section, ...
    bound, spaceHeight, lineHeight)

    % The ROI is the area just after the time signature's rightmost
    % boundary
    tempImg = ones(size(section));
    boundary = bound:size(section,2);
    tempImg(:,boundary) = section(:,boundary);
    
    %---------------------------------------------------------------------
    % First pass: Connected components that fall in the stemmed note/chord
    % and whole note/chord category are sorted
    %---------------------------------------------------------------------
    cc = bwconncomp(~tempImg);
    unbeamedStats = regionprops(cc, 'BoundingBox', 'Eccentricity', ...
        'Circularity');
    unbeamedSec = ones(size(section));
    for i = 1:numel(unbeamedStats)
        z = unbeamedStats(i).BoundingBox;
        % Symbols that fall under unbeamed category:
        % - half-64th note/chords     
        % - whole notes/chords
        if ((z(3) >= 1.375*spaceHeight && z(3) <= 3.5*spaceHeight) && ...
            (z(4) >= 2*spaceHeight && z(4) <= 15*spaceHeight))
            % Perform stem check on current symbol
            temp = ismember(labelmatrix(cc), i);
            tempOpen = imopen(temp, strel('line', (1.75*spaceHeight), 90));
            stemStats = regionprops(tempOpen);

            % If stem(s) exist, it will be included in the unbeamed 
            % section
            if(numel(stemStats) ~= 0)
                unbeamedSec = xor(ismember(labelmatrix(cc),i), ...
                    unbeamedSec);
            end
        % Potential single whole notes; circularity is added in the
        % condition
        elseif ((z(3) >= 1.375*spaceHeight && z(3) <= 3.25*spaceHeight) ...
            && (z(4) >= spaceHeight && z(4) <= (1.5*spaceHeight)) && ...
            (unbeamedStats(i).Circularity > 0.2))
            unbeamedSec = xor(ismember(labelmatrix(cc),i), unbeamedSec);
        end
    end
    % Remove potential unbeamed symbols from original section
    beamedSec = xor(tempImg, unbeamedSec);

    %---------------------------------------------------------------------
    % Second pass: Connected components that fall in the other symbol
    % category are sorted
    %---------------------------------------------------------------------
    cc2 = bwconncomp(beamedSec);
    otherStats = regionprops(cc2, 'BoundingBox');
    otherSymsSec = ones(size(section));
    for j = 1:numel(otherStats)
        % Bounding box parameters for second pass
        z2 = otherStats(j).BoundingBox;
        if (((z2(3) < 20*spaceHeight)  && ...
            (z2(4) < 3*spaceHeight)) || ...
            ((z2(3) < 3*spaceHeight)  && ...
            (z2(4) < 6*spaceHeight)) || ...
            z2(3) <= spaceHeight)
            otherSymsSec = xor(ismember(labelmatrix(cc2),j), otherSymsSec);
        end
    end
    % Remove potential other symbols from original section
    beamedSec = xor(beamedSec, ~otherSymsSec); 

    %---------------------------------------------------------------------
    % Third pass: Connected components that was initially counted as 
    % beamed notes will be sorted
    %---------------------------------------------------------------------
    cc3 = bwconncomp(beamedSec);
    beamedStats = regionprops(cc3, 'BoundingBox');
    for k = 1:numel(beamedStats)
        % Perform opening on remaining symbols to detect stems
        tempImg3 = ismember(labelmatrix(cc3),k);
        tempOpen = imopen(tempImg3, strel('line', (2*spaceHeight + ...
            3*lineHeight), 90));
        stemStats2 = regionprops(tempOpen);

        % If two stems are detected, symbol is sent to beamed section, 
        % otherwise, sent to other symbol section 
        if (numel(stemStats2) < 2)
            otherSymsSec = xor(otherSymsSec, tempImg3);
            beamedSec = xor(beamedSec, tempImg3);
        end
    end
    % Invert final result as beamed section
    beamedSec = ~beamedSec;
end
