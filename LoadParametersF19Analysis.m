function [ SubjectFolder , scan_dir, beginning, startFile, x, y, z ] = LoadParametersF19Analysis(  )
%This function determines the inputs for the main_f19.m analysis script

beginning = 'TestPatient'; % enter SubjectID for plots and filenames here

SubjectFolder = 'G:\2017-Glass\scratch\f19_test_data\MATLAB Outputs';
% folder to send MATLAB outputs to
scan_dir = 'G:\2017-Glass\scratch\f19_test_data\MIM Outputs\Subject 0509-002\2015-01__Studies';
% folder with MIM outputs with f19 scan information
startFile = 'G:\2017-Glass\scratch\f19_test_data\MIM Outputs\Subject 0509-002\2015-01__Studies\F19-0509-002_F19-0509-002  29Jan2015_MR_2015-01-28_135901_TRIO^BODY_Coronal.LUmask_n15__00000\2.16.840.1.114362.1.6.6.9.161209.8888491279.450996585.729.2182';
% startFile is a single image in a folder with a stack of mask images

x =  1; % Enter first air scan number
y = 11; % Enter last air scan number
z =  6; % Enter scan number of last PFP breath-hold


end

