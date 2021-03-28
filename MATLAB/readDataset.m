%-------------------------------------------------------------------------
% Function name:    readDataset
% Input arg(s):     None
% Outputs arg(s):   Musical symbols and whole notes
% Description:      Returns a categorized set of notes and musical symbols
%                   to be used for template matching 
%-------------------------------------------------------------------------
function [clefSyms, accidentalSyms, timeSigSyms, wholeNotes, restSyms, ...
    dotSyms, otherSyms, tieSlurs] = readDataset

    ext = '.bmp';
	%----------------------------------------------------
	% Read clefs (15)
	trebleClef1 = imread('dataset\clefs\trebleClef1.bmp');
	trebleClef2 = imread('dataset\clefs\trebleClef2.bmp');
	trebleClef3 = imread('dataset\clefs\trebleClef3.bmp');
	trebleClef4 = imread('dataset\clefs\trebleClef4.bmp');
	trebleClef5 = imread('dataset\clefs\trebleClef5.bmp');
	bassClef1 = imread('dataset\clefs\bassClef1.bmp');
	bassClef2 = imread('dataset\clefs\bassClef2.bmp');
	bassClef3 = imread('dataset\clefs\bassClef3.bmp');
	bassClef4 = imread('dataset\clefs\bassClef4.bmp');
	bassClef5 = imread('dataset\clefs\bassClef5.bmp');
	bassClef6 = imread('dataset\clefs\bassClef6.bmp');
	altoClef1 = imread('dataset\clefs\altoClef1.bmp');
	altoClef2 = imread('dataset\clefs\altoClef2.bmp');
	altoClef3 = imread('dataset\clefs\altoClef3.bmp');
	altoClef4 = imread('dataset\clefs\altoClef4.bmp');
	clefs = {trebleClef1, trebleClef2, trebleClef3, trebleClef4, ... 
		trebleClef5, bassClef1, bassClef2, bassClef3, bassClef4, ...
		bassClef5, bassClef6, altoClef1, altoClef2, altoClef3, altoClef4};
	category(:,1:length(clefs)) = {'clef'};
	type = {'treble', 'treble', 'treble', 'treble', 'treble', ... 
		'bass', 'bass', 'bass', 'bass', 'bass', 'bass', ... 
		'alto', 'alto', 'alto', 'alto'};
	clefSyms = [clefs', category', type' {}];
	%----------------------------------------------------

	%----------------------------------------------------
	% Read time signatures (26)
	category = {};
	ts22 = imread('dataset\timeSignature\ts22.bmp');
	ts24_1 = imread('dataset\timeSignature\ts24_1.bmp');
	ts24_2 = imread('dataset\timeSignature\ts24_2.bmp');
	ts24_3 = imread('dataset\timeSignature\ts24_3.bmp');
	ts34_1 = imread('dataset\timeSignature\ts34_1.bmp');
	ts34_2 = imread('dataset\timeSignature\ts34_2.bmp');
	ts34_3 = imread('dataset\timeSignature\ts34_3.bmp');
	ts34_4 = imread('dataset\timeSignature\ts34_4.bmp');
	ts34_5 = imread('dataset\timeSignature\ts34_5.bmp');
	ts34_6 = imread('dataset\timeSignature\ts34_6.bmp');
	ts34_7 = imread('dataset\timeSignature\ts34_7.bmp');
	ts44_1 = imread('dataset\timeSignature\ts44_1.bmp');
	ts44_2 = imread('dataset\timeSignature\ts44_2.bmp');
	ts44_3 = imread('dataset\timeSignature\ts44_3.bmp');
	ts44_4 = imread('dataset\timeSignature\ts44_4.bmp');
	ts44_5 = imread('dataset\timeSignature\ts44_5.bmp');
	ts54 = imread('dataset\timeSignature\ts54.bmp');
	ts38 = imread('dataset\timeSignature\ts38.bmp');
	ts68_1 = imread('dataset\timeSignature\ts68_1.bmp');
	ts68_2 = imread('dataset\timeSignature\ts68_2.bmp');
	ts98 = imread('dataset\timeSignature\ts98.bmp');
	ts128 = imread('dataset\timeSignature\ts128.bmp');
	common = imread('dataset\timeSignature\common.bmp');
	cut1 = imread('dataset\timeSignature\cut1.bmp');
	cut2 = imread('dataset\timeSignature\cut2.bmp');
	cut3 = imread('dataset\timeSignature\cut3.bmp');
	timeSig = {ts22, ts24_1, ts24_2, ts24_3, ts34_1, ts34_2, ts34_3, ts34_4, ts34_5, ...
		ts34_6, ts34_7, ts44_1, ts44_2, ts44_3, ts44_4, ts44_5, ts54, ...
		ts38, ts68_1, ts68_2, ts98, ts128, common, cut1, cut2, cut3};
	category(:,1:length(timeSig)) = {'timeSignature'};  
	type = {'2/2', '2/4', '2/4', '2/4', '3/4', '3/4', '3/4', '3/4', '3/4', '3/4', ...
		'3/4', '4/4', '4/4', '4/4', '4/4', '4/4', '5/4', '3/8', '6/8', ...
		'6/8', '9/8', '12/8', '4/4', '2/2', '2/2', '2/2'};
	beat = {2, 2, 2, 2, 3, 3, 3, 3, 3, 3, ...
		3, 4, 4, 4, 4, 4, 5, 3, 6, ...
		6, 9, 12, 4, 2, 2, 2};
	timeSigSyms = [timeSig' category' type' beat'];    
	%----------------------------------------------------

	%----------------------------------------------------
	% Read whole notes (8)
	category = {};
	type = {};
	beat = {};
	loc = 'dataset\notes\whole';
	for i = 1:8
		img = imread(strcat(loc, num2str(i), ext));
		whole{i} = img;
		category(i) = {'note'};
		type(i) = {'whole'};
		beat(i) = {1};
	end
	wholeNotes = [whole' category' type' beat'];
	%----------------------------------------------------

	%----------------------------------------------------
	% Read rests (7)
	category = {};
	rest12 = imread('dataset\rests\rest12.bmp');
	rest4_1 = imread('dataset\rests\rest4_1.bmp');
	rest4_2 = imread('dataset\rests\rest4_2.bmp');
	rest8 = imread('dataset\rests\rest8.bmp');
	rest16 = imread('dataset\rests\rest16.bmp');
	rest32 = imread('dataset\rests\rest32.bmp');
	rest64 = imread('dataset\rests\rest64.bmp');
	rests = {rest12, rest4_1, rest4_2, rest8, rest16, rest32, rest64};
	category(:,1:length(rests)) = {'rest'};        
	type = {'wholehalf', 'quarter', 'quarter', '8th', '16th', '32nd', '64th'};  
	beat = {1, 0.25, 0.25, 0.125, 0.0625, 0.03125, 0.015625};
	restSyms = [rests', category', type', beat'];
	%----------------------------------------------------

	%----------------------------------------------------
	% Read dots (6)
	category = {};
	type = {};
	beat = {};
	loc = 'dataset\dots\dot';
	for i = 1:6
		img = imread(strcat(loc, num2str(i), ext));
		dots{i} = img;
		category(i) = {'dot'};
		type(i) = {'augmentation'};
		value(i) = {0};
	end
	dotSyms = [dots' category' type' value'];   
	%----------------------------------------------------

	%----------------------------------------------------
	% Read accidentals (5)
	category = {};
	flat1 = imread('dataset\accidental\flat1.bmp');
	flat2 = imread('dataset\accidental\flat2.bmp');
	sharp1 = imread('dataset\accidental\sharp1.bmp');
	sharp2 = imread('dataset\accidental\sharp2.bmp');
	natural = imread('dataset\accidental\natural.bmp');
	accidentals = {flat1, flat2, sharp1, sharp2, natural};
	category(:,1:length(accidentals)) = {'accidental'};
	type = {'flat', 'flat', 'sharp', 'sharp', 'natural'}; 
	pitch = {-1, -1, 1, 1, 0};
	accidentalSyms = [accidentals', category', type', pitch'];    
	%----------------------------------------------------

	%----------------------------------------------------
	% Read fermatas (4)
	category = {};
	type = {};
	beat = {};
	loc = 'dataset\other\fermata';
	for i = 1:4
		img = imread(strcat(loc, num2str(i), ext));
		other{i} = img;
		category(i) = {''};
		type(i) = {'fermata'};
		beat(i) = {4};
	end	
	otherSyms = [other' category' type' beat'];  
	%----------------------------------------------------
	
	%----------------------------------------------------
	% Read slurs (6)
	type = {};
	beat = {};
	loc = 'dataset\other\slur';
	for i = 1:6
		img = imread(strcat(loc, num2str(i), ext));
		other{i} = img;
		category(i) = {''};
		type(i) = {'slur'};
		beat(i) = {0};
	end
	slurs = [other' category' type' beat'];
	tieSlurs = slurs;    
	%----------------------------------------------------

	%----------------------------------------------------
	% Read ties (15)
	category = {};
	type = {};
	beat = {};
	loc = 'dataset\other\tie';
	for i = 1:17
		img = imread(strcat(loc, num2str(i), ext));
		tie{i} = img;
		category(i) = {''};
		type(i) = {'tie'};
		beat(i) = {0};
	end
	ties = [tie' category' type' beat'];
	tieSlurs = [tieSlurs; ties];
	%----------------------------------------------------
    
end