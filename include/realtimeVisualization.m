classdef realtimeVisualization < matlab.System
    properties
        app
    end
    
    properties(Access = private)
        figs
        RMA
        BPAMF
        RA
        rangeVsTime
        doppler
        time
        target
        range
        dca
        oscillation
        fcnnEnhance
    end
    
    methods
        function obj = realtimeVisualization(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            appSetup(obj);
            setupDCA1000EVM(obj);
            timeSetup(obj);
            targetSetup(obj);
            
            switch obj.app.imMethod
                case "RMA"
                    rmaSetup(obj);
                case "BPA-MF"
                    BPAMFSetup(obj);
                case "Range Angle"
                    RASetup(obj);
                case "Doppler"
                    dopplerSetup(obj);
                case "Range vs Time"
                    rangeVsTimeSetup(obj);
                case "Range"
                    
                case "Oscillation"
                    oscillationSetup(obj);
                case "RMA-FCNN"
                    rmaSetup(obj);
                    fcnnEnhanceSetup(obj);
            end
            figSetup(obj);
        end
        
        function stepImpl(obj)
            [frame,frame_num] = getFrame(obj);
            
            switch obj.app.imMethod
                case "BPA-MF"
                    BPAMFWork(obj,frame);
                case "RMA"
                    rmaWork(obj,frame);
                case "Range Angle"
                    RAWork(obj,frame);
                case "Doppler"
                    dopplerWork(obj,frame,frame_num);
                case "Range vs Time"
                    rangeVsTimeWork(obj,frame);
                case "Range"
                    rangeWork(obj,frame);
                case "Oscillation"
                    oscillationWork(obj,frame,frame_num);
                case "RMA-FCNN"
                    fcnnEnhanceWork(obj,frame);
            end
        end
        
        function releaseImpl(obj)
            figClose(obj);
            clear mex;
        end
    end
    
    methods (Access = private)
        function setupDCA1000EVM(obj)
            if ~isfield(obj.app.Params,'nIQchan')
                obj.app.Params.nIQchan = 2;
            end
            if ~isfield(obj.app.Params,'bytes')
                obj.app.Params.bytes = 2;
            end
            if ~isfield(obj.app.Params,'nChirps')
                obj.app.Params.nChirps = 1;
            end
            
            k = reshape(obj.app.Params.k,1,[]);
            
            obj.dca.phaseCorrectionFactor = exp(-1j* k .* obj.app.Params.D_m(:,2).^2 / (4*obj.app.Params.z0_mm*1e-3));
            
            obj.dca.BYTES_IN_FRAME = obj.app.Params.adcSample * obj.app.Params.nVx * obj.app.Params.nIQchan * obj.app.Params.bytes * obj.app.Params.nChirps;
            obj.dca.calib = load("calib").calib;
            obj.dca.coeff = obj.dca.calib.ampPhaseBiasCalibration.*exp(1j*obj.app.Params.k.*obj.dca.calib.rangeCorrection_m).*obj.dca.phaseCorrectionFactor;
        end
        
        function [frame_out,frame_num] = getFrame(obj)
            [obj.dca.frame,frame_num] = dca1000evm_MATLAB_interface(obj.dca.BYTES_IN_FRAME);
            
            obj.dca.frame_out = gpuArray(single(typecast(uint8(obj.dca.frame),'uint16'))) - 2^15;
            
            obj.dca.frame_out = reshape(obj.dca.frame_out,2*obj.app.Params.nRx,[]);
            obj.dca.frame_out = complex(obj.dca.frame_out([1,3,5,7],:),obj.dca.frame_out([2,4,6,8],:));
            
            try
                obj.dca.frame_out = reshape(obj.dca.frame_out,obj.app.Params.nRx,obj.app.Params.adcSample,obj.app.Params.nTx);
            catch
                warning("Something is wrong with the number of captures!")
                obj.dca.frame_out = gpuArray(single(zeros(obj.app.Params.nVx,obj.app.Params.adcSample)));
                return;
            end
            
            obj.dca.frame_out = reshape(permute(obj.dca.frame_out,[1,3,2,4]),obj.app.Params.nVx,obj.app.Params.adcSample);
            frame_out = obj.dca.frame_out.*obj.dca.coeff.*hamming(8);
        end
        
        function figSetup(obj)
            % RMA Figure
            switch obj.app.imMethod
                case "RMA"
                    obj.figs.rmaPlot.fig = figure('OuterPosition',[400,400,400,400]);
                    obj.figs.rmaPlot.ax = handle(axes);
                    obj.figs.rmaPlot.surf = handle(surf(NaN(2)));
                    
                    view(obj.figs.rmaPlot.ax,2);
                    
                    obj.figs.rmaPlot.ax.XLabel.String = "Cross Range (m)";
                    obj.figs.rmaPlot.ax.YLabel.String = "Range (m)";
                    obj.figs.rmaPlot.surf.XData = obj.app.p.yT;
                    obj.figs.rmaPlot.surf.YData = obj.app.p.zT;
                case "BPA-MF"
                    obj.figs.bpaPlot.fig = figure('OuterPosition',[400,400,400,400]);
                    obj.figs.bpaPlot.ax = handle(axes);
                    obj.figs.bpaPlot.surf = handle(surf(NaN(2)));
                    
                    view(obj.figs.bpaPlot.ax,2);
                    
                    obj.figs.bpaPlot.ax.XLabel.String = "Cross Range (m)";
                    obj.figs.bpaPlot.ax.YLabel.String = "Range (m)";
                    obj.figs.bpaPlot.surf.XData = obj.app.p.yT;
                    obj.figs.bpaPlot.surf.YData = obj.app.p.zT;
                case "Range Angle"
                    obj.figs.RAPlot.fig = figure('OuterPosition',[400,400,400,400]);
                    obj.figs.RAPlot.ax = handle(axes);
                    obj.figs.RAPlot.surf = handle(surf(NaN(2)));
                    
                    view(obj.figs.RAPlot.ax,2);
                    
                    obj.figs.RAPlot.ax.XLabel.String = "Angle (deg)";
                    obj.figs.RAPlot.ax.YLabel.String = "Range (m)";
                    obj.figs.RAPlot.ax.XLim = [-30,30];
                    obj.figs.RAPlot.surf.XData = obj.RA.angleT;
                    obj.figs.RAPlot.surf.YData = obj.app.p.zT;
                case "Doppler"
                    obj.figs.dopplerPlot.fig = figure('OuterPosition',[400,400,400,400]);
                    obj.figs.dopplerPlot.ax = handle(axes);
                    obj.figs.dopplerPlot.surf = handle(surf(NaN(2)));
                    
                    view(obj.figs.dopplerPlot.ax,2);
                    
                    obj.figs.dopplerPlot.ax.XLabel.String = "Velocity (m/s)";
                    obj.figs.dopplerPlot.ax.YLabel.String = "Range (m)";
                    obj.figs.dopplerPlot.surf.XData = obj.doppler.dopplerT;
                    obj.figs.dopplerPlot.surf.YData = obj.app.p.zT;
                case "Range vs Time"
                    obj.figs.rangeVsTime.fig = figure('OuterPosition',[400,400,400,400]);
                    obj.figs.rangeVsTime.ax = handle(axes);
                    obj.figs.rangeVsTime.surf = handle(surf(NaN(2)));
                    
                    view(obj.figs.rangeVsTime.ax,2);
                    
                    obj.figs.rangeVsTime.ax.XLabel.String = "Time";
                    obj.figs.rangeVsTime.ax.YLabel.String = "Range (m)";
                    obj.figs.rangeVsTime.surf.YData = obj.app.p.zT;
                case "Range"
                    obj.figs.range.fig = figure('OuterPosition',[400,400,400,400]);
                    obj.figs.range.ax = handle(axes);
                    obj.figs.range.plot = handle(plot(NaN));
                    obj.figs.range.ax.XLabel.String = "Range (m)";
                    obj.figs.range.plot.XData = obj.app.p.zT;
                    obj.figs.range.ax.YLim = [-20,5];
                case "Oscillation"
                    obj.figs.oscillation.fig = figure('OuterPosition',[100,400,400,400]);
                    obj.figs.oscillation.ax = handle(axes);
                    obj.figs.oscillation.plot = handle(plot(NaN(size(obj.time.f_oscillation_Hz)),'.'));
                    obj.figs.oscillation.plot.XData = obj.time.f_oscillation_Hz;
                    obj.figs.oscillation.ax.XLabel.String = "Oscillation Freq (Hz)";
                    obj.figs.oscillation.ax.YLim = [0,100];
                    obj.figs.oscillation.ax.XLim = [1,10];
                    obj.figs.oscillation.ax.Title.String = "Oscillation Frequency";
                    
                    obj.figs.AoA_vs_time.fig = figure('OuterPosition',[550,400,400,400]);
                    obj.figs.AoA_vs_time.ax = handle(axes);
                    obj.figs.AoA_vs_time.plot = handle(plot(NaN(size(obj.time.t_slowtime_s)),'.'));
                    obj.figs.AoA_vs_time.ax.XLabel.String = "Time (s)";
                    obj.figs.AoA_vs_time.ax.YLim = [-30,30];
                    obj.figs.AoA_vs_time.ax.Title.String = "AoA vs Time";
                    
                    obj.figs.AoA.fig = figure('OuterPosition',[1000,400,400,400]);
                    obj.figs.AoA.ax = handle(axes);
                    obj.figs.AoA.plot = handle(plot(NaN(size(obj.oscillation.angleAxis))));
                    obj.figs.AoA.ax.XLabel.String = "Angle (deg)";
                    obj.figs.AoA.plot.XData = obj.oscillation.angleAxis;
                    obj.figs.AoA.ax.XLim = [-30,30];
                    obj.figs.AoA.ax.YLim = [0,1];
                    obj.figs.AoA.ax.Title.String = "AoA";
                case "RMA-FCNN"
                    obj.figs.rmaPlot.fig = figure('OuterPosition',[400,400,400,400]);
                    obj.figs.rmaPlot.ax = handle(axes);
                    obj.figs.rmaPlot.surf = handle(surf(NaN(2)));
                    
                    view(obj.figs.rmaPlot.ax,2);
                    
                    obj.figs.rmaPlot.ax.XLabel.String = "Cross Range (m)";
                    obj.figs.rmaPlot.ax.YLabel.String = "Range (m)";
                    obj.figs.rmaPlot.surf.XData = obj.fcnnEnhance.p.yT;
                    obj.figs.rmaPlot.surf.YData = obj.fcnnEnhance.p.zT;
            end
        end
        
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
        
        function fcnnEnhanceSetup(obj)
            obj.fcnnEnhance = load(obj.app.FCNNEditField_2.Value);
        end
        
        function fcnnEnhanceWork(obj,frame)
            % Zeropad echoData to Center
            obj.RMA.echoData = cat(1,obj.RMA.zpad,gpuArray(single(frame)));
            
            % Compute S(kY,k) = FT_y[s(y,k)]: echoDataFFT
            obj.RMA.echoDataFFT = fftshift(fft(conj(obj.RMA.echoData),obj.app.Params.nFFT,1),1);
            
            % Stolt Interpolation P(kY,k) -> P(kY,kZ)
            obj.RMA.sarImageFFT = interpn(obj.RMA.kY,obj.RMA.k,obj.RMA.echoDataFFT,obj.RMA.kYU,obj.RMA.kU,obj.app.Params.Stolt,0);
            
            % Recover the Reflectivity Function p(y,z)
            obj.RMA.sarImageFull = ifft2(obj.RMA.sarImageFFT);
            
            obj.RMA.sarImage = obj.RMA.sarImageFull(obj.RMA.indY,obj.RMA.indZ);
            
            % Crop and Resize Image
            obj.RMA.sarImage64x64 = imresize(abs(obj.RMA.sarImage),[obj.fcnnEnhance.p.yLim,obj.fcnnEnhance.p.zLim]);
            
            % Get 64x64 enhanced image
            obj.fcnnEnhance.filter64x64 = predict(obj.fcnnEnhance.fcnnNet,obj.RMA.sarImage64x64);
            
            % Show the Image
            obj.figs.rmaPlot.surf.ZData = gather(obj.fcnnEnhance.filter64x64)';
        end
        
        function rmaSetup(obj)
            obj.RMA.k = gpuArray(single(reshape(obj.app.Params.k,1,[])));
            obj.RMA.zpad = gpuArray(single(zeros((obj.app.Params.nFFT-obj.app.Params.nVx)/2,obj.app.Params.adcSample)));
            kSy = 2*pi/(obj.app.Params.yStepV_mm*1e-3);
            obj.RMA.kY = gpuArray(single(reshape(linspace(-kSy/2,kSy/2,obj.app.Params.nFFT),[],1)));
            
            obj.RMA.kZU = reshape(linspace(0,2*max(obj.RMA.k),obj.app.Params.nFFT),1,[]);
            obj.RMA.kU = gpuArray(single(1/2 * sqrt(obj.RMA.kY.^2 + obj.RMA.kZU.^2)));
            
            obj.RMA.kYU = repmat(obj.RMA.kY,[1,obj.app.Params.nFFT]);
            
            obj.RMA.yRangeRMA_crop_m = single(gather(obj.app.Params.yStepV_mm*1e-3 * (-(obj.app.Params.nFFT-1)/2 : (obj.app.Params.nFFT-1)/2)));
            obj.RMA.zRangeRMA_crop_m = single(gather((1:obj.app.Params.nFFT)*(2*pi/(mean(diff(obj.RMA.kZU))*length(obj.RMA.kZU)))));
            
            obj.RMA.indY = obj.RMA.yRangeRMA_crop_m >= (obj.app.p.yT(1)) & obj.RMA.yRangeRMA_crop_m <= (obj.app.p.yT(end));
            obj.RMA.indZ = obj.RMA.zRangeRMA_crop_m >= (obj.app.p.zT(1)) & obj.RMA.zRangeRMA_crop_m <= (obj.app.p.zT(end));
            
            obj.RMA.indY_offset = find(obj.RMA.indY == 1,1) - 1;
            obj.RMA.indZ_offset = find(obj.RMA.indZ == 1,1) - 1;
            
            obj.RMA.yT = obj.RMA.yRangeRMA_crop_m(obj.RMA.indY);
            obj.RMA.zT = obj.RMA.zRangeRMA_crop_m(obj.RMA.indZ);
            
            obj.RMA.yLim = length(obj.RMA.yT);
            obj.RMA.zLim = length(obj.RMA.zT);
            
            obj.RMA.sarImage = zeros(obj.RMA.yLim,obj.RMA.zLim);
            obj.RMA.sarImage64x64 = zeros(obj.app.p.yLim,obj.app.p.zLim);
        end
        
        function rmaWork(obj,frame)
            % Zeropad echoData to Center
            obj.RMA.echoData = cat(1,obj.RMA.zpad,gpuArray(single(frame)));
            
            % Compute S(kY,k) = FT_y[s(y,k)]: echoDataFFT
            obj.RMA.echoDataFFT = fftshift(fft(conj(obj.RMA.echoData),obj.app.Params.nFFT,1),1);
            
            % Stolt Interpolation P(kY,k) -> P(kY,kZ)
            obj.RMA.sarImageFFT = interpn(obj.RMA.kY,obj.RMA.k,obj.RMA.echoDataFFT,obj.RMA.kYU,obj.RMA.kU,obj.app.Params.Stolt,0);
            
            % Recover the Reflectivity Function p(y,z)
            obj.RMA.sarImageFull = ifft2(obj.RMA.sarImageFFT);
            
            obj.RMA.sarImage = obj.RMA.sarImageFull(obj.RMA.indY,obj.RMA.indZ);
            
            % Crop and Resize Image
            obj.RMA.sarImage64x64 = imresize(abs(obj.RMA.sarImage),[obj.app.p.yLim,obj.app.p.zLim]);
            
            % Show the Image
            obj.figs.rmaPlot.surf.ZData = gather(obj.RMA.sarImage64x64)';
            [~,obj.RMA.maxInd] = max(obj.RMA.sarImage64x64(:));
            [obj.RMA.indYMax,obj.RMA.indZMax] = ind2sub([obj.app.p.yLim,obj.app.p.zLim],obj.RMA.maxInd);
            obj.figs.rmaPlot.ax.Title.String = "RMA y=" + round(obj.app.p.yT(obj.RMA.indYMax),3) + ", z=" + round(obj.app.p.zT(obj.RMA.indZMax),3);
        end
        
        function BPAMFSetup(obj)
            obj.BPAMF.k = gpuArray(single(reshape(obj.app.Params.k,1,[])));
            obj.BPAMF.yRange_m = (1:obj.app.Params.nFFT)*obj.app.Params.yStepV_mm*1e-3;
            obj.BPAMF.yRange_m = obj.BPAMF.yRange_m - mean(obj.BPAMF.yRange_m);
            obj.BPAMF.yRange_m = gpuArray(single(reshape(obj.BPAMF.yRange_m,[],1)));
            obj.BPAMF.zRange_m = gpuArray(single(reshape(obj.app.p.zT,1,1,[])));
            
            obj.BPAMF.yRange_crop_m = reshape(obj.BPAMF.yRange_m,[],1) + obj.app.Params.yStepV_mm*1e-3;
            obj.BPAMF.zRange_crop_m = reshape(obj.BPAMF.zRange_m,1,[]);
            
            obj.BPAMF.indY = obj.BPAMF.yRange_crop_m >= (obj.app.p.yT(1)) & obj.BPAMF.yRange_crop_m <= (obj.app.p.yT(end));
            obj.BPAMF.indZ = obj.BPAMF.zRange_crop_m >= (obj.app.p.zT(1)) & obj.BPAMF.zRange_crop_m <= (obj.app.p.zT(end));
            
            if obj.BPAMF.yRange_crop_m(end) < obj.app.p.yT(end)
                warning("p.yT needs to be changed! Making changes...");
                pause(1);
                obj.app.p.yT = linspace(-obj.BPAMF.yRange_crop_m(1)+(obj.BPAMF.yRange_crop_m(end)-obj.BPAMF.yRange_crop_m(1))*obj.app.p.yLim,obj.BPAMF.yRange_crop_m(end),obj.app.p.yLim);
                updatepFields(obj.app);
                updateAll(obj.app);
            end
            
            if obj.BPAMF.zRange_crop_m(end) < obj.app.p.zT(end)
                warning("p.zT needs to be changed! Making changes...");
                pause(1);
                obj.app.p.zT = linspace(obj.app.p.zOffset + (obj.BPAMF.zRange_crop_m(end) - obj.app.p.zOffset)/obj.app.p.zLim,obj.BPAMF.zRange_crop_m(end),obj.app.p.zLim);
                updatepFields(obj.app);
                updateAll(obj.app);
            end
            
            convKernel = (obj.BPAMF.yRange_m.^2 + obj.BPAMF.zRange_m.^2).*exp(-1j*2*obj.BPAMF.k.*sqrt(obj.BPAMF.yRange_m.^2 + obj.BPAMF.zRange_m.^2));
            
            if obj.app.Params.nFFT < numel(obj.BPAMF.yRange_m)
                obj.app.Params.nFFT = 2^(ceil(log2(numel(obj.BPAMF.yRange_m))));
            end
            
            convKernelPadded = padarray(convKernel,[floor((obj.app.Params.nFFT-size(convKernel,1))/2) 0],0,'pre');
            
            obj.BPAMF.convKernelFFT = fft(convKernelPadded,obj.app.Params.nFFT,1);
        end
        
        function BPAMFWork(obj,frame)
            % Zeropad frame
            obj.BPAMF.framePadded = gpuArray(single(frame));
            obj.BPAMF.framePadded = padarray(obj.BPAMF.framePadded,[floor((obj.app.Params.nFFT-size(frame,1))/2) 0],0,'pre');
            
            % Take an FFT across the x dimension of the echoData and convKernel
            obj.BPAMF.frameFFT = fft(obj.BPAMF.framePadded,obj.app.Params.nFFT,1);
            
            % Reconstruct Image
            obj.BPAMF.sarImage = abs(squeeze(ifftshift(ifft( sum(obj.BPAMF.frameFFT .* obj.BPAMF.convKernelFFT,2),obj.app.Params.nFFT,1),1)));
            
            % Crop and Resize Image
            obj.BPAMF.sarImage64x64 = imresize(obj.BPAMF.sarImage(obj.BPAMF.indY,obj.BPAMF.indZ),[obj.app.p.yLim,obj.app.p.zLim]);
            
            % Show the BPA-MF Image
            obj.figs.bpaPlot.surf.ZData = gather(obj.BPAMF.sarImage64x64)';
        end
        
        function RASetup(obj)
            c = physconst('lightspeed');
            rangeIdxToMeters = c * obj.app.Params.fS / (2 * obj.app.Params.K * obj.app.Params.adcSample);
            obj.app.Params.rangeAxis = linspace(0, (obj.app.Params.adcSample-1) * rangeIdxToMeters, obj.app.Params.nFFT);
            
            obj.RA.zpad = gpuArray(single(zeros((obj.app.Params.nFFT-obj.app.Params.nVx)/2,obj.app.Params.adcSample)));
            
            obj.RA.zRange_crop_m = obj.app.Params.rangeAxis;
            obj.RA.indZ = obj.RA.zRange_crop_m >= (obj.app.p.zT(1)) & obj.RA.zRange_crop_m <= (obj.app.p.zT(end));
            obj.RA.indZ_offset = find(obj.RA.indZ==1,1) - 1;
            
            if obj.RA.zRange_crop_m(end) < obj.app.p.zT(end)
                warning("p.zT needs to be changed! Making changes...");
                pause(1);
                obj.app.p.zT = linspace(obj.app.p.zOffset + (obj.RA.zRange_crop_m(end) - obj.app.p.zOffset)/obj.app.p.zLim,obj.RA.zRange_crop_m(end),obj.app.p.zLim);
                updatepFields(obj.app);
                updateAll(obj.app);
            end
            
            obj.RA.angleT = -asind(linspace(-1,1,obj.app.p.yLim));
        end
        
        function RAWork(obj,frame)
            obj.RA.frame = cat(1,obj.RA.zpad,gpuArray(single(frame)));
            obj.RA.rangeAngle = abs(fftshift(fft2(obj.RA.frame,obj.app.Params.nFFT,obj.app.Params.nFFT),1))/(obj.app.Params.nFFT^2);
            obj.RA.rangeAngle64x64 = imresize(obj.RA.rangeAngle(:,obj.RA.indZ),[obj.app.p.yLim,obj.app.p.zLim]);
            obj.RA.rangeAngle64x64 = obj.RA.rangeAngle64x64/max(obj.RA.rangeAngle64x64(:))*max(obj.RA.rangeAngle(:));
            
            % Show the Range Angle Image
            obj.figs.RAPlot.surf.ZData = (gather(obj.RA.rangeAngle64x64))';
        end
        
        function dopplerSetup(obj)
            c = physconst('lightspeed');
            fc = 79e9;
            lambda = c/fc;
            obj.doppler.dopplerCoefficient = lambda/(4*pi*obj.app.Params.framePeriodicity_ms*1e-3);
            
            obj.doppler.numFramesInCircularBuffer = 32;
            obj.doppler.circularBuffer = gpuArray(single(zeros(obj.doppler.numFramesInCircularBuffer,sum(obj.app.p.indZ))));
            
            obj.doppler.dopplerT = linspace(-obj.app.Params.lambda_mm*1e-3/(4*obj.time.pri_s),obj.app.Params.lambda_mm*1e-3/(4*obj.time.pri_s),obj.app.p.yLim);
            obj.doppler.t_slowtime_s = zeros(1,obj.doppler.numFramesInCircularBuffer);
        end
        
        function dopplerWork(obj,frame,frame_num)
            % perform doppler fft across multiple frames
            obj.doppler.rangeData = fft(mean(frame,1),obj.app.Params.nFFT,2);
            
            obj.doppler.circularBuffer(1:end-1,:) = obj.doppler.circularBuffer(2:end,:);
            obj.doppler.circularBuffer(end,:) = obj.doppler.rangeData(obj.app.p.indZ);
            obj.doppler.t_slowtime_s(1:end-1) = obj.doppler.t_slowtime_s(2:end);
            obj.doppler.t_slowtime_s(end) = double(frame_num) * obj.app.Params.framePeriodicity_ms*1e-3;
            
            % Doppler NUFFT
            obj.doppler.rangeDoppler = abs(nufft(gather(single(obj.doppler.circularBuffer)),obj.doppler.t_slowtime_s,obj.time.f_doppler,1));
            obj.doppler.rangeDoppler64x64 = imresize(obj.doppler.rangeDoppler,[obj.app.p.yLim,obj.app.p.zLim]);
            
            % Show the Range Doppler Image
            obj.figs.dopplerPlot.surf.ZData = mag2db(gather(obj.doppler.rangeDoppler64x64))';
        end
        
        function rangeVsTimeSetup(obj)
            obj.rangeVsTime.numFramesInCircularBuffer = 16;
            obj.rangeVsTime.circularBuffer = gpuArray(single(zeros(obj.rangeVsTime.numFramesInCircularBuffer,sum(obj.app.p.indZ))));
        end
        
        function rangeVsTimeWork(obj,frame)
            obj.rangeVsTime.circularBuffer(1:end-1,:) = obj.rangeVsTime.circularBuffer(2:end,:);
            
            obj.rangeVsTime.rangeData = abs(fft(mean(frame,1),obj.app.Params.nFFT,2));
            obj.rangeVsTime.rangeDataCrop = obj.rangeVsTime.rangeData(obj.app.p.indZ);
            
            obj.rangeVsTime.circularBuffer(end,:) = obj.rangeVsTime.rangeDataCrop;
            
            obj.rangeVsTime.sarImage64x64 = imresize(obj.rangeVsTime.circularBuffer,[obj.app.p.yLim,obj.app.p.zLim]);
            
            % Show Range vs Time Plot
            obj.figs.rangeVsTime.surf.ZData = mag2db(gather(obj.rangeVsTime.sarImage64x64))';
        end
        
        function timeSetup(obj)
            obj.time.numFrames = 32;
            obj.time.t_slowtime_s = zeros(obj.time.numFrames,1);
            
            obj.time.f_oscillation_Hz = [4,6,8];%1:30; % Frequencies of interest (Hz)
            
            obj.time.pri_s = obj.app.Params.framePeriodicity_ms*1e-3;
            obj.time.prf_Hz = 1/obj.time.pri_s;
            
            obj.time.f_doppler = -obj.time.prf_Hz/2:obj.time.prf_Hz/obj.app.Params.nFFT:obj.time.prf_Hz/2-obj.time.prf_Hz/obj.app.Params.nFFT;
        end
        
        function targetSetup(obj)
            obj.target.AoA_vs_time = zeros(obj.time.numFrames,1);
            obj.target.zRangeVsTime = zeros(obj.time.numFrames,1);
            obj.target.rangeT = obj.app.Params.rangeAxis(obj.app.p.indZ);
        end
        
        function oscillationSetup(obj)
            obj.oscillation.angleAxis = atand(linspace(-1,1,obj.app.Params.nFFT));
            obj.oscillation.detectBuffer = zeros(1,4);
        end
        
        function oscillationWork(obj,frame,frame_num)
            % Get Doppler data from the range peaks
            obj.time.t_slowtime_s(1:end-1) = obj.time.t_slowtime_s(2:end);
            obj.target.AoA_vs_time(1:end-1) = obj.target.AoA_vs_time(2:end);
            obj.target.zRangeVsTime(1:end-1) = obj.target.zRangeVsTime(2:end);
            obj.oscillation.detectBuffer(1:end-1) = obj.oscillation.detectBuffer(2:end);
            obj.time.t_slowtime_s(end) = double(frame_num) * obj.app.Params.framePeriodicity_ms*1e-3;
            
            obj.oscillation.rangeData = fft(frame,obj.app.Params.nFFT,2);
            obj.oscillation.rangeDataCrop = obj.oscillation.rangeData(:,obj.app.p.indZ);
            
            obj.oscillation.peakValue = max(abs(obj.oscillation.rangeDataCrop));
            
            if obj.oscillation.peakValue > 0.35
                obj.oscillation.detectBuffer(end) = 1;
            else
                obj.oscillation.detectBuffer(end) = 0;
            end
            
            obj.oscillation.isHand = max(obj.oscillation.detectBuffer);
            
            if ~obj.oscillation.isHand
                % No target detected!
                % Update the stored data with the newest data
                obj.target.AoA_vs_time(end) = 0;
                obj.target.zRangeVsTime(end) = obj.target.zRangeVsTime(end-1);
                obj.app.mmWaveStudioTextArea.Value = "NO HAND!";
                return;
            end
            
            % Target is detected and hand is open!
            
            % Find the target range
            obj.target.rangeDataMean = mean(obj.oscillation.rangeDataCrop*10/obj.app.Params.nFFT,1);
            [~,obj.target.indRange] = max(obj.target.rangeDataMean);
            obj.target.zRange = obj.target.rangeT(obj.target.indRange);
            
            % Find the target angle
            angle_data = fftshift(fft(obj.oscillation.rangeDataCrop(:,obj.target.indRange),obj.app.Params.nFFT,1),1);
            [~,obj.target.indAngle] = max(angle_data);
            obj.target.angle = obj.oscillation.angleAxis(obj.target.indAngle);
            
            % Update the stored data with the newest data
            obj.target.AoA_vs_time(end) = obj.target.angle;
            obj.target.zRangeVsTime(end) = obj.target.zRange;
            
            % Get the oscillation frequency domain
            % Plain NUFFT (Best?)
            oscillationFreq = abs(nufft(obj.target.AoA_vs_time - mean(obj.target.AoA_vs_time),obj.time.t_slowtime_s,obj.time.f_oscillation_Hz));
            obj.target.AoA_vs_time_smoothed = obj.target.AoA_vs_time;
            % Print results in app
            obj.app.mmWaveStudioTextArea.Value = ("TARGET AT Z = " + obj.target.zRange + " AoA = " + obj.target.angle);
            
            % Update the real time AoA plot
            obj.figs.AoA.plot.YData = gather(abs(angle_data./max(angle_data(:))));
            
            % Update the AoA vs Time plot
            obj.figs.AoA_vs_time.plot.YData = obj.target.AoA_vs_time_smoothed;%obj.target.AoA_vs_time;
            
            % Update the AoA oscillation frequency plot
            obj.figs.oscillation.plot.YData = oscillationFreq;
        end
        
        function rangeWork(obj,frame)
            obj.range.rangeData = abs(fft(mean(frame,1),obj.app.Params.nFFT,2))*10/obj.app.Params.nFFT;
            obj.range.rangeDataCrop = mean(obj.range.rangeData(:,obj.app.p.indZ),1);
            obj.range.rangeData64 = imresize(obj.range.rangeDataCrop,[1,obj.app.p.zLim]);
            
            % Show the Range Plot
            obj.figs.range.plot.YData = mag2db(gather(obj.range.rangeData64));
        end
        
        function appSetup(obj)
            c = physconst('lightspeed');
            rangeIdxToMeters = c * obj.app.Params.fS / (2 * obj.app.Params.K * obj.app.Params.adcSample);
            obj.app.Params.rangeAxis = linspace(0, (obj.app.Params.adcSample-1) * rangeIdxToMeters, obj.app.Params.nFFT);
            obj.app.p.indZ = obj.app.Params.rangeAxis >= (obj.app.p.zT(1)) & obj.app.Params.rangeAxis <= (obj.app.p.zT(end));
            obj.app.p.indZ_offset = find(obj.app.p.indZ == 1,1) - 1;
            
            obj.app.Params.Stolt = 'linear';
        end
    end
end
