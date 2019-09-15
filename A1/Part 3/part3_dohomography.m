function mat = part3_dohomography(input_mat,h)
% input_mat = 3xN homogeneous points
% h = homography matrix
% mat = transformed homogeneous coordinates
output = h * input_mat;
mat(1:3,:) = output(:,:)./output(3,:);
end

