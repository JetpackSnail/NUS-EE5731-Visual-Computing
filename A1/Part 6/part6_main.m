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























% %%
% for i = 1:9
%     pic = imread(['..\assg1\pic',num2str(i) ,'.jpg']);
%     pic = imresize(pic,0.2);
%     imwrite(pic,['..\assg1\mod_pic',num2str(i) ,'.jpg'])
% end
% 






%%
% randorder = randperm(4,4);
% for i = 1:num_of_imgs
%     idx = randorder(i);
%     rand_img_cell{i} = imread(['..\assg1\im0',num2str(idx) ,'.jpg']);
% end
% 
% for i = 1:num_of_imgs
%     disp(i);
%     for j = 1:num_of_imgs
%         disp(j);
%         if i == j
%             A(i,j) = 0;
%             continue
%         end
%         img1 = rand_img_cell{i};
%         img2 = rand_img_cell{j};
%         [matches1, matches2] = part6_runsift(img1,img2,uniq);
%         [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2);
%         A(i,j) = 6+0.2*size(matches1,2) - size(best_mat1,2);
%     end
% end

%%












% 
% 
% 
% 
% %% Left first stitch
% img1 = img_cell{order(1)};
% img2 = img_cell{order(2)};             % img 2 is transformed
% 
% [matches1, matches2] = part6_runsift(img1,img2,uniq);
% [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2);
% [img2_T,xmin,ymin] = part6_getoutput(img2,best_h);
% 
% mat2_H_shifted = part6_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
% displacement = round(mean(mat2_H_shifted - best_mat1,2));
% [~,stitched2] = part6_padstitch(displacement,img1,img2_T);
% 
% %% Right first stitch
% img1 = stitched2;
% img2 = img_cell{order(3)};             % img 2 is transformed
% 
% % img2_2 = zeros(size(img1,1),'like',img1);
% % img2_2(1:size(img2,1),1:size(img2,2),1:size(img2,3)) = img2(:,:,:);
% 
% [matches1, matches2] = part6_runsift(img1,img2,uniq);
% [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2);
% [img2_T,xmin,ymin] = part6_getoutput(img2,best_h);
% 
% mat2_H_shifted = part6_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
% displacement = round(mean(mat2_H_shifted - best_mat1,2));
% [~,stitched2] = part6_padstitch(displacement,img1,img2_T);
% 
% %% Left second stitch
% img1 = stitched2;
% img2 = img_cell{order(4)};             % img 2 is transformed
% 
% % img2_2 = zeros(size(img1),'like',img1);
% % img2_2(1:size(img2,1),1:size(img2,2),1:size(img2,3)) = img2(:,:,:);
% 
% [matches1, matches2] = part6_runsift(img1,img2,uniq);
% [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2);
% [img2_T,xmin,ymin] = part6_getoutput(img2,best_h);
% 
% mat2_H_shifted = part6_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
% displacement = round(mean(mat2_H_shifted - best_mat1,2));
% [~,stitched2] = part6_padstitch(displacement,img1,img2_T);
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %%
% % next few stitches
% % img1 = img2_TP;
% % img2 = img_cell{4};             % img 2 is transformed
% % 
% % img2_2 = zeros(size(img1),'like',img1);
% % img2_2(1:size(img2,1),1:size(img2,2),1:size(img2,3)) = img2(:,:,:);
% % 
% % [matches1, matches2] = part6_runsift(img1,img2_2,uniq);
% % [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2_2);
% % [img2_T,xmin,ymin] = part6_getoutput(img2,best_h);
% % 
% % mat2_H_shifted = part6_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
% % displacement = round(mean(mat2_H_shifted - best_mat1,2));
% % [img2_TP,stitched2] = part6_padstitch(displacement,stitched2,img2_T);
% 
% %%
% 
% 
% 
% 
% 
% 
% 
% 
% % 
% % 
% % 
% % img1 = stitched2;
% % img2 = img_cell{4};             % img 2 is transformed
% % 
% % img2_2 = zeros(size(img1),'like',img1);
% % img2_2(1:size(img2,1),1:size(img2,2),1:size(img2,3)) = img2(:,:,:);
% % 
% % [matches1, matches2] = part6_runsift(img1,img2_2,uniq);
% % [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2_2);
% % [img2_T,xmin,ymin] = part6_getoutput(img2,best_h);
% % 
% % mat2_H_shifted = part6_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
% % displacement = round(mean(mat2_H_shifted - best_mat1,2));
% % 
% % 
% % height = size(stitched2,1);          % vertical y axis,
% % length = size(stitched2,2);          % horizontal x axis
% % x_d = displacement(1,1);
% % y_d = displacement(2,1);
% % 
% % if y_d > 0              % horizontal stitching only
% %     output2 = cat(1,zeros(y_d,length,3),stitched2,zeros(size(img2_T,1)-height-y_d,length,3));  	% add rows
% %     if x_d > 0          % positve y, positive x
% %         output2 = cat(2,zeros(size(output2,1),x_d,3),output2);                                  % add cols
% %         output = cat(2,img2_T,zeros(size(img2_T,1),size(output2,2)-size(img2_T,2),3));          % finish padding
% %     else                % positve y, negative x
% %         output = cat(2,zeros(size(img2_T,1),abs(x_d),3),img2_T);                                % add cols
% %         output2 = cat(2,output2,zeros(size(output2,1),size(output,2)-size(output2,2),3));       % finish padding
% %     end
% % end
% % 
% % 
% % 
% % [img2_TP,stitched2] = part6_padstitch(displacement,stitched2,img2_T);
% 
% 
%     
%     
% %     if j ~= 2
% %         img1 = img2_TP;
% %         img2 = img_cell{j};
% %         
% %         img2_2 = zeros(size(img1),'like',img1);
% %         img2_2(1:size(img2,1),1:size(img2,2),1:size(img2,3)) = img2(:,:,:);
% %         
% %         [matches1, matches2] = part6_runsift(img1,img2_2,uniq);
% %         [best_mat1,best_mat2,best_h] = part6_ransac(matches1,matches2,img1,img2_2);
% %         [img2_T,xmin,ymin] = part6_getoutput(img2,best_h);
% %         
% %         mat2_H_shifted = part6_dohomography(best_mat2,best_h) - [xmin-1 ; ymin-1 ; 0];
% %         displacement = round(mean(mat2_H_shifted - best_mat1,2));
% %         [img2_TP,stitched2] = part6_padstitch(displacement,stitched2,img2_T);




% Given N images,




		% n = 2
		% find sift matches between img 1 and img 2. output = coordinates of matches
		% use ransac to get best matches. output = coordinates of best matches
		% calculate homography matrix. output = homography matrix between img 1 and img 2
		% transform img 2 with homography matrix. output = transformed img 2
		% find displacement, pad img 1 and transformed img 2. output = padded img 1 and padded transformed img 2
		% stitch padded img 1 and padded transformed img 2. output = stitched img: img 2'
		
		% n = 3
		% find sift matches between padded transformed img 2 and img 3. output = coordinates of matches
		% use ransac to get best matches. output = coordinates of best matches
		% calculate homography matrix. output = homography matrix between padded transformed img 2 and img 3
		% transform img 3 with homography matrix. output = transformed img 3
		% find displacement, pad img 2' and transformed img 3. output = padded img 2' and padded transformed img 3
		% stitch padded img 2' and padded transformed img 3. output = stitched img: img 3'

		% n = 4
		% find sift matches between padded transformed img 3 and img 4. output = coordinates of matches
		% use ransac to get best matches. output = coordinates of best matches
		% calculate homography matrix. output = homography matrix between padded transformed img 3 and img 4
		% transform img 4 with homography matrix. output = transformed img 4
		% find displacement, pad img 3' and transformed img 4. output = padded img 3' and padded transformed img 4
		% stitch padded img 3' and padded transformed img 4. output = stitched img: img 4'
		
		
		
		
		
		% for i = 2:N
		
		
		% if i == 2
		% find sift matches between img i-1 and img i. output = coordinates of matches
		% use ransac to get best matches. output = coordinates of best matches
		% calculate homography matrix. output = homography matrix between img i-1 and img i
		% transform img i with homography matrix. output = transformed img i
		% find displacement, pad img i-1 and transformed img i. output = padded img i-1 and padded transformed img i
		% stitch padded img i-1 and padded transformed img i. output = stitched img: img i'
		
		
		% if i != 2
		% find sift matches between padded transformed img i-1 and img i. output = coordinates of matches
		% use ransac to get best matches. output = coordinates of best matches
		% calculate homography matrix. output = homography matrix between padded transformed img i-1 and img i
		% transform img i with homography matrix. output = transformed img i
		% find displacement, pad img i-1' and transformed img i. output = padded img i-1' and padded transformed img i
		% stitch padded img i-1' and padded transformed img i. output = stitched img: img i'
		
		
		% for i = 3:N
		%	img i' = part6_stitch(img i-1', padded transformed img i-1, img i)
		% end 
		
		
		% end 
		
		
		
% 
