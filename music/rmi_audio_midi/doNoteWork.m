function doNoteWork(obj)
obj.music.rangeNormalized = (obj.target.zRangeBuffer(end) - obj.app.p.zOffset)/(obj.app.p.zMax - obj.app.p.zOffset);

% Shift buffers
obj.music.indPreviousNote = obj.music.indCurrentNote;
obj.music.recentNoteBuffer(1:end-1) = obj.music.recentNoteBuffer(2:end);

% Virtual frets
% Quantize note index
obj.music.indCurrentNote = round(obj.music.rangeNormalized*obj.music.numNotes);
if obj.music.indCurrentNote < 1
    obj.music.indCurrentNote = 1;
elseif obj.music.indCurrentNote > obj.music.numNotes
    obj.music.indCurrentNote = obj.music.numNotes;
end
obj.music.recentNoteBuffer(end) = obj.music.indCurrentNote;

% Extract the current note
% Use flip since MATLAB  mode() takes the first element
% if they are all the different
obj.music.indCurrentNote = mode(flip(obj.music.recentNoteBuffer));

if obj.music.indCurrentNote < 1
    obj.music.indCurrentNote = 1;
end
end
