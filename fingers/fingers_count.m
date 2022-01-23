close all
clear all
clc

%% Read Image
img=imread('3.jpeg');

%% Show image
figure(1)
imshow(img);
title('Image read in')
img3 = img;
%% Noise addition
% [noise]=vsg('GaussianNoise',img,20);
% noise = imgaussfilt(img,20);
%[rotate]=vsg('RotateImg',noise,30);

%% Scale given image and filter background noise
% [img2]=vsg('ScaleImg',noise,1400,1400); 
% [img3]=vsg('Median',img2);
% figure(2)
% imshow(img);

%% Convert to greyscale and display the result 
img3=col2gray(img3); 
img3=uint8(img3); 

%% data driven threshold based on the max/min of the image histogram 
hi_grey=vsg('HighestGrey',img3); 
disp('highestgrey done'); 
lo_grey=vsg('LowestGrey',img3); 
disp('lowestgrey done'); 
thresh=uint8(3*(hi_grey+lo_grey)/4);

%% apply a lowpass filter to input image to remove any noise in the image 
%% display the resulting image 
img4=vsg('LowPass',img3); 
disp('lowpass done'); 
 
%% apply the threshold to the image and display the resultant binary image 
img5=vsg('Threshold',img4,thresh);
disp('threshold done'); 
img5=uint8(img5); 
figure(2);
imshow(img5);

%% invert Image
[img6]=vsg('Inverse',img5);
figure(3);
imshow(img6);
title ('Inverted Binary Image')

%% mask boundary pixels to avoid any edge effects 
img7=vsg('MaskImg',img6,20); 
figure(4);
image(uint8(img7));

%% Get width
[num1]=vsg('GetWidth',img3); 
[num2]=num1*.5;

%% Thin
[img8]=vsg('ThinImg',img7,70); 

%% Join lines
[img9]=vsg('LINFilter',img8);
figure(5);
image(uint8(img9));

%% Apply centroid and find position
[img10]=vsg('Centroid',img9);
[p1]=vsg('FWP',img10);

%% Fill Circle
[img11]=vsg('FillCircle',img9,p1,num2,[0,0,0]);

%% Fill box
[img12]=vsg('FillBox',img11,[0,1200],[1400,1400],[0,0,0]);
figure(6);
image(uint8(img12));

%% Count the number of blobs and display finger count
[num3]= vsg('CountBlobs',img12);
figure(7);
image(uint8(img));
text(50,50,strcat('\color{red}Finger count:',num2str(num3)))