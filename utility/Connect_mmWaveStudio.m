function Connect_mmWaveStudio(app)
%% Do TI Work
% Initialize Radarstudio .NET connection
ErrStatus = Init_RSTD_Connection(app.RSTD_DLL_Path);
if (ErrStatus ~= 30000)
    app.mmWaveStudioTextArea.Value = 'Error inside Init_RSTD_Connection';
    app.mmWaveStudioLamp.Color = 'red';
    app.isConnectedmmWaveStudio = false;
    return;
else
    app.mmWaveStudioTextArea.Value = 'RSTD connection is successful';
    app.mmWaveStudioLamp.Color = 'green';
    app.isConnectedmmWaveStudio = true;
end