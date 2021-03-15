function updateParamFields(app)
app.FreqSlopeMHzusEditField.Value = app.Params.K*1e-12;
app.SampleRatekspsEditField.Value = app.Params.fS*1e-3;
app.ADCSamplesEditField.Value = app.Params.adcSample;
app.IdleTimeusEditField.Value = app.Params.IdleTime*1e6;
app.TXStartTimeusEditField.Value = app.Params.TXStartTime*1e6;
app.ADCStartTimeusEditField.Value = app.Params.ADCStartTime*1e6;
app.RampEndTimeusEditField.Value = app.Params.RampEndTime*1e6;
app.StartFreqGHzEditField.Value = app.Params.f0*1e-9;

app.NoofFramesEditField.Value = app.Params.nFrame;
app.NoofChirpLoopsEditField.Value = app.Params.nChirp;
app.PeriodicitymsEditField.Value = app.Params.framePeriodicity_ms;

app.MaxRangemEditField.Value = app.Params.rangeMax_m;
app.RangeResmEditField.Value = app.Params.rangeResolution_m;
app.BandwidthGHzEditField.Value = app.Params.B_useful*1e-9;
app.DutyCycleEditField.Value = app.Params.dutyCycle*1e2;

app.FFTSizeSlider.Value = app.Params.nFFT;

app.FileNameEditField.Value = app.Params.fileName;