function stopFrame(app)
% Trigger Frame
app.mmWaveStudioTextArea.Value = "Stopping frame";
app.mmWaveStudioLamp.Color = 'yellow';
Lua_String = "ar1.StopFrame()";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = "Stop frame failed!";
    app.mmWaveStudioLamp.Color = 'red';
else
    pause(2);
    app.mmWaveStudioTextArea.Value = "Stop frame success!";
    app.mmWaveStudioLamp.Color = 'green';
    app.isCaptureActive = false;
end