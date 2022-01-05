%%
addpath('functions');

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
[BB, mask] = seg2(img2);

img2 = insertShape(img2,"Rectangle",BB);

display_img(img2,"diamond in a box")

function display_img(img, head)
figure
imshow(img)
title(head)
end

