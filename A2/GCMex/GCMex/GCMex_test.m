%[LABELS ENERGY ENERGYAFTER] = GCMEX(CLASS, UNARY, PAIRWISE, LABELCOST,EXPANSION)
%
%   Runs a minimization starting with the labels for each node defined
%   by CLASS, with unary potentials UNARY and the structure of the
%   graph and pairwise potentials defined by PAIRWISE. LABELCOST
%   determines data costs in terms of the labels of adjacent nodes.
%
% Parameters:
%   CLASS:: A 1xN vector which specifies the initial labels of each of the N nodes in the graph
%   UNARY:: A CxN matrix specifying the potentials (data term) for each of the C possible classes at each of the N nodes.
%   PAIRWISE:: An NxN sparse matrix specifying the graph structure and cost for each link between nodes in the graph.
%   LABELCOST:: A CxC matrix specifying the fixed label cost for the labels of each adjacent node in the graph.
%   EXPANSION:: A 0-1 flag which determines if the swap or expansion method is used to solve the minimization. 
%   0 == swap, 1 == expansion. If ommitted, defaults to swap.
W = 5;
H = 5;
for row = 0:H-1
  for col = 0:W-1
    pixel = 1+ row*W + col;
    if row+1 < H, pairwise(pixel, 1+col+(row+1)*W) = 1; end
    if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = 1; end 
    if col+1 < W, pairwise(pixel, 1+(col+1)+row*W) = 1; end
    if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = 1; end 
  end
end

for row = 1:H
  for col = 1:W
    pixel = sub2ind([H,W],row,col);
    if row < H, pairwise2(pixel, pixel + 1) = 1; pairwise2(pixel + 1, pixel) = 1; end
    if col < W, pairwise2(pixel, pixel + H) = 1; pairwise2(pixel + H, pixel) = 1; end
  end
end








[labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);

fprintf('E: %d (should be 260), Eafter: %d (should be 44)\n', E, Eafter);
fprintf('unique(labels) should be [0 4] and is: [');
fprintf('%d ', unique(labels));
fprintf(']\n');
