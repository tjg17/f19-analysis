function [ moving_stretched ] = Stretch_Functional3D( moving, fixed )
%Stretches moving mask image in apex base direction to match apex base
%measurement from fixed image

%% Get dimensions of input segmentation
moving_dimensions = size(moving);
fixed_dimensions  = size(fixed);

%% Compute moving image apex base
for row = 1:moving_dimensions(1)
    moving_row_maximums(row) = max(max(moving(row,:,:)));
end
Moving_ApexBaseMeasurement_pixels = sum(moving_row_maximums(:));

%% Compute moving image apex base
for row = 1:fixed_dimensions(1)
    fixed_row_maximums(row) = max(max(fixed(row,:,:)));
end
Fixed_ApexBaseMeasurement_pixels = sum(fixed_row_maximums(:));

%% Stretch moving by ratio of measurements
StretchRatio = Fixed_ApexBaseMeasurement_pixels/Moving_ApexBaseMeasurement_pixels;
NumberRows_stretched = round(moving_dimensions(1)*StretchRatio);
moving_stretched = imresize(moving, [ NumberRows_stretched    moving_dimensions(2) ]);

end

