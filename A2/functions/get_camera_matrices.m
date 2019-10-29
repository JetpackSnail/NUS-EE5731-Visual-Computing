function [k1,k2,r1,r2,t1,t2] = get_camera_matrices(filename)
fileID = fopen(filename,'r');
a = fscanf(fileID,'%f');
k1 = (reshape(a(1:9,1),[],3))';
r1 = (reshape(a(10:18,1),[],3))';
t1 = (reshape(a(19:21,1),[],3))';
k2 = (reshape(a(22:30,1),[],3))';
r2 = (reshape(a(31:39,1),[],3))';
t2 = (reshape(a(40:42,1),[],3))';
fclose(fileID);
end

