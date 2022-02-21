% function mask = fix_hand_mask(mask)
% 
% 
% end


h5 = imbinarize(rgb2gray(imread("h5_2.png")));
h3_f = imbinarize(rgb2gray(imread("h3_finger_2.png")));
h3 = imbinarize(rgb2gray(imread("h3_2.png")));

imshow(h3)