function oscillationWork(obj)
obj.target.crossRangeOscillation = 1e3*abs(nufft(obj.target.yRangeBuffer - mean(obj.target.yRangeBuffer),obj.time.t,obj.time.f_yRangeOscillation));
end
