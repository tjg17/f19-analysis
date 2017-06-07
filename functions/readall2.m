function [ directories, filenames, scans, times, numscans ] = readall2( scan_dir , home, x , y )
%reads READS the DICOM files for a all scans and saves it into a
%64-by-64-by-n double array (ss)
%   Detailed explanation goes here%
%
%
% INPUT:
%       Folder path that contains the DICOM images of a scan.
% OUTPUT:
%        A 3D array of those images


cd(scan_dir)

% all_scans = dir(fullfile(pwd, '*.dcm'));
all_scans = genpath(scan_dir);
all_scans = strsplit(all_scans, ';');
length = size(all_scans, 2);

only_scans = all_scans(2 : (length-6));

% DICOM READ all those files
t = cell(30,30);
for count = 1 : numel(only_scans)-1
%     cd(home)
%     ima2dcm(only_scans{count})
    cd(only_scans{count})
    single_scan = dir(fullfile(pwd, '*.dcm'));
    s = struct2cell(single_scan);
    j=1;
   
    for i = 1 : 5 : numel(s)
        
        t(count,j) = s(i);
        j=j+1;

    end
end
directories = only_scans;
filenames = t;

nscans = (y-x) + 1;
nslice = 15; %Number of coronal slices per scan... (MAY NEED TO BE UI IN FUTURE)changed 04-26-17 from 18 to 15
nrows = 128; %(MAY NEED TO BE UI IN FUTURE)changed 04-26-17 from 64 to 128
ncols = 128; %(MAY NEED TO BE UI IN FUTURE)changed 04-26-17 from 64 to 128
all_scans_3D = cell(nrows, ncols, nslice, nscans);
all_times = zeros(nscans);

m = 1;

 for j = x : y
     cd(home)
     all_scans_3D{m}(:, :, :) = reads(directories{j}); %(m : nslice-1)
     cd(home)
     all_times(m) = dicom411(directories{j});
     m = m + 1;
     
 end

 scans = all_scans_3D;
 times = all_times;
 numscans = nscans;
 
end

