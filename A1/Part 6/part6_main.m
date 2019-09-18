%% Initialise
clc;
clear;
close all;

run('..\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup.m')
num_of_imgs = 5;
for i = 1:num_of_imgs
    img_cell{i} = imread(['..\assg1\im0',num2str(i) ,'.jpg']);
end

for j = 2:4
    if j == 2
        uniq = 1.5;
        img1 = img_cell{j-1};
        img2 = img_cell{j};
        
        [matches1, matches2] = part6_runsift(img1,img2,uniq);
        [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2);
        [img2_T,xmin,ymin] = part6_getoutput(img2,best_h);
           
        mat2_H_shifted = part6_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
        displacement = round(mean(mat2_H_shifted - best_mat1,2));
        [img2_TP,stitched2] = part6_padstitch(displacement,img1,img2_T);
    end
    
    if j ~= 2
        uniq = uniq + 1;
        img1 = img2_TP;
        img2 = img_cell{j};
        
        img2_2 = zeros(size(img1),'like',img1);
        img2_2(1:size(img2,1),1:size(img2,2),1:size(img2,3)) = img2(:,:,:);
        
        [matches1, matches2] = part6_runsift(img1,img2_2,uniq);
        [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2_2);
        [img2_T,xmin,ymin] = part6_getoutput(img2,best_h);
        
        mat2_H_shifted = part6_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
        displacement = round(mean(mat2_H_shifted - best_mat1,2));
        [img2_TP,stitched2] = part6_padstitch(displacement,stitched2,img2_T);

    end
end