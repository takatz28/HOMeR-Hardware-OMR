clc, clear, close all;

dir = 'C:\Projects\FinalProject\Prototype\OrganNotes.sdk\OrganTest\src\';
outFile1 = 'sheetNotes4.h';
fullFile = strcat(dir, outFile1);
fid1 = fopen(fullFile, 'w');

outFile2 = 'sheetBeat4.h';
fullFile = strcat(dir, outFile2);
fid2 = fopen(fullFile, 'w');

% fid3 = fopen('Elapsed2.txt', 'w');

fprintf(fid1,'#include "notes.h"\n\n');
fprintf(fid1,'int noteArray[][9] = \n{\n');
fprintf(fid2,'double beatArray[] = \n{\n\t');   


[file,path] = uigetfile({'*.jpg';'*.png';}, 'multiselect', 'on');
% file
% pause;
if isequal(file,0)
   disp('User selected Cancel');
%    continue;
else
%    disp(['User selected ', fullfile(path,file)]');
    x = string(fullfile(path,file));
    if (length(x) == 1)
        tic
        inputImg = imread(x);
        OMR(inputImg, fid1, fid2);
        close all;
        toc
    else
%         tic
%         time = zeros(length(x),5);
        for i = 1:length(x)
%             for j = 1:5
                inputImg = imread(cell2mat(x(i)));
                tic
                OMR(inputImg, fid1, fid2);
%                 time(i,j) = toc;
                close all;
%             end
%             fprintf(fid3, "%s,%3.6f,%3.6f,%3.6f,%3.6f,%3.6f,%3.6f\n", ...
%                 cell2mat(file(i)), time(i,1), time(i,2), time(i,3), time(i,4), ...
%                 time(i,5), mean(time(i,:))); 
        end
%         end
%         toc
    end

    fprintf(fid1,'};');
    fprintf(fid2,'\n};');
end
% size(x)
% cell2mat(x(1))
% pause

%}
    close all
% toc