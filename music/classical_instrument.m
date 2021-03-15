function classical_instrument(obj,frame,frame_num)
% Shift all time buffers
shiftTimeBuffers(obj);

% Update time vector with newest info
obj.time.t(end) = double(frame_num) * obj.time.pri_s;

% Classical detect work
classical_detectWork(obj,frame);

% If no hand
if ~obj.detect.isHand
    % Fill time buffers with previous data
    obj.target.yRangeBuffer(end) = obj.target.yRangeBuffer(end-1);
    obj.target.zRangeBuffer(end) = obj.target.zRangeBuffer(end-1);
    obj.RMA.rmaBuffer(:,:,end) = obj.RMA.rmaBuffer(:,:,end-1);
    obj.app.mmWaveStudioTextArea.Value = "NO HAND!";
    stopMIDI(obj);
    return;
end

% RMA work
rmaWork(obj,frame); % Changes obj.RMA.sarImage, obj.RMA.sarImage64x64

% Classical target work
classical_targetWork(obj);

% Music work
musicWork(obj);

% Do the fig work
figWork(obj);
end