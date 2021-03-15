function setupDCA1000EVM(obj)
if ~isfield(obj.app.Params,'nIQchan')
    obj.app.Params.nIQchan = 2;
end
if ~isfield(obj.app.Params,'bytes')
    obj.app.Params.bytes = 2;
end
if ~isfield(obj.app.Params,'nChirps')
    obj.app.Params.nChirps = 1;
end

k = reshape(obj.app.Params.k,1,[]);

obj.dca.phaseCorrectionFactor = exp(-1j* k .* obj.app.Params.D_m(:,2).^2 / (4*obj.app.Params.z0_mm*1e-3));

obj.dca.BYTES_IN_FRAME = obj.app.Params.adcSample * obj.app.Params.nVx * obj.app.Params.nIQchan * obj.app.Params.bytes * obj.app.Params.nChirps;
obj.dca.calib = load("calib").calib;
obj.dca.coeff = obj.dca.calib.ampPhaseBiasCalibration.*exp(1j*obj.app.Params.k.*obj.dca.calib.rangeCorrection_m).*obj.dca.phaseCorrectionFactor;
end