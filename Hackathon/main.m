
%%
img = imread("diamond.png");
%display_img(img,"diamond")

%%
BW = edge(rgb2gray(img));
display_img(BW,"edge")

%%
BW = zeros(size(BW));
[poly_x,poly_y] = find(BW==1);
polyin = polyshape(poly_x,poly_y);
[ylim,xlim] = boundingbox(polyin);

%%
dx = xlim(2) - xlim(1);
dy = ylim(2) - ylim(1);
img2 = insertShape(img,"Rectangle",[xlim(1),ylim(1),dx,dy]);

display_img(img2,"diamond in a box")

%%
%img = rgb2gray(img);
[rec, BW2] = dip_edge_detect(img);
img3 = insertShape(img,"Rectangle",rec);
display_img(img3,"function diamond in a box")
%display_img(BW2,"function edge")



































%%
function display_img(img, head)
figure
imshow(img)
title(head)
end
