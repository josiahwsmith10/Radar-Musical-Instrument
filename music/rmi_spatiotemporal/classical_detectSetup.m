function classical_detectSetup(obj)
obj.detect.rangePeakThreshold = 0.3;
obj.detect.isHandBufferSize = 4;
obj.detect.isHandBuffer = zeros(1,obj.detect.isHandBufferSize);
end
