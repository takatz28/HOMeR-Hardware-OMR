%-------------------------------------------------------------------------
% Function name:    scoreToSections
% Input arg(s):     Binarized image
% Outputs arg(s):   (1 x n) cell of sheet music sections
% Description:      Divides original sheet music image into sections based
%                   on staff type (solo or grand)
%-------------------------------------------------------------------------
function [sections, newStaffLines] = scoreToSections(img_no_staff, ...
    staffLines, dividers)
    for a = 1:length(dividers)-1
        % Individual hypermeasures is assigned as a cell
        sections{a} = img_no_staff(dividers(a)+1:dividers(a+1)-1,:);
        staff_idx = staffLines(staffLines >= dividers(a) & ...
            staffLines <= dividers(a+1));

        % staff lines indices are recalculated based on each section
        newStaffLines{a} = staff_idx - dividers(a);
    end
end