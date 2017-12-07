%% load images
clear;clc;
home = pwd;

% choose patient
all = [2;3;4;5;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;24;25];
normals = [2;3;4;5;11;15;16;17;19;21];
mild = [9;10;13;18;20;24;25];
moderate = [7;8;12;14;22];

% choose set
patients = normals;
for i = 1:length(patients)
    
    % load ventilaion
    cd('G:\2017-Glass\mim\f19_ventilation_segmentations')
    %filename = strcat('0509-015','.mat');
    filename = strcat('0509-',num2str(patients(i),'%03d'),'.mat');
    load(filename);
    moving = imresize(roi,[128,128]); % f19 is moving

    % load anatomical
    cd('G:\2017-Glass\mim\inspiration_anatomic_segmentations')
    %filename = strcat('0509-015','.mat');
    filename = strcat('0509-',num2str(patients(i),'%03d'),'.mat');
    load(filename)
    fixed = imresize(inspiration_ROI, [128,128]); % anat is fixed
    fixed(:,:,16:18) = 0; % make fixed the same size as moving functional

%     % view images
%     figure(1);clf
%     subplot(4,4,1)
%     imshowpair(fixed(:,:,2), moving(:,:,2),'Scaling','joint');
%     subplot(4,4,2)
%     imshowpair(fixed(:,:,3), moving(:,:,3),'Scaling','joint');
%     subplot(4,4,3)
%     imshowpair(fixed(:,:,4), moving(:,:,4),'Scaling','joint');
%     subplot(4,4,4)
%     imshowpair(fixed(:,:,5), moving(:,:,5),'Scaling','joint');
%     subplot(4,4,5)
%     imshowpair(fixed(:,:,6), moving(:,:,6),'Scaling','joint');
%     subplot(4,4,6)
%     imshowpair(fixed(:,:,7), moving(:,:,7),'Scaling','joint');
%     subplot(4,4,7)
%     imshowpair(fixed(:,:,8), moving(:,:,8),'Scaling','joint');
%     subplot(4,4,8)
%     imshowpair(fixed(:,:,9), moving(:,:,9),'Scaling','joint');
%     subplot(4,4,9)
%     imshowpair(fixed(:,:,10), moving(:,:,10),'Scaling','joint');
%     subplot(4,4,10)
%     imshowpair(fixed(:,:,11), moving(:,:,11),'Scaling','joint');
%     subplot(4,4,11)
%     imshowpair(fixed(:,:,12), moving(:,:,12),'Scaling','joint');
%     subplot(4,4,12)
%     imshowpair(fixed(:,:,13), moving(:,:,13),'Scaling','joint');
%     subplot(4,4,13)
%     imshowpair(fixed(:,:,14), moving(:,:,14),'Scaling','joint');
%     subplot(4,4,14)
%     imshowpair(fixed(:,:,15), moving(:,:,15),'Scaling','joint');
%     subplot(4,4,15)
%     imshowpair(fixed(:,:,16), moving(:,:,16),'Scaling','joint');
%     subplot(4,4,16)
%     imshowpair(fixed(:,:,17), moving(:,:,17),'Scaling','joint');

    % set up registration
    [optimizer, metric] = imregconfig('monomodal');
    %optimizer.GradientMagnitudeTolerance = 1e-2;
    %optimizer.MinimumStepLength = 1e-5;
    %optimizer.MaximumStepLength = 0.0625;
    %optimizer.MaximumIterations = 2;
    %optimizer.RelaxationFactor = 0.1;
    f19_MOVING = imregister(uint8(moving), uint8(fixed), 'translation', optimizer, metric);

    %% Plot Registered Results
    figure(1);clf
    plot_title = sprintf('Subject %i', patients(i));

    subplot(4,4,1)
    imshowpair(fixed(:,:,2), f19_MOVING(:,:,2),'Scaling','joint');
    title(plot_title)
    subplot(4,4,2)    
    imshowpair(fixed(:,:,3), f19_MOVING(:,:,3),'Scaling','joint');
    subplot(4,4,3)    
    imshowpair(fixed(:,:,4), f19_MOVING(:,:,4),'Scaling','joint');
    subplot(4,4,4)
    imshowpair(fixed(:,:,5), f19_MOVING(:,:,5),'Scaling','joint');
    subplot(4,4,5)
    imshowpair(fixed(:,:,6), f19_MOVING(:,:,6),'Scaling','joint');
    subplot(4,4,6)
    imshowpair(fixed(:,:,7), f19_MOVING(:,:,7),'Scaling','joint');
    subplot(4,4,7)
    imshowpair(fixed(:,:,8), f19_MOVING(:,:,8),'Scaling','joint');
    subplot(4,4,8)
    imshowpair(fixed(:,:,9), f19_MOVING(:,:,9),'Scaling','joint');
    subplot(4,4,9)
    imshowpair(fixed(:,:,10), f19_MOVING(:,:,10),'Scaling','joint');
    subplot(4,4,10)
    imshowpair(fixed(:,:,11), f19_MOVING(:,:,11),'Scaling','joint');
    subplot(4,4,11)
    imshowpair(fixed(:,:,12), f19_MOVING(:,:,12),'Scaling','joint');
    subplot(4,4,12)
    imshowpair(fixed(:,:,13), f19_MOVING(:,:,13),'Scaling','joint');
    subplot(4,4,13)
    imshowpair(fixed(:,:,14), f19_MOVING(:,:,14),'Scaling','joint');
    subplot(4,4,14)
    imshowpair(fixed(:,:,15), f19_MOVING(:,:,15),'Scaling','joint');
    subplot(4,4,15)
    imshowpair(fixed(:,:,16), f19_MOVING(:,:,16),'Scaling','joint');
    subplot(4,4,16)
    imshowpair(fixed(:,:,17), f19_MOVING(:,:,17),'Scaling','joint');
    
   
%     %% Save figure (optional)
%     FigureDirectory    = strcat('G:/2017-Glass/f19_fit_results/Registered/');  mkdir(FigureDirectory);
%     FigureName = strcat('Registration_Patient_',string(patients(i)));
%     FileName = char(strcat(FigureDirectory,FigureName,'.png'));
%     saveas(gcf,FileName)

    %% Pause and return to home
    pause(1)
    cd(home)
    
    
end