function updateParams(app)
if app.Tx0CheckBox.Value && app.Tx1CheckBox.Value && app.Tx2CheckBox.Value
    app.Params.nTx = 3;
elseif app.Tx0CheckBox.Value && ~app.Tx1CheckBox.Value && app.Tx2CheckBox.Value
    app.Params.nTx = 2;
elseif app.Tx0CheckBox.Value && ~app.Tx1CheckBox.Value && ~app.Tx2CheckBox.Value
    app.Params.nTx = 1;
else
    app.mmWaveStudioTextArea.Value = "Warning: incompatible Tx combination. Resetting Tx selection.";
    app.Tx0CheckBox.Value = 1;
    app.Tx1CheckBox.Value = 1;
    app.Tx2CheckBox.Value = 1;
    app.Params.nTx = 3;
end
AWR1243_ArrayDimensions_GUI(app);

app.Params.K = app.FreqSlopeMHzusEditField.Value*1e12;
app.Params.fS = app.SampleRatekspsEditField.Value*1e3;
app.Params.adcSample = app.ADCSamplesEditField.Value;
app.Params.IdleTime = app.IdleTimeusEditField.Value*1e-6;
app.Params.TXStartTime = app.TXStartTimeusEditField.Value*1e-6;
app.Params.ADCStartTime = app.ADCStartTimeusEditField.Value*1e-6;
app.Params.RampEndTime = app.RampEndTimeusEditField.Value*1e-6;
app.Params.f0 = app.StartFreqGHzEditField.Value*1e9;
app.Params.k = kCreate_app(app);

app.Params.nFrame = app.NoofFramesEditField.Value;
app.Params.nChirp = app.NoofChirpLoopsEditField.Value;
app.Params.framePeriodicity_ms = app.PeriodicitymsEditField.Value;

app.Params.ADCSampleTime_time = app.Params.RampEndTime - app.Params.ADCStartTime - app.Params.TXStartTime;
app.Params.ADCSampleTime_sample = app.Params.adcSample/app.Params.fS;

if app.Params.ADCSampleTime_sample > app.Params.ADCSampleTime_time
    % Error! Not enough time to collect enough samples
    warndlg("Not enough time to collect " + app.Params.adcSample + " samples at " + app.Params.fS*1e-3 + " ksps",'ERROR');
end
app.Params.B_total = app.Params.RampEndTime*app.Params.K;
app.Params.B_useful = app.Params.ADCSampleTime_sample*app.Params.K;

if app.Params.B_total > 4e9
    warndlg("Bandwidth exceeds maximum of 4GHz");
end

c = physconst('lightspeed');

app.Params.rangeMax_m = app.Params.fS*c/(2*app.Params.K);
app.Params.rangeResolution_m = c/(2*app.Params.B_useful);

app.Params.dutyCycle = app.Params.nTx*(app.Params.IdleTime + app.Params.RampEndTime)/(app.Params.framePeriodicity_ms*1e-3);

app.Params.nFFT = 2^(ceil(log2(app.FFTSizeSlider.Value)));

app.Params.fileName = app.FileNameEditField.Value;