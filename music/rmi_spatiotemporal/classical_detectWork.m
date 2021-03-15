function classical_detectWork(obj,frame)
% Shift isHand buffer
obj.detect.isHandBuffer(1:end-1) = obj.detect.isHandBuffer(2:end);

% Take and crop range FFT
obj.detect.rangeData = fft(mean(frame,1),obj.app.Params.nFFT,2)*10/obj.app.Params.nFFT;
obj.detect.rangeDataCrop = obj.detect.rangeData(obj.app.p.indZ);

% Get the amplitude of the peak
obj.detect.peakValue = max(abs(obj.detect.rangeDataCrop));

% Use threshold
if obj.detect.peakValue >= obj.detect.rangePeakThreshold
    obj.detect.isHandBuffer(end) = 1;
else
    obj.detect.isHandBuffer(end) = 0;
end

% Determine if hand is currently in scene
obj.detect.isHand = max(obj.detect.isHandBuffer);
end
