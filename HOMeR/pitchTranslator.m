%-------------------------------------------------------------------------
% Function name:    pitchTranslator
% Input arg(s):     Pitch number
% Outputs arg(s):   String equivalent of pitch number
% Description:      Returns the pitch equivalent of a number based on the 
%                   piano's 88 keys
%-------------------------------------------------------------------------
function pitch = pitchTranslator(pitchNumber)
    
    % If pitch number is 1, 2, 3, or 88, the pitch is specified
    if (pitchNumber == 1)
        pitch = 'A0';        
    elseif (pitchNumber == 2)
        pitch = 'Bb0';        
    elseif (pitchNumber == 3)
        pitch = 'B0';        
    elseif (pitchNumber == 88)
        pitch = 'C8';
    % If pitch is between 4 and 87, the pitch assignment is generalized
    elseif ((pitchNumber > 3) && (pitchNumber < 88))
        % Returns the octave where the pitch belongs to
        octave = (fix((pitchNumber - 4) / 12) + 1);
        % Returns the pitch based on modulo-12 
        temp = mod((pitchNumber - 4), 12);
        if (temp == 0)
            note = 'C';
        elseif (temp == 1)
            note = 'Cs';            
        elseif (temp == 2)
            note = 'D';
        elseif (temp == 3)
            note = 'Eb';
        elseif (temp == 4)
            note = 'E';        
        elseif (temp == 5)
            note = 'F';  
        elseif (temp == 6)
            note = 'Fs';        
        elseif (temp == 7)
            note = 'G';        
        elseif (temp == 8)
            note = 'Gs';        
        elseif (temp == 9)
            note = 'A';            
        elseif (temp == 10)
            note = 'Bb';
        elseif (temp == 11)
            note = 'B';        
        end
        % Concatenate initial pitch and octave to produce the 
        % complete pitch
        pitch = strcat(note, num2str(octave));
    % If number is out of bounds, set pitch to 0
    else
        pitch = '0';
    end
end