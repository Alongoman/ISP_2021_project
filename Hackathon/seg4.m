function [BB,mask]=seg4(img1)
    img1=double(img1);
    img1=(img1-min(img1(:)))./(max(img1(:)-min(img1(:))));
    [h,s,v]=rgb2hsv(img1);
    Lab=rgb2lab(img1);
    a_img1=Lab(:,:,2);
    b_img1=Lab(:,:,3);
    mask=(s>0.75).*(h>0.98).*(b_img1>29).*(b_img1<46).*(a_img1>50).*(a_img1<75);
    mask=mask+(s>0.3).*(s<0.65).*(h>0.05).*(h<0.15).*(b_img1>25).*(b_img1<45).*(a_img1>0).*(a_img1<10);
    mask=mask+(s>0.65).*(h<0.2).*(b_img1>60).*(b_img1<90).*(a_img1>-20).*(a_img1<0);
    mask = medfilt2(mask);
    mask = medfilt2(mask);
    mask = medfilt2(mask,[5 5]);
    mask = medfilt2(mask,[5 5]);
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