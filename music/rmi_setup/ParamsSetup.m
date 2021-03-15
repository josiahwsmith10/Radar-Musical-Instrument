function ParamsSetup(obj)
obj.app.Params.numFrames = obj.app.DopplerNumFramesEditField.Value;
obj.app.Params.numMTIFrames = obj.app.NumMTIFramesEditField.Value;
obj.app.Params.numDopplerBins = obj.app.NumDopplerBinsEditField.Value;

if obj.app.Params.numDopplerBins < obj.app.Params.numFrames
    obj.app.Params.numDopplerBins = obj.app.Params.numFrames;
    obj.app.NumDopplerBinsEditField.Value = obj.app.Params.numDopplerBins;
    warning("Too few Doppler bins... correcting!")
    beep();
end

obj.app.Params.Stolt = 'linear';
end
