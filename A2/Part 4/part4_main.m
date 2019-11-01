%% Initialise
clc;
clear;
close all;
addpath(genpath('..\GCMex\'));
addpath('..\functions');

%% Parameters & Properties
% change this value to change the weight of smoothness or prior term. high value = encourage smoothness between neightbours
ratio = 1;         % ratio = number of patches per dimension (1)
% higher  = more patches, small patchers, take longer time but maybe better results
lambda = 15;        % smoothness factor (15)
num_of_labels = 45;  % number of labels (60)
r = 255/(num_of_labels - 1);

%% Read images and camera matrix
img1 = imread('..\assg2\test00.jpg');
img2 = imread('..\assg2\test09.jpg');

[K,R,T] = get_camera_matrices('..\assg2\Road\Road\cameras.txt',5);










