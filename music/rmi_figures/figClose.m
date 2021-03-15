function figClose(obj)
try
    figList = fieldnames(obj.figs);
    for indFig = 1:length(figList)
        try
            close(obj.figs.(char(figList(indFig))).fig);
        catch
        end
    end
catch
end
end
