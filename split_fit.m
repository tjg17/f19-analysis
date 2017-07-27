%% split_fit.m
% Tyler Glass
% Code computes time constants and washin/washout dynamics for f19 MRI
% Splits fitting into separate Washout and Washout Components

%% Initialize Workspace
clear; clc; close all
home = pwd;
addpath('./functions') % Add path for f19 processing functions
addpath('G:\2017-Glass\mim\f19_MATLAB_workspaces') % add path for f19 data

%% LDefine Patients and Last PFP Times
patientNumbers = [ 3; 4; 5; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20];
first_PFP      = [ 1; 2; 2; 1; 2; 2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2];
last_PFP       = [ 5; 7; 7; 7; 7; 6;  6;  6;  7;  6;  5;  7;  6;  6;  7;  6;  6]; % updated 7/27/17

%% Loop Through all F19 Patients
tic
for i=1:length(patientNumbers)
    % Load Patient Data
    filename = strcat('0509-',num2str(patientNumbers(i),'%03d'),'.mat');
    load(filename);
    fprintf('\n\n\nStarting Patient %03d', patientNumbers(i))
    
    % Process Normal Fit
    [tau1_normal , tau2_normal , r2_normal , mask ] = NormalFitProcess( image , roi , scantimes , last_PFP(i) );
    
    % Process Split Fit
    [ df_map , tau1_split , r2_Washin_map , d0_map , tau2_split , r2_Washout_map ] =  SplitFitProcess( image , roi , scantimes , first_PFP(i), last_PFP(i) );
    
    % Plot Results
    PlotSplitFitResults( patientNumbers(i), tau1_normal, tau1_split, tau2_normal, tau2_split, r2_normal, r2_Washin_map, mask )
    
end
toc
