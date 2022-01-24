% test_1
close all;
clc;
clear all;

img = imbinarize(rgb2gray(imread("hand_bin.jpeg")));

[n,m] = size(img);

stats=regionprops(img,'Centroid');
% figure(1); imshow(img);title("orig");

bw = edge(img);
% figure(2);imshow(bw);

center_of_mass = stats(1).Centroid;
x_cent = round(center_of_mass(1));
y_cent = round(center_of_mass(2));
% remove all below center
bw2 = bw;
bw2(y_cent:end,:) = 0;

% figure(3);imshow(bw2);

%find radius
[py,px] = find(bw2==1);
points = vecnorm([px,py]-center_of_mass,2,2);
r = ceil(max(points)/2);

I = zeros(size(bw2));
A = rgb2gray(insertShape(I,'circle',[x_cent,y_cent,r],'LineWidth',1));
counts = ceil((sum(A.*bw2,'all'))/2);
figure(4);imshow(img);title(strcat("fingers:",num2str(counts)));

% figure(5);imshow(A.*bw2,[]);title("masked");
