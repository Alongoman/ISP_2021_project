function mask = fix_hand_mask(handles)
mask = handles.hand.mask;
se = strel('disk',5);
b = imclose(mask,se);
mask = imfill(b,'holes');

end


% h5 = imbinarize(rgb2gray(imread("h5_2.png")));
% h3_f = imbinarize(rgb2gray(imread("h3_finger_2.png")));
% h3 = imbinarize(rgb2gray(imread("h3_2.png")));
% 
% tic
% 
% se = strel('disk',7);
% b = imclose(h5,se);
% c = imfill(b,'holes');
% c = medfilt2(c,[7 7]);
% out = count_fingers(c)
% toc
% figure
% 
% imshow(c)