function doModWork(obj)
% Shift the modulation buffer
obj.music.recentModBuffer(1:end-1) = obj.music.recentModBuffer(2:end);

% Get the maximum from the oscillation Fourier transform
[obj.music.modFreqMax,obj.music.indModFreqMax] = max(obj.target.crossRangeOscillation);

obj.music.modThreshold = obj.app.ModThresholdEditField.Value;

% If the mode of the recent note buffer reoccures 75% of the
% recent mod buf && the peak is above the threshold
if numel(find(mode(obj.music.recentNoteBuffer) == obj.music.recentNoteBuffer)) > 3/4*numel(obj.music.recentNoteBuffer) && obj.music.modFreqMax >= obj.music.modThreshold
    obj.music.recentModBuffer(end) = obj.time.f_yRangeOscillation(obj.music.indModFreqMax);
else
    obj.music.recentModBuffer(end) = 0;
end

if obj.app.ModParticleFilterCheckBox.Value
    % Use particle filter to track modulation
    
    % Step 1: Generate new samples s' by sampling
    try
        obj.music.pf.s_p = randsample(1:obj.music.pf.numParticles,obj.music.pf.numParticles,true,obj.music.pf.weights);
    catch
    end
    obj.music.pf.locations = obj.music.pf.locations(obj.music.pf.s_p);
    
    % Step 2: Diffusion
    obj.music.pf.measurement = (obj.music.recentModBuffer(end) - obj.music.recentModBuffer(end-1))/obj.app.ModEpsilonEditField.Value;
    obj.music.pf.locations = obj.music.pf.locations + obj.music.pf.measurement + obj.music.pf.sigmaDiffusion*randn(size(obj.music.pf.locations));
    obj.music.pf.locations = sort(obj.music.pf.locations);
    
    % Step 3: Measurement
    obj.music.pf.mu = obj.music.recentModBuffer(end-1);
    obj.music.pf.weights = exp(-1/2 * (1/obj.music.pf.sigmaResample^2) * sum(obj.music.pf.locations-obj.music.pf.mu,2));
    obj.music.pf.sum_w = sum(obj.music.pf.weights,'omitnan');
    obj.music.pf.weights = obj.music.pf.weights/obj.music.pf.sum_w;
    
    % Step 4: Estimate
    obj.music.recentModBuffer(end) = round(sum(obj.music.pf.locations.*obj.music.pf.weights)./sum(obj.music.pf.weights)*obj.app.QuantizationLevelsEditField.Value)/obj.app.QuantizationLevelsEditField.Value;
end

% Set the current modulation frequency
obj.music.modFreq = mean(obj.music.recentModBuffer(end-3:end));
end
