
function [rec_params,BB] = seg6(img)
[n,m,k] = size(img);
rec_params = zeros([1,4]);
BW = zeros(n,m);

if k < 3
   BW = ones(n,m);
else


[c,m,y,k] = dip_rgb2cymk(

[idx,C] = kmeans(img2,5);
img3 = reshape(idx,n,m);
figure; imshow(img3,[]);
a=0;


end
% %create the polyshape
% [poly_x,poly_y] = find(BW==1);
% polyin = polyshape(poly_x,poly_y);
% [ylim,xlim] = boundingbox(polyin);
% 
% if(length(ylim)<2 || length(xlim)<2)
%     return;
% end
% 
% %rectangular params
% dx = xlim(2) - xlim(1);
% dy = ylim(2) - ylim(1);
% 
% rec_params(1) = xlim(1);
% rec_params(2) = ylim(1);
% rec_params(3) = dx;
% rec_params(4) = dy;

rec_params = uint16(rec_params);
BB = logical(BW);

end