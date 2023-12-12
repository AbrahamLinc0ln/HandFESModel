%% Twitch Model
% Marshall Trout
% Dec 10, 2023
% Models Grip Forces evoked by Noninvasive Functional Electrical Stimulation

%% Setup
clc
clear
close all

%% Setup Models
% twitch model
twitch_rate = 20; % steepness
twitch_center = 0.2; %time of peak in s
tm = twitchModel(twitch_rate,twitch_center);

% force amplitude model
f_max = 5;
rate = 1;
center = 7;
fam = FAModel(f_max,rate,center);

% summation model
f_stim = 10;
t_stim = 1/f_stim;
tsm = twitchSummationModel(tm,fam);
tsm.updateStimFreq(f_stim);

%% Visualize normalized twitch
x = -1:.001:1;% time
y = tm.twitchCalc(x);

figure()
hold on
plot(x,y)
xlabel('Time (s)');
ylabel('Normalized Force');
hold off


%% Visualize force amplitude curve
x = -1:.1:10; %amplitude in mA
y = fam.forceCalc(x);

figure()
hold on
plot(x,y)
xlabel('Amplitude (mA)');
ylabel('F (N)');
hold off

%% Define torque summation
% stimulation parameters
amp = 5.7;
amp_freq = 1;

% Simulation vars
f_smpl = 1000;
t_smpl = 1/f_smpl;
time_vec = -1:t_smpl:5;
prev_stim = time_vec(1);

%%% DEFINE AMPLITUDE HERE
amp_vec = amp*(sin(2*pi*amp_freq.*time_vec)+1).*heaviside(time_vec);

summed_force = zeros(size(time_vec));

for kk = 1:length(time_vec)
    
    if (time_vec(kk)-prev_stim) > t_stim
        prev_stim = time_vec(kk);
        
        tsm.newStim(time_vec(kk), amp_vec(kk));
    end
    
    summed_force(kk) = tsm.twitchSum(time_vec(kk));
end

figure()
plt = tiledlayout(2,1);
ax1 = nexttile;
plot(time_vec,summed_force);
ylabel('Force (N)');
ax2 = nexttile;
plot(time_vec,amp_vec);
ylabel('Current (mA)');
xlabel('Time (s)');
linkaxes([ax1 ax2],'x');

