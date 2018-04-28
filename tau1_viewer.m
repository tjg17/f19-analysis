%% tau_washing_washout.m
% Tyler Glass
% Code for generating tau1 and tau2 parameters for f19

%% Initialize Workspace
clear; clc; close all
home = pwd;
addpath('./functions') % Add path for f19 processing functions
addpath('G:\2017-Glass\mim\f19_ventilation_segmentations') % add path for f19 data

%% Data for First and Last PFP Times
first_last_PFP_data = load('first_last_PFP.txt');
patientNumbers = first_last_PFP_data(1,:);
first_PFP = first_last_PFP_data(2,:);
last_PFP = first_last_PFP_data(3,:);

%% Select Patients for Experiment to Run
ExperimentName  = 'd0_fitted';
FigureDirectory    = strcat('../../f19_fit_results/',ExperimentName,'/figures/');    mkdir(FigureDirectory);
ParameterDirectory = strcat('../../f19_fit_results/',ExperimentName,'/parameters/'); mkdir(ParameterDirectory);

%% Loop Through all F19 Patients
tic
for i=26;
    % Load Patient Data
    filename = strcat('0509-',num2str(patientNumbers(i),'%03d'),'.mat');
    load(filename);
    fprintf('\n\n\nStarting Patient %03d', patientNumbers(i))
    
    % Process Normal Fit
    %[tau1_normal , tau2_normal , r2_normal , mask ] = NormalFitProcess( image , roi , scantimes , last_PFP(i) );
    
    % Process Split Fit
    [ dF , tau1 , r2_Washin , d0 , tau2 , r2_Washout ] =  SplitFitProcess( image , roi , scantimes , first_PFP(i), last_PFP(i) );
    
    % Get mask variable
    [ means , mask ] = ComputePixelAverageIn3DROI( image, roi );
    
    % Plot Results
    PlotSplitFitResultsv2( patientNumbers(i), FigureDirectory, tau1, tau2, dF, d0, r2_Washin, r2_Washout, mask )
    
    % Save Parameters
    SaveFitParameterData(patientNumbers(i), ParameterDirectory, tau1, tau2, dF, d0)
    
    % Get VV to confirm patient data
    VentilationVolumeLiters(i,1) = patientNumbers(i);
    Mask = imresize(roi,[64,64]);
    VentilationVolumeLiters(i,2) = sum(Mask(:))*6.25*6.25*15/1e6;
    
end
toc