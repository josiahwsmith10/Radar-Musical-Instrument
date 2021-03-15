function MIDISetup(obj)
if ~obj.app.MIDIOutputCheckBox.Value
    return;
end

obj.midi.channel = 1;
obj.midi.note = 60;
obj.midi.velocity = 64;

obj.midi.major.major = [0,2,4,5,7,9,11];
obj.midi.oneOctave.C = 60;
obj.midi.oneOctave.Db = 61;
obj.midi.oneOctave.D = 62;
obj.midi.oneOctave.Eb = 63;
obj.midi.oneOctave.E = 64;
obj.midi.oneOctave.F = 65;
obj.midi.oneOctave.Gb = 66;
obj.midi.oneOctave.G = 67;
obj.midi.oneOctave.Ab = 68;
obj.midi.oneOctave.A = 69;
obj.midi.oneOctave.Bb = 70;
obj.midi.oneOctave.B = 71;

obj.midi.method = obj.app.KeyMethodDropDown.Value;
obj.midi.oneOctave.pentatonic = [0,3,5,7,10];

if obj.midi.method == "Chromatic"
    obj.midi.numOctaves = ceil(obj.app.NumberofNotesSpinner.Value/12);
    obj.midi.oneOctave.allNotes = 0:11;
    
    obj.midi.notes = [];
    for indOct = 1:obj.midi.numOctaves
        obj.midi.notes = cat(2,obj.midi.notes,obj.midi.oneOctave.allNotes + obj.midi.oneOctave.allNotes + (obj.app.StartingOctaveSpinner.Value - 4 + indOct)*12);
    end
elseif obj.midi.method == "Major"
    obj.midi.numOctaves = ceil(obj.app.NumberofNotesSpinner.Value/7);
    
    obj.midi.notes = [];
    for indOct = 1:obj.midi.numOctaves
        obj.midi.notes = cat(2,obj.midi.notes,obj.midi.oneOctave.(obj.app.KeyDropDown.Value) + obj.midi.oneOctave.(obj.midi.method) + (obj.app.StartingOctaveSpinner.Value - 4 + indOct - 1)*12);
    end
elseif obj.midi.method == "mPentatonic"
    obj.midi.numOctaves = ceil(obj.app.NumberofNotesSpinner.Value/5);
    
    obj.midi.notes = [];
    for indOct = 1:obj.midi.numOctaves
        obj.midi.notes = cat(2,obj.midi.notes,obj.midi.oneOctave.(obj.app.KeyDropDown.Value) + obj.midi.oneOctave.(obj.midi.method) + (obj.app.StartingOctaveSpinner.Value - 4 + indOct - 1)*12);
    end
end
end
