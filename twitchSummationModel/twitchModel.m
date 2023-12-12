classdef twitchModel < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        rate
        center
    end
    
    methods
        function obj = twitchModel(rate,center)
            obj.rate = rate;
            obj.center = center;
        end
        
        function twitch = twitchCalc(obj,x)
            %% Define twitch function
            % twitch = exp(-1.*(obj.rate.*sqrt((x-obj.center).^2)).^2).*heaviside(x-0.001).*heaviside(x+5*x0);
            twitch = exp(-1.*(obj.rate.*sqrt((x-obj.center).^2)).^2).*heaviside(x-0.001);
        end
    end
end