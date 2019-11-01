%% Initialise
clc;
clear;
close all;
addpath(genpath('..\GCMex\'));
addpath('..\functions');

%% Parameters & Properties
% change this value to change the weight of smoothness or prior term. high value = encourage smoothness between neightbours
ratio = 1;         % ratio = number of patches per dimension (1)
% higher  = more patches, small patchers, take longer time but maybe better results
lambda = 1;        % smoothness factor (15)
num_of_labels = 60;  % number of labels (60)
r = 255/(num_of_labels - 1);

%% Read images
img1 = imread('..\assg2\left.png');
img2 = imread('..\assg2\right.png');

% figure(1);imshow(img1);title('left');figure(2);imshow(img2);title('right');
[H, W, ~] = size(img1);
vert = floor(H/ratio);   % height of patch
hor = floor(W/ratio);    % width of patch

%%
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
        
        patch = img1((idx_y-1)*vert+1 : ylim , (idx_x-1)*hor+1 : xlim,:);    % get a patch
        [h, w, ~] = size(patch);
        % CLASS
        % A 1xN vector which specifies the initial labels of each of the N nodes in the graph
        
        class = zeros(1,h*w);
        % class = randi([0,num_of_labels-1],1,h*w);
        
        % UNARY (data)
        % A CxN matrix specifying the potentials (data term) for each of the C possible classes at each of the N nodes.
        unary = [];
        for i = 0:num_of_labels-1
            img2_r = cat(2,img2(:,1+i:end,:),zeros(H,i,3));
            img2_r_crop = img2_r((idx_y-1)*vert+1 : ylim , (idx_x-1)*hor+1 : xlim,:);
            diff = double(patch) -  double(img2_r_crop);
            norms = vecnorm(diff,2,3);
            norms =  reshape(norms,1,[]);
            unary = [unary;norms];
            unary = min(unary,40);
        end
        
        % PAIRWISE (prior)
        % An NxN sparse matrix specifying the graph structure and cost for each link between nodes in the graph.
        hor_conn = sparse(ones(w*(h-1), 1));
        vert_conn = sparse(repmat([ones(w-1, 1); 0], h, 1));
        vert_conn = vert_conn(1:end-1);
        pairwise = diag(vert_conn, 1) + diag(hor_conn, w);
        pairwise = pairwise + pairwise';
        
        % LABELCOST
        % A CxC matrix specifying the fixed label cost for the labels of each adjacent node in the graph.
        % labelcost = (ones(num_of_labels) - eye(num_of_labels)) * lambda;
        labelcost = min(abs((meshgrid(1:num_of_labels) - meshgrid(1:num_of_labels)')),3) * lambda;
        
        % EXPANSION:: A 0-1 flag which determines if the swap or expansion method is used to solve the minimization.
        % 0 == swap, 1 == expansion. If ommitted, defaults to swap.
        [labels, ~, ~] = GCMex(double(class), single(unary), pairwise, single(labelcost),1);
        new_img_bin = reshape(labels,[h,w]);
        restored_patch = uint8(new_img_bin*r);
        cleaned_img((idx_y-1)*vert+1 : ylim , (idx_x-1)*hor+1 : xlim,:) = restored_patch;
        
    end
end
figure(); imshow(cleaned_img); title(['labels = ', num2str(num_of_labels),'lambda = ', num2str(lambda)]);