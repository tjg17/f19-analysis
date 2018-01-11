function [ Means , Mask ] = ComputePixelAverageIn3DROI( Image, ROI )
%ComputePixelAverageInROI finds the mean signal intensity value in an image
%within an inputted ROI

% Image is a 4D image (rows x columns x slices x time)
% ROI is a 3D segmentation mask (rows x columns x slices)
% Means is a 1D array (length = number of slices) with mean pixel value of Image in ROI for each slice

%% Start timer
fprintf('\nFinding mean pixel value for ROI at each time point...'); tStart = tic;

%% Get dimensions of image volume in 3D (rows x cols x slices)
nrows     = size(Image, 1); % number of rows in image
ncols     = size(Image, 2); % number of cols in image
nscans    = size(Image, 4); % number of scans in time

%% Resize ROI to match image
Mask = imresize(ROI,[nrows,ncols]);

%% Compute mean of ROI at each time point
Means = zeros(nscans,1);

for i = 1:nscans
    Segmented = Image(:,:,:,i).*Mask; % select only image values within mask
    Values    = Segmented(:); % put image into 1d array
    Means(i)  = sum(Values)./sum(Values~=0); % find mean of all nonzero values
end

%% End timer
fprintf('done (%0.1f Seconds)',toc(tStart))

end
