function timeSetup(obj)
obj.time.pri_s = obj.app.Params.framePeriodicity_ms*1e-3;
obj.time.prf_Hz = 1/obj.time.pri_s;
obj.time.t = zeros(obj.app.Params.numFrames,1);
obj.time.f_yRangeOscillation = 0:0.375:2.625; % Frequencies of interest (Hz) for cross range oscillation

% Doppler parameters
obj.time.f_doppler = -obj.time.prf_Hz/2:obj.time.prf_Hz/obj.app.Params.numDopplerBins:obj.time.prf_Hz/2-obj.time.prf_Hz/obj.app.Params.numDopplerBins;
obj.app.Params.dopplerAxis = linspace(-obj.app.Params.lambda_mm*1e-3/(4*obj.time.pri_s),obj.app.Params.lambda_mm*1e-3/(4*obj.time.pri_s),obj.app.Params.numDopplerBins);

obj.time.indDoppler = find(abs(obj.app.Params.dopplerAxis) > 0.001);
obj.app.Params.dopplerAxis = obj.app.Params.dopplerAxis(obj.time.indDoppler);
obj.time.f_doppler = obj.time.f_doppler(obj.time.indDoppler);
obj.app.Params.numDopplerBins = length(obj.app.Params.dopplerAxis);
end
