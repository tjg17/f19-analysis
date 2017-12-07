function [ OverlapVolume , CombinedVolume ] = ComputeCombinedOverlapVolumes( volume1 , volume2 )
%Computes overlapping and combined volumes for input 3d binary masks
% inputs must be same size matrices

%% Find Overlapping Volumes
OverlapMask = and(volume1,volume2);
OverlapVolume = sum(OverlapMask(:))*6.25*6.25*15/1e6; % in liters

%% Find Combined Volumes
CombinedMask = or(volume1,volume2);
CombinedVolume = sum(CombinedMask(:))*6.25*6.25*15/1e6; % in liters

end