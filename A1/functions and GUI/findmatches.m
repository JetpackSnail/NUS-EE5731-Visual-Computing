function m = findmatches(desc1,desc2,threshold)
% Matching function for SIFT. For each desc1, find L2 norm against desc2. Count as match if ratio
% between second smallest norm and smallest norm is more than threshold. 
% High ratio = more strict = less matches ; Low ratio = less strict = more matches
%   desc1, desc2    = descriptors found from VLFeat
%   threshold       = threshold ratio betweeen second smallest norm and smallest norm
%   m               = each column shows matching desc1 on 1st row, and desc2 on 2nd row      
m = [];
for i = 1:size(desc1,2)
    diff = vecnorm(double(desc1(:,i)) - double(desc2));
    sorted = sort(diff);
    if sorted(1,2)/sorted(1,1) > threshold
        [~,c] = min(diff);
        m = cat(2,m,[i;c]);
    end
end
end
