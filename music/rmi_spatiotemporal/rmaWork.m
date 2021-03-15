function rmaWork(obj,frame)
obj.RMA.previousImage64x64 = obj.RMA.sarImage64x64;

% Zeropad echoData to Center
obj.RMA.echoData = cat(1,obj.RMA.zpad,gpuArray(single(frame)));

% Compute S(kY,k) = FT_y[s(y,k)]: echoDataFFT
obj.RMA.echoDataFFT = fftshift(fft(conj(obj.RMA.echoData),obj.app.Params.nFFT,1),1);

% Stolt Interpolation P(kY,k) -> P(kY,kZ)
obj.RMA.sarImageFFT = interpn(obj.RMA.kY,obj.RMA.k,obj.RMA.echoDataFFT,obj.RMA.kYU,obj.RMA.kU,obj.app.Params.Stolt,0);

% Recover the Reflectivity Function p(y,z)
obj.RMA.sarImageFull = ifft2(obj.RMA.sarImageFFT);

% Crop only Region of Interest (ROI)
obj.RMA.sarImage = obj.RMA.sarImageFull(obj.RMA.indY,obj.RMA.indZ);

% Resize Image
obj.RMA.sarImage64x64 = imresize(abs(obj.RMA.sarImage),[obj.app.p.yLim,obj.app.p.zLim]);
obj.RMA.sarImage64x64 = obj.RMA.sarImage64x64/max(obj.RMA.sarImage64x64,[],'all');

% Fill the rmaBuffer with the rmaImage
obj.RMA.rmaBuffer(:,:,end) = obj.RMA.sarImage;

% Do MTI work
obj.RMA.mtiBuffer(:,:,end) = obj.RMA.sarImage;
obj.RMA.sarImage64x64 = imresize(sqrt(sum(abs(filter([1,-2,1],1,obj.RMA.mtiBuffer,[],3)).^2,3)),[64,64]).*obj.RMA.sarImage64x64/max(obj.RMA.sarImage64x64(:));
end
