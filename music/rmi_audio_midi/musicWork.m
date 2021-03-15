function musicWork(obj)
% Do the note work
doNoteWork(obj);

% Do the modulation work
doModWork(obj);

% Show the results
obj.app.mmWaveStudioTextArea.Value = ("NOTE = " + obj.music.indCurrentNote + " MODFREQ = " + obj.music.modFreq);

% Play the note
if obj.app.AudioOutputCheckBox.Value && obj.music.indCurrentNote ~= 0
    playNoteWithMod(obj);
end

% Send the MIDI Signals
doMIDIWork(obj);
end
