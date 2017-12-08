function [ OverlapVolume , CombinedVolume ] = ComputeCombinedOverlapVolumes( volume1 , volume2 , pixel_size , slice_thickness )
%Computes overlapping and combined volumes for input 3d binary masks
% inputs must be same size matrices

%% Find Overlapping Volumes
OverlapMask = and(volume1,volume2);
OverlapVolume = sum(OverlapMask(:))*pixel_size*pixel_size*slice_thickness;

%% Find Combined Volumes
CombinedMask = or(volume1,volume2);
CombinedVolume = sum(CombinedMask(:))*pixel_size*pixel_size*slice_thickness;

end