%% Initialise
clc;
clear;
close all;
addpath('..\functions and GUI')

run('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m')
warning off                                 % suppress warnings

%% Function parameters and Ordering
num_of_imgs = 9;    % min = 2, max = number of images to stitch    
uniq = 1.25;    	% uniqness ratio for SIFT
iter = 7000;    	% iterations for RANSAC

for i = 1:num_of_imgs
    img_cell{i} = imread(['..\assg1\mod_pic',num2str(i) ,'.jpg']);   % 928 x 522 x 3 image
end

for j = 0:num_of_imgs-1
    idx = ((-1)^j) * ceil(j/2) + round((num_of_imgs + 1) / 2);
    order(j+1) = idx;
end

%% Begin stitching
for j = 2:num_of_imgs
    %% Select next image to stitch
    disp(['Doing stitch ', num2str(j),'/',num2str(num_of_imgs),'....']);
    if j == 2
        img1 = img_cell{order(j-1)};
    else
        img1 = stitched;
    end
    img2 = img_cell{order(j)};	% img1 is main composite picture ; img2 is transformed image
    
    %% Run SIFT by VLFeat
    [matches1, matches2] = run_sift(img1,img2,uniq);
    
    %% RANSAC
    [best_mat1,best_mat2,best_h] = run_ransac(matches1,matches2,img1,img2,iter);
    
    %% Get output
    [img2_T,xmin,ymin] = getoutput(img2,best_h);
    
    %% Stitch
    mat2_H_shifted = dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
    displacement = round(mean(mat2_H_shifted - best_mat1,2));
    [~,stitched] = padstitch(displacement,img1,img2_T);
    
end

figure; imshow(stitched); title("Part 6: RANSAC homography and stitching");
disp('STITCHING DONE!');
