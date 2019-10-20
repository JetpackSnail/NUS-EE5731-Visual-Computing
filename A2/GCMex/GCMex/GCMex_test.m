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
clear
W = 576;
H = 567;
for row = 0:H-1
  for col = 0:W-1
    pixel = 1+ row*W + col;
    if row+1 < H, pairwise(pixel, 1+col+(row+1)*W) = 1; end
    if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = 1; end 
    if col+1 < W, pairwise(pixel, 1+(col+1)+row*W) = 1; end
    if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = 1; end 
  end
end
sum(sum(pairwise))



% 
% for row = 0:H-1
%   for col = 0:W-1
%     pixel = 1+ row*W + col;
%     if row+1 < H, pairwise(pixel, 1+col+(row+1)*W) = 1; end
%     if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = 1; end 
%     if col+1 < W, pairwise(pixel, 1+(col+1)+row*W) = 1; end
%     if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = 1; end 
%   end
% end

% ii = 1:H*W;
% c = zeros(H*W,H*W);
% 
% for idx = 1:H*W
%     btm = idx + 1;
%     right = idx + H;
%     
%     if ceil(btm/H) <= H
%         jj(1,btm) = idx;
%         c(idx,btm) = 1;
%         c(btm,idx) = 1;
%     end
%     if ceil(right/H) <= W
%         jj(1,right) = idx;
%         c(idx,right) = 1;
%         c(right,idx) = 1;
%     end
% end
% 
% pairwise - c




% 
% 
% [labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);
% 
% fprintf('E: %d (should be 260), Eafter: %d (should be 44)\n', E, Eafter);
% fprintf('unique(labels) should be [0 4] and is: [');
% fprintf('%d ', unique(labels));
% fprintf(']\n');
