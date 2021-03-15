function [frame_out,frame_num] = getFrame(obj)
[obj.dca.frame,frame_num] = dca1000evm_MATLAB_interface(obj.dca.BYTES_IN_FRAME);

obj.dca.frame_out = gpuArray(single(typecast(uint8(obj.dca.frame),'uint16'))) - 2^15;

obj.dca.frame_out = reshape(obj.dca.frame_out,2*obj.app.Params.nRx,[]);
obj.dca.frame_out = complex(obj.dca.frame_out([1,3,5,7],:),obj.dca.frame_out([2,4,6,8],:));

try
    obj.dca.frame_out = reshape(obj.dca.frame_out,obj.app.Params.nRx,obj.app.Params.adcSample,obj.app.Params.nTx);
catch
    warning("Something is wrong with the number of captures!")
    obj.dca.frame_out = gpuArray(single(zeros(obj.app.Params.nVx,obj.app.Params.adcSample)));
    return;
end

obj.dca.frame_out = reshape(permute(obj.dca.frame_out,[1,3,2,4]),obj.app.Params.nVx,obj.app.Params.adcSample);
frame_out = obj.dca.frame_out.*obj.dca.coeff;
end