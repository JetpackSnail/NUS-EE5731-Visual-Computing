function h_mat = part6_hmat(mat1, mat2)   
A = zeros(8,9);
j = 1;
for i = 1:4
    x1 = mat1(1,i);
    y1 = mat1(2,i);
    x2 = mat2(1,i);
    y2 = mat2(2,i);
    a_pt = [x1, y1, 1, 0, 0, 0, -x2*x1, -x2*y1, -x2 ; 0, 0, 0, x1, y1, 1, -y2*x1, -y2*y1, -y2];
    
    A(j:j+1,:) = a_pt;
    j = j + 2;
end
[~ , ~, V] = svd(A);
h_mat = reshape(V(:,end),[3,3])';
end

