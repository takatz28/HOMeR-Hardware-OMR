function [symbols] = readDataset(set)

    %----------------------------------------------------
    % read clefs (14)
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
    % read keysigs (single sharp/flat) (3)
    category = {};
    flat1 = imread('dataset\keySig\flat1.bmp');
    flat2 = imread('dataset\keySig\flat2.bmp');
    sharp1 = imread('dataset\keySig\sharp1.bmp');
    sharp2 = imread('dataset\keySig\sharp2.bmp');
    keys = {flat1, flat2, sharp1, sharp2};
    category(:,1:length(keys)) = {'keySignature'};        
    type = {'flat', 'flat', 'sharp', 'sharp'};
    pitch = {-1, -1, 1, 1};
    keySyms = [keys' category' type' pitch'];    
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read time signatures (11)
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
        6, 9, 12, 4, 4, 4, 4};
    timeSigSyms = [timeSig' category' type' beat'];    
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read whole notes (8)
    ext = '.bmp';
    category = {};
    type = {};
    beat = {};
    loc = 'dataset\notes\whole';
    for i = 1:8
        img = imread(strcat(loc, num2str(i), ext));
        whole{i} = img;
        category(i) = {'note'};
        type(i) = {'whole'};
        beat(i) = {4};
    end
    wholeNotes = [whole' category' type' beat'];
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read half notes (12)
    category = {};
    type = {};
    beat = {};
    loc = 'dataset\notes\half';
    for i = 1:12
        img = imread(strcat(loc, num2str(i), ext));
        half{i} = img;
        category(i) = {'note'};
        type(i) = {'half'};
        beat(i) = {2};
    end
    halfNotes = [half' category' type' beat'];
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read quarter notes (14)
    category = {};
    type = {};
    beat = {};
    loc = 'dataset\notes\quarter';
    for i = 1:18
        img = imread(strcat(loc, num2str(i), ext));
        quarter{i} = img;
        category(i) = {'note'};
        type(i) = {'quarter'};
        beat(i) = {1};
    end
    quarterNotes = [quarter' category' type' beat'];    
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read eighth notes (114)
    category = {};
    type = {};
    beat = {};
    loc = 'dataset\notes\eighth';
    for i = 1:12
        img = imread(strcat(loc, num2str(i), ext));
        eighth{i} = img;
        category(i) = {'note'};
        type(i) = {'8th'};
        beat(i) = {0.5};
    end
    notes8 = [eighth' category' type' beat'];      
    %----------------------------------------------------
    
    
    %----------------------------------------------------
    % read sixteenth notes (92)
    category = {};
    type = {};
    beat = {};
    loc = 'dataset\notes\sixteenth';
    for i = 1:12
        img = imread(strcat(loc, num2str(i), ext));
        sixteenth{i} = img;
        category(i) = {'note'};
        type(i) = {'16th'};
        beat(i) = {0.25};
    end
    notes16 = [sixteenth' category' type' beat'];          
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read thirtysecond notes (54)
    category = {};
    type = {};
    beat = {};
    loc = 'dataset\notes\thirtysecond';
    for i = 1:12
        img = imread(strcat(loc, num2str(i), ext));
        thirysecond{i} = img;
        category(i) = {'note'};
        type(i) = {'32nd'};
        beat(i) = {0.125};
    end
    notes32 = [thirysecond' category' type' beat'];        
    %----------------------------------------------------

    %----------------------------------------------------
    % read sixtyfourth notes (18)
    category = {};
    type = {};
    beat = {};
    loc = 'dataset\notes\sixtyfourth';
    for i = 1:12
        img = imread(strcat(loc, num2str(i), ext));
        sixtyfourth{i} = img;
        category(i) = {'note'};
        type(i) = {'64th'};
        beat(i) = {0.0625};
    end
    notes64 = [sixtyfourth' category' type' beat'];      
    %----------------------------------------------------

    %----------------------------------------------------
    % read rests (6)
    category = {};
    rest12 = imread('dataset\rests\rest12.bmp');
%     rest_2 = imread('dataset\rests\rest12.bmp');
    rest4_1 = imread('dataset\rests\rest4_1.bmp');
    rest4_2 = imread('dataset\rests\rest4_2.bmp');
    rest8 = imread('dataset\rests\rest8.bmp');
    rest16 = imread('dataset\rests\rest16.bmp');
    rest32 = imread('dataset\rests\rest32.bmp');
    rest64 = imread('dataset\rests\rest64.bmp');
	rests = {rest12, rest4_1, rest4_2, rest8, rest16, rest32, rest64};
    category(:,1:length(rests)) = {'rest'};        
    type = {'wholehalf', 'quarter', 'quarter', '8th', '16th', '32nd', '64th'};  
    beat = {0, 1, 1, 0.5, 0.25, 0.125, 0.0625};
    restSyms = [rests', category', type', beat'];
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read dots (5)
    category = {};
    type = {};
    dot1 = imread('dataset\dots\dot1.bmp');
    dot2 = imread('dataset\dots\dot2.bmp');
    dot3 = imread('dataset\dots\dot3.bmp');
    dot4 = imread('dataset\dots\dot4.bmp');
    dot5 = imread('dataset\dots\dot5.bmp');
    dots = {dot1, dot2, dot3, dot4, dot5};
    category(:,1:length(dots)) = {'augmentation'};        
    type(:,1:length(dots)) = {'dot'};        
    value = {0, 0, 0, 0, 0};
    dotSyms = [dots' category' type' value'];   
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read accidentals (5)
    flat = imread('dataset\accidental\flat.bmp');
    sharp = imread('dataset\accidental\sharp.bmp');
    natural = imread('dataset\accidental\natural.bmp');
    doubleFlat = imread('dataset\accidental\doubleFlat.bmp');
    doubleSharp = imread('dataset\accidental\doubleSharp.bmp');
    accidentals = {flat, sharp, natural, doubleFlat, doubleSharp};
    category(:,1:length(accidentals)) = {'accidental'};
	type = {'flat', 'sharp', 'natural', 'doubleFlat', 'doubleSharp'};
    pitch = {-1, 1, 0, -2, 2};
    accidentalSyms = [accidentals', category', type', pitch'];    
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read fermatas
    category = {};
    fermata1 = imread('dataset\other\fermata1.bmp');
    fermata2 = imread('dataset\other\fermata2.bmp');
    fermata3 = imread('dataset\other\fermata3.bmp');
    fermata4 = imread('dataset\other\fermata4.bmp');
    other = {fermata1, fermata2, fermata3, fermata4}; 
    category(:,1:length(other)) = {'other'};        
    type = {'fermata', 'fermata', 'fermata', 'fermata'}; 
    beat = {4, 4, 4, 4};
    otherSyms = [other' category' type' beat'];    
    %----------------------------------------------------

    %----------------------------------------------------
    % read slurs
    category = {};
    slur1 = imread('dataset\other\slur1.bmp');
    slur2 = imread('dataset\other\slur2.bmp');
    slur3 = imread('dataset\other\slur3.bmp');
    slur4 = imread('dataset\other\slur4.bmp');
    slur5 = imread('dataset\other\slur5.bmp');
    slur6 = imread('dataset\other\slur6.bmp');
    other = {slur1, slur2, slur3, slur4, slur5, slur6}; 
    category(:,1:length(other)) = {'other'};        
    type = {'slur', 'slur', 'slur', 'slur', 'slur', 'slur'}; 
    beat = {0, 0, 0, 0, 0, 0};
    slurs = [other' category' type' beat'];
    otherSyms = [otherSyms; slurs];    
    %----------------------------------------------------
    
    %----------------------------------------------------
    % read ties (15)
    category = {};
    type = {};
    beat = {};
    loc = 'dataset\other\tie';
    for i = 1:17
        img = imread(strcat(loc, num2str(i), ext));
        tie{i} = img;
        category(i) = {'other'};
        type(i) = {'tie'};
        beat(i) = {0};
    end
    ties = [tie' category' type' beat'];
    otherSyms = [otherSyms; ties];
    %----------------------------------------------------
    
    
    %----------------------------------------------------
    % Group open and closed notes together
    openNoteSyms = [wholeNotes; halfNotes];
    closedNoteSyms = [quarterNotes; notes8; notes16; notes32; notes64];
    stemmedNoteSyms = [halfNotes; closedNoteSyms];
    %----------------------------------------------------
    
    %-----------------------------------------------------------------    
    % statements that output the appropriate symbol(s) based on choice
    if (strcmpi(set,'clefs'))
        symbols = clefSyms;
    elseif (strcmpi(set,'keys'))
        symbols = keySyms;
    elseif (strcmpi(set,'timeSignatures'))
        symbols = timeSigSyms;
    elseif (strcmpi(set,'openNotes'))
        symbols = openNoteSyms;
    elseif (strcmpi(set,'closedNotes'))
        symbols = closedNoteSyms;
    elseif (strcmpi(set,'stemmed'))
        symbols = stemmedNoteSyms;
    elseif (strcmpi(set,'whole'))
        symbols = wholeNotes;
    elseif (strcmpi(set,'rests'))
        symbols = restSyms;
    elseif (strcmpi(set,'dots'))
        symbols = dotSyms;
    elseif (strcmpi(set,'accidentals'))
        symbols = accidentalSyms;
    elseif (strcmpi(set, 'others'))
        symbols = otherSyms;
    else
        symbols = {};
    end
    
end