function [ledgerStaffSpace, pitch, note] = staffPitchAssignment(centers, staffCenters, ...
    clefs, clefIdx, noteRefArr)
    
    pitch = [];
    note = [];
    tempCentroidDiff = centers(1:end-1) + (diff(centers/2));
    centroidDiff = [centers(1) - (diff(tempCentroidDiff(1:2))/2);... 
        tempCentroidDiff; centers(end) + ...
        (diff(tempCentroidDiff(end-1:end))/2)];
    ledgerStaffSpace = sort([centers; centroidDiff]);

    ledgerStaffSpaceSize = length(ledgerStaffSpace);
    staffVal = cell2mat(clefs(clefIdx,5));
    staffLineVal = cell2mat(clefs(clefIdx,6));
    refPitchIdx = find(strcmp(noteRefArr(:,2), staffVal));
    refLineIdx = find(ledgerStaffSpace == staffCenters(staffLineVal));
    offset = refPitchIdx - refLineIdx + 1;
    for ii = 1:ledgerStaffSpaceSize
        pitch = [pitch; str2double(noteRefArr(offset, 1))];
        note = [note; noteRefArr(offset, 2)];
        offset = offset+1;            
    end
end