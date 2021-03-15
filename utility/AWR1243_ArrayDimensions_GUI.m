function AWR1243_ArrayDimensions_GUI(app)
%% Create Array Topology
%-------------------------------------------------------------------------%
lambda_m = 299792458/(79e9);
app.Params.lambda_mm = lambda_m*1e3;

dTxRx = 5e-3;

% Rx Antenna 1 is the reference
% Coordinates: [x y] x-Horizontal, y-Vertical

app.Params.locRx_m =   [0       0
    0       lambda_m/2
    0       lambda_m
    0       3*lambda_m/2];

if app.Params.nTx == 3
    % 12 Channel
    app.Params.locTx_m =   [0               3*lambda_m/2+dTxRx
        -lambda_m/2     3*lambda_m/2+dTxRx+lambda_m
        0               3*lambda_m/2+dTxRx+2*lambda_m   ];
elseif app.Params.nTx == 2
    % 8 Channel
    app.Params.locTx_m =   [0               3*lambda_m/2+dTxRx
        0               3*lambda_m/2+dTxRx+2*lambda_m   ];
elseif app.Params.nTx == 1
    % 4 Channel
    app.Params.locTx_m =   [0               3*lambda_m/2+dTxRx];
end


%% Change Locations of Tx and Rx to nTx x nRx x 2
%-------------------------------------------------------------------------%
app.Params.nTx = size(app.Params.locTx_m,1);
app.Params.nRx = size(app.Params.locRx_m,1);

txT = reshape(app.Params.locTx_m,app.Params.nTx,1,[]);
rxT = reshape(app.Params.locRx_m,1,app.Params.nRx,[]);

%% Declare Difference Vector
%-------------------------------------------------------------------------%
app.Params.D_m = reshape(permute(txT-rxT,[2,1,3]),[],2);   % Distance between each Tx/Rx pair

%% Declare Spatial Features of Virtual Array
%-------------------------------------------------------------------------%
app.Params.V_m = reshape(permute((txT+rxT)/2,[2,1,3]),[],2);

%% Check for Overlapping Elements
%-------------------------------------------------------------------------%
[~,app.Params.idxUnique] = uniquetol(app.Params.V_m,'Byrows',true);
if size(app.Params.V_m,1) ~= size(uniquetol(app.Params.V_m,'Byrows',true),1)
    warning(size(app.Params.V_m,1) - size(uniquetol(app.Params.V_m,'Byrows',true),1) + " elements are overlapping, out of " + size(app.Params.V_m,1))
    app.Params.V_m = uniquetol(app.Params.V_m,'Byrows',true);
    app.Params.D_m = uniquetol(app.Params.D_m,'Byrows',true);
end
app.Params.nVx = numel(app.Params.idxUnique);
app.Params.yStepV_mm = mean(diff(app.Params.V_m(:,2)))*1e3;

%% Plot the Arrays
%-------------------------------------------------------------------------%
cla(app.PhysicalElementsUIAxes);
scatter(app.PhysicalElementsUIAxes,app.Params.locRx_m(:,1)*1e3,app.Params.locRx_m(:,2)*1e3)
k=0:length(app.Params.locRx_m(:,1))-1; 
text(app.PhysicalElementsUIAxes,app.Params.locRx_m(:,1)*1e3+0.05,app.Params.locRx_m(:,2)*1e3+0.05,num2str(k'));
hold(app.PhysicalElementsUIAxes,'on');
scatter(app.PhysicalElementsUIAxes,app.Params.locTx_m(:,1)*1e3,app.Params.locTx_m(:,2)*1e3,'x')
k=0:length(app.Params.locTx_m(:,1))-1; 
text(app.PhysicalElementsUIAxes,app.Params.locTx_m(:,1)*1e3+0.05,app.Params.locTx_m(:,2)*1e3+0.05,num2str(k'));
legend(app.PhysicalElementsUIAxes,"Rx","Tx",'Location','southwest')
title(app.PhysicalElementsUIAxes,"Physical Elements")
app.PhysicalElementsUIAxes.XAxis.Visible = 'off';
app.PhysicalElementsUIAxes.YAxis.Visible = 'off';

cla(app.VirtualElementsUIAxes);
scatter(app.VirtualElementsUIAxes,app.Params.V_m(:,1)*1e3,app.Params.V_m(:,2)*1e3)
k=1:length(app.Params.V_m(:,1)); 
text(app.VirtualElementsUIAxes,app.Params.V_m(:,1)*1e3+0.05,app.Params.V_m(:,2)*1e3+0.05,num2str(k'));
title(app.VirtualElementsUIAxes,"Virtual Elements")
app.VirtualElementsUIAxes.XAxis.Visible = 'off';
app.VirtualElementsUIAxes.YAxis.Visible = 'off';

if app.Params.nTx == 3
    app.PhysicalElementsUIAxes.XLim = [-2,0.25];
    app.VirtualElementsUIAxes.XLim = [-1,0.25];
elseif app.Params.nTx == 2 || app.Params.nTx == 1
    app.PhysicalElementsUIAxes.XLim = [-0.5,0.25];
    app.VirtualElementsUIAxes.XLim = [-0.5,0.25];
end
app.PhysicalElementsUIAxes.YLim = [-5,20];
app.VirtualElementsUIAxes.YLim = [4,13];