function [ tot_elap_time, t ] = elapsedtime_vector( times, nscans )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Make X-Axis acquisition time
% times2 = floor(times);
% time_string = num2str(times2(:,1),6);
time_string = num2str(times(:,1),6);
%% For morning scan only!!!! Need to fix!
% zs = num2str(zeros(nscans, 1));
% 
% time_string = strcat(zs, time_string);
%% 
t = datetime(time_string, 'InputFormat', 'HHmmss', 'Format', 'HH:mm:ss');

for i = 1: nscans
    elapsed_t(i,1) = t(i)-t(1);
end

tot_elap_time = seconds(elapsed_t); %TIME VECTOR!!!


end

