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
patientNumbers = [2; 3; 4; 5; 7; 8; 9; 10; 12; 13; 14; 15; 16; 17; 18; 19; 20; 24; 25] %; 26; 27; 28; 33]
tic
for i=1:length(patientNumbers)
    %% Load Phantom Images
    cd('G:\2017-Glass\mim\phantom_f19_images')
    filename = strcat('0509-',num2str(patientNumbers(i),'%03d'),'.mat');
    load(filename); phantom = phantom;
    cd(home)
    
%     %% Plot Phantom
%     figure(1);clf
%     title(sprintf('Subject %i', patientNumbers(i)));
%     window_f19 = [0 120];
%     
%     subplot(4,4,1)
%     imshow(phantom(:,:,2), window_f19)
%     subplot(4,4,2)    
%     imshow(phantom(:,:,3), window_f19)
%     subplot(4,4,3)    
%     imshow(phantom(:,:,4), window_f19)
%     subplot(4,4,4)
%     imshow(phantom(:,:,5), window_f19)
%     subplot(4,4,5)
%     imshow(phantom(:,:,6), window_f19)
%     subplot(4,4,6)
%     imshow(phantom(:,:,7), window_f19)
%     subplot(4,4,7)
%     imshow(phantom(:,:,8), window_f19)
%     subplot(4,4,8)
%     imshow(phantom(:,:,9), window_f19)
%     subplot(4,4,9)
%     imshow(phantom(:,:,10), window_f19)
%     subplot(4,4,10)
%     imshow(phantom(:,:,11), window_f19)
%     subplot(4,4,11)
%     imshow(phantom(:,:,12), window_f19)
%     subplot(4,4,12)
%     imshow(phantom(:,:,13), window_f19)
%     subplot(4,4,13)
%     imshow(phantom(:,:,14), window_f19)
%     subplot(4,4,14)
%     imshow(phantom(:,:,15), window_f19)
%     subplot(4,4,15)
%     imshow(phantom(:,:,16), window_f19)
%     subplot(4,4,16)
%     imshow(phantom(:,:,17), window_f19)
    
    %% Threshold Value
    threshold_value = 16;
    
    %% Old method
    inside_phantom = phantom(find(phantom>threshold_value));
    median_bgds(i) = median(inside_phantom);
    phantom_volumes(i) = length(inside_phantom)*0.625*0.625*1.5/1000;
    median_bgds1(i) = median(inside_phantom);
    phantom_volumes1(i) = length(inside_phantom)*0.625*0.625*1.5/1000;
    
    %% Get values inside histogram - new method
    below_threshold_locs = find(phantom<threshold_value);
    thresh_mat = ones(size(phantom));
    thresh_mat(below_threshold_locs) = 0;
    phantom_thresh = phantom.*thresh_mat;
    
    % Median Filter
    phantom_thresh_filt = medfilt3(phantom_thresh);
    % Choose only values above 0
    filtered_phantom_vals = phantom_thresh_filt(find(phantom_thresh_filt>0));
    
    median_bgds2(i) = median(filtered_phantom_vals);
    phantom_volumes2(i) = length(filtered_phantom_vals)*0.625*0.625*1.5/1000;
    
    p1(i) = prctile(filtered_phantom_vals,1);
    p5(i) = prctile(filtered_phantom_vals,5);
    p10(i) = prctile(filtered_phantom_vals,10);
    p20(i) = prctile(filtered_phantom_vals,20);
    p40(i) = prctile(filtered_phantom_vals,40);
    p90(i) = prctile(filtered_phantom_vals,90);

%     %% Plot Phantom
%     figure(1);clf
%     
% 
%     
%     window_f19 = [0 16];
%     phantom = phantom_thresh_filt;
%     
%     subplot(4,4,1)
%     imshow(phantom(:,:,2), window_f19)
%     subplot(4,4,2)    
%     imshow(phantom(:,:,3), window_f19)
%     subplot(4,4,3)    
%     imshow(phantom(:,:,4), window_f19)
%     subplot(4,4,4)
%     imshow(phantom(:,:,5), window_f19)
%     subplot(4,4,5)
%     imshow(phantom(:,:,6), window_f19)
%     subplot(4,4,6)
%     imshow(phantom(:,:,7), window_f19)
%     subplot(4,4,7)
%     imshow(phantom(:,:,8), window_f19)
%     subplot(4,4,8)
%     imshow(phantom(:,:,9), window_f19)
%     subplot(4,4,9)
%     imshow(phantom(:,:,10), window_f19)
%     subplot(4,4,10)
%     imshow(phantom(:,:,11), window_f19)
%     subplot(4,4,11)
%     imshow(phantom(:,:,12), window_f19)
%     subplot(4,4,12)
%     imshow(phantom(:,:,13), window_f19)
%     subplot(4,4,13)
%     imshow(phantom(:,:,14), window_f19)
%     subplot(4,4,14)
%     imshow(phantom(:,:,15), window_f19)
%     subplot(4,4,15)
%     imshow(phantom(:,:,16), window_f19)
%     subplot(4,4,16)
%     imshow(phantom(:,:,17), window_f19)
%     
%     title(sprintf('Subject %i', patientNumbers(i)));
%     pause(0.3)

    
    %% Plot histogram
    figure(3);clf
    histogram(filtered_phantom_vals)
    xlabel('Pixel Intensity')
    ylabel('Number of Pixels')
    xlim([10 180])
    ylim([0 1700])
    title(sprintf('f19 Phantom before Subject %i', patientNumbers(i)));
    
    pause(1)
    
    %% Save figure (optional)
    FigureDirectory    = strcat('G:\2017-Glass\f19_fit_results\phantom_histograms\');  mkdir(FigureDirectory);
    FigureName = strcat('Phantom_Histogram_Subject_',string(patientNumbers(i)));
    FileName = char(strcat(FigureDirectory,FigureName,'.png'));
    saveas(gcf,FileName)
           
end

median_bgds'
phantom_volumes2'

max(phantom_volumes)-min(phantom_volumes)
p10 = p10'
p40 = p40'