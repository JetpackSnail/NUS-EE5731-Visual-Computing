% returns K,R,T matrix from camera text file 
% inputs: filename = filename of txt file
%         n = number of camera matrix to take
function [K,R,T] = get_camera_matrices(filename, n)
fileID = fopen(filename,'r');
a = fscanf(fileID,'%f');
for i = 1:n
    first = (i-1)*21+1;
    K{i} = (reshape(a(first:first+8,1),[],3))';
    R{i} = (reshape(a(first+9:first+17,1),[],3))';
    T{i} = (reshape(a(first+18:first+20,1),[],3))';
end
fclose(fileID);
% k1 = (reshape(a(1:9,1),[],3))';
% r1 = (reshape(a(10:18,1),[],3))';
% t1 = (reshape(a(19:21,1),[],3))';
% 
% k2 = (reshape(a(22:30,1),[],3))';
% r2 = (reshape(a(31:39,1),[],3))';
% t2 = (reshape(a(40:42,1),[],3))';

end

