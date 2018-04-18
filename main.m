%% main.m
% Tyler Glass
% Code for running f19 fit experiments

%% Initialize Workspace
clear; clc; close all
home = pwd;
addpath('./functions') % Add path for f19 processing functions

%% Get Data for First and Last PFP Times
first_last_PFP_data = load('first_last_PFP.txt');
patientNumbers = first_last_PFP_data(1,:);
first_PFP = first_last_PFP_data(2,:);
last_PFP = first_last_PFP_data(3,:);

% background signal info 
BGD = [5.32985	6.0345	5.8718	6.14255	5.8982	5.88445	5.98415	5.86475	5.78295	6.48255	5.978	5.85025	4.8496	4.8497	4.9275	4.92565 ...
    4.8934	4.84835	10.8336	7.98885	9.33085	9.66375	9.6091	9.76625	9.6471];



%% Select Patients for Experiment to Run
%ExperimentName  = 'd0_constant';
%FigureDirectory    = strcat('../../f19_fit_results/',ExperimentName,'/figures/');    mkdir(FigureDirectory);
%ParameterDirectory = strcat('../../f19_fit_results/',ExperimentName,'/parameters/'); mkdir(ParameterDirectory);

Control = [ 2; 3; 4;  5; 11; 15; 16; 17]; % check on 19,20
Exper   = [ 7; 8; 9; 10; 12; 13; 14; 18; 19; 20]; % not sure on 19,20 but both look normal

% Set up counters for control and exper
ControlCount = 1;
ExperCount = 1;

%% Selected Image Data
f19_pixel_size = 0.625; % cm
f19_slice_thickness = 1.5; % cm
anatomic_pixel_size = 0.3125; % cm
anatomic_slice_thickness = 1.5; % cm

%% Loop Through all F19 Patients
tic
for i=1:length(patientNumbers)
    %% Load F19 Data
    cd('G:\2017-Glass\mim\f19_ventilation_segmentations')
    filename = strcat('0509-',num2str(patientNumbers(i),'%03d'),'.mat');
    load(filename); roi = roi; image = image; 
    cd(home)
    
    %% Load Anatomic MRI
    cd('G:\2017-Glass\mim\inspiration_anatomic_segmentations')
    filename = strcat('0509-',num2str(patientNumbers(i),'%03d'),'.mat');
    load(filename); inspiration = inspiration; inspiration_ROI = inspiration_ROI; 
    cd(home)
    
    %fprintf('\n\n\nStarting Patient %03d', patientNumbers(i))
    
    % Process Normal Fit
    %[tau1_normal , tau2_normal , r2_normal , mask ] = NormalFitProcess( image , roi , scantimes , last_PFP(i) );
    
    %Process Split Fit
    %[ dF , tau1 , r2_Washin , d0 , tau2 , r2_Washout ] =  SplitFitProcess( image , roi , scantimes , first_PFP(i), last_PFP(i) );
    
    % Plot Results
    %PlotSplitFitResultsv2( patientNumbers(i), FigureDirectory, tau1, tau2, dF, d0, r2_Washin, r2_Washout, mask )
    
    % Save Parameters
    %SaveFitParameterData(patientNumbers(i), ParameterDirectory, tau1, tau2, dF, d0)
    %VentilationVolumeLiters(i,1) = patientNumbers(i);
    
    %% Resize segmentations to image dimensions
    Mask = imresize(roi,[64,64]); % f19
    inspiration_roi = imresize(inspiration_ROI,[128,128]); % anatomic
    
    %% Compute F19 volumes and apex base measurements
    VentilationVolumeLiters(i) = sum(Mask(:))*f19_pixel_size*f19_pixel_size*f19_slice_thickness/1e3;
    Ventilation_ApexBase(i) = ComputeApexBaseMeasurement(Mask, f19_pixel_size);
    Ventilation_AnteriorPosterior(i) = ComputeAntPostMeasurement(Mask, f19_slice_thickness);
    Ventilation_LeftRight(i) = ComputeLeftRightMeasurement(Mask, f19_pixel_size);
    
    %% Compute anatomic volumes and apex base measurements
    AnatomicVolumeLiters(i) = sum(inspiration_roi(:))*anatomic_pixel_size*anatomic_pixel_size*anatomic_slice_thickness/1e3;
    Anatomic_ApexBase(i) = ComputeApexBaseMeasurement(inspiration_roi, anatomic_pixel_size);
    Anatomic_AnteriorPosterior(i) = ComputeAntPostMeasurement(inspiration_roi, anatomic_slice_thickness);
    Anatomic_LeftRight(i) = ComputeLeftRightMeasurement(inspiration_roi, anatomic_pixel_size);
    
    slice1 = image(:,:,:,1);
    FirstSlice_Mean(i) = mean(slice1(:));
    FirstSliceSTD(i) = std(slice1(:));
    
    sliceEnd = image(:,:,:,end);
    lastSlice_Mean(i) = mean(sliceEnd(:));
    lastSliceSTD(i) = std(sliceEnd(:));
    
    
    
    % Compute 
    
%     % Compute Slow Washins
%     [SlowFillingVolumes(i) , SlowFillingPercentages(i) ] = ComputeSlowFillingVolumes(image, roi, first_PFP(i) , patientNumbers(i) , 2 , 11); % 2 washin cycles, threshold 11
%     
%     % Compute Gas Trapping
%     [GasTrappingVolumes(i) , GasTrappingPercentages(i) ] = ComputeGasTrappingVolumes(image, roi, last_PFP(i)  , patientNumbers(i) , 3 , 11); % 3 washout cycles, threshold 11
%     
%     % Compute Total Ventilation Number
%     MaximumValsImage = max(image,[],4);
%     TotalVentilationVolume = Mask.*MaximumValsImage;
%     TotalVentilation(i) = sum(TotalVentilationVolume(:))*6.25*6.25*15/1e6;
%     
%     % Compute Stats
%     if ismember(patientNumbers(i),Control)
%         Control_VentilationVolume(ControlCount) = VentilationVolumeLiters(i);
%         Control_SlowFillPercent(ControlCount) = SlowFillingPercentages(i);
%         Control_TrapPercent(ControlCount) = GasTrappingPercentages(i);
%         ControlCount = ControlCount + 1;
%     elseif ismember(patientNumbers(i),Exper)
%         Exper_VentilationVolume(ExperCount) = VentilationVolumeLiters(i);
%         Exper_SlowFillPercent(ExperCount) = SlowFillingPercentages(i);
%         Exper_TrapPercent(ExperCount) = GasTrappingPercentages(i);
%         ExperCount = ExperCount + 1;
%     end
       
    
end

Ventilation_AnteriorPosterior'
Anatomic_AnteriorPosterior'

% loop for stats
%[h_ventVolu , p_ventVolu] = ttest2(Control_VentilationVolume , Exper_VentilationVolume , 'Vartype','unequal')
%[h_trapPerc , p_TrapPerc] = ttest2(Control_TrapPercent , Exper_TrapPercent , 'Vartype','unequal' )
%[h_slowFPer , p_slowFPer] = ttest2(Control_TrapPercent , Exper_TrapPercent , 'Vartype','unequal' )
%[h_trapNorm , p_TrapNorm] = ttest2(Control_TrapNormalized , Exper_TrapNormalized , 'Vartype','unequal' )

toc

%SlowFillingPercentages'
