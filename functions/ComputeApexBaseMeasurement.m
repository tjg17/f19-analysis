function [ ApexBaseMeasurement ] = ComputeApexBaseMeasurement( segmentation, pixel_size )
%Computes apex base measurement from roi of function and pixel size
%   segmentation = 3d matrix of image binary information
%   pixel_size is in mm

%% Get dimensions of input segmentation
segmentation_dimensions = size(segmentation);

%% Loop to find max of each row
for row = 1:segmentation_dimensions(1);
    row_maximums(row) = max(max(segmentation(row,:,:)));
end

%figure()
%plot(row_maximums); pause(0.1)

ApexBaseMeasurement = sum(row_maximums(:))*pixel_size-pixel_size;

end

