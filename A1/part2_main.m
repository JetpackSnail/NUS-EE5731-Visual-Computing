%% Initialise
clc;
clear;
close all;

img = imread('.\assg1\im01.jpg');
img_gray = single(rgb2gray(img));
imshow(img); hold on; title('Part 2: SIFT Features and Descriptors')
%% Run SIFT by VLFeat
% VLFeat is distributed under the BSD license:
% Copyright (C) 2007-11, Andrea Vedaldi and Brian Fulkerson
% Copyright (C) 2012-13, The VLFeat Team
% All rights reserved.
run('.\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m')
[keypts,desc] = vl_sift(img_gray);
perm = randperm(size(keypts,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(keypts(:,sel)) ;
h2 = vl_plotframe(keypts(:,sel)) ;
h3 = vl_plotsiftdescriptor(desc(:,sel),keypts(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
set(h3,'color','g') ;