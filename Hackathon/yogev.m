
%% 
img1 = imread("I2_train1.jpg");
img2 = imread("I2_train2.jpg");

%%
[BB, mask] = seg2(img1);

%%
img1 = insertShape(img1,"Rectangle",BB);

display_img(img1,"diamond in a box")

function display_img(img, head)
figure
imshow(img)
title(head)
end

