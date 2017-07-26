%% split_fit.m
% Tyler Glass
% Code computes time constants and washin/washout dynamics for f19 MRI
% splits the fit into 2 parts using last_pfp timepoint

%% Initialize Workspace
clear; clc; close all
home = pwd;
addpath('./functions') % Add path for f19 processing functions
addpath('G:\2017-Glass\mim\f19_MATLAB_workspaces') % add path for f19 data

