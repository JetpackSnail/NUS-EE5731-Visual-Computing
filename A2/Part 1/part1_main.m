%   labels for each node defined by CLASS
%   unary potentials UNARY 
%   the structure of the graph and pairwise potentials defined by PAIRWISE 
%   LABELCOST determines data costs in terms of the labels of adjacent nodes.


%% Initialise
clc;
clear;
close all;
addpath(genpath('..\GCMex\'));

%% Parameters & Properties
% change this value to change the weight of smoothness or prior term. high value = encourage smoothness between neightbours
lambda = 0.9;
img = imresize(imread('..\assg2\bayes_in.jpg'),0.4);   
figure; imshow(img);
img_gray = rgb2gray(img);
img_bin = imbinarize(img_gray,'global');

source_colour = reshape([0; 0; 255],[1,1,3]);       % foreground, 0, blue
sink_colour = reshape([245; 210; 110],[1,1,3]);     % background, 1, yellow

% img2  = [];
% for i = 1:3
%     c = img(:,:,i);
%     c(img_bin(:,:)) = sink_colour(:,:,i);
%     c(~img_bin(:,:)) = source_colour(:,:,i);
%     img2 = cat(3,img2,c);
% end

num_of_labels = 2;
[H, W] = size(img_bin);

%% GraphCut denoising
% CLASS
% A 1xN vector which specifies the initial labels of each of the N nodes in the graph
class = reshape(img_bin,1,[]);

% UNARY (data)
% A CxN matrix specifying the potentials (data term) for each of the C possible classes at each of the N nodes.
% dist_source = abs(class - source_colour);
% dist_sink   = abs(class - sink_colour);
dist_source =   reshape(mean(abs(double(img) - source_colour),3),1,[]);
dist_sink   =  	reshape(mean(abs(double(img) - sink_colour),3),1,[]);
unary = [dist_source ; dist_sink];

% PAIRWISE (prior)
% An NxN sparse matrix specifying the graph structure and cost for each link between nodes in the graph.
% pairwise = sparse(numel(img_bin),numel(img_bin));
% for row = 0:H-1
%     tic
%     disp(row);
%     for col = 0:W-1
%         pixel = 1+ row*W + col;
%         if row+1 < H
%             pairwise(pixel, 1+col+(row+1)*W) = lambda;
%             pairwise(1+col+(row+1)*W,pixel) = lambda;
%         end
%         % if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = 1; end
%         if col+1 < W
%             pairwise(pixel, 1+(col+1)+row*W) = lambda;
%             pairwise(1+(col+1)+row*W,pixel) = lambda;
%         end
%         % if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = 1; end
%     end
%     toc
% end
diagVec1 = sparse(repmat([ones(W-1, 1); 0], H, 1));  % Make the first diagonal vector
                                             %   (for horizontal connections)
diagVec1 = diagVec1(1:end-1);                % Remove the last value
diagVec2 = sparse(ones(W*(H-1), 1));                 % Make the second diagonal vector
                                             %   (for vertical connections)
pairwise = diag(diagVec1, 1) + diag(diagVec2, W);   % Add the diagonals to a zero matrix
pairwise = pairwise + pairwise';

% LABELCOST
% A CxC matrix specifying the fixed label cost for the labels of each adjacent node in the graph.

% [X, Y] = meshgrid(1:num_of_labels, 1:num_of_labels);
% labelcost = (X - Y).*(X - Y) * lambda;
labelcost = [1 65 ; 65 1] * lambda;



%   EXPANSION:: A 0-1 flag which determines if the swap or expansion method is used to solve the minimization.
%   0 == swap, 1 == expansion. If ommitted, defaults to swap.
[labels, E, Eafter] = GCMex(double(class), single(unary), pairwise, single(labelcost),1);
new_img_bin = reshape(labels,[H,W]);
% figure; imshow(img_bin);
% figure; imshow(new_img_bin); title(['lambda = ',num2str(lambda)]);
diff = E-Eafter;
disp(diff);

restored_img  = [];

for i = 1:3
    c = zeros(H,W);
    c(new_img_bin == 0) = source_colour(:,:,i);
    c(new_img_bin == 1) = sink_colour(:,:,i);
    restored_img = cat(3,restored_img,c);
end
restored_img = uint8(restored_img);
figure; imshow(restored_img); title(['lambda = ',num2str(lambda)]);

% foreground, 0,    blue,   [0; 0; 255],        source
% background, 1,    yellow,	[245; 210; 110],    sink



 