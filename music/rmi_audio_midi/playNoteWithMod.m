function playNoteWithMod(obj)
if ~obj.app.ModulationCheckBox.Value || obj.music.modFreq == 0
    % Play note with no modulation
    obj.music.count = 0;
    while obj.music.count < obj.music.noteDuration
        obj.music.osc.Frequency = obj.music.noteFreqInterp(obj.music.indCurrentNote);
        obj.music.aDW(obj.music.osc());
        obj.music.count = obj.music.count + 1;
    end
else
    % Play note with modulation
    obj.music.count = 0;
    while obj.music.count < obj.music.noteDuration
        obj.music.osc.Frequency = obj.music.noteFreqInterp(obj.music.indCurrentNote) + 10*sin(2*pi*obj.music.modFreq*100/obj.music.fs*obj.music.modulationTimeIndex);
        obj.music.aDW(obj.music.osc());
        obj.music.modulationTimeIndex = obj.music.modulationTimeIndex + 1;
        obj.music.count = obj.music.count + 1;
    end
end
end
