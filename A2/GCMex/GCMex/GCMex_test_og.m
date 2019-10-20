clear
W = 10;
H = 5;
segclass = zeros(50,1);
pairwise = sparse(50,50);
unary = zeros(7,25);
[X Y] = meshgrid(1:7, 1:7);
labelcost = min(4, (X - Y).*(X - Y));

for row = 0:H-1
  for col = 0:W-1
    pixel = 1+ row*W + col;
    if row+1 < H, pairwise(pixel, 1+col+(row+1)*W) = 1; end
    if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = 1; end 
    if col+1 < W, pairwise(pixel, 1+(col+1)+row*W) = 1; end
    if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = 1; end 
    if pixel < 25
      unary(:,pixel) = [0 10 10 10 10 10 10]'; 
    else
      unary(:,pixel) = [10 10 10 10 0 10 10]'; 
    end
  end
end

[labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),1);

fprintf('E: %d (should be 260), Eafter: %d (should be 44)\n', E, Eafter);
fprintf('unique(labels) should be [0 4] and is: [');
fprintf('%d ', unique(labels));
fprintf(']\n');


r = H;                         % Get the matrix size
c = W;
diagVec1 = sparse(repmat([ones(c-1, 1); 0], r, 1));  % Make the first diagonal vector
                                             %   (for horizontal connections)
diagVec1 = diagVec1(1:end-1);                % Remove the last value
diagVec2 = sparse(ones(c*(r-1), 1));                 % Make the second diagonal vector
                                             %   (for vertical connections)
pairwise2 = diag(diagVec1, 1) + diag(diagVec2, c);   % Add the diagonals to a zero matrix
pairwise2 = pairwise2 + pairwise2';
