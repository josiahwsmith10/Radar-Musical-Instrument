function startDataReader(app)
if ~app.isRadarConfigure
    app.mmWaveStudioTextArea.Value = "Configure radar before attampting to open data reader!";
end

% Make sure app.Params has the nChirp field
if ~isfield(app.Params,'nChirp')
    app.Params.nChirp = 1;
end

if app.isSaveData
    system("start ./include/dca1000evm_udp_interface.exe " + app.Params.adcSample + " " + app.Params.nVx + " " + app.Params.nChirp + " " + ".\data\" + string(app.Params.fileName));
    Params = app.Params;
    [~,name] = fileparts(app.Params.fileName);
    save("./data/" + string(name),"Params");
else
    system("start ./include/dca1000evm_udp_interface.exe " + app.Params.adcSample + " " + app.Params.nVx + " " + app.Params.nChirp);
end
app.isDataReader = true;
app.DataReaderLamp.Color = 'green';
end