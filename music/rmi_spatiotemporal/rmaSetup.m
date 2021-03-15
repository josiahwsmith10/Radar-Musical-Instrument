function rmaSetup(obj)
obj.RMA.k = gpuArray(single(reshape(obj.app.Params.k,1,[])));
obj.RMA.zpad = gpuArray(single(zeros((obj.app.Params.nFFT-obj.app.Params.nVx)/2,obj.app.Params.adcSample)));
kSy = 2*pi/(obj.app.Params.yStepV_mm*1e-3);
obj.RMA.kY = gpuArray(single(reshape(linspace(-kSy/2,kSy/2,obj.app.Params.nFFT),[],1)));

obj.RMA.kZU = reshape(linspace(0,2*max(obj.RMA.k),obj.app.Params.nFFT),1,[]);
obj.RMA.kU = gpuArray(single(1/2 * sqrt(obj.RMA.kY.^2 + obj.RMA.kZU.^2)));

obj.RMA.kYU = repmat(obj.RMA.kY,[1,obj.app.Params.nFFT]);

obj.RMA.yRangeRMA_crop_m = single(gather(obj.app.Params.yStepV_mm*1e-3 * (-(obj.app.Params.nFFT-1)/2 : (obj.app.Params.nFFT-1)/2)));
obj.RMA.zRangeRMA_crop_m = single(gather((1:obj.app.Params.nFFT)*(2*pi/(mean(diff(obj.RMA.kZU))*length(obj.RMA.kZU)))));

obj.RMA.indY = obj.RMA.yRangeRMA_crop_m >= (obj.app.p.yT(1)) & obj.RMA.yRangeRMA_crop_m <= (obj.app.p.yT(end));
obj.RMA.indZ = obj.RMA.zRangeRMA_crop_m >= (obj.app.p.zT(1)) & obj.RMA.zRangeRMA_crop_m <= (obj.app.p.zT(end));

obj.RMA.indY_offset = find(obj.RMA.indY == 1,1) - 1;
obj.RMA.indZ_offset = find(obj.RMA.indZ == 1,1) - 1;

obj.RMA.yT = obj.RMA.yRangeRMA_crop_m(obj.RMA.indY);
obj.RMA.zT = obj.RMA.zRangeRMA_crop_m(obj.RMA.indZ);

obj.RMA.yLim = length(obj.RMA.yT);
obj.RMA.zLim = length(obj.RMA.zT);

obj.RMA.rmaBuffer = gpuArray(single(zeros(obj.RMA.yLim,obj.RMA.zLim,obj.app.Params.numFrames)));
obj.RMA.mtiBuffer = gpuArray(single(zeros(obj.RMA.yLim,obj.RMA.zLim,obj.app.Params.numMTIFrames)));

obj.RMA.sarImage = zeros(obj.RMA.yLim,obj.RMA.zLim);
obj.RMA.sarImage64x64 = zeros(obj.app.p.yLim,obj.app.p.zLim);
end
