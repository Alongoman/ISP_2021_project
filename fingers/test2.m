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

polygon = [x,y];%,circshift(x,1),circshift(y,1)];
filled_img = zeros(size(img));
filled_img = imbinarize(rgb2gray(insertShape(filled_img,'FilledPolygon',polygon)));
figure();imshow(filled_img,[]);

sum(filled_img,'all');
sum(img,'all');
sum(filled_img,'all')/sum(img,'all');




[py1,px1] = find(img==1);
radii1 = vecnorm([px1,py1]-center_of_mass,2,2);
disp("a")
max(radii1)/mean(radii1,'all')
figure(1);histogram(radii1,'Normalization','cdf');

img = imbinarize(rgb2gray(imread("o1.png")));
stats=regionprops(img,'Centroid');
center_of_mass = stats(1).Centroid;
x_cent = round(center_of_mass(1));
y_cent = round(center_of_mass(2));
[py,px] = find(img==1);
disp("b")
radii = vecnorm([px,py]-center_of_mass,2,2);
max(radii)/mean(radii,'all')
figure(2);histogram(radii,'Normalization','cdf');
