
function [rec_params,BW] = seg6(img)
[n,m,k] = size(img);
rec_params = zeros([1,4]);
BW = zeros(n,m);

if k < 3
   BW = ones(n,m);
else

[c,m,y,k] = dip_rgb2cymk(img);
img3 = m;

th = 0.45;
img3 = norm_pic(img3);
img3(img3<th) = 0;
img3(img3>=th) = 1;

% img3 = imgaussfilt(img3,10);
img3 = medfilt2(img3,[5,5]);

BW = uint16(img3);

end
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
BW = logical(BW);



end

function [C,Y,M,K] = dip_rgb2cymk(img) % get a N x M x 4 matrix
    img = norm_pic(img);
    K = min(1-img,[],3);
    C = (1-K-img(:,:,1))./(1-K);
    M = (1-K-img(:,:,2))./(1-K);
    Y = (1-K-img(:,:,3))./(1-K);
end

function normalized_pic = norm_pic(gs_pic)
gs_pic = double(gs_pic);
normalized_pic = (gs_pic - min(gs_pic(:)))/(max(gs_pic(:))-min(gs_pic(:)));
end