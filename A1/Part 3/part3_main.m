%% Initialise
clc;
clear;
close all;
%% Start GUI to save points on images
[mat1, mat2, img1, img2] = part3_gui;  
disp(['Points saved.' newline 'Computing homography matrix and output...']);

%% Calculate homography matrix
h = part3_hmat(mat1,mat2);

%% Get output image
output = part3_getoutput(img1, h);
disp('Done!');
imshow(img2); xlabel("Image 2"); figure; 
imshow(output); xlabel("Image 1 after homography");



