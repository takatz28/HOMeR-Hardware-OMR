function [newSection] = beamSegmentation(section, spaceHeight)
 
    tempOpen = imopen(~section, strel('disk', floor(spaceHeight * 0.5)));
    tempOpen = imdilate(tempOpen, strel('square', 1));
    tempOpen = xor(section, ~tempOpen);
%     imshow(tempOpen); pause;

    beamBuf = imopen(tempOpen, strel('line', floor(0.4*spaceHeight), 90));
%     imshow(~beamBuf); pause;
    
	stats = regionprops(beamBuf, {'BoundingBox'}); 
	boxes = [];
%         hold on;
%         hold off;
	for j=1:numel(stats)
		z = stats(j).BoundingBox;
		h = ceil(z(2))+z(4);
		w = ceil(z(1))+z(3);
		boxHeight = ceil(z(2)):h;
		boxWidth = ceil(z(1)):w;
		if (z(3) > spaceHeight)
% 			boxes = [boxes; ceil(z(2)) h ceil(z(1))-5 w+5];
%                 rectangle('Position',stats(j).BoundingBox, ...
%                     'EdgeColor','r', 'LineWidth',2);
%                 pause;
			symTemp = ~beamBuf(boxHeight,boxWidth);
%                 imshow(symTemp);
			peaks = sum(~symTemp,1);
			peaks(peaks<0.5*length(boxHeight)) = 0;
			if(isempty(find(peaks ~= 0)))
				beamBuf(boxHeight,boxWidth) = 0;
			else
				boxes = [boxes; ceil(z(2)) h ceil(z(1))-5 w+5];
			end
		else
			beamBuf(boxHeight,boxWidth) = 0;
		end
	end
	beamBuf = beamBuf(1:size(section,1),1:size(section,2));        
	sectionNoBeam = or(section, beamBuf);
%     imshow(sectionNoBeam); pause;
	section_clean = zeros(size(section));
	for ii = 1:size(boxes,1)
		newBeamStems = ~beamBuf;
		newBeamStems(1:boxes(ii,1),:) = 1;        
		newBeamStems(boxes(ii,2):end,:) = 1;
		newBeamStems(:,1:boxes(ii,3)) = 1;        
		newBeamStems(:,boxes(ii,4):end) = 1;
%             imshow(newBeamStems);
		peaks = sum(~newBeamStems, 1);
%                 hold on;
%                 mode(peaks(peaks~=0))
%                 peaks(peaks <= 2.5*spaceHeight) = 0;
        peaks(peaks <= 1.75*mean(peaks(peaks~=0))) = 0;
%                 bar(1:length(peaks), peaks, 'r');
%                 pause;
%                 hold off;
%             peaks(peaks<=mode(peaks)) = 0;
		stems = find(peaks ~= 0);
		stems(diff(stems) == 1) = [];

		count = stems(stems > boxes(ii,3) & stems < boxes(ii,4));
		dividers = count(1:length(count)-1) + ceil(diff(count)./2);
		for jj = 1:length(dividers)
			newBeamStems(:,dividers(jj)-2:dividers(jj)+2) = 1;
		end
		section_clean = section_clean + not(newBeamStems);
	end
	newSection = ~or(~sectionNoBeam, section_clean);
%     imshowpair(section, newSection); pause;
 
end