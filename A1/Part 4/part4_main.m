%% Initialise
clc;
clear;
close all;

%% Start GUI to save points on images
[mat1, mat2, img1, img2] = part4_gui;  
disp(['Points saved.' newline 'Computing homography matrix and output...']);

%% Calculate homography matrix
h = part4_hmat(mat1,mat2);

%% Get output image


%% get input img to pixel coordinates
height = size(img1,1);         % vertical y axis
length = size(img1,2);         % horizontal x axis
input_size = length * height;
[input_x, input_y] = meshgrid(linspace(1,length,length), linspace(1,height,height));
input_coord = [input_x(:), input_y(:), ones(input_size,1)]';
input_coord_H = part4_dohomography(input_coord,h);

%% get input corner points tl, tr, bl, br. do homography and get limits of tranformed image
xmax = max(input_coord_H(1,:));           
xmin = min(input_coord_H(1,:));
ymax = max(input_coord_H(2,:));           
ymin = min(input_coord_H(2,:));
xdiff = xmax - xmin;                % difference between horizontal limits
ydiff = ymax - ymin;                % difference between vertical limits

%% split output image into output rows and columns 
[x, y] = meshgrid(linspace(xmin,xmax,xdiff), linspace(ymin,ymax,ydiff));
dim = size(x,1) * size(x,2);
output_coord_H = [x(:), y(:), ones(dim,1)]';      % inteprolated meshgrid values in img2 frame

%% do inverse homography to get back input coordinates x' = Hx and x = H\x'
inputx = h\output_coord_H;
inputx_H = inputx(:,:)./inputx(3,:);      % interpolated img1 coordinates

output = [];
for i = 1:3
    intensity = interp2(double(img1(:,:,i)),inputx_H(1,:),inputx_H(2,:));
    channel = uint8(reshape(intensity, [size(x,1),size(x,2)]));
    output = cat(3,output,channel);
end


%% shift origin of input image
input_coord_H_shifted(1:3,:) = input_coord_H(1:3,:) - [xmin-1 ; ymin-1 ; 0];

%% tansformed input points 
mat1_H_shifted = part4_dohomography(mat1,h) - [xmin-1 ; ymin-1 ; 0];


%% pad images and stitch
displacement = round(mat1_H_shifted - mat2);
x_d = displacement(1,1);
y_d = displacement(2,1);


if y_d > 0
    if x_d > 0          % positve y, positive x
        output2 = cat(1,zeros(y_d,length,3),img2,zeros(size(output,1)-height-y_d,length,3));  	% add rows
        output2 = cat(2,zeros(size(output2,1),x_d,3),output2);                                  % add cols
        output = cat(2,output,zeros(size(output,1),size(output2,2)-size(output,2),3));          % finish padding
    else                % positve y, negative x
        output2 = cat(1,zeros(y_d,length,3),img2,zeros(size(output,1)-height-y_d,length,3));    % add rows
        output = cat(2,zeros(size(output,1),abs(x_d),3),output);                                % add cols
        output2 = cat(2,output2,zeros(size(output2,1),size(output,2)-size(output2,2),3));       % finish padding
    end
end


if y_d < 0
    if x_d > 0          % negative y, positive x
        %     output = cat(1,zeros(abs(y_d),size(output,2),3),output);
        %     d = size(output,1) - size(img2,1);
        %     output2 = cat(1,img2,zeros(d,size(img2,2),3));
        disp('1');
    else                % negative y, negative x
        disp('2');
    end
end

stitched = max(output,output2);


figure;imshow(stitched); title("Part 4: Manual homography and stitching");
% figure;imshow(output); title("Transformed image im01.jpg after homography (padded)");
% figure;imshow(output2); title("Image im02.jpg (padded)");

