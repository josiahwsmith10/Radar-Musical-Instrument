function dopplerSetup(obj)
obj.target.zVelocityBuffer = single(zeros(1,obj.app.Params.numFrames));
obj.target.dopplerVector = single(zeros(1,obj.app.Params.numDopplerBins));

% Doppler particle filter parameters
obj.doppler.pf.numParticles = obj.app.DopplerNumParticlesEditField.Value;
obj.doppler.pf.locations = obj.app.Params.dopplerAxis(1) + (obj.app.Params.dopplerAxis(end) - obj.app.Params.dopplerAxis(1))*rand(obj.doppler.pf.numParticles,1);
obj.doppler.pf.weights = ones(size(obj.doppler.pf.locations))/obj.doppler.pf.numParticles;
obj.doppler.pf.sigmaDiffusion = obj.app.DopplerDiffusionSigmaEditField.Value;
obj.doppler.pf.sigmaResample = obj.app.DopplerResampleSigmaEditField.Value;
end
