%-------------------------------------------------------------------------
% Function name:    ledgerRemove
% Input arg(s):     unbeamed/beamed section, ledger line locations
% Outputs arg(s):   section without ledger lines
% Description:      Removes the lines that protrude through the noteheads
%                   of closed notes
%-------------------------------------------------------------------------
function [imgNoLedger] = ledgerRemove(section, ledgerLineLocs)

    % Calculate the heights of the ledger lines
    imgTemp = ones(size(section,1),1);
    imgTemp(ledgerLineLocs) = 0;
    len = encodeRL(imgTemp');
    ledgerHeights = len(1:2:end);
    ledgerHeights = ledgerHeights(ledgerHeights ~= 0);

    % Calculate reference values
    ledgerDiff = [diff(ledgerLineLocs); 0];
    newLL = ledgerLineLocs(ledgerDiff ~= 1);
        
    % Holes in image are filled to keep the integrity of the note once 
    % the ledger lines are removed
    imgNoLedger = ~section;
    imgFilled = imfill(imgNoLedger, 'holes');
    holes = xor(imgNoLedger, imgFilled); 
    
    % Ledger removal part: remove white pixel column with no symbol 
    % segment attached on either top or bottom of lines
    for i = 1:length(newLL)
        for j = 1:size(section,2)
            if (unique(imgFilled(newLL(i)-ledgerHeights(i)+1:newLL(i),j)) == 1)            
                imgFilled(newLL(i)-ledgerHeights(i)+1:newLL(i),j) ...
                = ~(isequal(imgFilled(newLL(i)-ledgerHeights(i),j),0) && ...
                isequal(imgFilled(newLL(i)+1,j),0));
            end
        end
    end

    % Put the holes back in the no-ledger image
    imgNoLedger = ~xor(holes,imgFilled);
end