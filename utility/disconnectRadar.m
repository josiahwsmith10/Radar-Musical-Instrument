function disconnectRadar(app)
% Configure DCA Packet Delay
Lua_String = "ar1.PowerOff()";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = 'RF disconnect failure!';
    return;
else
    pause(0.01)
    app.mmWaveStudioTextArea.Value = 'RF disconnect success';
end

% Trigger Frame
Lua_String = "ar1.Disconnect()";
ErrStatus = RtttNetClientAPI.RtttNetClient.SendCommand(Lua_String);
if (ErrStatus ~=30000)
    app.mmWaveStudioTextArea.Value = "RS232 disconnect failed!";
else
    app.mmWaveStudioTextArea.Value = "RS232 disconnect success!";
end

app.InitializeLamp.Color = 'red';