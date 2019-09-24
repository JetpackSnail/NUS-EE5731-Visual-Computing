%% Initialise
clc;
clear;
close all;
addpath('..\functions and GUI')

run('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m')
img1 = imread('..\assg1\im01.jpg');
img2 = imread('..\assg1\im02.jpg');
uniq = 1.25;                        % uniqness ratio for SIFT
iter = 7000;                        % iterations for RANSAC

%% Choose img sides. Left image will be transformed.
left_img = img1;
right_img = img2;

%% Run SIFT by VLFeat
[keypts1,desc1] = vl_sift(single(rgb2gray(img1)));
[keypts2,desc2] = vl_sift(single(rgb2gray(img2)));
[matches1, matches2] = run_sift(right_img,left_img,uniq);

% for plotting
match_fig = [right_img left_img];
figure; imshow(match_fig); axis on; hold on ;
for i = 1:size(matches1,2)
    x = [matches1(1,i),matches2(1,i)+ size(right_img,2)];
    y = [matches1(2,i),matches2(2,i)];
    plot(x,y,'color',rand(1,3),'LineWidth', 1.2); title('Part 5: Matches found from SIFT');
end; hold off

%% RANSAC
[best_mat1,best_mat2,best_h] = run_ransac(matches1,matches2,right_img,left_img,iter);

% for plotting
figure; imshow(match_fig); axis on; hold on ;
for k = 1:size(best_mat1,2)
    x = [best_mat1(1,k), best_mat2(1,k)] + [0, size(img2,2)];
    y = [best_mat1(2,k), best_mat2(2,k)] ;
    plot(x,y,'color',rand(1,3),'LineWidth', 1.2); title('Part 5: Matches found from best RANSAC');
end; hold off;

%% Get output
[img2_T,xmin,ymin] = getoutput(left_img,best_h);

%% Stitch
mat2_H_shifted = dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
displacement = round(mean(mat2_H_shifted - best_mat1,2));
[~,stitched] = padstitch(displacement,right_img,img2_T);

figure; imshow(stitched);    title("Part 5: RANSAC homography and stitching");

