function [handles,first_time_hand_BB] = initial_hand_rep_hs(handles,img)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    err=2.25;
    bracelet = handles.bracelet;
    [n,m]=size(img(:,:,1));
    hand.BB=adaptive_hand_BB(bracelet.BB,zeros(1,4));
    Yl=max(hand.BB(2),1);
    Yh=min(hand.BB(2)+hand.BB(4),n);
    Xl=max(hand.BB(1),1);
    Xh=min(hand.BB(1)+hand.BB(3),m);

    [hue,sat,v]=rgb2hsv(img);
    hue_small=hue(Yl:Yh,Xl:Xh);sat_small=sat(Yl:Yh,Xl:Xh);v_small=v(Yl:Yh,Xl:Xh);
    value_mask=(v_small<0.95).*(v_small>0.05);
    tmp=value_mask.*sat_small;

    x = tmp(:);
    clust = kmeans(x,2);
    [miu_h1,sigma_h1]=normfit(x(clust==1));
    [miu_h2,sigma_h2]=normfit(x(clust==2));
    if miu_h1>miu_h2
        miu_h=miu_h1;sigma_h=sigma_h1;
    else
        miu_h=miu_h2;sigma_h=sigma_h2;
    end
    
    hand.sat_low_th = miu_h-sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    hand.sat_high_th = miu_h+sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    
    mask=logical((tmp>=hand.sat_low_th).*(tmp<=hand.sat_high_th));
    
    % Hue
    tmp=value_mask.*hue_small;
    x = tmp(mask);
    clust = kmeans(x,2);
    [miu_h1,sigma_h1]=normfit(x(clust==1));
    [miu_h2,sigma_h2]=normfit(x(clust==2));
    if miu_h1<miu_h2
        miu_h=miu_h1;sigma_h=sigma_h1;
    else
        miu_h=miu_h2;sigma_h=sigma_h2;
    end
    
    hand.hue_low_th = miu_h-sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    hand.hue_high_th = miu_h+sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    
    % Sat again
    tmp=value_mask.*sat_small;
    x = tmp(mask);
    clust = kmeans(x,2);
    [miu_h1,sigma_h1]=normfit(x(clust==1));
    [miu_h2,sigma_h2]=normfit(x(clust==2));
    if miu_h1>miu_h2
        miu_h=miu_h1;sigma_h=sigma_h1;
    else
        miu_h=miu_h2;sigma_h=sigma_h2;
    end
    
    hand.sat_low_th = miu_h-sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    hand.sat_high_th = miu_h+sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));



    handles.hand = hand;

    tmpmask=logical((sat_small>=hand.sat_low_th).*(sat_small<=hand.sat_high_th).*(hue_small>=hand.hue_low_th).*(hue_small<=hand.hue_high_th));
    se90=strel('line',3,90);se0=strel('line',3,0);%changed
    tmpmask=imdilate(tmpmask,[se90 se0]);%changed
    tmpmask=bwareafilt(tmpmask,1,"largest");
    tmpmask=imfill(tmpmask,'holes');
    first_time_hand_mask=zeros(size(hue));
    first_time_hand_mask(Yl:Yh,Xl:Xh)=tmpmask;
         % BB Computation
    [poly_x,poly_y] = find(first_time_hand_mask==1);
    polyin = polyshape(poly_x,poly_y);
    [ylim,xlim] = boundingbox(polyin);

    if(length(ylim)<2 || length(xlim)<2)
        BB=0;
        return;
    end

    
    %rectangular params
    dx = xlim(2) - xlim(1);
    dy = ylim(2) - ylim(1);
    
    rec_params(1) = xlim(1);
    rec_params(2) = ylim(1);
    rec_params(3) = dx;
    rec_params(4) = dy;
    
    first_time_hand_BB = uint16(rec_params);
   

end

