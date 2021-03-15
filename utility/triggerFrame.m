function triggerFrame(app)
if ~app.isCaptureActive
    % Configure DCA Packet Delay
    Lua_String = "ar1.CaptureCardConfig_StartRecord(""" + strrep(pwd + "\data\realTimeData.bin","\","\\") + """, 1)";
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~=30000)
        app.mmWaveStudioTextArea.Value = 'Configure DCA record failure';
        return;
    else
        pause(1)
        if ~app.isDataReader
            app.Params.fileNameFullPath = pwd + "\data\realTimeData_Raw_0.bin";
            app.mmWaveStudioTextArea.Value = 'Configure DCA record success, saving using mmWave Studio method';
        else
            app.Params.fileNameFullPath = pwd + "\data\" + string(app.Params.fileName);
            app.mmWaveStudioTextArea.Value = 'Configure DCA record success, saving using custom method';
        end
    end
    
    % Trigger Frame
    Lua_String = "ar1.StartFrame()";
    ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
    if (ErrStatus ~=30000)
        app.mmWaveStudioTextArea.Value = "Trigger frame failed!";
    else
        pause(0.1);
        if app.Params.nFrame == 0
            app.isCaptureActive = true;
        else
            app.isCaptureActive = false;
        end
        app.mmWaveStudioTextArea.Value = "Trigger frame success!";
    end
else
    app.mmWaveStudioTextArea.Value = "Please stop frame before starting another!";
end