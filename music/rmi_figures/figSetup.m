function figSetup(obj)
% Cross Range Oscillation Figure
if obj.app.OscillationPlotCheckBox.Value
    obj.figs.oscillationPlot.fig = figure('OuterPosition',[100,100,400,400]);
    obj.figs.oscillationPlot.ax = handle(axes);
    obj.figs.oscillationPlot.plot = handle(plot(NaN(size(obj.time.f_yRangeOscillation)),'.'));
    
    obj.figs.oscillationPlot.ax.XLabel.String = "Doppler Freq (Hz)";
    obj.figs.oscillationPlot.ax.YLim = [0,2*obj.app.Params.nFFT];
    obj.figs.oscillationPlot.ax.XLim = [obj.time.f_yRangeOscillation(1),obj.time.f_yRangeOscillation(end)];
    obj.figs.oscillationPlot.ax.Title.String = "Oscillation Frequency";
    obj.figs.oscillationPlot.plot.XData = obj.time.f_yRangeOscillation;
end

% Modulation Figure
if obj.app.ModulationCheckBox.Value && obj.app.OscillationPlotCheckBox.Value
    obj.figs.modulationPlot.fig = figure('OuterPosition',[1450,100,400,400]);
    obj.figs.modulationPlot.ax = handle(axes);
    obj.figs.modulationPlot.plot = handle(plot(NaN(size(obj.music.recentModBuffer)),'.'));
    
    obj.figs.modulationPlot.ax.XLabel.String = "Time";
    obj.figs.modulationPlot.ax.YLabel.String = "Modulation Frequency (Hz)";
    obj.figs.modulationPlot.ax.YLim = [-1,obj.time.f_yRangeOscillation(end)];
    obj.figs.modulationPlot.ax.Title.String = "Modulation vs Time";
end

% Cross Range vs Time Figure
if obj.app.CrossRangevsTimePlotCheckBox.Value
    obj.figs.yRange_vs_time.fig = figure('OuterPosition',[550,100,400,400]);
    obj.figs.yRange_vs_time.ax = handle(axes);
    obj.figs.yRange_vs_time.plot = handle(plot(NaN(size(obj.time.t)),'.'));
    
    obj.figs.yRange_vs_time.ax.XLim = [0,(obj.app.Params.numFrames-1)*obj.app.Params.framePeriodicity_ms*1e-3];
    obj.figs.yRange_vs_time.ax.XLabel.String = "Time (s)";
    obj.figs.yRange_vs_time.ax.YLabel.String = "Cross Range (m)";
    obj.figs.yRange_vs_time.ax.YLim = [obj.app.p.yT(1),obj.app.p.yT(end)];
    obj.figs.yRange_vs_time.ax.Title.String = "Cross Range vs Time";
    obj.figs.yRange_vs_time.plot.XData = (0:(obj.app.Params.numFrames-1))*obj.app.Params.framePeriodicity_ms*1e-3;
end

% Scatter 2-D Range vs Cross Range Figure
if obj.app.Position2DScatterCheckBox.Value
    obj.figs.scatterPosition2D.fig = figure('OuterPosition',[1000,100,400,400]);
    obj.figs.scatterPosition2D.ax = handle(axes);
    obj.figs.scatterPosition2D.scatter = handle(scatter(NaN,NaN));
    
    obj.figs.scatterPosition2D.ax.XLabel.String = "y (m)";
    obj.figs.scatterPosition2D.ax.YLabel.String = "z (m)";
    obj.figs.scatterPosition2D.ax.Title.String = "Position 2-D";
    obj.figs.scatterPosition2D.ax.XLim = [obj.fcnnEnhance.p.yT(1),obj.fcnnEnhance.p.yT(end)];
    obj.figs.scatterPosition2D.ax.YLim = [obj.fcnnEnhance.p.zT(1),obj.fcnnEnhance.p.zT(end)];
end

% RMA Figure
if obj.app.RMAPlotCheckBox.Value
    obj.figs.rmaPlot.fig = figure('OuterPosition',[100,550,400,400]);
    obj.figs.rmaPlot.ax = handle(axes);
    obj.figs.rmaPlot.surf = handle(surf(NaN(2)));
    
    view(obj.figs.rmaPlot.ax,2);
    
    obj.figs.rmaPlot.ax.XLabel.String = "Cross Range (m)";
    obj.figs.rmaPlot.ax.YLabel.String = "Range (m)";
    if obj.app.isDeepLearning
        obj.figs.rmaPlot.surf.XData = obj.fcnnEnhance.p.yT;
        obj.figs.rmaPlot.surf.YData = obj.fcnnEnhance.p.zT;
        obj.figs.rmaPlot.ax.XLim = [obj.fcnnEnhance.p.yT(1),obj.fcnnEnhance.p.yT(end)];
        obj.figs.rmaPlot.ax.YLim = [obj.fcnnEnhance.p.zT(1),obj.fcnnEnhance.p.zT(end)];
    else
        obj.figs.rmaPlot.surf.XData = obj.app.p.yT;
        obj.figs.rmaPlot.surf.YData = obj.app.p.zT;
        obj.figs.rmaPlot.ax.XLim = [obj.app.p.yT(1),obj.app.p.yT(end)];
        obj.figs.rmaPlot.ax.YLim = [obj.app.p.zT(1),obj.app.p.zT(end)];
    end
end

% Range vs Time Figure
if obj.app.RangevsTimePlotCheckBox.Value
    obj.figs.zRange_vs_time.fig = figure('OuterPosition',[550,550,400,400]);
    obj.figs.zRange_vs_time.ax = handle(axes);
    obj.figs.zRange_vs_time.plot = handle(plot(NaN(size(obj.time.t)),'.'));
    
    obj.figs.zRange_vs_time.ax.XLim = [0 (obj.app.Params.numFrames-1)*obj.app.Params.framePeriodicity_ms*1e-3];
    obj.figs.zRange_vs_time.ax.XLabel.String = "Time (s)";
    obj.figs.zRange_vs_time.ax.YLabel.String = "Range (m)";
    obj.figs.zRange_vs_time.ax.YLim = [obj.app.p.zT(1) obj.app.p.zT(end)];
    obj.figs.zRange_vs_time.ax.Title.String = "Range vs Time";
    obj.figs.zRange_vs_time.plot.XData = (0:(obj.app.Params.numFrames-1))*obj.app.Params.framePeriodicity_ms*1e-3;
end

% Doppler Plot Figure
if obj.app.DopplerPlotCheckBox.Value
    obj.figs.dopplerPlot.fig = figure('OuterPosition',[1000,550,400,400]);
    obj.figs.dopplerPlot.ax = handle(axes);
    obj.figs.dopplerPlot.plot = handle(plot(NaN(size(obj.app.Params.dopplerAxis))));
    
    obj.figs.dopplerPlot.ax.XLim = [obj.app.Params.dopplerAxis(1) obj.app.Params.dopplerAxis(end)];
    %                 obj.figs.dopplerPlot.ax.YLim = [0 5e-3];
    obj.figs.dopplerPlot.ax.XLabel.String = "Doppler Velocity (m/s)";
    obj.figs.dopplerPlot.ax.YLabel.String = "Amplitude";
    obj.figs.dopplerPlot.ax.Title.String = "Doppler";
    obj.figs.dopplerPlot.plot.XData = obj.app.Params.dopplerAxis;
    
    obj.figs.dopplerVsTime.fig = figure('OuterPosition',[1450,550,400,400]);
    obj.figs.dopplerVsTime.ax = handle(axes);
    obj.figs.dopplerVsTime.plot = handle(plot(NaN(size(obj.target.zVelocityBuffer)),'.'));
    obj.figs.dopplerVsTime.ax.YLim = [obj.app.Params.dopplerAxis(1)-0.01,obj.app.Params.dopplerAxis(end)+0.01]*1e3;
    obj.figs.dopplerVsTime.ax.YLabel.String = "Doppler Velocity (mm/s)";
    obj.figs.dopplerVsTime.ax.XLabel.String = "Time";
    obj.figs.dopplerVsTime.ax.Title.String = "Doppler vs Time";
end
end