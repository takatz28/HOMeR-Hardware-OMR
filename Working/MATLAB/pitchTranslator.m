function pitch = pitchTranslator(pitchNumber)

    if (pitchNumber == 1)
        pitch = 'A0';        
    elseif (pitchNumber == 2)
        pitch = 'Bb0';        
    elseif (pitchNumber == 3)
        pitch = 'B0';        
    elseif (pitchNumber == 88)
        pitch = 'C8';
    elseif ((pitchNumber > 3) && (pitchNumber < 88))
        octave = (fix((pitchNumber - 4) / 12) + 1);
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
        pitch = strcat(note, num2str(octave));
    else
        pitch = '0';
    end
end