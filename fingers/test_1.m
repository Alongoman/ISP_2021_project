% test_1
close all;
clc;
clear all;

img = imbinarize(rgb2gray(imread("hand_bin.jpeg")));
stats=regionprops(img,'Centroid');
% figure(1); imshow(img);
center_of_mass = stats(1).Centroid;

k = 3;

boundry=bwboundaries(img);
mat = cell2mat(boundry);

dist = vecnorm((mat-center_of_mass),2,2);
radius = round(max(dist)/2);

sed=strel('disk',51);
final=imerode(img,sed);
final=imdilate(final,sed);
final=img-final;
final=bwareaopen(final,200);
% final=imerode(final,strel('disk',10));
% final=bwareaopen(final,400);

% [L,num]=bwlabel(final,8);
% final=imclearborder(final,8);


figure(2); imshow(final);


