%% Initialise
clc;
clear;
close all;

%% Start GUI to save points on images
[mat1, mat2, img1, img2] = part3_gui;  
disp(['Points saved.' newline 'Computing homography matrix and output...']);

%% Calculate homography matrix
h = hmat(mat1,mat2);

%% Get output image
% get limits of input image and do homography
[max_x, min_x, max_y, min_y] = part3_getlimits(img1,h);

% get limits of output image
xlim = size(img2,2);
ylim = size(img2,1);

% split output image into output rows and columns 
[x, y] = meshgrid(linspace(min_x,max_x,xlim), linspace(min_y,max_y,ylim));
X=[x(:), y(:), ones(xlim*ylim,1)];

% do inverse homography to get back input coordinates x' = Hx and x = H\x'
inputx = h\X';
inputx_H = inputx(1:2,:)./inputx(3,:);

% estimate intensity values at calculated input coordinates at each colour channel and merge
output = [];
for i = 1:3
    intensity = interp2(double(img1(:,:,i)),inputx_H(1,:),inputx_H(2,:));
    channel = uint8(reshape(intensity, [ylim,xlim]));
    output = cat(3,output,channel);
end
imshow(output);