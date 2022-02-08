% test 3
clc
close all
clear all

o0 = imread("o0.png");
o1 = imread("o1.png");
o2 = imread("o2.png");
o3 = imread("o3.png");
o4 = imread("o4.png");
o5 = imread("o5.png");

tic
c0 = count_fingers(o0)
toc

tic
c1 = count_fingers(o1)
toc

tic
c2 = count_fingers(o2)
toc

tic
c3 = count_fingers(o3)
toc

tic
c4 = count_fingers(o4)
toc

tic
c5 = count_fingers(o5)
toc


function counts = count_fingers2(img)
if size(img,3)>1
    img = imbinarize(rgb2gray(img));
else
    img = imbinarize(img);
end

stats=regionprops(img,'Centroid');

bw = edge(img);



center_of_mass = stats(1).Centroid;
x_cent = round(center_of_mass(1));
y_cent = round(center_of_mass(2));

% remove all below center
bw2 = bw;
bw2(y_cent:end,:) = 0;


%find radius
[py,px] = find(bw2==1);
points = vecnorm([px,py]-center_of_mass,2,2);
r = ceil(max(points)/2)*1.2;

I = zeros(size(bw2));
A = rgb2gray(insertShape(I,'circle',[x_cent,y_cent,r],'LineWidth',1));

intersect = A.*bw2;
% counts = ceil((sum(intersect,'all'))/2);
[g,counts] = bwlabel(intersect);
counts = ceil(counts/2);

% figure(1); imshow(img);title("orig");
% figure(2);imshow(bw);
% figure(3);imshow(bw2);
% figure(4);imshow(img);title(strcat("fingers:",num2str(counts)));
% figure(5);imshow(A.*bw2,[]);title("masked");

% B = rgb2gray(insertShape(uint8(255*bw2),'circle',[x_cent,y_cent,r],'LineWidth',1));

% figure();imshow(g,[]);title(num2str(ceil(counts/2)));
% figure();imshow(B,[]);title(num2str(ceil(counts/2)));


end