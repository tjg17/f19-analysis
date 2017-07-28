%% split_fit.m
% Tyler Glass
% Code computes time constants and washin/washout dynamics for f19 MRI
% Splits fitting into separate Washout and Washout Components

%% Initialize Workspace
clear; clc; close all
home = pwd;
addpath('./functions') % Add path for f19 processing functions
addpath('G:\2017-Glass\mim\f19_MATLAB_workspaces') % add path for f19 data

%% Data for First and Last PFP Times
patientNumbers = [ 3; 4; 5; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20];
first_PFP      = [ 1; 2; 2; 1; 2; 2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2];
last_PFP       = [ 5; 7; 7; 7; 7; 6;  6;  6;  7;  6;  5;  7;  6;  6;  7;  6;  6]; % updated 7/27/17

%% Select Patients for Experiment to Run
ExperimentName  = 'Experiment13';
FigureDirectory    = strcat('../../f19_fit_results/',ExperimentName,'/figures/');    mkdir(FigureDirectory);
ParameterDirectory = strcat('../../f19_fit_results/',ExperimentName,'/parameters/'); mkdir(ParameterDirectory);

patientNumbers  = [ 3; 4; 5; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20];
first_PFP       = [ 1; 2; 2; 1; 2; 2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2];
last_PFP        = [ 5; 7; 7; 7; 7; 6;  6;  6;  7;  6;  5;  7;  6;  6;  7;  6;  6]; 

Control = [ 3; 4; 5; 11; 15; 16; 17];
Exper   = [ 7; 8; 9; 10; 12; 13; 14; 18]; % not sure on 19,20

%% Loop Through all F19 Patients
tic
for i=1:length(patientNumbers)
    % Load Patient Data
    filename = strcat('0509-',num2str(patientNumbers(i),'%03d'),'.mat');
    load(filename);
    fprintf('\n\n\nStarting Patient %03d', patientNumbers(i))
    
    % Process Normal Fit
    %[tau1_normal , tau2_normal , r2_normal , mask ] = NormalFitProcess( image , roi , scantimes , last_PFP(i) );
    
    % Process Split Fit
    %[ dF , tau1 , r2_Washin , d0 , tau2 , r2_Washout ] =  SplitFitProcess( image , roi , scantimes , first_PFP(i), last_PFP(i) );
    
    % Plot Results
    %PlotSplitFitResultsv2( patientNumbers(i), FigureDirectory, tau1, tau2, dF, d0, r2_Washin, r2_Washout, mask )
    
    % Save Parameters
    %SaveFitParameterData(patientNumbers(i), ParameterDirectory, tau1, tau2, dF, d0)
    VentilationVolumeLiters(i,1) = patientNumbers(i);
    Mask = imresize(roi,[64,64]);
    VentilationVolumeLiters(i,2) = sum(Mask(:))*6.25*6.25*15/1e6;
    
end
toc
VentilationVolumeLiters
mean(VentilationVolumeLiters(:,2))
