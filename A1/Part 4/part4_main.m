%% Initialise
clc;
clear;
close all;
addpath('..\functions and GUI')

%% Start GUI to save points on images
[mat1, mat2, img1, img2] = part4_gui;  
disp(['Points saved.' newline 'Computing homography matrix and output...']);

%% Calculate homography matrix
h = hmat(mat1,mat2);

%% Get output
[output,xmin,ymin] = getoutput(img1,h);
disp(h);

%% Stitch
mat1_H_shifted = dohomography(mat1,h) - [xmin-1 ; ymin-1 ; 0];
displacement = round(mean(mat1_H_shifted - mat2,2));
[~,stitched] = padstitch(displacement,img2,output);

figure; imshow(stitched);    title("Part 4: Manual homography and stitching");