function k = kCreate_app(app)
f0 = app.Params.f0 + app.Params.ADCStartTime*app.Params.K; % This is for ADC sampling offset
f = f0 + (0:app.Params.adcSample-1)*app.Params.K/app.Params.fS; % wideband frequency

c = 299792458; % physconst('lightspeed'); in m/s
k = 2*pi*f/c;
end