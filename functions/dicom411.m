function [ SingleScan_Time ] = dicom411( scan_dir )
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


% home = pwd;

cd(scan_dir)

single_scan = dir(fullfile(pwd, '*.dcm'));
s = struct2cell(single_scan);

% DICOM INFO all those files
SingleScan_AcqTime = dicominfo(char(s(1,1)));
SingleScan_Time = str2double(SingleScan_AcqTime.AcquisitionTime);
end

