function figWork(obj)
% Update the real time yRange plot
if obj.app.Position2DScatterCheckBox.Value
    obj.figs.scatterPosition2D.scatter.XData = obj.target.yRangeBuffer(end);
    obj.figs.scatterPosition2D.scatter.YData = obj.target.zRangeBuffer(end);
end

% Update the yRange vs time plot
if obj.app.CrossRangevsTimePlotCheckBox.Value
    obj.figs.yRange_vs_time.plot.YData = obj.target.yRangeBuffer;
end

% Update the yRange oscillation frequency plot
if obj.app.OscillationPlotCheckBox.Value
    obj.figs.oscillationPlot.plot.YData = obj.target.crossRangeOscillation;
end

% Update the modulation vs time plot
if obj.app.ModulationCheckBox.Value && obj.app.OscillationPlotCheckBox.Value
    obj.figs.modulationPlot.plot.YData = obj.music.recentModBuffer;
end

% Update the zRange vs time plot
if obj.app.RangevsTimePlotCheckBox.Value
    obj.figs.zRange_vs_time.plot.YData = obj.target.zRangeBuffer;
end

% Update the RMA real time plot
if obj.app.RMAPlotCheckBox.Value
    obj.figs.rmaPlot.surf.ZData = gather(obj.RMA.sarImage64x64.');
end

% Update the Doppler and Doppler vs time plots
if obj.app.DopplerPlotCheckBox.Value
    obj.figs.dopplerPlot.plot.YData = gather(obj.target.dopplerVector);
    obj.figs.dopplerPlot.ax.Title.String = "Velocity = " + round(obj.target.zVelocityBuffer(end)*1e3,1) + " mm/s";
    
    obj.figs.dopplerVsTime.plot.YData = obj.target.zVelocityBuffer*1e3;
end
drawnow
end
