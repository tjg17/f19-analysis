function [ SubjectFolder , scan_dir, SubjectID, beginning, startFile, startFile_timepoint, x, y, z ] = LoadParametersF19Analysis(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

SubjectFolder = 'G:\2017-Glass\scratch\f19_test_data\MATLAB Outputs';
scan_dir = 'G:\2017-Glass\scratch\f19_test_data\MIM Outputs\Subject 0509-002\2015-01__Studies';
SubjectID = 'TestPatient';
beginning = SubjectID; % need to see if this is necessary
startFile = 'G:\2017-Glass\scratch\f19_test_data\MIM Outputs\Subject 0509-002\2015-01__Studies\F19-0509-002_F19-0509-002  29Jan2015_MR_2015-01-28_135901_TRIO^BODY_Coronal.Aligned05\2.16.840.1.114362.1.6.6.9.161209.8888491279.450996790.665.2276';
startFile_timepoint = 5; % timepoint for selected startFile
x =  1; % Enter first air scan number
y = 11; % Enter last air scan number
z =  6; % Enter scan number of last PFP breath-hold


end

