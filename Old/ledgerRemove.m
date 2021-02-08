function [imgNoLedger] = ledgerRemove(section, ledgerLineLocs)

    imgTemp = ones(size(section,1),1);
    imgTemp(ledgerLineLocs) = 0;
    len = encodeRL(imgTemp');
    ledgerHeights = len(1:2:end);
    ledgerHeights = ledgerHeights(ledgerHeights ~= 0);

    ledgerDiff = [diff(ledgerLineLocs); 0];
    newLL = ledgerLineLocs(ledgerDiff ~= 1);
    
        
    % Staff removal part: remove white pixel column with no symbol segment attached on 
    % either top or bottom of lines
    imgNoLedger = ~section;
    imgFilled = imfill(imgNoLedger, 'holes');
    holes = xor(imgNoLedger, imgFilled); 
%     newHoles = imclose(holes, strel('line', 4, 90));
%     imshow(newHoles);
    
%     imshow(imgNoLedger, imgFilled); pause;
    for i = 1:length(newLL)
        for j = 1:size(section,2)
            if (unique(imgFilled(newLL(i)-ledgerHeights(i)+1:newLL(i),j)) == 1)            
                imgFilled(newLL(i)-ledgerHeights(i)+1:newLL(i),j) ...
                = ~(isequal(imgFilled(newLL(i)-ledgerHeights(i),j),0) && ...
                isequal(imgFilled(newLL(i)+1,j),0));
            end
        end
    end
    
    imgNoLedger = ~xor(holes,imgFilled);
end