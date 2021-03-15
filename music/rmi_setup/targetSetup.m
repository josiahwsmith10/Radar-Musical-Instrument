function targetSetup(obj)
obj.target.yRangeBuffer = zeros(obj.app.Params.numFrames,1);
obj.target.zRangeBuffer = zeros(obj.app.Params.numFrames,1);
obj.target.zRangeBufferRaw = zeros(obj.app.Params.numFrames,1);
obj.target.crossRangeOscillation = zeros(1,length(obj.time.f_yRangeOscillation));

% 2-D location particle filter paramters
obj.target.pf.numParticles = obj.app.LocNumParticlesEditField.Value;
obj.target.pf.locations(:,1) = obj.app.p.yT(1) + (obj.app.p.yT(end) - obj.app.p.yT(1))*rand(obj.target.pf.numParticles,1);
obj.target.pf.locations(:,2) = obj.app.p.zT(1) + (obj.app.p.zT(end) - obj.app.p.zT(1))*rand(obj.target.pf.numParticles,1);
obj.target.pf.weights = ones(obj.target.pf.numParticles,1)/obj.target.pf.numParticles;

obj.target.pf.sigmaDiffusion = obj.app.LocDiffusionSigmaEditField.Value;
obj.target.pf.sigmaResample = obj.app.LocResampleSigmaEditField.Value;
end
