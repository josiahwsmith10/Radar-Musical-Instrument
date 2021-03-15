function classical_targetWork(obj)
% Do 2-D position finding on RMA 64x64 image
[~,obj.target.maxInd] = max(obj.RMA.sarImage64x64(:));
[obj.target.indY,obj.target.indZ] = ind2sub([obj.app.p.yLim,obj.app.p.zLim],obj.target.maxInd);

if abs(atand(obj.fcnnEnhance.p.yT(obj.target.indY)/obj.app.p.zT(obj.target.indZ))) < 15
    obj.target.yRangeBuffer(end) = obj.app.p.yT(obj.target.indY);
    obj.target.zRangeBuffer(end) = obj.app.p.zT(obj.target.indZ);
    obj.target.zRangeBufferRaw(end) = obj.app.p.zT(obj.target.indZ);
else
    obj.target.yRangeBuffer(end) = obj.target.yRangeBuffer(end-1);
    obj.target.zRangeBuffer(end) = obj.target.zRangeBuffer(end-1);
    obj.target.zRangeBufferRaw(end) = obj.target.zRangeBufferRaw(end-1);
end

if obj.app.ImprovedTrackingCheckBox.Value
    improvedTrackingWork(obj);
end

% Do cross range oscillation work
oscillationWork(obj);

% Do Doppler work
dopplerWork(obj);
end
