function [ SlowFillingVolume , SlowFillingPercentage , SlowFillingMask ] = ComputeSlowFillingVolumes( image , roi , first_PFP , PatientNumber, washincycles , unventilated_threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Resample segmentation to size of image volume
Mask = imresize(roi,[64,64]);

%% Choose Image Timepoint to Compute Gas Trapping
SlowFillingImage = image(:,:,:,first_PFP+washincycles-1).*Mask; % firstPFP includes 1 washin cycle

%% Create Binary Image using Threshold
% this is fast fill as currently constructed...
SlowFillingImage(find(SlowFillingImage<0.5)) = 100; % set outside lung to some high value
SlowFillingImage(find(SlowFillingImage>unventilated_threshold)) = 0; % set all values greater than threshold to 0
SlowFillBinary = SlowFillingImage; SlowFillBinary(find(SlowFillBinary>0.5)) = 1;
SlowFillingMask = SlowFillBinary;

% SlowFillBinary = zeros(size(SlowFillingImage));
% for slice = 1:size(SlowFillingImage,3)
%     SlowFillBinary(:,:,slice) = imbinarize(SlowFillingImage(:,:,slice), unventilated_threshold); % make binary image base on ventilation threshold
% end


%% Clean Up Binary Image to Remove Small Volumes
%SlowFillBinary = bwareaopen(SlowFillBinary,3); % num pixels to keep image

%% Compute Gas Trapping and Ventilation Volumes
VentilationVolume = sum(Mask(:))*6.25*6.25*15/1e6; % in liters

SlowFillingVolume = sum(SlowFillBinary(:))*6.25*6.25*15/1e6; % in liters

SlowFillingPercentage = SlowFillingVolume/VentilationVolume; % percent

%% Optional Plotting
figure(PatientNumber);clf
plot_title = sprintf('Slow Filling for Patient %i',PatientNumber);

subplot(4,4,1)
imshow(SlowFillBinary(:,:,2),[])
title(plot_title)
subplot(4,4,2)
imshow(SlowFillBinary(:,:,3),[])
subplot(4,4,3)
imshow(SlowFillBinary(:,:,4),[])
subplot(4,4,4)
imshow(SlowFillBinary(:,:,5),[])
subplot(4,4,5)
imshow(SlowFillBinary(:,:,6),[])
subplot(4,4,6)
imshow(SlowFillBinary(:,:,7),[])
subplot(4,4,7)
imshow(SlowFillBinary(:,:,8),[])
subplot(4,4,8)
imshow(SlowFillBinary(:,:,9),[])
subplot(4,4,9)
imshow(SlowFillBinary(:,:,10),[])
subplot(4,4,10)
imshow(SlowFillBinary(:,:,11),[])
subplot(4,4,11)
imshow(SlowFillBinary(:,:,12),[])
subplot(4,4,12)
imshow(SlowFillBinary(:,:,13),[])
subplot(4,4,13)
imshow(SlowFillBinary(:,:,14),[])
subplot(4,4,14)
imshow(SlowFillBinary(:,:,15),[])
subplot(4,4,15)
imshow(SlowFillBinary(:,:,16),[])
subplot(4,4,16)
imshow(SlowFillBinary(:,:,17),[])


% % Save figure
FigureDirectory    = strcat('G:/2017-Glass/f19_fit_results/SlowFilling2cycles/');    mkdir(FigureDirectory);
FigureName = strcat('SlowFilling2_Patient',string(PatientNumber));
FileName = char(strcat(FigureDirectory,FigureName,'.png'));
saveas(gcf,FileName)


end

