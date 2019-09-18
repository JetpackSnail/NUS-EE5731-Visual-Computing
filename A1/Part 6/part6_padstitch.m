function [output,stitched] = part6_padstitch(displacement,img1,img2_T)
height = size(img1,1);          % vertical y axis,
length = size(img1,2);          % horizontal x axis
x_d = displacement(1,1);
y_d = displacement(2,1);

if y_d > 0              % horizontal stitching only
    output2 = cat(1,zeros(y_d,length,3),img1,zeros(size(img2_T,1)-height-y_d,length,3));  	% add rows
    if x_d > 0          % positve y, positive x
        output2 = cat(2,zeros(size(output2,1),x_d,3),output2);                                  % add cols
        output = cat(2,img2_T,zeros(size(img2_T,1),size(output2,2)-size(img2_T,2),3));          % finish padding
    else                % positve y, negative x
        output = cat(2,zeros(size(img2_T,1),abs(x_d),3),img2_T);                                % add cols
        output2 = cat(2,output2,zeros(size(output2,1),size(output,2)-size(output2,2),3));       % finish padding
    end
end

stitched = max(output,output2);
figure; imshow(stitched); title("Part 5: RANSAC homography and stitching");

end

