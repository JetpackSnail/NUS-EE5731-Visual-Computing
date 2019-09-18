%% Initialise
clc;
clear;
close all;

%% Start GUI to save points on images
[mat1, mat2, img1, img2] = part4_gui;  
disp(['Points saved.' newline 'Computing homography matrix and output...']);

%% Calculate homography matrix
h = part4_hmat(mat1,mat2);

%% Get output
[output,xmin,ymin] = part4_getoutput(img1,h);

%% Get dimensions of original img1, get displacement of transformed img1 points to img2
height = size(img1,1);         % vertical y axis
length = size(img1,2);         % horizontal x axis
mat1_H_shifted = part4_dohomography(mat1,h) - [xmin-1 ; ymin-1 ; 0];
displacement = round(mat1_H_shifted - mat2);
x_d = displacement(1,1);
y_d = displacement(2,1);

%% Do padding based on displacement and stitch
if y_d > 0              % only horizontal stitiching
    output2 = cat(1,zeros(y_d,length,3),img2,zeros(size(output,1)-height-y_d,length,3));  	% add rows
    if x_d > 0          % positve y, positive x
        output2 = cat(2,zeros(size(output2,1),x_d,3),output2);                                  % add cols
        output = cat(2,output,zeros(size(output,1),size(output2,2) - size(output,2),3));          % finish padding
    else                % positve y, negative x
        output = cat(2,zeros(size(output,1),abs(x_d),3),output);                                % add cols
        output2 = cat(2,output2,zeros(size(output2,1),size(output,2) - size(output2,2),3));       % finish padding
    end
end

stitched = max(output,output2);

figure; imshow(stitched);    title("Part 4: Manual homography and stitching");