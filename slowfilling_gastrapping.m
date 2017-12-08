%% main.m
% Tyler Glass
% Code for F19 slow filling and gas trapping volumes

%% Initialize Workspace
clear; clc; close all
home = pwd;
addpath('./functions') % Add path for f19 processing functions

%% Data for First and Last PFP Times
patientNumbers = [2; 3; 4; 5; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20; 21; 22; 24; 25; 26; 27; 28];
first_PFP      = [2; 1; 2; 2; 1; 2; 2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2];
last_PFP       = [7; 5; 7; 7; 7; 7; 6;  6;  6;  7;  6;  5;  7;  6;  6;  7;  6;  6;  6;  6;  4;  6;  6;  4;  6]; % updated 12/07/2017

%% Selected Image Data
f19_pixel_size = .625; % cm
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
    
    %% Compute Threshold for slow washin and gas trapping using 1st slice as background
    backgroundSlice = image(:,:,:,1);
    threshold_value(i) = mean(backgroundSlice(:))+2*std(backgroundSlice(:)); % mean + 2 stds
    
    %% Compute Slow Washins
    % need to update this with pixel size as variable
    [SlowFillingVolumes(i) , SlowFillingPercentages(i) , SlowFillingMask(:,:,:,i) ] = ComputeSlowFillingVolumes(image, roi, first_PFP(i) , patientNumbers(i) , 2 , threshold_value(i)); % 2 washin cycles
    
    %% Compute Gas Trapping
    [GasTrappingVolumes(i) , GasTrappingPercentages(i) , GasTrappingMask(:,:,:,i) ] = ComputeGasTrappingVolumes(image, roi, last_PFP(i)  , patientNumbers(i) , 3 , threshold_value(i)); % 3 washout cycles
    
    %% Compute Overlap and Combined Volumes
    [Overlap_GTSF_Volumes(i) Combined_GTSF_Volumes(i)] = ComputeCombinedOverlapVolumes(SlowFillingMask(:,:,:,i) , GasTrappingMask(:,:,:,i) , f19_pixel_size , f19_slice_thickness );
    
end

close all
toc

1000*GasTrappingVolumes'
1000*SlowFillingVolumes'
1000*Overlap_GTSF_Volumes'
1000*Combined_GTSF_Volumes'
