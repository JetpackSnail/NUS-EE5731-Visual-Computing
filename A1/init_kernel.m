function mat = init_kernel(name,s,sig)
switch name
    case 'sobel'
        %           Formula for bigger Sobel filters taken from:
        %           Expansion and Implementation of a 3x3 Sobel and Prewitt Edge
        %           Detection Filter to a 5x5 Dimension Filter
        %           M.Sc. Rana Abdul Rahman Lateef
        %           Baghdad College of Economic Sciences University
        if (mod(s,2) == 0)
            s = s + 1;
        end
        y_mat = zeros(s);
        mid = ceil(s/2);
        for i = mid+1:s
            for j = mid:s
                i2 = i - mid;
                j2 = j - mid;
                y_mat(i,j) = i2 / (i2*i2 + j2*j2);
            end
        end
        y_mat(mid+1:s,1:mid-1) = y_mat(mid+1:s,mid+1:s);
        y_mat(1:mid-1,1:s) = -flip(y_mat(mid+1:s,1:s));
        x_mat = rot90(y_mat,1);
        
        mat = {x_mat, y_mat};
        
    case 'gaussian'
        if (mod(s,2) == 0)
            s = s + 1;
        end
        mat = zeros(s);
        mid = ceil(s/2);
        for i = mid:s
            for j = mid:i
                i2 = i - mid;
                j2 = j - mid;
                mat(i,j) = (1 / (2*pi*(sig^2)) ) * exp(-(j2^2+i2^2) / (2*(sig^2)));
                mat(j,i) = mat(i,j);
            end
        end
        mat(mid:s,1:mid-1) = flip(mat(mid:s,mid+1:s),2);
        mat(1:mid-1,1:s) = flip(mat(mid+1:s,1:s));
        mat = mat/sum(sum(mat));
        
    case 'haar_1'
        mat = ones(2^(s-1),2*2^(s-1));
        mat(1:2^(s-1),1:2^(s-1)) = -mat(1:2^(s-1),1:2^(s-1));
        
    case 'haar_2'
        mat = ones(2*2^(s-1),2^(s-1));
        mat(1:2^(s-1),1:2^(s-1)) = -mat(1:2^(s-1),1:2^(s-1));
        
    case 'haar_3'
        mat = ones(2^(s-1),3*2^(s-1));
        mat(:,2^(s-1)+1:2^(s-1)+2^(s-1)) = -mat(:,2^(s-1)+1:2^(s-1)+2^(s-1));
        
    case 'haar_4'
        mat = ones(3*2^(s-1),2^(s-1));
        mat(2^(s-1)+1:2^(s-1)+2^(s-1),:) = -mat(2^(s-1)+1:2^(s-1)+2^(s-1),:);
        
    case 'haar_5'
        mat = repmat(ones(2),2^(s-1));
        mat(1:0.5*2^(s),1:0.5*2^(s)) = -mat(1:0.5*2^(s),1:0.5*2^(s));
        mat(0.5*2^(s)+1:2^(s),0.5*2^(s)+1:2^(s)) = -mat(0.5*2^(s)+1:2^(s),0.5*2^(s)+1:2^(s));
        
end

end

