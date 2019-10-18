%% Initialise
clc;
clear;
close all;
addpath(genpath('..\GCMex\'));

%% Parameters & Properties
lambda = 25;       % change this value to change the weight of smoothness or prior term. high value = encourage smoothness between neightbours

img = imresize(imread('..\assg2\bayes_in.jpg'),0.3);
img_gray = rgb2gray(img);
img_bin = imbinarize(img_gray,'global');

source_colour = reshape([0; 0; 255],[1,1,3]);       % foreground, 0
sink_colour = reshape([245; 210; 110],[1,1,3]);     % background, 1

num_of_labels = 2;
[height, width] = size(img_bin);

%% GraphCut denoising
% CLASS
% A 1xN vector which specifies the initial labels of each of the N nodes in the graph
class = reshape(img_bin,1,[]);

% UNARY (data)
% A CxN matrix specifying the potentials (data term) for each of the C possible classes at each of the N nodes.
dist_source =   reshape(mean(abs(double(img) - source_colour),3),1,[]);
dist_sink   =  	reshape(mean(abs(double(img) - sink_colour),3),1,[]);
unary = [dist_source; dist_sink];

% PAIRWISE (prior)
% An NxN sparse matrix specifying the graph structure and cost for each link between nodes in the graph.
pairwise = sparse(numel(img_bin),numel(img_bin));
for col = 1:width
    disp([num2str(col),'/',num2str(width)]);
    for row = 1:height
        pixel = row + (col-1) * height;
        % bottom check
        if row < height, pairwise2(pixel, pixel + 1) = 1; pairwise2(pixel + 1, pixel) = 1; end
        % right check
        if col < width, pairwise2(pixel, pixel + height) = 1; pairwise2(pixel + height, pixel) = 1; end
    end
end

% LABELCOST
% A CxC matrix specifying the fixed label cost for the labels of each adjacent node in the graph.
[X, Y] = meshgrid(1:num_of_labels, 1:num_of_labels);
labelcost = (X - Y).*(X - Y) * lambda;

%   EXPANSION:: A 0-1 flag which determines if the swap or expansion method is used to solve the minimization.
%   0 == swap, 1 == expansion. If ommitted, defaults to swap.
[labels, E, Eafter] = GCMex(double(class), single(unary), pairwise, single(labelcost),1);
% figure;imshow(reshape(labels,[height,width]));title(['after',num2str(lambda)]);

