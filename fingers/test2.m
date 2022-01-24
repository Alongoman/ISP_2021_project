% test_1
close all;
clc;
clear all;

img = imbinarize(rgb2gray(imread("o0.png")));
stats=regionprops(img,'Centroid');
center_of_mass = stats(1).Centroid;
x_cent = round(center_of_mass(1));
y_cent = round(center_of_mass(2));

[py,px] = find(img==1);
k = boundary(px,py);

x = px(k);
y = py(k);

polygon = [x,y];
filled_img = zeros(size(img));
filled_img = insertShape(filled_img,'FilledPolygon',polygon);
figure();imshow(filled_img,[]);




% 
% [py1,px1] = find(img==1);
% radii1 = vecnorm([px1,py1]-center_of_mass,2,2);
% figure(1);histogram(radii1,'Normalization','cdf');
% 
% img = imbinarize(rgb2gray(imread("o5.png")));
% stats=regionprops(img,'Centroid');
% center_of_mass = stats(1).Centroid;
% x_cent = round(center_of_mass(1));
% y_cent = round(center_of_mass(2));
% [py,px] = find(img==1);
% radii = vecnorm([px,py]-center_of_mass,2,2);
% figure(2);histogram(radii,'Normalization','cdf');
