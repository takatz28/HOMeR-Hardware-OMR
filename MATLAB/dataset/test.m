clc, clear, close all;

%
loc = 'dot';
% % figure; 
for jj = 6
% xx = 6;
full = strcat(loc, num2str(jj), '.jpg');
img = imread(full);
% %     img(1:50,1:20) = 1;
img = imbinarize(rgb2gray(img));
% x = imclose(~img, strel('line',1,90));
% imshow(x); impixelinfo;
stats = regionprops(~img, 'BoundingBox');
hold on;
% for i = 1:numel(stats)
% %     pause;
%     z = stats(i).BoundingBox;
%     h = ceil(z(2))+z(4);
%     w = ceil(z(1))+z(3);
%     boxHeight2 = ceil(z(2)):h-1;
%     boxWidth2 = ceil(z(1)):w-1;    
%     rectangle('Position',stats(i).BoundingBox, ...
%         'EdgeColor','r', 'LineWidth',2);
%     if (z(3) < 20 && z(4) < 20)
%         img(boxHeight2, boxWidth2) = 1;
%     end
%     pause;
% end
% hold off;
imshow(img); pause;

% stats = regionprops(~x, 'BoundingBox');
    z = stats(1).BoundingBox;
    h = ceil(z(2))+z(4);
    w = ceil(z(1))+z(3);
    boxHeight2 = ceil(z(2)):h-1;
    boxWidth2 = ceil(z(1)):w-1;  
    img = img(boxHeight2, boxWidth2);
    imshow(img); pause;


   close;
   imwrite(img, strcat('dot', num2str(jj), '.bmp'));
end
% end
% % for 
% i = 1:3
% % loc = '5-4/';
% % ii = num2str(i);
% % % loc = 'whole/';
% % ext1 = '.png';
% % % rname = strcat(loc, ext1);
% % rname = strcat(loc, ii, ext1);
% % 
% % z =  imread(rname);
% % wname = strcat(loc,ii,ext2);
% % imwrite(z, wname);
% % end
% % close all;
%}

% img = imread('other\tie16.jpg');
% img = imbinarize(rgb2gray(img));
% % img(61:end,:) = 0;
% % img(1:10,:) = 0;
% % img(:,1:8) = 0;
% img(:,41:43) = 1;
% img(9:11,41:43) = 0;
% % img(:,1:8) = 0;
% imshow(img); impixelinfo;
% % stats = regionprops(img,'BoundingBox');
% % imshow(img(11:24,13:41)); impixelinfo
% % % hold on
% % % rectangle('Position',stats(1).BoundingBox, ...
% %             'EdgeColor','r', 'LineWidth',2);
%         imwrite(img,'tie16.bmp');
% % % hold o

