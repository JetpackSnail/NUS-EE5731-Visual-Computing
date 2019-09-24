%% Initialise
clc;
clear;
close all;
addpath('..\functions and GUI')

%% Start GUI to save points on images
[mat1, mat2, img1, img2] = part3_gui;  
disp(['Points saved.' newline 'Computing homography matrix and output...']);

%% Calculate homography matrix
h = hmat(mat1,mat2);

%% Get output image
[output,~,~] = getoutput(img1, h);
disp(h);
imshow(output); xlabel("Image 1 after homography");



