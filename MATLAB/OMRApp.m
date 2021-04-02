classdef HOMeR < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        HOMeRUIFigure           matlab.ui.Figure
        FileMenu                matlab.ui.container.Menu
        ExitMenu                matlab.ui.container.Menu
        HelpMenu                matlab.ui.container.Menu
        InstructionsMenu        matlab.ui.container.Menu
        AboutMenu               matlab.ui.container.Menu
        Status                  matlab.ui.control.TextArea
        FirstButton             matlab.ui.control.Button
        LastButton              matlab.ui.control.Button
        PrevButton              matlab.ui.control.Button
        NextButton              matlab.ui.control.Button
        SectionnavigationLabel  matlab.ui.control.Label
        Panel                   matlab.ui.container.Panel
        ReadScoreButton         matlab.ui.control.Button
        ResetButton             matlab.ui.control.Button
        SelectimagesLabel       matlab.ui.control.Label
        BrowseButton            matlab.ui.control.Button
        ExportDataButton        matlab.ui.control.Button
        ScoreoptionsLabel       matlab.ui.control.Label
        PicCount                matlab.ui.control.Label
        SectionImg              matlab.ui.control.UIAxes
    end

    properties (Access = public)
        Property % Description
        file
        path
        inputFile
        fid1
        fid2
        debug = 0;
        stop = 0;
        totalSections = 0;
        sectionBuf = {};
        tempCount;
    end

    methods (Access = public)
        function ReadScore(app, inputImg, fid1, fid2)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%         PHASE ONE: PREPROCESSING         %%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [img_bw, lineHeight, spaceHeight] = preprocess(inputImg);
        
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%   PHASE TWO: MUSIC SYMBOLS RECOGNITION   %%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Part 2.1: Staff detection, removal, and division
            [staffLines, staffHeights] = staffDetect(img_bw);
            dividers = staffDivider(img_bw, staffLines, lineHeight, ...
                spaceHeight);
            img_no_staff = staffRemove(img_bw, staffLines, staffHeights, ...
                spaceHeight);
            [sections, newStaffLines] = scoreToSections(img_no_staff, ...
                staffLines, dividers);
        
            % Part 2.2: Importing dataset for template matching
            [clef, key, timeSig, wholeNotes, rest, dot, other, ...
                tieslur] = readDataset;
            combined = [key; rest; other];
        
            totalTimeSignature = [];
            for i = 1:length(sections)
                app.totalSections = app.totalSections + 1;
                if (app.stop == 1)
                    break;
                end
                app.Status.Value = [app.Status.Value; 
                    sprintf("%s\nSECTION %d:", pad('-', 100, 'left', '-'), ...
                    app.totalSections)];

                app.PicCount.Text = string(app.totalSections);
                app.sectionBuf{app.totalSections} = sections{i};
                I = imshow(app.sectionBuf{app.totalSections}, ...
                    'Parent', app.SectionImg, ...
                    'XData', [1 app.SectionImg.Position(3)], ...
                    'YData', [1 app.SectionImg.Position(4)]);
                app.SectionImg.XLim = [0 I.XData(2)];
                app.SectionImg.YLim = [0 I.YData(2)];    
        
                % Part 2.3: Clef detection
                [clefs, clefBound]  = detectClefs(sections{i}, spaceHeight, ... 
                    newStaffLines{i}, clef, app.debug);
                temp = [];
                for jjj = 1:size(clefs,1)
                    if (app.stop ~= 1)
                        temp = [temp, sprintf('%s %s, ',...
                        string(clefs(jjj,4)), string(clefs(jjj,3)))]; 
                   end
                end
                app.Status.Value = [app.Status.Value; strcat("Clefs: ", temp)];
       
                % Part 2.4: Key signature detection
                if (i == 1)
                    [keySignature, keys, keyTemp] = detectKeySig(sections{i}, ...
                        spaceHeight, i, newStaffLines{i}, clefBound, ...
                        clefBound+10*spaceHeight, key, app.debug);
                    keySigBound = keyTemp;
                    app.Status.Value = [app.Status.Value; sprintf(...
                        'Key signature: %s,', keySignature)];
                else
                    [keySignature, keys, keyTemp] = detectKeySig(...
                        sections{i}, spaceHeight, i, newStaffLines{i}, ...
                        clefBound, keySigBound, key, app.debug);
                    keySigBound = keyTemp;
                    app.Status.Value = [app.Status.Value; sprintf(...
                        'Key signature: %s,', keySignature)];
                end
        
                % Part 2.5: Time signature detection
                [timeSignature, timeSigBound] = detectTimeSig(sections{i}, ...
                    spaceHeight, keySigBound, timeSig, app.debug);
        
                totalTimeSignature =  [totalTimeSignature; timeSignature];
        
                if(isempty(timeSignature))
                    nextBound = keySigBound;
                else
                    nextBound = timeSigBound;
                    app.Status.Value = [app.Status.Value; sprintf(...
                        'Time signature: %s,', string(timeSignature(1,4)))];
                end
        
                % Part 2.6: Section sorting to unbeamed/beamed notes, and 
                % other symbols
                [unbeamedSec, beamedSec, otherSymsSec] = noteSorter(...
                    sections{i}, nextBound, spaceHeight, lineHeight);
        
                % Part 2.7: Unbeamed note detection
                if(~isequal(zeros(size(sections{i})), unbeamedSec))
                    [unbeamedNotes, ledgerLineLocs1] = detectUnbeamedNotes(...
                        unbeamedSec, spaceHeight, lineHeight, wholeNotes, ...
                        app.debug);    
                end    
                % Part 2.8: Beamed note detection
                if(~isequal(zeros(size(sections{i})), beamedSec))
                    [beamedNotes, ledgerLineLocs2] = detectBeamedNotes(...
                        beamedSec, spaceHeight, app.debug);
                end
                
                % Part 2.9: Other symbol detection (rests, dots, ties, slurs,
                % barlines)
                [otherSymbols, ledgerLineLocs3] = detectOtherSymbols(...
                    otherSymsSec, spaceHeight, lineHeight, ...
                    newStaffLines{i}, combined, dot, tieslur, app.debug);
        
                % Part 2.10: Combining symbols sorted by horizontal location for next
                % phase
                totalSyms = [unbeamedNotes; beamedNotes; otherSymbols];
                totalSyms = sortrows(totalSyms, 6);
                app.Status.Value = [app.Status.Value; sprintf('Symbols:')];  
                for jjj = 1:length(totalSyms)
                    if (app.stop ~= 1)
                        app.Status.Value = [app.Status.Value; sprintf('\t%s %s',...
                            string(totalSyms(jjj,4)), string(totalSyms(jjj,3)))];  
                   end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%%%%%   PHASES 3/4: MUSIC NOTATION RECONSTRUCTION   %%%%%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % Part 3.1 Calculating ledger/staff lines and staff space locations,
                % and assigning appropriate pitches
                ledgerLineLocs = sort([ledgerLineLocs1; ledgerLineLocs2; ...
                    ledgerLineLocs3]);
                [ledgerStaffSpace, pitch, note, pitchPreKS, staffCenters, keyType, ...
                    keySigIdx, grandStaffDivider] = finalStaffPitchAssignment(...
                    sections{i}, newStaffLines{i}, ledgerLineLocs, clefs, keys);
        
                % Part 3.2 
                if (isempty(grandStaffDivider))
                    SoloSheetMusicGenerator(totalSyms, totalTimeSignature, ...
                        ledgerStaffSpace,  pitch, note, pitchPreKS, ...
                        staffCenters, keyType, keySigIdx, spaceHeight, ...
                        lineHeight, fid1, fid2);
                else
                    PianoSheetMusicGenerator(totalSyms, totalTimeSignature, ...
                        ledgerStaffSpace, pitch, note, pitchPreKS, ...
                        staffCenters, keyType, keySigIdx, spaceHeight, ...
                        lineHeight, fid1, fid2);        
                end

                scroll(app.Status, 'bottom');
                pause(1);
            end
        scroll(app.Status, 'bottom');
        end  
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            movegui(app.HOMeRUIFigure,"center");
            disableDefaultInteractivity(app.SectionImg);
            app.SectionImg.Visible = false;
            app.ExportDataButton.Enable = false;
            app.ReadScoreButton.Enable = false;

        end

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            app.FirstButton.Enable = false;
            app.PrevButton.Enable = false;
            app.NextButton.Enable = false;
            app.LastButton.Enable = false;
            [app.file,app.path] = uigetfile({'*.jpg';'*.png'}, ...
                'multiselect', 'on');
            cla(app.SectionImg);
            app.totalSections = 0;
            if isequal(app.file, 0)
                app.Status.Value = '';
                app.Status.Value = 'User selection canceled.';
            else
                app.Status.Value = '';
                app.inputFile = string(fullfile(app.path, app.file));
                if (length(app.inputFile) == 1)
                    readStatus = strcat('User selected', " ", fullfile(...
                        app.path, app.file));
                    app.Status.Value = [app.Status.Value; readStatus];                
                else                
                    for i = 1:length(app.inputFile)
                        readStatus = strcat('User selected', " ", string(...
                            app.inputFile(i)));
                        app.Status.Value = [app.Status.Value; readStatus];                
                    end
                end
                app.ReadScoreButton.Enable = true;
                app.ExportDataButton.Enable = false;

                dir = 'OrganNotes.sdk\Synthesizer\src\';
                outFile1 = 'sheetNotes.h';
                fullFile = strcat(dir, outFile1);
                app.fid1 = fopen(fullFile, 'w');
                
                outFile2 = 'sheetBeat.h';
                fullFile = strcat(dir, outFile2);
                app.fid2 = fopen(fullFile, 'w');
                
                fprintf(app.fid1,'#include "notes.h"\n\n');
                fprintf(app.fid1,'int noteArray[][9] = \n{\n');
                fprintf(app.fid2,'double beatArray[] = \n{\n\t');

                app.stop = 0;
            end
            app.PicCount.Text = "";
        end

        % Button pushed function: ReadScoreButton
        function ReadScoreButtonPushed(app, event)
            app.totalSections = 0;
            app.ReadScoreButton.Enable = false;
            app.Status.Value = [app.Status.Value; 
                sprintf("%s", pad('-', 100, 'left', '-'))];
           if (length(app.inputFile) == 1)
                scanStatus = strcat('Scanning', " ", app.file, '...');
                tic
                app.Status.Value = [app.Status.Value; scanStatus];
                inputImg = imread(app.inputFile);
                ReadScore(app, inputImg, app.fid1, app.fid2);
                elapsed = toc;
                app.Status.Value = [app.Status.Value; 
                    sprintf("%s", pad('-', 100, 'left', '-'))];
            else
                tic
                for i = 1:length(app.inputFile)
                    scanStatus = strcat('Scanning', " ", string(...
                        app.file(i)), " ", '...');
                    app.Status.Value = [app.Status.Value; scanStatus];
                    inputImg = imread(cell2mat(app.inputFile(i)));
                    ReadScore(app, inputImg, app.fid1, app.fid2);
                    app.Status.Value = [app.Status.Value; 
                        sprintf("%s", pad('-', 100, 'left', '-'))];
                end
                elapsed = toc;
            end

            if (app.stop ~= 1)
                app.Status.Value = [app.Status.Value; 
                    sprintf("Elapsed time: %.6f seconds", elapsed); ...
                    sprintf("%s", pad('-', 100, 'left', '-')); sprintf(...
                    "Please open Xilinx SDK to listen to the tune.")];
                scroll(app.Status, 'bottom');
                
                fprintf(app.fid1,'};');
                fprintf(app.fid2,'\n};');
                pause(1);
                
                scroll(app.Status, 'bottom');

                app.FirstButton.Enable = true;
                app.PrevButton.Enable = true;
                app.ExportDataButton.Enable = true;
                app.tempCount = app.totalSections;
            end

        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            cla(app.SectionImg);
            app.ExportDataButton.Enable = false;
            app.ReadScoreButton.Enable = false;
            app.FirstButton.Enable = false;
            app.PrevButton.Enable = false;
            app.NextButton.Enable = false;
            app.LastButton.Enable = false;
            app.Status.Value = "";
            app.stop = 1;
            app.totalSections = 0;
            app.PicCount.Text = "";
            close all
        end

        % Button pushed function: FirstButton
        function FirstButtonPushed(app, event)
            app.tempCount = 1;
            I = imshow(app.sectionBuf{app.tempCount}, ...
                'Parent', app.SectionImg, ...
                'XData', [1 app.SectionImg.Position(3)], ...
                'YData', [1 app.SectionImg.Position(4)]);
            % Set limits of axes
            app.SectionImg.XLim = [0 I.XData(2)];
            app.SectionImg.YLim = [0 I.YData(2)];
            app.PicCount.Text = string(app.tempCount);
            app.FirstButton.Enable = false;
            app.PrevButton.Enable = false;
            app.NextButton.Enable = true;
            app.LastButton.Enable = true;
        end

        % Button pushed function: LastButton
        function LastButtonPushed(app, event)
            app.tempCount = app.totalSections;
            I = imshow(app.sectionBuf{app.tempCount}, ...
                'Parent', app.SectionImg, ...
                'XData', [1 app.SectionImg.Position(3)], ...
                'YData', [1 app.SectionImg.Position(4)]);
            % Set limits of axes
            app.SectionImg.XLim = [0 I.XData(2)];
            app.SectionImg.YLim = [0 I.YData(2)];
            app.PicCount.Text = string(app.tempCount);
            app.FirstButton.Enable = true;
            app.NextButton.Enable = false;
            app.PrevButton.Enable = true;
            app.LastButton.Enable = false;
        end

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            app.tempCount = app.tempCount + 1;
            I = imshow(app.sectionBuf{app.tempCount}, ...
                'Parent', app.SectionImg, ...
                'XData', [1 app.SectionImg.Position(3)], ...
                'YData', [1 app.SectionImg.Position(4)]);
            % Set limits of axes
            app.SectionImg.XLim = [0 I.XData(2)];
            app.SectionImg.YLim = [0 I.YData(2)];
            app.PicCount.Text = string(app.tempCount);
            if (app.tempCount < app.totalSections)
                app.NextButton.Enable = true;
                app.LastButton.Enable = true;
            else
                app.NextButton.Enable = false;                
                app.LastButton.Enable = false;
            end
            app.FirstButton.Enable = true;
            app.PrevButton.Enable = true;

        end

        % Button pushed function: PrevButton
        function PrevButtonPushed(app, event)
            app.tempCount = app.tempCount - 1;
            I = imshow(app.sectionBuf{app.tempCount}, ...
                'Parent', app.SectionImg, ...
                'XData', [1 app.SectionImg.Position(3)], ...
                'YData', [1 app.SectionImg.Position(4)]);
            % Set limits of axes
            app.SectionImg.XLim = [0 I.XData(2)];
            app.SectionImg.YLim = [0 I.YData(2)];
            app.PicCount.Text = string(app.tempCount);
            if (app.tempCount > 1 )
                app.FirstButton.Enable = true;
                app.PrevButton.Enable = true;
            else
                app.FirstButton.Enable = false;
                app.PrevButton.Enable = false;                
            end
            app.NextButton.Enable = true;
            app.LastButton.Enable = true;               
        end

        % Menu selected function: ExitMenu
        function ExitMenuSelected(app, event)
            app.delete;
        end

        % Button pushed function: ExportDataButton
        function ExportDataButtonPushed(app, event)
            scroll(app.Status, 'bottom');
            value = app.Status.Value;  % Value entered in textArea
            fileName = strcat('SheetData.txt');
            f=fopen(fileName,'w');
            formatSpec = "%s\n";  
            for i =1:length(value)
                fprintf(f,formatSpec,value{i});
            end
            fclose(f);
            app.Status.Value = [app.Status.Value; sprintf(...
                "%s", pad('-', 100, 'left', '-')); sprintf(...
                "Sheet music data exported.")];
            app.ExportDataButton.Enable = false;
            pause(1);
            scroll(app.Status, 'bottom');
            
            
        end

        % Menu selected function: AboutMenu
        function AboutMenuSelected(app, event)
            About;
        end

        % Menu selected function: InstructionsMenu
        function InstructionsMenuSelected(app, event)
            Instructions;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create HOMeRUIFigure and hide until all components are created
            app.HOMeRUIFigure = uifigure('Visible', 'off');
            app.HOMeRUIFigure.Position = [100 100 910 610];
            app.HOMeRUIFigure.Name = 'HOMeR';
            app.HOMeRUIFigure.Resize = 'off';

            % Create FileMenu
            app.FileMenu = uimenu(app.HOMeRUIFigure);
            app.FileMenu.Text = 'File';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.FileMenu);
            app.ExitMenu.MenuSelectedFcn = createCallbackFcn(app, @ExitMenuSelected, true);
            app.ExitMenu.Text = 'Exit';

            % Create HelpMenu
            app.HelpMenu = uimenu(app.HOMeRUIFigure);
            app.HelpMenu.Text = 'Help';

            % Create InstructionsMenu
            app.InstructionsMenu = uimenu(app.HelpMenu);
            app.InstructionsMenu.MenuSelectedFcn = createCallbackFcn(app, @InstructionsMenuSelected, true);
            app.InstructionsMenu.Text = 'Instructions';

            % Create AboutMenu
            app.AboutMenu = uimenu(app.HelpMenu);
            app.AboutMenu.MenuSelectedFcn = createCallbackFcn(app, @AboutMenuSelected, true);
            app.AboutMenu.Text = 'About';

            % Create Status
            app.Status = uitextarea(app.HOMeRUIFigure);
            app.Status.Editable = 'off';
            app.Status.FontName = 'Cambria';
            app.Status.FontSize = 14;
            app.Status.Position = [361 313 535 270];

            % Create FirstButton
            app.FirstButton = uibutton(app.HOMeRUIFigure, 'push');
            app.FirstButton.ButtonPushedFcn = createCallbackFcn(app, @FirstButtonPushed, true);
            app.FirstButton.Enable = 'off';
            app.FirstButton.Position = [730 16 39 22];
            app.FirstButton.Text = 'First';

            % Create LastButton
            app.LastButton = uibutton(app.HOMeRUIFigure, 'push');
            app.LastButton.ButtonPushedFcn = createCallbackFcn(app, @LastButtonPushed, true);
            app.LastButton.Enable = 'off';
            app.LastButton.Position = [857 16 39 22];
            app.LastButton.Text = 'Last';

            % Create PrevButton
            app.PrevButton = uibutton(app.HOMeRUIFigure, 'push');
            app.PrevButton.ButtonPushedFcn = createCallbackFcn(app, @PrevButtonPushed, true);
            app.PrevButton.Enable = 'off';
            app.PrevButton.Position = [774 16 25 22];
            app.PrevButton.Text = '<';

            % Create NextButton
            app.NextButton = uibutton(app.HOMeRUIFigure, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.Enable = 'off';
            app.NextButton.Position = [826 16 26 22];
            app.NextButton.Text = '>';

            % Create SectionnavigationLabel
            app.SectionnavigationLabel = uilabel(app.HOMeRUIFigure);
            app.SectionnavigationLabel.HorizontalAlignment = 'right';
            app.SectionnavigationLabel.Position = [615 16 107 22];
            app.SectionnavigationLabel.Text = 'Section navigation:';

            % Create Panel
            app.Panel = uipanel(app.HOMeRUIFigure);
            app.Panel.Position = [19 313 322 270];

            % Create ReadScoreButton
            app.ReadScoreButton = uibutton(app.Panel, 'push');
            app.ReadScoreButton.ButtonPushedFcn = createCallbackFcn(app, @ReadScoreButtonPushed, true);
            app.ReadScoreButton.Enable = 'off';
            app.ReadScoreButton.Position = [153 134 100 22];
            app.ReadScoreButton.Text = 'Read Score';

            % Create ResetButton
            app.ResetButton = uibutton(app.Panel, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.Position = [153 58 100 22];
            app.ResetButton.Text = 'Reset';

            % Create SelectimagesLabel
            app.SelectimagesLabel = uilabel(app.Panel);
            app.SelectimagesLabel.Position = [47 194 107 22];
            app.SelectimagesLabel.Text = 'Select image(s): ';

            % Create BrowseButton
            app.BrowseButton = uibutton(app.Panel, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.Position = [153 194 100 22];
            app.BrowseButton.Text = 'Browse';

            % Create ExportDataButton
            app.ExportDataButton = uibutton(app.Panel, 'push');
            app.ExportDataButton.ButtonPushedFcn = createCallbackFcn(app, @ExportDataButtonPushed, true);
            app.ExportDataButton.Enable = 'off';
            app.ExportDataButton.Position = [153 97 100 22];
            app.ExportDataButton.Text = 'Export Data';

            % Create ScoreoptionsLabel
            app.ScoreoptionsLabel = uilabel(app.Panel);
            app.ScoreoptionsLabel.HorizontalAlignment = 'right';
            app.ScoreoptionsLabel.Position = [48 134 83 22];
            app.ScoreoptionsLabel.Text = 'Score options:';

            % Create PicCount
            app.PicCount = uilabel(app.HOMeRUIFigure);
            app.PicCount.HorizontalAlignment = 'center';
            app.PicCount.Position = [798 15 29 25];
            app.PicCount.Text = '';

            % Create SectionImg
            app.SectionImg = uiaxes(app.HOMeRUIFigure);
            app.SectionImg.Toolbar.Visible = 'off';
            app.SectionImg.XTick = [];
            app.SectionImg.YTick = [];
            app.SectionImg.Clipping = 'off';
            app.SectionImg.Visible = 'off';
            app.SectionImg.HandleVisibility = 'off';
            app.SectionImg.Interruptible = 'off';
            app.SectionImg.HitTest = 'off';
            app.SectionImg.Position = [1 40 910 265];

            % Show the figure after all components are created
            app.HOMeRUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = OMRApp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.HOMeRUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.HOMeRUIFigure)
        end
    end
end