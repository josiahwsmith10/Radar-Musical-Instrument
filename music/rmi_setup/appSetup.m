function appSetup(obj)
c = physconst('lightspeed');
rangeIdxToMeters = c * obj.app.Params.fS / (2 * obj.app.Params.K * obj.app.Params.adcSample);
obj.app.Params.rangeAxis = linspace(0, (obj.app.Params.adcSample-1) * rangeIdxToMeters, obj.app.Params.nFFT);
obj.app.p.indZ = obj.app.Params.rangeAxis >= (obj.app.p.zT(1)) & obj.app.Params.rangeAxis <= (obj.app.p.zT(end));
obj.app.p.indZ_offset = find(obj.app.p.indZ == 1,1) - 1;
end
