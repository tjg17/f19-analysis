function [ GasTrappingVolume , GasTrappingPercentage , GasTrappingMask ] = ComputeGasTrappingVolumes( image , roi , last_pfp , PatientNumber , washoutcycles , ventilated_threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Resample segmentation to size of image volume
Mask = imresize(roi,[64,64]);

%% Choose Image Timepoint to Compute Gas Trapping
GasTrapImage = image(:,:,:,last_pfp+washoutcycles).*Mask; % after 3 washout cycles

%% Create Binary Image using Threshold
GasTrapBinary = zeros(size(GasTrapImage));
for slice = 1:size(GasTrapImage,3)
    GasTrapBinary(:,:,slice) = imbinarize(GasTrapImage(:,:,slice), ventilated_threshold); % make binary image base on ventilation threshold
end
GasTrappingMask = GasTrapBinary;

%% Clean Up Binary Image to Remove Small Volumes
%GasTrapBinary = bwareaopen(GasTrapBinary,3);

%% Compute Gas Trapping and Ventilation Volumes
GasTrappingVolume = sum(GasTrapBinary(:))*6.25*6.25*15/1e6; % in liters - update this to stop hard coding
VentilationVolume = sum(Mask(:))*6.25*6.25*15/1e6; % in liters
GasTrappingPercentage = GasTrappingVolume/VentilationVolume; % percent

%% Optional Plotting
figure(PatientNumber);clf
plot_title = sprintf('Gas Trapping for Patient %i',PatientNumber);

subplot(4,4,1)
imshow(GasTrapBinary(:,:,2),[])
title(plot_title)
subplot(4,4,2)
imshow(GasTrapBinary(:,:,3),[])
subplot(4,4,3)
imshow(GasTrapBinary(:,:,4),[])
subplot(4,4,4)
imshow(GasTrapBinary(:,:,5),[])
subplot(4,4,5)
imshow(GasTrapBinary(:,:,6),[])
subplot(4,4,6)
imshow(GasTrapBinary(:,:,7),[])
subplot(4,4,7)
imshow(GasTrapBinary(:,:,8),[])
subplot(4,4,8)
imshow(GasTrapBinary(:,:,9),[])
subplot(4,4,9)
imshow(GasTrapBinary(:,:,10),[])
subplot(4,4,10)
imshow(GasTrapBinary(:,:,11),[])
subplot(4,4,11)
imshow(GasTrapBinary(:,:,12),[])
subplot(4,4,12)
imshow(GasTrapBinary(:,:,13),[])
subplot(4,4,13)
imshow(GasTrapBinary(:,:,14),[])
subplot(4,4,14)
imshow(GasTrapBinary(:,:,15),[])
subplot(4,4,15)
imshow(GasTrapBinary(:,:,16),[])
subplot(4,4,16)
imshow(GasTrapBinary(:,:,17),[])

% Save figure
FigureDirectory    = strcat('G:/2017-Glass/f19_fit_results/GasTrapping3/');    mkdir(FigureDirectory);
FigureName = strcat('GasTrapping_Patient',string(PatientNumber));
FileName = char(strcat(FigureDirectory,FigureName,'.png'));
saveas(gcf,FileName)

end

