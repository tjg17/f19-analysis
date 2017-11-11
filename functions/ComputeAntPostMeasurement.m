function [ AntPostMeasurement ] = ComputeAntPostMeasurement( segmentation, slice_thickness )
%Computes anterior posterior measurement from roi of function and number of
%slices
%   segmentation = 3d matrix of image binary information
%   pixel_size is in mm

%% Get dimensions of input segmentation
segmentation_dimensions = size(segmentation);

%% Loop to find max of each row
for slice = 1:segmentation_dimensions(3)
    slice_maximums(slice) = max(max(segmentation(:,:,slice)));
end

%figure()
%plot(row_maximums); pause(0.1)

AntPostMeasurement = sum(slice_maximums(:))*slice_thickness-slice_thickness;

end

