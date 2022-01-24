function [BB,mask]=seg5(img1)
    img1=double(img1);
    img1=(img1-min(img1(:)))./(max(img1(:)-min(img1(:))));
    [h,s,v]=rgb2hsv(img1);
    Lab=rgb2lab(img1);
    a_img1=Lab(:,:,2);
    b_img1=Lab(:,:,3);
    
    mask=(s>0.6).*(s<0.85).*(h>0).*(h<0.1).*(b_img1>15).*(b_img1<57).*(a_img1>10).*(a_img1<85);
    mask = medfilt2(mask);
    mask = medfilt2(mask);
    mask = medfilt2(mask,[5 5]);
    mask = medfilt2(mask,[5 5]);
    se90=strel('line',3,90);
    se0=strel('line',3,0);
    mask=imdilate(mask,[se90 se0]);
    mask=imfill(mask,'holes');
    se90=strel('line',3,90);
    se0=strel('line',3,0);
    mask=imdilate(mask,[se90 se0]);
    mask=imfill(mask,'holes');
    se90=strel('line',3,90);
    se0=strel('line',3,0);
    mask=imdilate(mask,[se90 se0]);
    mask=imfill(mask,'holes');
    se90=strel('line',3,90);
    se0=strel('line',3,0);
    mask=imdilate(mask,[se90 se0]);
    mask=imfill(mask,'holes');
    se90=strel('line',3,90);
    se0=strel('line',3,0);
    mask=imdilate(mask,[se90 se0]);
    mask=imfill(mask,'holes');

    [poly_x,poly_y] = find(mask==1);
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
    
    BB = uint16(rec_params);
    mask = logical(mask);
end

