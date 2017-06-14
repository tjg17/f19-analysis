function [ ss ] = reads( scan_dir )
%reads READS the DICOM files for a single scan and saves it into a
%64-by-64-by-n double array (ss)
%   Detailed explanation goes here%
% 
% 
% INPUT:
%       Folder path that contains the DICOM images of a scan.
% OUTPUT: 
%        A 3D array of those images

if nargin < 1
    scan_dir = uigetdir();
end


home = pwd;

cd(scan_dir)

single_scan = dir(fullfile(pwd, '*.dcm'));
s = struct2cell(single_scan);

ss = zeros(128,128,numel(s)/6); %Changed to 128 by 128 voxels and to "numel(s)/6" from "numel(s)/5" on 4-26-2017 - tjg17 (note image dimensions here)
for count = 1 : numel(s)/6
    ss(:,:,count) = dicomread(char(s(1,count)));
    tt(count)=dicominfo(char(s(1,count)));
end

