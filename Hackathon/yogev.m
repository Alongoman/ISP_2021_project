%%
addpath('functions');
addpath('train');
%% 
img1 = imread("I2_train1.jpg");
img2 = imread("I2_train2.jpg");

%%
img2_n = dip_GN_imread("I2_train1.jpg");
h_2 = dip_hough_circles(edge(img2_n),1,1);
peaks2 = dip_houghpeaks3d(h_2);
H = dip_draw_hough_circle(img2_n,peaks2,1);
display_img(H,"")
%%

res = img1;
[BB, mask] = seg2(res);

res = insertShape(res,"Rectangle",BB);

display_img(res,"diamond in a box")

function display_img(img, head)
figure
imshow(img)
title(head)
end

