%% Initialise
clc;
clear;
close all;
addpath(genpath('..\GCMex\'));
addpath('..\functions');

%% Parameters & Properties
lambda = 1;        % smoothness factor
sigma_d = 1;
sigma_c = 1;
d_min = 0;
d_max = 0.01;
m = 100;
levels = m + 1;
d = linspace(d_min,d_max,levels);
r = 255/m;


%% Read images and camera matrix
img1 = imresize(imread('..\assg2\test00.jpg'),1);
img2 = imresize(imread('..\assg2\test09.jpg'),1);

% figure();imshow(img1);title('img1');figure();imshow(img2);title('img2');

[H,W,~] = size(img1);
[K,R,T] = get_camera_matrices('..\assg2\camera_matrices.txt',2);
[X,Y] = meshgrid(linspace(1,W,W),linspace(1,H,H));
coord = [X(:), Y(:), ones(W*H,1)]';         % [X, Y, 1]
% coord_f = coord([2, 1, 3],:);                 % [Y, X, 1]

% CLASS
% A 1xN vector which specifies the initial labels of each of the N nodes in the graph
class = zeros(1,H*W);
% class = randi([0,num_of_labels-1],1,H*W);

% UNARY (data)
% A CxN matrix specifying the potentials (data term) for each of the C possible classes at each of the N nodes.
% unary = zeros(num_of_labels, H*W);
count = 1;
img1_ch1 = reshape(img1(:,:,1),1,[]);
img1_ch2 = reshape(img1(:,:,2),1,[]);
img1_ch3 = reshape(img1(:,:,3),1,[]);
img1_row = [img1_ch1; img1_ch2; img1_ch3];

img2_ch1 = reshape(img2(:,:,1),1,[]);
img2_ch2 = reshape(img2(:,:,2),1,[]);
img2_ch3 = reshape(img2(:,:,3),1,[]);
img2_row = [img2_ch1; img2_ch2; img2_ch3];


for D = d
    diff = img1_row;
    coord_prime = K{2} * R{2}' * R{1} * inv(K{1}) * coord + D * K{2} * R{2}' * (T{1} - T{2}); % [X, Y, W]
    coord_prime(1:3,:) = coord_prime(1:3,:) ./ coord_prime(3,:);        % [X, Y, 1]
    coord_prime = uint16(coord_prime);                              
        
    % get columns with valid coordinates
    col = all(coord_prime(1:2,:) > 0 & coord_prime(1,:) <= W & coord_prime(2,:) <= H);
    
    diff(:,col) = img1_row(:,col) - img2_row(sub2ind([H,W], coord_prime(2,col), coord_prime(1,col)));
    norm = vecnorm(double(diff),2,1);
    
    L_init(count,:) = norm;
    count = count + 1;
end
p_c = sigma_c ./ (sigma_c + L_init);

unary = 1 - (p_c ./ max(p_c));

% PAIRWISE (prior)
% An NxN sparse matrix specifying the graph structure and cost for each link between nodes in the graph.
hor_conn = sparse(ones(W*(H-1), 1));
vert_conn = sparse(repmat([ones(W-1, 1); 0], H, 1));
vert_conn = vert_conn(1:end-1);
pairwise = diag(vert_conn, 1) + diag(hor_conn, W);
pairwise = pairwise + pairwise';

% LABELCOST
% A CxC matrix specifying the fixed label cost for the labels of each adjacent node in the graph.
% labelcost = (ones(num_of_labels) - eye(num_of_labels)) * lambda;
labelcost = abs((meshgrid(1:levels) - meshgrid(1:levels)') * lambda);

% EXPANSION:: A 0-1 flag which determines if the swap or expansion method is used to solve the minimization.
% 0 == swap, 1 == expansion. If ommitted, defaults to swap.
[labels, e, e2] = GCMex(double(class), single(unary), pairwise, single(labelcost),1);
new_labels = uint8(reshape(labels,[H,W]) * r);

imshow(new_labels);







% count  = 1;
% % x = randi(960);
% % y = randi(540);
% x = 724;
% y = 482;
% for d = [0,10e200]
% 
%     x2 = K{2} * R{2}' * R{1} * inv(K{1}) * [x;y;1] + d * K{2} * R{2}' * (T{1} - T{2});
%     x2 = x2/x2(3,1);
%     line(:,count) = x2(:);
%     count = count + 1;
% end
% line_eq = cross(line(:,1),line(:,2));
% piccoord(1,:) = 1:960;
% piccoord(2,:) = (-line_eq(3,1) - line_eq(1,1) * piccoord(1,:))/line_eq(2,1);
% figure; subplot(1,2,1); imshow(img1); hold on; plot(x,y,'Marker','o','MarkerSize',5,'MarkerFaceColor','r'); title('img1'); axis on; hold off;
% subplot(1,2,2); imshow(img2); hold on; plot(line(1,:),line(2,:),'LineWidth',1); title('img2'); axis on;  hold off;
% subplot(1,2,2); imshow(img2); hold on; plot(line(1,:),line(2,:),'Marker','x','Color','red'); title('img2'); axis on;  hold off;
% subplot(1,2,2); imshow(img2); hold on; plot(piccoord(1,:),piccoord(2,:),'Color','red'); title('img2'); axis on;  hold off;




% x = 617;
% y = 343;
% for d = 0.0004
%     x2 = K{2} * R{2}' * R{1} * inv(K{1}) * [x;y;1] + d * K{2} * R{2}' * (T{1} - T{2});
%     x2 = x2/x2(3,1);
% end
% figure; subplot(1,2,1); imshow(img1); hold on; plot(x,y,'Marker','o','MarkerSize',5,'MarkerFaceColor','r'); title('img1'); axis on; hold off;
% subplot(1,2,2); imshow(img2); hold on; plot(x2(1,1),x2(2,1),'Marker','o','MarkerSize',5,'MarkerFaceColor','r'); title('img1'); axis on; hold off;
% 
% 
% 


% figure; imshow([img1 img2]);


% [H, W, ~] = size(img1);
% vert = floor(H/ratio);   % height of patch
% hor = floor(W/ratio);    % width of patch
%
% %%
% for idx_x = 1:floor(W/hor)
%     for idx_y = 1:floor(H/vert)
%         ylim = idx_y*vert;
%         xlim = idx_x*hor;
%
%         if idx_y == floor(H/vert)   % adding the last few rows for a given column
%             ylim = H;
%         end
%         if idx_x == floor(W/hor)    % adding the last few columns for given rows
%             xlim = W;
%         end
%
%         patch = img1((idx_y-1)*vert+1 : ylim , (idx_x-1)*hor+1 : xlim,:);    % get a patch
%         [h, w, ~] = size(patch);
%         % CLASS
%         % A 1xN vector which specifies the initial labels of each of the N nodes in the graph
%
%         class = zeros(1,h*w);
%         % class = randi([0,num_of_labels-1],1,h*w);
%
%         % UNARY (data)
%         % A CxN matrix specifying the potentials (data term) for each of the C possible classes at each of the N nodes.
%         unary = [];
%         for i = 0:num_of_labels-1
%             img2_r = cat(2,zeros(H,i,3),img2(:,1:end-i,:));
%             img2_r_crop = img2_r((idx_y-1)*vert+1 : ylim , (idx_x-1)*hor+1 : xlim,:);
%             diff = double(patch) -  double(img2_r_crop);
%             norms = vecnorm(diff,2,3);
%             norms =  reshape(norms,1,[]);
%             unary = [unary;norms];
%             unary = min(unary,30);
%         end
%
%         % PAIRWISE (prior)
%         % An NxN sparse matrix specifying the graph structure and cost for each link between nodes in the graph.
%         hor_conn = sparse(ones(w*(h-1), 1));
%         vert_conn = sparse(repmat([ones(w-1, 1); 0], h, 1));
%         vert_conn = vert_conn(1:end-1);
%         pairwise = diag(vert_conn, 1) + diag(hor_conn, w);
%         pairwise = pairwise + pairwise';
%
%         % LABELCOST
%         % A CxC matrix specifying the fixed label cost for the labels of each adjacent node in the graph.
%         % labelcost = (ones(num_of_labels) - eye(num_of_labels)) * lambda;
%         labelcost = min(abs((meshgrid(1:num_of_labels) - meshgrid(1:num_of_labels)')),3) * lambda;
%
%         % EXPANSION:: A 0-1 flag which determines if the swap or expansion method is used to solve the minimization.
%         % 0 == swap, 1 == expansion. If ommitted, defaults to swap.
%         [labels, ~, ~] = GCMex(double(class), single(unary), pairwise, single(labelcost),1);
%         new_img_bin = reshape(labels,[h,w]);
%         restored_patch = uint8(new_img_bin*r);
%         cleaned_img((idx_y-1)*vert+1 : ylim , (idx_x-1)*hor+1 : xlim,:) = restored_patch;
%
%     end
% end
% figure(); imshow(cleaned_img); title(['labels = ', num2str(num_of_labels),'lambda = ', num2str(lambda)]);
%
%
%


%
% d = 0;
% coords_2_1 = K{2} * R{2}' * R{1} * inv(K{1}) * coords_1 + d * K{2} * R{2}' * (T{1} - T{2});
% coords_2_1 = coords_2_1(1:3,:) ./ coords_2_1(3,:);
%
% d = 10e100;
% coords_2_2 = K{2} * R{2}' * R{1} * inv(K{1}) * coords_1 + d * K{2} * R{2}' * (T{1} - T{2});
% coords_2_2 = coords_2_2(1:3,:) ./ coords_2_2(3,:);
%
% line = cross(coords_2_1,coords_2_2);
