function dl_targetWork(obj)
% Do 2-D position finding on 64x64 filter
[~,obj.target.maxInd] = max(obj.fcnnEnhance.filter64x64(:));
[obj.target.indY,obj.target.indZ] = ind2sub([obj.fcnnEnhance.p.yLim,obj.fcnnEnhance.p.zLim],obj.target.maxInd);

if abs(atand(obj.fcnnEnhance.p.yT(obj.target.indY)/obj.fcnnEnhance.p.zT(obj.target.indZ))) < 15
    obj.target.yRangeBuffer(end) = obj.fcnnEnhance.p.yT(obj.target.indY);
    obj.target.zRangeBuffer(end) = obj.fcnnEnhance.p.zT(obj.target.indZ);
    obj.target.zRangeBufferRaw(end) = obj.fcnnEnhance.p.zT(obj.target.indZ);
else
    obj.target.yRangeBuffer(end) = obj.target.yRangeBuffer(end-1);
    obj.target.zRangeBuffer(end) = obj.target.zRangeBuffer(end-1);
    obj.target.zRangeBufferRaw(end) = obj.target.zRangeBuffer(end-1);
end

if obj.app.ImprovedTrackingCheckBox.Value
    improvedTrackingWork(obj);
end

% Do cross range oscillation work
oscillationWork(obj);

% Do Doppler work
dopplerWork(obj);
end
