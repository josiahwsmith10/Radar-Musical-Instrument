function configureRadar(app)

if ~app.isConnectedmmWaveStudio
    app.mmWaveStudioTextArea.Value = "mmWave Studio is not connected. Cannot configure.";
    return;
elseif app.isInitialize
    app.mmWaveStudioTextArea.Value = "mmWave Studio is not initilized. Cannot configure";
    return;
end

% Starting Radar Configuration
pause(0.01)
app.mmWaveStudioLamp.Color = 'yellow';
app.mmWaveStudioTextArea.Value = 'Configuring radar';
app.isRadarConfigure = false;

% Channel Config
Lua_String = "ar1.ChanNAdcConfig(" +...
    int8(app.Tx0CheckBox.Value) + ", " +...
    int8(app.Tx1CheckBox.Value) + ", " +...
    int8(app.Tx2CheckBox.Value) + ", " +...
    int8(app.Rx0CheckBox.Value) + ", " +...
    int8(app.Rx1CheckBox.Value) + ", " +...
    int8(app.Rx2CheckBox.Value) + ", " +...
    int8(app.Rx3CheckBox.Value) + ", " +...
    "2, 1, 0)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Channel config failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Channel config success';
end

% Set LP Mode
Lua_String = "ar1.LPModConfig(0, 0)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'LP mode failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'LP mode success';
end

% RF Initialize
Lua_String = "ar1.RfInit()";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'RF initialize failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'RF initialize success';
end

% Data Path Configuration
Lua_String = "ar1.DataPathConfig(513, 1216644097, 0)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Data path configuration failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Data path configuration success';
end

% LVDS Clock Configuration
Lua_String = "ar1.LvdsClkConfig(1, 1)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'LVDS clock configuration failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'LVDS clock configuration success';
end

% LVDS Lane Configuration
Lua_String = "ar1.LVDSLaneConfig(0, 1, 1, 1, 1, 1, 0, 0)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'LVDS lane configuration failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'LVDS lane configuration success';
end

% Profile Configuration
Lua_String = "ar1.ProfileConfig(0, " + ...
    app.StartFreqGHzEditField.Value + ", " + ...
    app.IdleTimeusEditField.Value + ", " + ...
    app.ADCStartTimeusEditField.Value + ", " + ...
    app.RampEndTimeusEditField.Value + ", " + ...
    "0, 0, 0, 0, 0, 0, " + ...
    round(app.FreqSlopeMHzusEditField.Value,3) + ", " + ...
    app.TXStartTimeusEditField.Value + ", " + ...
    app.ADCSamplesEditField.Value + ", " + ...
    app.SampleRatekspsEditField.Value + ", " + ...
    "0, 0, 30)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Profile configuration failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Profile configuration success';
end

% First Chrip Configuration
Lua_String = "ar1.ChirpConfig(0, 0, 0, 0, 0, 0, 0, 1, 0, 0)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'First chirp configuration failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'First chirp configuration success';
end

if app.Params.nTx == 2
    % Second Chrip Configuration
    Lua_String = "ar1.ChirpConfig(1, 1, 0, 0, 0, 0, 0, 0, 0, 1)";
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~=30000)
        app.mmWaveStudioTextArea.Value = 'Second chirp configuration failure';
        return;
    else
        pause(0.01)
        app.mmWaveStudioTextArea.Value = 'Second chirp configuration success';
    end
    
    % Frame Configuration
    Lua_String = "ar1.FrameConfig(0, 1, " + ...
        app.NoofFramesEditField.Value + ", " + ...
        app.NoofChirpLoopsEditField.Value + ", " + ...
        app.PeriodicitymsEditField.Value + ", " + ...
        "0, 0, 1)";
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~=30000)
        app.mmWaveStudioTextArea.Value = 'Frame configuration failure';
        return;
    else
        pause(0.01)
        app.mmWaveStudioTextArea.Value = 'Frame configuration success';
    end
elseif app.Params.nTx == 3
    % Second Chrip Configuration
    Lua_String = "ar1.ChirpConfig(1, 1, 0, 0, 0, 0, 0, 0, 1, 0)";
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~=30000)
        app.mmWaveStudioTextArea.Value = 'Second chirp configuration failure';
        return;
    else
        pause(0.01)
        app.mmWaveStudioTextArea.Value = 'Second chirp configuration success';
    end
    
    % Third Chrip Configuration
    Lua_String = "ar1.ChirpConfig(2, 2, 0, 0, 0, 0, 0, 0, 0, 1)";
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~=30000)
        app.mmWaveStudioTextArea.Value = 'Third chirp configuration failure';
        return;
    else
        pause(0.01)
        app.mmWaveStudioTextArea.Value = 'Third chirp configuration success';
    end
    
    % Frame Configuration
    Lua_String = "ar1.FrameConfig(0, 2, " + ...
        app.NoofFramesEditField.Value + ", " + ...
        app.NoofChirpLoopsEditField.Value + ", " + ...
        app.PeriodicitymsEditField.Value + ", " + ...
        "0, 0, 1)";
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~=30000)
        app.mmWaveStudioTextArea.Value = 'Frame configuration failure';
        return;
    else
        pause(0.01)
        app.mmWaveStudioTextArea.Value = 'Frame configuration success';
    end
end

% Select Capture Device
Lua_String = "ar1.SelectCaptureDevice(""DCA1000"")";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Select capture device failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Select capture device success';
end

% Configure DCA
Lua_String = "ar1.CaptureCardConfig_EthInit(""192.168.33.30"", ""192.168.33.180"", ""12:34:56:78:90:12"", 4096, 4098)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Configure DCA failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Configure DCA success';
end

% Configure DCA Mode
Lua_String = "ar1.CaptureCardConfig_Mode(1, 1, 1, 2, 3, 30)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Configure DCA mode failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Configure DCA mode success';
end

% Configure DCA Packet Delay
Lua_String = "ar1.CaptureCardConfig_PacketDelay(25)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Configure DCA packet delay failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Configure DCA packet delay success';
end

% Finished Initialization
pause(0.01)
app.mmWaveStudioTextArea.Value = 'Radar configuration success!';

if app.isDataReader
    app.mmWaveStudioTextArea.Value = "Please close the open Data Reader and reopen!";
else
    app.mmWaveStudioTextArea.Value = "Don't forget to start the Data Reader!";
end
app.DataReaderLamp.Color = 'red';
app.mmWaveStudioLamp.Color = 'green';
app.ConfigureRadarLamp.Color = 'green';
app.isRadarConfigure = true;
app.isDataReader = false;