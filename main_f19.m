%% main_f19.m
% Tyler Glass
% Adapted from Esther Akinnagbe-Zusterzeel
% Code computes time constants and washin/washout dynamics for f19 MRI

%% Initialize Workspace
clear; clf; clc

%% Add functions path
addpath('./functions')

%% Read and View 3D data
cd .\functions\ReadData3D_version1k\
[V1, info1] =ReadData3D;
imtool3D(V1)
cd ..

%% What is this
thresh = 100; % Set threshold value for ROI selection!

%% Choose directory of scan date
SubjectFolder = uigetdir('', 'Select Output Subject Folder');
scan_dir = uigetdir('', 'Select folder containing DICOM Directories');

prompt4 = 'Enter Subject ID (NormalSubject# or CFSubject#):';
beginning = input(prompt4, 's');



%% Read all DICOM files of the entire scan
[scanfolders, dcmfiles, all, times, nscans, x, y, home] = readall2(scan_dir);
cd(home)

% j=1;
% k=18;
% ma = zeros(64, 64, 18*nscans);
% for i=1:nscans
%     ma(:,:,j:k) = all{i};
%     j=j+18;
%     k=k+18;
% end
% h = ones([3 3 3])/prod([3 3 3]);
% B=imfilter(ma,h);

%% Make X-Axis acquisition time
[ et_vector, t ] = elapsedtime_vector( times, nscans );

%% Find mean of whole lung ROI
[ timepts, means, times, nrow, ncol, nslice, nel, nvox, x, y, z, last_pfp, mask ] = lungVOIavg2( nscans, y, x, all, all{1}, times, V1 );

%% Fitting of whole lung
[ f4 ] = whole_lung_fit( last_pfp, means, et_vector, nscans, beginning );
beep

%% Get vector of each voxel signal intensity over time within whole lung ROI
[ masked_all ] = maskcellimages( mask, all, nrow, ncol, nslice, nscans );

%% Find peak wash-in and time to preak wash-in for each voxel
cd(home)
[ vvec2, nrow, ncol, nslice, nel, nscans, x, y ] = voxel_vector( masked_all, nscans, x, y );

cd(home)
[ max_map, time2max_map, time2max_mapt, avg_time2max, avt, M, I, I2 ] = max_washin_time( vvec2, nrow, ncol, nslice, nel, all, et_vector, x, y, z, last_pfp, mask );

 %% choose one method, and apply to each voxel
 datetime('now') % print time at start of processing
[ d0_map, df_map, tau1_map, tau2_map, t0_map, t1_map, probe ] = ffitmaps( nrow, ncol, nslice, nscans, nel, time2max_map, time2max_mapt, vvec2, et_vector, f4 );
datetime('now') % print time when processing is done

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

% 
% cd(home)
% imtool3D(masked_all{5})
% 
% imtool3D(all{5})


cd(SubjectFolder)
heading = strcat( beginning, 'workspace' );
save(heading)












