%% Initialise
clc;
clear;
close all;
addpath('..\functions and GUI')

%% User-defined parameters
img = imread('..\assg1\testpic1.jpg');
kernel = 'sobel';               % sobel, gaussian, haar_1, haar_2, haar_3, haar_4, haar_5
sigma = 3;                      % sigma for use in gaussian kernel only, no effect on others
scale = 2;                      % scale of kernel, will be rounded to nearest int if double

%% Image processing
% get gray image
if size(size(img),2) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% get convolution mask 
masks = part1_init_kernel(kernel,scale,sigma);

% get size of padding 
x_pad = floor(scale/2);
y_pad = x_pad;

%% Do convolution on gray image with mask
switch kernel
    case 'sobel'
        output_x = part1_do_convolution(img_gray,masks{1,1},x_pad,y_pad,kernel);
        output_y = part1_do_convolution(img_gray,masks{1,2},x_pad,y_pad,kernel);
        output = output_x + output_y;
    case 'gaussian'
        output = part1_do_convolution(img_gray,masks,x_pad,y_pad,kernel);
    otherwise
        x_pad = size(masks,2)-1;
        y_pad = size(masks,1)-1;
        output = part1_do_convolution(img_gray,masks,x_pad,y_pad,kernel);
end

%% Show results
if strcmp(kernel,'sobel')
    figure; imshow(output_x); title('Image after G_x Sobel kernel');
    figure; imshow(output_y); title('Image after G_y Sobel kernel');
end

figure; imshow(img_gray); title('Original image')
figure; imshow(output); title(['Image after ', kernel, ' convolution'])

if strcmp(kernel,'gaussian')
    xlabel(['Sigma = ', num2str(sigma), ', Scale = ', num2str(scale)]);
else
    xlabel(['Scale = ', num2str(scale)]);
end