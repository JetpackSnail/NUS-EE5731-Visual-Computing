function [m1,m2] = part6_runsift(img1,img2,uniq)
[keypts1,desc1] = vl_sift(single(rgb2gray(img1)));
[keypts2,desc2] = vl_sift(single(rgb2gray(img2)));
[matches, ~] = vl_ubcmatch(desc1, desc2,uniq);

keypt1_coord = [keypts1(1:2,:); ones(1,size(keypts1,2))];              % col,row format (x,y)
keypt2_coord = [keypts2(1:2,:); ones(1,size(keypts2,2))];

% reorder the matches properly
m1 = keypt1_coord(:,matches(1,:));
m2 = keypt2_coord(:,matches(2,:));


%% For plotting 
% match_fig = [img1 img2];
% figure; imshow(match_fig); axis on; hold on ;
% 
% for i = 1:size(matches,2)
%     x = [keypt1_coord(1,matches(1,i)),keypt2_coord(1,matches(2,i))+ size(img1,2)];
%     y = [keypt1_coord(2,matches(1,i)),keypt2_coord(2,matches(2,i))];
%     plot(x,y,'color',rand(1,3),'LineWidth', 1.2); title('Part 6: Matches found from SIFT');
% end; hold off
end

