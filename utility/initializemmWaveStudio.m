function initializemmWaveStudio(app)

if ~app.isConnectedmmWaveStudio
    app.mmWaveStudioTextArea.Value = "mmWave Studio is not connected. Cannot Initialize.";
    return;
elseif app.isInitialize
    app.mmWaveStudioTextArea.Value = "mmWave Studio is already initilized.";
    return;
end

serialList = serialportlist;
[serialIdx,tf] = listdlg('PromptString','XDS110 Class Application/User UART','SelectionMode','single','ListString',serialList);

if tf
    app.COMPort = sscanf(serialList(serialIdx),"COM%d",1);
    app.mmWaveStudioTextArea.Value = "Select COM port: " + app.COMPort;
else
    % No serial port selected
    app.mmWaveStudioTextArea.Value = "Invalid COM port selected or no COM port selected. Cannot Initialize mmWave Studio";
    return;
end

% Starting Initialization
pause(0.01)
app.mmWaveStudioLamp.Color = 'yellow';

% Select DCA Board
Lua_String = "ar1.SelectCaptureDevice(""DCA1000"")";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Failed to select DCA board';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Selected DCA board';
end

% Select Frequency Band
Lua_String = "ar1.frequencyBandSelection(""77G"")";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Failed to select frequency band';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Selected frequency band success';
end

% Select Chip Version
Lua_String = "ar1.SelectChipVersion(""AR1243"")";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Failed to select chip version';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Selected chip version success';
end

% Select Device Variant
Lua_String = "ar1.deviceVariantSelection(""XWR1243"")";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Failed to select device variant';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Selected device variant success';
end

% Reset Board
Lua_String = "ar1.FullReset()";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'Failed to reset board';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'Reset board success';
end

% SOP Control
Lua_String = "ar1.SOPControl(2)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'SOP control failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'SOP control success';
end

% RS232 Connect
Lua_String = "ar1.Connect(" + app.COMPort + ",921600,1000)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'RS232 connect failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'RS232 connect success';
end

% Download BSS Firmware
if app.ESVersionDropDown.Value == "ES3"
    fullPath = "C:\ti\mmwave_dfp_01_02_05_01\rf_eval\rf_eval_firmware\radarss\xwr12xx_xwr14xx_radarss_rprc.bin";
    if ~exist(fullPath,'file')
        beep()
        app.mmWaveStudioTextArea.Value = "ERROR! ES3 Firmware is not found. Please install TI mmWave DFP 1.2.5.1 or change /functions/initializemmWaveStudio() function to have the desired path!";
        return;
    end
    Lua_String = "ar1.DownloadBSSFw(""C:\\ti\\mmwave_dfp_01_02_05_01\\rf_eval\\rf_eval_firmware\\radarss\\xwr12xx_xwr14xx_radarss_rprc.bin"")";
elseif app.ESVersionDropDown.Value == "ES2"
    fullPath = "C:\ti\mmwave_studio_01_00_00_00\rf_eval_firmware\radarss\xwr12xx_xwr14xx_radarss_ES2.0.bin";
    if ~exist(fullPath,'file')
        beep()
        app.mmWaveStudioTextArea.Value = "ERROR! ES2 Firmware is not found. Please install TI mmWave Studio 1.0.0.0 or change /functions/initializemmWaveStudio() function to have the desired path!";
        return;
    end
    Lua_String = "ar1.DownloadBSSFw(""C:\\ti\\mmwave_studio_01_00_00_00\\rf_eval_firmware\\radarss\\xwr12xx_xwr14xx_radarss_ES2.0.bin"")";
end
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'BSS firmware failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'BSS firmwave success';
end

% Download MSS Firmware
if app.ESVersionDropDown.Value == "ES3"
    fullPath = "C:\ti\mmwave_dfp_01_02_05_01\rf_eval\rf_eval_firmware\masterss\xwr12xx_xwr14xx_masterss_rprc.bin";
    if ~exist(fullPath,'file')
        beep()
        app.mmWaveStudioTextArea.Value = "ERROR! ES3 Firmware is not found. Please install TI mmWave DFP 1.2.5.1 or change /functions/initializemmWaveStudio() function to have the desired path!";
        return;
    end
    Lua_String = "ar1.DownloadMSSFw(""C:\\ti\\mmwave_dfp_01_02_05_01\\rf_eval\\rf_eval_firmware\\masterss\\xwr12xx_xwr14xx_masterss_rprc.bin"")";
elseif app.ESVersionDropDown.Value == "ES2"
    fullPath = "C:\ti\mmwave_studio_01_00_00_00\rf_eval_firmware\masterss\xwr12xx_xwr14xx_masterss_ES2.0.bin";
    if ~exist(fullPath,'file')
        beep()
        app.mmWaveStudioTextArea.Value = "ERROR! ES2 Firmware is not found. Please install TI mmWave Studio 1.0.0.0 or change /functions/initializemmWaveStudio() function to have the desired path!";
        return;
    end
    Lua_String = "ar1.DownloadMSSFw(""C:\\ti\\mmwave_studio_01_00_00_00\\rf_eval_firmware\\masterss\\xwr12xx_xwr14xx_masterss_ES2.0.bin"")";
end
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'MSS firmware failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'MSS firmwave success';
end

% SPI Connect
Lua_String = "ar1.PowerOn(0, 1000, 0, 0)";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'SPI connect failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'SPI connect success';
end

% RF Power Up
Lua_String = "ar1.RfEnable()";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'RF power up failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'RF power up success';
end

% Finished Initialization
pause(0.01)
app.mmWaveStudioLamp.Color = 'green';
app.InitializeLamp.Color = 'green';
app.mmWaveStudioTextArea.Value = 'mmWave Studio initialization success!';