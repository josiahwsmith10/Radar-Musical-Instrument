function fcnnEnhanceSetup(obj)
obj.fcnnEnhance = load(obj.app.FCNNEditField.Value);
obj.fcnnEnhance.filter64x64 = single(gpuArray(ones(obj.fcnnEnhance.p.yLim,obj.fcnnEnhance.p.zLim)));
end
