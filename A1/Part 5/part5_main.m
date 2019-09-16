%% Initialise
clc;
clear;
close all;
% run('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m')
img1 = imread('..\assg1\im01.jpg');
img2 = imread('..\assg1\im02.jpg');

%% Choose img sides. Left image will be transformed.
left_img = img1;
right_img = img2;

%% Run SIFT by VLFeat
% VLFeat is distributed under the BSD license:
% Copyright (C) 2007-11, Andrea Vedaldi and Brian Fulkerson
% Copyright (C) 2012-13, The VLFeat Team
% All rights reserved.
% A frame is a disk of center f(1:2), scale f(3) and orientation f(4)
% Matches also can be filtered for uniqueness by passing a third parameter which specifies a threshold. 
% Uniqueness of a pair is the ratio of the distance between the best matching keypoint and the second best.
% High uniqueness value = filter out more (less matches)
% Low uniqueness value = filter less (more matches)
uniq = 1.5;
[keypts1,desc1] = vl_sift(single(rgb2gray(left_img)));
[keypts2,desc2] = vl_sift(single(rgb2gray(right_img)));
[matches, scores] = vl_ubcmatch(desc1, desc2,uniq);

keypt1_coord = [keypts1(1:2,:); ones(1,size(keypts1,2))];              % col,row format (x,y)
keypt2_coord = [keypts2(1:2,:); ones(1,size(keypts2,2))];
% keypt2_coord_shifted = keypt2_coord + [size(left_img,2) ; 0 ; 0];
match_fig = [left_img right_img];
figure; imshow(match_fig); axis on; hold on ; 

for i = 1:size(matches,2)
    x = [keypt1_coord(1,matches(1,i)),keypt2_coord(1,matches(2,i))+ size(left_img,2)];
    y = [keypt1_coord(2,matches(1,i)),keypt2_coord(2,matches(2,i))];
    % x = [keypt1_coord(1,matches(1,i)),keypt2_coord_shifted(1,matches(2,i))];
    % y = [keypt1_coord(2,matches(1,i)),keypt2_coord_shifted(2,matches(2,i))];
    plot(x,y,'color',rand(1,3),'LineWidth', 1.2); title('Part 5: Matches found from SIFT');
end; hold off

%% RANSAC
% Initialise RANSAC parameters
iter = 5000;
best_inline_count = 0;
e_threshold = 0.5;

% reorder the matches properly
matches1 = keypt1_coord(:,matches(1,:));
matches2 = keypt2_coord(:,matches(2,:));

% start RANSAC iterations
for i = 1:iter
    % choose 4 random pairs of matches and do homography
    idx = randperm(size(matches,2),4);
    mat1 = matches1(:,idx);
    mat2 = matches2(:,idx);
    h = part5_hmat(mat1, mat2);
    
    % check homography for all matches and count  mat2 = h * mat1
    norms = vecnorm(part5_dohomography(matches1,h) - matches2) < e_threshold;
    inline_count = sum(norms);
    
    % best inline count will correspond to best homography matrix
    if inline_count > best_inline_count
        best_norm = norms;
        best_inline_count = inline_count;
        best_h = h;
    end
end

[~, best_cols] = find(best_norm);
best_mat1 = matches1(:,best_cols);
best_mat2 = matches2(:,best_cols);

figure; imshow(match_fig); axis on; hold on ;
for i = 1:best_inline_count
    x = [best_mat1(1,i), best_mat2(1,i)] + [0, size(left_img,2)];
    y = [best_mat1(2,i), best_mat2(2,i)] ;
    plot(x,y,'color',rand(1,3),'LineWidth', 1.2); title('Part 5: Matches found from best RANSAC');
end; hold off;

%% Get output
[output,xmin,ymin] = part5_getoutput(left_img,best_h);

%% Get dimensions of original img1, get displacement of transformed img1 points to img2
height = size(left_img,1);         % vertical y axis
length = size(left_img,2);         % horizontal x axis

mat1_H_shifted = part5_dohomography(best_mat1,best_h) - [xmin-1 ; ymin-1 ; 0];
displacement = round(mean(mat1_H_shifted - best_mat2,2));
x_d = displacement(1,1);
y_d = displacement(2,1);


%% Do padding based on displacement and stitch
if y_d > 0              % horizontal stitching only
    output2 = cat(1,zeros(y_d,length,3),right_img,zeros(size(output,1)-height-y_d,length,3));  	% add rows
    if x_d > 0          % positve y, positive x
        output2 = cat(2,zeros(size(output2,1),x_d,3),output2);                                  % add cols
        output = cat(2,output,zeros(size(output,1),size(output2,2)-size(output,2),3));          % finish padding
    else                % positve y, negative x
        output = cat(2,zeros(size(output,1),abs(x_d),3),output);                                % add cols
        output2 = cat(2,output2,zeros(size(output2,1),size(output,2)-size(output2,2),3));       % finish padding
    end
end

stitched = max(output,output2);
figure; imshow(stitched); %title("Part 5: RANSAC homography and stitching");
imwrite(stitched,'../Part 6/untitled.jpg')