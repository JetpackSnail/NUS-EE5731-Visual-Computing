function restored_patch = graphcut_denoise(patch,lambda,source_colour,sink_colour)
patch_gray = rgb2gray(patch);
patch_bin = imbinarize(patch_gray,'global');
[h, w] = size(patch_bin);

% CLASS
% A 1xN vector which specifies the initial labels of each of the N nodes in the graph
class = reshape(patch_bin,1,[]);

% UNARY (data)
% A CxN matrix specifying the potentials (data term) for each of the C possible classes at each of the N nodes.
dist_source =   reshape(mean(abs(double(patch) - source_colour),3),1,[]);
dist_sink   =  	reshape(mean(abs(double(patch) - sink_colour),3),1,[]);
unary = [dist_source ; dist_sink];

% PAIRWISE (prior)
% An NxN sparse matrix specifying the graph structure and cost for each link between nodes in the graph.
hor_conn = sparse(ones(w*(h-1), 1));
vert_conn = sparse(repmat([ones(w-1, 1); 0], h, 1));                                         
vert_conn = vert_conn(1:end-1); 
pairwise = diag(vert_conn, 1) + diag(hor_conn, w);       
pairwise = pairwise + pairwise';

% LABELCOST
% A CxC matrix specifying the fixed label cost for the labels of each adjacent node in the graph.
labelcost = [0 1 ; 1 0] * lambda;

% EXPANSION:: A 0-1 flag which determines if the swap or expansion method is used to solve the minimization.
% 0 == swap, 1 == expansion. If ommitted, defaults to swap.
[labels, ~, ~] = GCMex(double(class), single(unary), pairwise, single(labelcost),1);
new_img_bin = reshape(labels,[h,w]);

restored_img  = [];

for i = 1:3
    c = zeros(h,w);
    c(new_img_bin == 0) = source_colour(:,:,i);
    c(new_img_bin == 1) = sink_colour(:,:,i);
    restored_img = cat(3,restored_img,c);
end
restored_patch = uint8(restored_img);
% figure(3); subplot(1,2,1); imshow(patch);
% figure(3); subplot(1,2,2); imshow(restored_img); title(['lambda = ',num2str(lambda)]);

end

