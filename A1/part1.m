%% Initialise
clc;
clear;
close all;

%% User-defined parameters
img = imread('C:\Users\MrSandBag\Desktop\pic.jpg');
kernel = 'sobel';            % sobel, gaussian, haar_1, haar_2, haar_3, haar_4, haar_5
sigma = 5;                      % sigma for gaussian kernel
scale = 5;                      % integer scale of kernel

%% Image processing
% get gray image and convolution mask defined above
img_gray = rgb2gray(img);
masks = init_kernel(kernel,scale,sigma);

%% Do convolution on gray image with mask
switch kernel
    case 'sobel'
        output_x = do_convolution(img_gray,masks{1,1},floor(scale/2));
        output_y = do_convolution(img_gray,masks{1,2},floor(scale/2));
        output = output_x + output_y;
    case 'gaussian'
        output = do_convolution(img_gray,masks,floor(scale/2));
    otherwise
end

%% Show results
figure;
imshow(img_gray)
title('Original image')
figure;
imshow(output)
title(['Image after ', kernel, ' convolution'])
if strcmp(kernel,'gaussian')
    xlabel(['Sigma = ', num2str(sigma), ', Scale = ', num2str(scale)]);
else
    xlabel(['Scale = ', num2str(scale)]);
end




