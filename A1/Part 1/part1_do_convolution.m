%%
% Inputs:
% img_gray  = grayscale image of input
% masks     = the kernel to do convolution with
% x_pad     = size of column padding in input image
% y_pad     = size of row padding in input image
% kernel    = name of kernel (sobel, gaussian, haar_1, haar_2, haar_3, haar_4, haar_5)

% Outputs:
% conv_img  = result of input image convolute with mask

%%
function conv_img = part1_do_convolution(img_gray,masks,x_pad,y_pad,kernel)
img_gray = cat(2,zeros(size(img_gray,1),x_pad),img_gray,zeros(size(img_gray,1),x_pad));
img_gray = cat(1,zeros(y_pad,size(img_gray,2)),img_gray,zeros(y_pad,size(img_gray,2)));

if not(contains(kernel,'haar'))         % sobel and gaussian    
    for i = x_pad + 1 : size(img_gray,2) - x_pad
        for j = y_pad + 1 : size(img_gray,1) - y_pad
            img_crop = img_gray(j-y_pad:j+y_pad,i-x_pad:i+x_pad);
            conv_img(j-y_pad,i-x_pad) = uint8(sum(sum(double(img_crop) .* masks)));
        end
    end
  
else                % haar features
    for i = 1:size(img_gray,2) - (x_pad*2)
        for j = 1:size(img_gray,1) - (y_pad*2)
            img_crop = img_gray(j:j+y_pad,i:i+x_pad);
            conv_img(j,i) = uint8(sum(sum(double(img_crop) .* masks)));
        end
    end
end
end

