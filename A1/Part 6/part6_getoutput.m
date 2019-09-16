function [output,min_x,min_y] = part6_getoutput(img1,h)
% get limits of input image and do homography
[max_x, min_x, max_y, min_y] = part6_getlimits(img1,h);
xdiff = round(max_x - min_x);
ydiff = round(max_y - min_y);

% split output image into output rows and columns 
[x, y] = meshgrid(linspace(min_x,max_x,xdiff), linspace(min_y,max_y,ydiff));
X = [x(:), y(:), ones(xdiff*ydiff,1)];      % interpolated meshgrid coordinates in img2 frame

% do inverse homography to get back input coordinates x' = Hx and x = H\x'
inputx = h\X';
inputx_H = inputx(:,:)./inputx(3,:);      % interpolated meshgrid coordinates in img1 frame 

% estimate intensity values at calculated input coordinates at each colour channel and merge
output = [];
for i = 1:3
    intensity = interp2(double(img1(:,:,i)),inputx_H(1,:),inputx_H(2,:));
    channel = uint8(reshape(intensity, [ydiff,xdiff]));
    output = cat(3,output,channel);
end
end