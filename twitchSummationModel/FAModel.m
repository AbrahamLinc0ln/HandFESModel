classdef FAModel < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        f_max
        rate
        center
    end
    
    methods
        function obj = FAModel(f_max,rate,center)
            obj.f_max = f_max;
            obj.rate = rate;
            obj.center = center;
        end
        
        function force = forceCalc(obj,amp)
            %% torque-amplitude relationship
            % force = (obj.f_max./(1 + exp(-1.*obj.rate.*(amp - obj.center)))).*heaviside(amp);
            force = (obj.f_max./(1 + exp(-1.*obj.rate.*(amp - obj.center)))).*heaviside(amp-0.001); % This works better? though the other equation is from the paper
        end
    end
end

