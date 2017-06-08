%% main_f19.m
% Tyler Glass
% Adapted from Esther Akinnagbe-Zusterzeel
% Code computes time constants and washin/washout dynamics for f19 MRI

%% Initialize Workspace
clear; clc; close all
home = pwd;
addpath('./functions') % Add path for f19 functions

%% Load Parameters for Running
fprintf('\nLoading Input Parameters...'); tStart = tic; % print status and start timer
[ SubjectFolder , scan_dir, beginning, startFile, x, y, z ] = LoadParametersF19Analysis();
fprintf('done (%0.1f Seconds)',toc(tStart))

%% Load 3D data
fprintf('\nLoading 3D Data...'); tStart = tic; % print status and start timer
cd('.\functions\ReadData3D_version1k\')
[V1, info1] =ReadData3D(startFile);
cd(home)
imtool3D(V1);
fprintf('done (%0.1f Seconds)',toc(tStart))

%% Read all DICOM files of the entire scan
fprintf('\nReading DICOM files...'); tStart = tic;
[scanfolders, dcmfiles, all, times, nscans ] = readall2( scan_dir , home , x , y);
fprintf('done (%0.1f Seconds)',toc(tStart))

%% Make X-Axis acquisition time
fprintf('\nFinding acquisition times...'); tStart = tic;
[ et_vector, t ] = elapsedtime_vector( times, nscans );
fprintf('done (%0.1f Seconds)',toc(tStart))

%% Find mean of whole lung ROI
fprintf('\nFinding mean of whole lung ROI...'); tStart = tic;
[ timepts, means, times, nrow, ncol, nslice, nel, nvox, last_pfp, mask ] = lungVOIavg2( nscans, z, y, x, all, all{1}, times, V1 );
fprintf('done (%0.1f Seconds)',toc(tStart))

%% Fitting of whole lung
fprintf('\nComputing fit for averaged whole lung...'); tStart = tic;
[ f4 ] = whole_lung_fit( last_pfp, means, et_vector, nscans, beginning );
fprintf('done (%0.1f Seconds)',toc(tStart))

%% Get vector of each voxel signal intensity over time within whole lung ROI
fprintf('\nGetting voxel vectors over time...'); tStart = tic;
[ masked_all ] = maskcellimages( mask, all, nrow, ncol, nslice, nscans );
fprintf('done (%0.1f Seconds)',toc(tStart))

%% Find peak wash-in and time to peak wash-in for each voxel
fprintf('\nComputing fit for each voxel...'); tStart = tic;
[ vvec2, nrow, ncol, nslice, nel, nscans, x, y ] = voxel_vector( masked_all, nscans, x, y );
[ max_map, time2max_map, time2max_mapt, avg_time2max, avt, M, I, I2 ] = max_washin_time( vvec2, nrow, ncol, nslice, nel, all, et_vector, x, y, z, last_pfp, mask );
fprintf('done (%0.1f Seconds)',toc(tStart))

 %% choose one method, and apply to each voxel
fprintf('\nComputing fit maps for images:'); tStart = tic;
[ d0_map, df_map, tau1_map, tau2_map, t0_map, t1_map, probe ] = ffitmaps( nrow, ncol, nslice, nscans, nel, time2max_map, time2max_mapt, vvec2, et_vector, f4 );
fprintf('\nFit Maps Completed (total time: %0.1f Seconds)',toc(tStart))

%% Write Maps to DICOM Files

% Tau1
cd(SubjectFolder)
mkdir('tau1')
cd('.\tau1')
for i = 1 : nslice
    slicenum = num2str(i);
    middle = '_tau1map_slice';
    filename = strcat(beginning, middle, slicenum, '.dcm');
    dicomwrite (uint16(tau1_map(:, :, i)), filename);
end
% Tau2
cd(SubjectFolder)
mkdir('tau2')
cd('.\tau2')
for i = 1 : nslice
    slicenum = num2str(i);
    middle = '_tau2map_slice';
    filename = strcat(beginning, middle, slicenum, '.dcm');
    dicomwrite (uint16(tau2_map(:, :, i)), filename);
end
% D0
cd(SubjectFolder)
mkdir('d0')
cd('.\d0')
for i = 1 : nslice
    slicenum = num2str(i);
    middle = '_d0map_slice';
    filename = strcat(beginning, middle, slicenum, '.dcm');
    dicomwrite (uint16(d0_map(:, :, i)), filename);
end
% Df
cd(SubjectFolder)
mkdir('df')
cd('.\df')
for i = 1 : nslice
    slicenum = num2str(i);
    middle = '_dfmap_slice';
    filename = strcat(beginning, middle, slicenum, '.dcm');
    dicomwrite (uint16(df_map(:, :, i)), filename);
end
% t0
cd(SubjectFolder)
mkdir('t0')
cd('.\t0')
for i = 1 : nslice
    slicenum = num2str(i);
    middle = '_t0map_slice';
    filename = strcat(beginning, middle, slicenum, '.dcm');
    dicomwrite (uint16(t0_map(:, :, i)), filename);
end
% t1
cd(SubjectFolder)
mkdir('t1')
cd('.\t1')
for i = 1 : nslice
    slicenum = num2str(i);
    middle = '_t1map_slice';
    filename = strcat(beginning, middle, slicenum, '.dcm');
    dicomwrite (uint16(t1_map(:, :, i)), filename);
end


%% Histograms

% A = t0_map(t0_map>0 | t0_map<0);
% 
% 
% edges = [-30 :5: 100];
% figure
% histogram(A,edges)
% heading = strcat( beginning, ': Study Start Time ' );
% title(heading)
% xlabel('Study Start Time (seconds)')
% ylabel('Count')



B = t1_map(t1_map>0);


edges = [0 :10: 450];
figure
fig = histogram(B,edges);
heading = strcat( beginning, ': Time to steady-state' );
title(heading)
xlabel('Time to steady-state (seconds)')
ylabel('Count')
cd(SubjectFolder)
heading1 = strcat( beginning, ' t1.fig' );
saveas(fig,heading1)
heading2 = strcat( beginning, ' t1.png' );
saveas(fig,heading2)
 

C = tau1_map(tau1_map>0);


edges = [0 : 5 : 200];
figure
fig = histogram(C,edges);
heading = strcat( beginning, ': Wash-in Rate' );
title(heading)
xlabel('\tau_1 (seconds)')
ylabel('Count')
cd(SubjectFolder)
heading1 = strcat( beginning, ' tau1.fig' );
saveas(fig,heading1)
heading2 = strcat( beginning, ' tau1.png' );
saveas(fig,heading2)


D = tau2_map(tau2_map>0);


edges = [0 : 5 : 200];
figure
fig = histogram(D,edges);
heading = strcat( beginning, ': Wash-out Rate' );
title(heading)
xlabel('\tau_2 (seconds)')
ylabel('Count')
cd(SubjectFolder)
heading1 = strcat( beginning, ' tau2.fig' );
saveas(fig,heading1)
heading2 = strcat( beginning, ' tau2.png' );
saveas(fig,heading2)


% E = d0_map(d0_map>0);
% 
% 
% edges = [0 : 5 : 100];
% figure
% histogram(E,edges)
% heading = strcat( beginning, ': Baseline' );
% title(heading)
% xlabel('Base, D_0')
% ylabel('Count')


F = df_map(df_map>0);


edges = [0 : 20 : 250];
figure
fig=histogram(F,edges);
heading = strcat( beginning, ': Peak Signal Intensity' );
title(heading)
xlabel('Peak Signal Intensity (A.U.)')
ylabel('Count')
cd(SubjectFolder)
heading1 = strcat( beginning, ' df.fig' );
saveas(fig,heading1)
heading2 = strcat( beginning, ' df.png' );
saveas(fig,heading2)


% imtool3D(masked_all{5})
% 
% imtool3D(all{5})


cd(SubjectFolder)
heading = strcat( beginning, 'workspace' );
save(heading)












