clc, clear, close all;
tic
debug = 0;
inputImg =  imread('Dataset_Page_4.jpg');     % / C-clef,   (copy TS) 70.63
% figure; imshow(inputImg); impixelinfo;

[img_bw, lineHeight, spaceHeight] = preprocess(inputImg, debug);
if (debug == 1)
    figure; imshow(img_bw); impixelinfo;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%   PHASE TWO: MUSIC SYMBOLS RECOGNITION   %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 1: Staff detection and removal
[staffLines, staffDiff] = staffDetect(img_bw, debug);
dividers = staffDivider(img_bw, staffLines, lineHeight, spaceHeight);
[img_no_staff] = staffRemove(img_bw, staffLines, staffDiff);

% Part 2: Barline detection and removal / Measure 
% [measures, measureCount] = scoreToSections(img_no_staff, staffLines, dividers, spaceHeight);
[sections, newStaffLines] = scoreToSections(img_no_staff, ...
    staffLines, dividers, spaceHeight);
newSections = beamSegmentation(sections, spaceHeight);

for i = 1
%     figure;
    imshow(newSections{i}); impixelinfo;
    x = bwconncomp(~newSections{i});
    stats = regionprops(x, 'BoundingBox');
%     hold on;
    figure;
    for xx = 1:numel(stats)
        z = stats(xx).BoundingBox;
        h = ceil(z(2))+z(4);
        w = ceil(z(1))+z(3);
        boxHeight = ceil(z(2)):h-1;
        boxWidth = ceil(z(1)):w-1;
        imshow(newSections{i}(boxHeight, boxWidth));
%         rectangle('Position',stats(xx).BoundingBox, ...
%             'EdgeColor','r', 'LineWidth',2)
%     pause;
        sav = input('Save character?: ', 's');
        if (strcmpi(sav, 'a'))
            name = input('Enter name: ', 's');
            symbol = newSections{i}(boxHeight, boxWidth);
            loc = 'musescore\';
            full = strcat(loc, name, '.bmp');
            imwrite(symbol, full);
            clc;
%             pause;
        else
            clc;
            continue;
        end
    end
    pause;
    hold off;
    clc, close;
end


% [length(sections) size(clefs,1)]
% pause;
% close all


%--------------------------------------------------------------------
%     rectangle('Position',stats(i).BoundingBox, ...
%         'EdgeColor','r', 'LineWidth',2)
toc
