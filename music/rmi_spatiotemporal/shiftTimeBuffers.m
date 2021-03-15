function shiftTimeBuffers(obj)
obj.time.t(1:end-1) = obj.time.t(2:end);
obj.target.yRangeBuffer(1:end-1) = obj.target.yRangeBuffer(2:end);
obj.target.zRangeBuffer(1:end-1) = obj.target.zRangeBuffer(2:end);
obj.target.zRangeBufferRaw(1:end-1) = obj.target.zRangeBufferRaw(2:end);
obj.target.zVelocityBuffer(1:end-1) = obj.target.zVelocityBuffer(2:end);
obj.RMA.rmaBuffer(:,:,1:end-1) = obj.RMA.rmaBuffer(:,:,2:end);
obj.RMA.mtiBuffer(:,:,1:end-1) = obj.RMA.mtiBuffer(:,:,2:end);
end