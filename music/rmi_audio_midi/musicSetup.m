function musicSetup(obj)
% Note and modulation variables
obj.music.indCurrentNote = 0;
obj.music.indPreviousNote = 0;
obj.music.modulationTimeIndex = 0;

% Storage buffers
obj.music.recentNoteBuffer = zeros(1,obj.app.RecentNoteBufferSizeSpinner.Value);
obj.music.recentModBuffer = zeros(1,obj.app.RecentModBufferSizeSpinner.Value);

obj.music.modPersist = 0;

% Note, microtone, and virtual fret parameters
obj.music.virtualFretTolerance = 0.1;
obj.music.numNotes = obj.app.NumberofNotesSpinner.Value;
obj.music.noteDuration = obj.app.NoteDurationSpinner.Value;

if obj.app.AudioOutputCheckBox.Value
    % Note frequency parameters
    obj.music.fs = 44.1e3;
    notes = struct("C4",261.626,"Db4",277.183,"D4",293.665,"Eb4",311.127,"E4",329.628,"F4",349.228,"Gb4",369.994,...
        "G4",391.995,"Ab4",415.305,"A4",440,"Bb4",466.164,"B4",493.883);
    obj.music.major.C = [notes.C4,notes.D4,notes.E4,notes.F4,notes.G4,notes.A4,notes.B4];
    obj.music.major.D = [notes.D4,notes.E4,notes.Gb4,notes.G4,notes.A4,notes.B4,notes.Db4*2];
    obj.music.major.E = [notes.E4,notes.Gb4,notes.Ab4,notes.A4,notes.B4,notes.Db4*2,notes.Eb4*2];
    obj.music.major.F = [notes.F4,notes.G4,notes.A4,notes.Bb4,notes.C4*2,notes.D4*2,notes.E4*2];
    obj.music.major.G = [notes.G4,notes.A4,notes.B4,notes.C4*2,notes.D4*2,notes.E4*2,notes.Gb4*2];
    obj.music.major.A = [notes.A4,notes.B4,notes.Db4*2,notes.D4*2,notes.E4*2,notes.Gb4*2,notes.Ab4*2];
    obj.music.major.B = [notes.B4,notes.Db4*2,notes.Eb4*2,notes.E4*2,notes.Gb4*2,notes.Ab4*2,notes.Bb4*2];
    obj.music.major.All = [notes.C4,notes.Db4,notes.D4,notes.Eb4,notes.E4,notes.F4,notes.Gb4,notes.G4,notes.Ab4,notes.A4,notes.Bb4,notes.B4];
    
    obj.music.pentatonic.C = [notes.C4,notes.Eb4,notes.F4,notes.G4,notes.Bb4];
    obj.music.pentatonic.D = [notes.D4,notes.F4,notes.G4,notes.A4,notes.C4*2];
    obj.music.pentatonic.E = [notes.E4,notes.G4,notes.A4,notes.B4,notes.D4*2];
    obj.music.pentatonic.F = [notes.F4,notes.Ab4,notes.Bb4,notes.C4*2,notes.Eb4*2];
    obj.music.pentatonic.G = [notes.G4,notes.Bb4,notes.C4*2,notes.D4*2,notes.F4*2];
    obj.music.pentatonic.A = [notes.A4,notes.C4*2,notes.D4*2,notes.E4*2,notes.G4*2];
    obj.music.pentatonic.B = [notes.B4,notes.D4*2,notes.E4*2,notes.Gb4*2,notes.A4*2];
    
    if obj.app.KeyMethodDropDown.Value == "Chromatic"
        obj.app.mmWaveStudioTextArea.Value = "Using chromatic scale";
        obj.music.noteFreq = [];
        for indOctave = 1:ceil(obj.app.NumberofNotesSpinner.Value/12)
            obj.music.noteFreq = cat(2,obj.music.noteFreq,obj.music.major.All*(2^(obj.app.StartingOctaveSpinner.Value-5+indOctave)));
        end
    elseif obj.app.KeyMethodDropDown.Value == "Major"
        obj.app.mmWaveStudioTextArea.Value = "Using " + obj.app.KeyDropDown.Value + " major scale ";
        obj.music.noteFreq = [];
        for indOctave = 1:ceil(obj.app.NumberofNotesSpinner.Value/7)
            obj.music.noteFreq = cat(2,obj.music.noteFreq,obj.music.major.(obj.app.KeyDropDown.Value)*(2^(obj.app.StartingOctaveSpinner.Value-5+indOctave)));
        end
    elseif obj.app.KeyMethodDropDown.Value == "mPentatonic"
        obj.app.mmWaveStudioTextArea.Value = "Using " + obj.app.KeyDropDown.Value + " minor pentatonic scale";
        obj.music.noteFreq = [];
        for indOctave = 1:ceil(obj.app.NumberofNotesSpinner.Value/5)
            obj.music.noteFreq = cat(2,obj.music.noteFreq,obj.music.pentatonic.(obj.app.KeyDropDown.Value)*(2^(obj.app.StartingOctaveSpinner.Value-5+indOctave)));
        end
    end
    obj.music.noteFreqInterp = obj.music.noteFreq;
    
    % Audio hardware interface
    obj.music.aDW = audioDeviceWriter;
    if obj.app.TriangleButton.Value
        obj.music.osc = audioOscillator('sawtooth');
    elseif obj.app.SquareButton.Value
        obj.music.osc = audioOscillator('square');
    else
        obj.music.osc = audioOscillator('sine');
    end
    obj.music.osc.SampleRate = obj.music.fs;
    obj.music.osc.Amplitude = obj.app.AmplitudeSlider.Value;
end

if obj.app.ModParticleFilterCheckBox.Value
    % Modulation particle filter parameters
    obj.music.pf.numParticles = obj.app.ModNumParticlesEditField.Value;
    obj.music.pf.locations = obj.time.f_yRangeOscillation(1) + (obj.time.f_yRangeOscillation(end) - obj.time.f_yRangeOscillation(1))*rand(obj.music.pf.numParticles,1);
    obj.music.pf.weights = ones(size(obj.music.pf.locations))/obj.music.pf.numParticles;
    obj.music.pf.sigmaResample = obj.app.ModResampleSigmaEditField.Value;
    obj.music.pf.sigmaDiffusion = obj.app.ModDiffusionSigmaEditField.Value;
end
end
