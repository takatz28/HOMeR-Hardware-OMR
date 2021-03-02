%-------------------------------------------------------------------------
% Function name:    staffPitchAssignment
% Input arg(s):     staff and ledger centers, clef parameters, note 
%                   reference array
% Outputs arg(s):   Reference values for final pitch assignment
% Description:      Assigns the initial staff pitch/note based on clef
%                   attached to the given staff
%-------------------------------------------------------------------------
function [ledgerStaffSpace, pitch, note] = staffPitchAssignment(centers,...
    staffCenters, clefs, clefIdx, noteRefArr)
    
    pitch = [];
    note = [];
    % Calculate staff and ledger line midpoints
    tempCentroidDiff = centers(1:end-1) + (diff(centers/2));
    % In addition, spaces on top and bottom of staff are assigned values
    centroidDiff = [centers(1) - (diff(tempCentroidDiff(1:2))/2);... 
        tempCentroidDiff; centers(end) + ...
        (diff(tempCentroidDiff(end-1:end))/2)];
    % Complete reference points are the combination of the above points
    ledgerStaffSpace = sort([centers; centroidDiff]);

    % Length of reference points
    ledgerStaffSpaceSize = length(ledgerStaffSpace);
    % Returns the reference note value based on clef
    staffVal = cell2mat(clefs(clefIdx,5));
    % Staff line number based on clef
    staffLineVal = cell2mat(clefs(clefIdx,6));
    % Returns the note reference index where the note is equal the 
    % staff line note value
    refPitchIdx = find(strcmp(noteRefArr(:,2), staffVal));
    % Returns the index where ledger/staff/space line is equal the 
    % staffline specified in the clef parameters
    refLineIdx = find(ledgerStaffSpace == staffCenters(staffLineVal));
    % Returns the starting index for pitch/note assignment
    offset = refPitchIdx - refLineIdx + 1;
    for ii = 1:ledgerStaffSpaceSize
        pitch = [pitch; str2double(noteRefArr(offset, 1))];
        note = [note; noteRefArr(offset, 2)];
        offset = offset+1;            
    end
end