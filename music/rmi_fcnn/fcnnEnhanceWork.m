function fcnnEnhanceWork(obj)
% Get 64x64 enhanced image
obj.fcnnEnhance.filter64x64 = predict(obj.fcnnEnhance.fcnnNet,obj.RMA.sarImage64x64);

% Resize the image
obj.fcnnEnhance.filter = imresize(obj.fcnnEnhance.filter64x64,[obj.RMA.yLim,obj.RMA.zLim]);

% Use the filter
obj.fcnnEnhance.rmaEnhanced = obj.fcnnEnhance.filter.*obj.RMA.sarImage;

% Fill the rmaBuffer with the enhanced image
obj.RMA.rmaBuffer(:,:,end) = obj.fcnnEnhance.rmaEnhanced;
obj.RMA.sarImage64x64 = obj.fcnnEnhance.filter64x64;
end
