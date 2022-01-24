% test_1
close all;
clc;
clear all;

img = imbinarize(rgb2gray(imread("hand_bin.jpeg")));

[n,m] = size(img);

stats=regionprops(img,'Centroid');
figure(1); imshow(img);title("orig");

bw = edge(img);
figure(2);imshow(bw);

center_of_mass = stats(1).Centroid;
x_cent = center_of_mass(1);
y_cent = center_of_mass(2);
img2 = img;
img2(y_cent:end,:) = 0;
