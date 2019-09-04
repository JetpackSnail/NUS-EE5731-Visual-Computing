function conv_img = do_convolution(img_gray,masks,pad)
img_gray2 = cat(2,zeros(size(img_gray,1),pad),img_gray,zeros(size(img_gray,1),pad));
img_gray2 = cat(1,zeros(pad,size(img_gray2,2)),img_gray2,zeros(pad,size(img_gray2,2)));
for i = pad + 1 : size(img_gray2,1) - pad
    for j = pad + 1 : size(img_gray2,2) - pad
        img_crop = img_gray2(i-pad:i+pad,j-pad:j+pad);
        conv_img(i-pad,j-pad) = uint8(sum(sum(double(img_crop) .* masks)));
    end
end
end

