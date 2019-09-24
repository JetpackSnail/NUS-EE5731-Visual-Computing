function [output2,stitched] = padstitch(displacement,img1,img2_T)
h1 = size(img1,1);              % vertical y axis,
len1 = size(img1,2);            % horizontal x axis
h2 = size(img2_T,1);
len2 = size(img2_T,2);

x_d = displacement(1,1);
y_d = displacement(2,1);

if y_d > 0
    output1 = cat(1,zeros(y_d,len1,3),img1,zeros(h2-h1-y_d,len1,3));  	% add rows
    output2 = cat(1,img2_T,zeros(size(output1,1)-h2,len2,3));
    if x_d > 0          % positve y, positive x 
        output1 = cat(2,zeros(size(output1,1),x_d,3),output1,zeros(size(output1,1),size(output2,2)-size(output1,2)-x_d,3));  	% add cols
        output2 = cat(2,output2,zeros(size(output2,1),size(output1,2)-size(output2,2),3));      % finish padding
    else                % positve y, negative x ()
        output2 = cat(2,zeros(size(output2,1),abs(x_d),3),output2);   	% add cols
        output1 = cat(2,output1,zeros(size(output1,1),size(output2,2)-size(output1,2),3));  	% finish padding
    end
end


if y_d < 0
    output2 = cat(1,zeros(abs(y_d),len2,3),img2_T,zeros(h1-h2+y_d,len2,3));  	% add rows
    output1 = cat(1,img1,zeros(abs(h1-h2+y_d),size(img1,2),3));
    if x_d > 0          % negative y, positive x ()
        output1 = cat(2,zeros(size(output1,1),x_d,3),output1);                                  % add cols
        output2 = cat(2,output2,zeros(size(output2,1),size(output1,2)-size(output2,2),3));  	% finish padding
    else                % negative y, negative x 
        output2 = cat(2,zeros(size(output2,1),abs(x_d),3),output2);                             % add cols
        output1 = cat(2,output1,zeros(size(output1,1),size(output2,2)-size(output1,2),3));  	% finish padding
    end
end


stitched = max(output1,output2);

end

