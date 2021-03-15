function updatep(app)

% Adjust the range slider to have the correct maximum range
app.RangemSlider.Limits = [0,app.Params.rangeMax_m];

% If it is out of the limits, fix
if app.RangemSlider.Limits(2) < app.RangemSlider.Value
    app.RangemSlider.Value = app.RangemSlider.Limits(2);
end

% Image Dimensions
app.p.yLim = round(app.ImageSizeSlider.Value);
app.p.zLim = round(app.ImageSizeSlider.Value);

% Image Axes Sizes
app.p.yMax = app.CrossRangemSlider.Value;
app.p.zMax = app.RangemSlider.Value;

% Create the Axes
app.p.yT = linspace(-app.p.yMax+2*app.p.yMax/app.p.yLim,app.p.yMax,app.p.yLim);
app.p.zOffset = 0.1;
app.p.zT = linspace(app.p.zOffset + (app.p.zMax - app.p.zOffset)/app.p.zLim,app.p.zMax,app.p.zLim);