function dopplerWork(obj)
if ~obj.app.DopplerCheckBox.Value
    return;
end

obj.doppler.rawVelocity = (obj.target.zRangeBuffer(end)-obj.target.zRangeBuffer(end-1))/(obj.time.t(end)-obj.time.t(end-1));
if obj.doppler.rawVelocity > obj.app.Params.dopplerAxis(end)
    obj.target.zVelocityBuffer(end) = obj.app.Params.dopplerAxis(end);
    
elseif obj.doppler.rawVelocity < obj.app.Params.dopplerAxis(1)
    obj.target.zVelocityBuffer(end) = obj.app.Params.dopplerAxis(1);
else
    % Do Doppler work
    [~,obj.target.RMA.indY] = min(abs(obj.target.yRangeBuffer(end) - obj.RMA.yT));
    
    obj.target.dopplerMat = nufft(gather(squeeze(obj.RMA.rmaBuffer(obj.target.RMA.indY,:,:))),obj.time.t,obj.time.f_doppler,2);
    obj.target.dopplerVector = flip(squeeze(sqrt(sum(abs(obj.target.dopplerMat).^2,1))));
    
    [~,obj.target.indMaxDoppler] = max(obj.target.dopplerVector);
    obj.target.zVelocityBuffer(end) = obj.app.Params.dopplerAxis(obj.target.indMaxDoppler);
end

if obj.app.DopplerParticleFilterCheckBox.Value
    % Use particle filter to track Doppler
    
    % Step 1: Generate new samples s' by sampling
    try
        obj.doppler.pf.s_p = randsample(1:obj.doppler.pf.numParticles,obj.doppler.pf.numParticles,true,obj.doppler.pf.weights);
    catch
    end
    obj.doppler.pf.locations = obj.doppler.pf.locations(obj.doppler.pf.s_p);
    
    % Step 2: Diffusion
    obj.doppler.pf.measurement = (obj.target.zVelocityBuffer(end) - obj.target.zVelocityBuffer(end-1))/obj.app.DopplerEpsilonEditField.Value;
    obj.doppler.pf.locations = obj.doppler.pf.locations + obj.doppler.pf.measurement + obj.doppler.pf.sigmaDiffusion*randn(size(obj.doppler.pf.locations));
    obj.doppler.pf.locations = sort(obj.doppler.pf.locations);
    
    % Step 3: Measurement
    obj.doppler.pf.mu = obj.target.zVelocityBuffer(end-1);
    obj.doppler.pf.weights = exp(-1/2 * (1/obj.doppler.pf.sigmaResample^2) * sum(obj.doppler.pf.locations-obj.doppler.pf.mu,2));
    obj.doppler.pf.sum_w = sum(obj.doppler.pf.weights,'omitnan');
    obj.doppler.pf.weights = obj.doppler.pf.weights/obj.doppler.pf.sum_w;
    
    % Step 4: Estimate
    obj.target.zVelocityBuffer(end) = sum(obj.doppler.pf.weights.*obj.doppler.pf.locations);
end
end
