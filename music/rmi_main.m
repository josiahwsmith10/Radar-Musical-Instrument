classdef rmi_main < matlab.System
    properties
        app
        detect
        fcnnEnhance
        target
        time
        figs
        music
        RMA
        dca
        doppler
        midi
    end
    
    methods
        function obj = rmi_main(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end
    
    methods(Access = protected)
        function setupImpl(obj)
            appSetup(obj);
            disp("appSetup() done")
            ParamsSetup(obj);
            disp("ParamsSetup() done")
            setupDCA1000EVM(obj);
            disp("setupDCA1000EVM() done")
            timeSetup(obj);
            disp("timeSetup() done")
            musicSetup(obj);
            disp("musicSetup() done")
            MIDISetup(obj);
            disp("MIDISetup() done")
            dopplerSetup(obj)
            disp("dopplerSetup() done")
            rmaSetup(obj);
            disp("rmaSetup() done")
            fcnnEnhanceSetup(obj);
            disp("fcnnEnhanceSetup() done")
            classical_detectSetup(obj);
            disp("classical_detectSetup() done")
            targetSetup(obj);
            disp("targetSetup() done")
            figSetup(obj);
            disp("figSetup() done")
        end
        
        function stepImpl(obj)
            [frame,frame_num] = getFrame(obj);
            
            if obj.app.isDeepLearning
                dl_instrument(obj,frame,frame_num);
            else
                classical_instrument(obj,frame,frame_num);
            end
        end
        
        function releaseImpl(obj)
            stopMIDI(obj);
            figClose(obj);
            clear mex;
        end
    end
end
