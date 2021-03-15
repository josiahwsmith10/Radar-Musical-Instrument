function stopMIDI(obj)
if ~obj.app.MIDIOutputCheckBox.Value
    return;
end

% Silences the current note being played
obj.midi.notemsg = midimsg('NoteOff',obj.midi.channel,obj.midi.note,obj.midi.velocity);
midisend(obj.app.midi.out,obj.midi.notemsg);
end
