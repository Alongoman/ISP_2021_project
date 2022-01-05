
function [rec_params,BW] = dip_edge_detect(img)

if(size(img,3)>1)
    img = rgb2gray(img);
end

rec_params = zeros([1,4]);
BW = edge(img);

%create the polyshape
[poly_x,poly_y] = find(BW==1);
polyin = polyshape(poly_x,poly_y);
[ylim,xlim] = boundingbox(polyin);

if(length(ylim)<2 || length(xlim)<2)
    return;
end

%rectangular params
dx = xlim(2) - xlim(1);
dy = ylim(2) - ylim(1);

rec_params(1) = xlim(1);
rec_params(2) = ylim(1);
rec_params(3) = dx;
rec_params(4) = dy;

rec_params = uint16(rec_params);

end