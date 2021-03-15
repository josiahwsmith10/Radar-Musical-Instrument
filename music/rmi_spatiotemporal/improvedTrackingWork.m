function improvedTrackingWork(obj)
obj.target.yRangeBuffer(end) = mean(obj.target.yRangeBuffer(end-1:end));
obj.target.zRangeBuffer(end) = mean(obj.target.zRangeBuffer(end-1:end));

% Use Particle Filter
% Step 1: Generate new sample s' by sampling
try
    obj.target.pf.s_p = randsample(1:obj.target.pf.numParticles,obj.target.pf.numParticles,true,obj.target.pf.weights);
catch
    warning("sampling error!")
end
obj.target.pf.locations = obj.target.pf.locations(obj.target.pf.s_p,:);

% Step 2: Diffusion
if obj.app.PFCheckBox.Value
    obj.target.pf.zWeight = 1/obj.app.ZEpsilonEditField.Value;
elseif obj.app.DPFCheckBox.Value
    % Doppler predicted velocity
    obj.target.pf.dopplerVelocity = obj.target.zVelocityBuffer(end);
    
    % Data predicted velocity
    Nr = obj.app.NrEditField.Value;
    x = obj.time.t(end-(Nr-1):end) - max(obj.time.t(end-(Nr-1):end));
    y = obj.target.zRangeBufferRaw(end-(Nr-1):end);
    obj.target.pf.sampleVelocity = (Nr*sum(x.*y)-sum(x)*sum(y))/(Nr*sum(x.^2) - sum(x).^2);
    
    % Implement the cost function
    diffZ = abs(obj.target.pf.dopplerVelocity - obj.target.pf.sampleVelocity);
    if diffZ < obj.app.Params.dopplerAxis(end)
        obj.target.pf.zWeight = (1/obj.app.ZEpsilonEditField.Value)*cos(2*pi*diffZ/(4*obj.app.Params.dopplerAxis(end)));
    else
        obj.target.pf.zWeight = 0;
    end
end
obj.target.pf.measurement = [(obj.target.yRangeBuffer(end) - obj.target.yRangeBuffer(end-1))/obj.app.YEpsilonEditField.Value,(obj.target.zRangeBuffer(end) - obj.target.zRangeBuffer(end-1))*obj.target.pf.zWeight];
obj.target.pf.locations = obj.target.pf.locations + obj.target.pf.measurement + obj.target.pf.sigmaDiffusion*randn(size(obj.target.pf.locations));
obj.target.pf.locations = sort(obj.target.pf.locations);

% Step 3: Measurement & Resample
obj.target.pf.mu = [obj.target.yRangeBuffer(end-1),obj.target.zRangeBuffer(end-1)];
obj.target.pf.weights = exp(-1/2 * (1/obj.target.pf.sigmaResample^2) * sum(obj.target.pf.locations-obj.target.pf.mu,2));
obj.target.pf.sum_w = sum(obj.target.pf.weights,'omitnan');
obj.target.pf.weights = obj.target.pf.weights/obj.target.pf.sum_w;

% Step 4: Estimate
obj.target.pf.yz = sum(obj.target.pf.weights.*obj.target.pf.locations,1,'omitnan');
obj.target.yRangeBuffer(end) = obj.target.pf.yz(1);
obj.target.zRangeBuffer(end) = obj.target.pf.yz(2);

end
