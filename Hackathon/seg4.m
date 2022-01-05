function [BB,mask]=seg4(img1)
    img1=double(img1);
    img1=(img1-min(img1(:)))./(max(img1(:)-min(img1(:))));
    [h,s,v]=rgb2hsv(img1);
    Lab=rgb2lab(img1);
    a_img1=Lab(:,:,2);
    b_img1=Lab(:,:,3);
    mask=(s>0.75).*(s<0.80).*(h>0.98).*(b_img1>29).*(b_img1<46).*(a_img1>65).*(a_img1<75);
    mask=mask+(s>0.3).*(s<0.45).*(h>0.05).*(h<0.1).*(b_img1>25).*(b_img1<35).*(a_img1>0).*(a_img1<10);
    mask=mask+(s>0.7).*(s<0.9).*(h>0.15).*(h<0.17).*(b_img1>80).*(b_img1<85).*(a_img1>-20).*(a_img1<-10);
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