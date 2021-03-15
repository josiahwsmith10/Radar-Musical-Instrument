function disconnectDCA(app)
% Configure DCA Packet Delay
Lua_String = "ar1.CaptureCard_DisConnect()";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'DCA disconnect failure';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'DCA disconnect success';
end

app.ConfigureRadarLamp.Color = 'red';