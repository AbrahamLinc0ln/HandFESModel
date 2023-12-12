classdef twitchSummationModel < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Models
        fa_model
        twitch_model
        
        % Modeling parameters
        f_smpl
        t_smpl
        M
        M_time
        
        % stim params
        twitch_times
        stim_amp
        f_stim;
    end
    
    methods
        function obj = twitchSummationModel(twitch_model,fa_model)
            obj.fa_model = fa_model;
            obj.twitch_model = twitch_model;
            
            % Modeling parameters
            obj.f_smpl = 1000;
            obj.t_smpl = 1/obj.f_smpl;
            obj.M = 1000; % memory window in samples
            obj.M_time = obj.M*obj.t_smpl;
            obj.f_stim = 30; % assuming stim freq of 30 Hz
            
            % Stim parameters
            obj.twitch_times = ones(1,ceil(obj.M_time*obj.f_stim));
            obj.stim_amp = zeros(1,ceil(obj.M_time*obj.f_stim));
        end
        
        function force = twitchSum(obj,curr_time)
            %% lookup force for a given amplitude
            twitch_peaks = obj.fa_model.forceCalc(obj.stim_amp);
            %% sum forces
            force = sum(twitch_peaks.*obj.twitch_model.twitchCalc(curr_time-obj.twitch_times));
        end
        
        function newStim(obj,curr_time,amp)
            %% update stim times
            obj.twitch_times = circshift(obj.twitch_times, -1);
            obj.twitch_times(end) = curr_time;
            %% sum forces
            obj.stim_amp = circshift(obj.stim_amp, -1);
            obj.stim_amp(end) = amp;
        end
        
        function updateStimFreq(obj,f_stim)
            obj.f_stim = f_stim;
            
            % Stim parameters
            obj.twitch_times = ones(1,ceil(obj.M_time*obj.f_stim));
            obj.stim_amp = zeros(1,ceil(obj.M_time*obj.f_stim));
        end
        
        function clearHist(obj)
            % Stim parameters
            obj.twitch_times = ones(1,ceil(obj.M_time*obj.f_stim));
            obj.stim_amp = zeros(1,ceil(obj.M_time*obj.f_stim));
        end
    end
end