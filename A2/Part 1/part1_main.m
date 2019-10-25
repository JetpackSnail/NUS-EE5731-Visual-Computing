%% Initialise
clc;
clear;
close all;
addpath(genpath('..\GCMex\'));
addpath('..\functions');
tic;

%% Parameters & Properties
% change this value to change the weight of smoothness or prior term. high value = encourage smoothness between neightbours
ratio = 65;         % ratio = number of patches per dimension (65)
% higher  = more patches, small patchers, take longer time but maybe better results
lambda = 50;        % smoothness factor (45)
num_of_labels = 2;  % number of labels

source_colour = reshape([0; 0; 255],[1,1,3]);       % foreground, 0, blue,   source
sink_colour = reshape([245; 210; 110],[1,1,3]);     % background, 1, yellow, sink

%% Read images
img = imread('..\assg2\bayes_in.jpg');
[H, W, ~] = size(img);
vert = floor(H/ratio);   % height of patch
hor = floor(W/ratio);    % width of patch

%% GraphCut denoising
cleaned_img = zeros(size(img),'like',img);  % initialise canvas 
disp('Start denoise...');

for idx_x = 1:floor(W/hor)
    for idx_y = 1:floor(H/vert)
        ylim = idx_y*vert;
        xlim = idx_x*hor;
        
        if idx_y == floor(H/vert)   % adding the last few rows for a given column
            ylim = H;
        end
        if idx_x == floor(W/hor)    % adding the last few columns for given rows
            xlim = W;
        end
        
        patch = img((idx_y-1)*vert+1 : ylim , (idx_x-1)*hor+1 : xlim,:);                    % get a patch
        restored_patch = graphcut_denoise(patch,lambda,source_colour,sink_colour);          % denoise the patch
        cleaned_img((idx_y-1)*vert+1 : ylim , (idx_x-1)*hor+1 : xlim,:) = restored_patch;	% add patch to canvas

    end
end

figure(1); imshow(img); title('Original noisy image');
figure(2); imshow(cleaned_img); title(['Lambda = ', num2str(lambda),' , Patch size = ',num2str(vert),' x ',num2str(hor)]); 

disp('Denoise done!');
toc

     