%% Initialise
clc;
clear;
close all;

%% Start GUI to save points on images
[mat1, mat2] = part3_gui;
disp('points saved');

%% Calculate homography matrix
hmat(mat1,mat2);

