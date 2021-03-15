function doMIDIWork(obj)
if ~obj.app.MIDIOutputCheckBox.Value
    return;
end

obj.midi.previousNote = obj.midi.note;

% Get states
obj.midi.note = obj.midi.notes(obj.music.indCurrentNote);
obj.midi.ccvalueOscillation = round(obj.music.modFreq*32);
obj.midi.ccvalueDoppler = 64 + round(63*mean(obj.target.zVelocityBuffer)/obj.app.Params.dopplerAxis(end));

% Create messages
obj.midi.notemsg = midimsg('NoteOn',obj.midi.channel,obj.midi.note,obj.midi.velocity);
obj.midi.oscmsg = midimsg('ControlChange',obj.midi.channel,1,obj.midi.ccvalueOscillation);
obj.midi.dopmsg = midimsg('ControlChange',obj.midi.channel,2,obj.midi.ccvalueDoppler);

% Send the messages
if obj.midi.previousNote ~= obj.midi.note
    obj.midi.notestop = midimsg('NoteOff',obj.midi.channel,obj.midi.previousNote,obj.midi.velocity);
    midisend(obj.app.midi.out,obj.midi.notestop);
    midisend(obj.app.midi.out,obj.midi.notemsg);
end
midisend(obj.app.midi.out,obj.midi.oscmsg);
midisend(obj.app.midi.out,obj.midi.dopmsg);
end
