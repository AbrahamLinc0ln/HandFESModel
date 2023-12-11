%% Twitch Model
% Marshall Trout
% Dec 10, 2023
% Models Grip Forces evoked by Noninvasive Functional Electrical Stimulation

%% Setup
clc
clear
%% Define twitch function
twitch_model = @(rate,x,x0) exp(-1.*(rate.*sqrt((x-x0).^2)).^2).*heaviside(x-0.001).*heaviside(x+5*x0);
%% Visualize normalized twitch
x = -1:.001:1;% time
twitch_eps = 20; % steepness
twitch_center = 0.2; %time of peak in s
y = twitch_model(twitch_eps,x,twitch_center);

plot(x,y)

%% torque-amplitude relationship
% peak_force = @(a,b,c,amp) (a./(1 + exp(-1.*b.*(amp - c)))-a./(1 + exp(-1.*b.*c))).*heaviside(amp);
peak_force = @(a,b,c,amp) (a./(1 + exp(-1.*b.*(amp - c)))).*heaviside(amp-0.001); % This works better? though the other equation is from the paper

%% Visualize force amplitude curve
x = -1:.1:10; %amplitude in mA
y = peak_force(5,1,7,x);

plot(x,y)

%% Define torque summation
% stimulation parameters
f_stim = 20;
t_stim = 1/f_stim;
amp = 5.7;

% Modeling parameters
f_smpl = 1000;
t_smpl = 1/f_smpl;
time_vec = -1:t_smpl:5;
M = 1000; % memory window in samples
M_time = M*t_smpl;

twitch_times = time_vec(1).*ones(1,ceil(M_time*f_stim));
stim_amp = zeros(1,ceil(M_time*f_stim));
twitch_indx = 1;
amp_indx = 1;
summed_force = zeros(size(time_vec));

for kk = 1:length(time_vec)
    
    % record when stim occurs, add to vector with max length of 30 by
    % shifting out old values
    if (time_vec(kk)-twitch_times(end)) > t_stim
        
         % dont start stim before 0
        if time_vec(kk)<0
            stim_amp = circshift(stim_amp, -1);
            stim_amp(end) = 0;
        else
            stim_amp = circshift(stim_amp, -1);
            stim_amp(end) = amp;
        end
        
        twitch_times = circshift(twitch_times, -1);
        twitch_times(end) = time_vec(kk);
    end
    
    % lookup force for a given amplitude
    twitch_peaks = peak_force(5,1,7,stim_amp);
    
    % sum forces
    summed_force(kk) = sum(twitch_peaks.*twitch_model(twitch_eps,time_vec(kk)-twitch_times,twitch_center));
end


plot(time_vec,summed_force);
