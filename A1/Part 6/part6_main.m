%% Initialise
clc;
clear;
close all;
run('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m')

%% Function parameters and Ordering
num_of_imgs = 9;
uniq = 2.0;         % uniqness ratio for SIFT

for i = 1:num_of_imgs
    img_cell{i} = imread(['..\assg1\mod_pic',num2str(i) ,'.jpg']);   % 928 x 522 x 3
end

for j = 0:num_of_imgs-1
    idx = ((-1)^j) * ceil(j/2) + round((num_of_imgs + 1) / 2);
    order(j+1) = idx;
end

%% begin stitching
tic
for j = 2:num_of_imgs
    disp(['Doing stitch ', num2str(j),'/',num2str(num_of_imgs),'....']);
    if j == 2
        img1 = img_cell{order(j-1)};
    else
        img1 = stitched;
    end
    
    img2 = img_cell{order(j)};             % img 2 is transformed
    
    [matches1, matches2] = part6_runsift(img1,img2,uniq);
    [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2);
    [img2_T,xmin,ymin] = part6_getoutput(img2,best_h);
    
    mat2_H_shifted = part6_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
    displacement = round(mean(mat2_H_shifted - best_mat1,2));
    [~,stitched] = part6_padstitch(displacement,img1,img2_T);
    
end
figure; imshow(stitched); title("Part 6: RANSAC homography and stitching");
disp(['Stitching took ',num2str(toc),' seconds']);
