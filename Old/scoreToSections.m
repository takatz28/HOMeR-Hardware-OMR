function [sections, newStaffLines] = scoreToSections(img_no_staff, staffLines, dividers, spaceHeight)

    for a = 1:length(dividers)-1
        % Individual hypermeasures is assigned as a cell
        sections{a} = img_no_staff(dividers(a)+1:dividers(a+1)-1,:);
        staff_idx = staffLines(staffLines >= dividers(a) & ...
            staffLines <= dividers(a+1));

        % staff lines indices are recalculated based on each section
        newStaffLines{a} = staff_idx - dividers(a);
        
        for i = 1:length(sections)
            img_buf = ~sections{i};
            img_buf = imdilate(img_buf, strel('square',2));% - x;
            CC = bwconncomp(img_buf);
            stats = regionprops(CC, 'BoundingBox');

            for j=1:numel(stats)
                z = stats(j).BoundingBox;
                if ((z(3) > 6) && (z(3) <= 13 * spaceHeight) && ...
                    (z(4) <= 10 *spaceHeight))
                    w = ceil(z(2))+z(4);
                    h = ceil(z(1))+z(3);
                    img_buf(ceil(z(2)):w,ceil(z(1)):h) = 0;
                end
            end
        end
%         project_V = sum(img_buf, 1);

%         if (max(project_V) < 10*spaceHeight)
%             project_V(project_V < 28) = 0;
%             project_V(1:30) = 0;
%             bars = find(project_V ~= 0);
%             sections{a}(:,bars) = 1;
%             img_buf(:,bars) = 0;
%             bars(diff(bars)==1)=[];
%             bars = [1 bars];
%         else        
%             project_V(project_V < 0.9 * staffHeight) = 0;
%             bars = find(project_V ~= 0);
%             sections{a}(:,bars(1)) = 1;
%             img_buf(:,bars) = 0;
%             bars(diff(bars)<=20)=[];
% %             sections{a} = sections{a}(:,bars(1):bars(length(bars)));
%             bars = bars - bars(1)+1;
%             sections{a}(:,bars) = 0;
% %             imshow(sections{a}); impixelinfo; pause;
%         end
%         barLines{a} = bars;
    end
    
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % save code segment for pitch assignment
%     %
%     measureCount = 1;
%     for m = 1:length(sections)
%         for d = 1:length(barLines{m})-1
%             measures{measureCount} = sections{m}(:,barLines{m}(d):barLines{m}(d+1)-1);
%             measureCount = measureCount + 1;
%         end
%     end
%     measureCount = measureCount - 1;
%     %
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end