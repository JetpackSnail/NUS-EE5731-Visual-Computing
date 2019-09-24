function mat = dohomography(input_mat,h)
% Multiplies a set of homogeneous coordinates with homography matrix. Outputs normalised homogeneous
% points
%   input_mat   = 3xN homogeneous points
%   h           = homography matrix
%   mat         = transformed homogeneous coordinates
output = h * input_mat;
mat(1:3,:) = output(:,:)./output(3,:);
end

