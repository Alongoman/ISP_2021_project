% test_1
close all;
clc;
clear all;

img = imbinarize(rgb2gray(imread("hand_bin.jpeg")));

[n,m] = size(img);

stats=regionprops(img,'Centroid');
figure(1); imshow(img);title("orig");
center_of_mass = stats(1).Centroid;
x_cent = center_of_mass(1);
y_cent = center_of_mass(2);
img2 = img;
img2(y_cent:end,:) = 0;

figure(2); imshow(img2);title("2");

stats2=regionprops(img2,'Centroid');

stats2(1)
stats2(2)
stats2(3)
stats2(4)
stats2(5)




% [yi,xi] = find(img==1);
% r = max(xi)-x_cent;
% 
% x_vec = 1:m;
% y_vec = 1:n;


% points_vec = zeros(n*m,2);

% for i=1:n
%     for j=1:m
%         points_vec((i-1)*m+j,:) = [x_vec(i),y_vec(j)];
%     end
% end

% points = vecnorm(points_vec-center_of_mass,2,2);
% points = reshape(points,[n,m]);
% img2(points<r) = 0;
% 
% figure(2); imshow(img2);
% bw = edge(img);
% figure(2); imshow(bw);
% 
% [a,h,v,d] = dwt2(bw,'haar','mode','sym');
% % figure(3);imagesc(h);title("h");
% % figure(4); imshow(d);title("d");
% % figure(5); imshow(v);title("v");
% figure(6); imshow(a-h);title("sub");
% s = sum(bw,2);
% m = max(s)


% k = 3;
% 
% boundry=bwboundaries(img);
% mat = cell2mat(boundry);
% 
% dist = vecnorm((mat-center_of_mass),2,2);
% radius = round(max(dist)/2);

% sed=strel('disk',51);
% final=imerode(img,sed);
% final=imdilate(final,sed);
% final=img-final;
% final=bwareaopen(final,200);
% final=imerode(final,strel('disk',10));
% final=bwareaopen(final,400);

% [L,num]=bwlabel(final,8);
% final=imclearborder(final,8);


% figure(3); imshow(final);


