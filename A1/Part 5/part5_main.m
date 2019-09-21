%% Initialise
clc;
clear;
close all;
run('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m')
img1 = imread('..\assg1\im01.jpg');
img2 = imread('..\assg1\im02.jpg');
uniq = 1.5;

%% Choose img sides. Left image will be transformed.
left_img = img2;
right_img = img1;

%% Run SIFT by VLFeat
[matches1, matches2] = part5_runsift(right_img,left_img,uniq);

%% RANSAC
[best_mat1,best_mat2,best_h] = part5_ransac(matches1,matches2,right_img,left_img);

%% Get output
[img2_T,xmin,ymin] = part5_getoutput(left_img,best_h);

%% Get displacement of transformed img1 points to img2 and stitch
mat2_H_shifted = part5_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
displacement = round(mean(mat2_H_shifted - best_mat1,2));
[~,stitched] = part5_padstitch(displacement,right_img,img2_T);



