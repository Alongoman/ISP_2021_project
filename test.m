cam=webcam(2);
frames=200;
figure
% for i = 1:frames
%     img=(snapshot(cam));
%     img=double(rgb2gray(img));
%     img(1:300,1:300,:)=1;
%     imshow(img,[])
% end
%
img=(snapshot(cam));
[h,s,V]=rgb2hsv(img);

figure
subplot(2,1,1)
imshow(h);
colormap("hsv")
colorbar
subplot(2,1,2)
imshow(s,[])
colorbar

Lab=rgb2lab(img);
a_img1=Lab(:,:,2);
b_img1=Lab(:,:,3);

YCBCR=rgb2ycbcr(img);
CB=YCBCR(:,:,2);
CR=YCBCR(:,:,3);


mask=(h>0.72).*(h<0.8);

% mask = medfilt2(mask,[5 5]);
% se90=strel('line',3,90);
% se0=strel('line',3,0);
% mask=imdilate(mask,[se90 se0]);
% mask=imfill(mask,'holes');
% seD=strel('diamond',1);
% mask=imerode(mask,seD);
% mask = medfilt2(mask);
% mask=imerode(mask,seD);

figure
subplot(2,1,1)
imshow(mask,[])
colorbar
subplot(2,1,2)
imshow(uint8(img),[])
colorbar
