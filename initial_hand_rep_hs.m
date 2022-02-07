function [BB,h_low_th,h_high_th,sat_low_th,sat_high_th] = initial_hand_rep_hs(bracelet_BB,img)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    err=2.25;
    [n,m]=size(img(:,:,1));
    BB=adaptive_hand_BB(bracelet_BB,zeros(1,4));
    Yl=max(BB(2),1);
    Yh=min(BB(2)+BB(4),n);
    Xl=max(BB(1),1);
    Xh=min(BB(1)+BB(3),m);

    [hue,sat,v]=rgb2hsv(img(Yl:Yh,Xl:Xh,:));
    value_mask=(v<0.95).*(v>0.05);
    tmp=value_mask.*sat;

    x = tmp(:);
    clust = kmeans(x,2);
    [miu_h1,sigma_h1]=normfit(x(clust==1));
    [miu_h2,sigma_h2]=normfit(x(clust==2));
    if miu_h1>miu_h2
        miu_h=miu_h1;sigma_h=sigma_h1;
    else
        miu_h=miu_h2;sigma_h=sigma_h2;
    end
    
    sat_low_th = miu_h-sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    sat_high_th = miu_h+sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    
    mask=logical((tmp>=sat_low_th).*(tmp<=sat_high_th));
    
    % Hue
    tmp=value_mask.*hue;
    x = tmp(mask);
    clust = kmeans(x,2);
    [miu_h1,sigma_h1]=normfit(x(clust==1));
    [miu_h2,sigma_h2]=normfit(x(clust==2));
    if miu_h1<miu_h2
        miu_h=miu_h1;sigma_h=sigma_h1;
    else
        miu_h=miu_h2;sigma_h=sigma_h2;
    end
    
    h_low_th = miu_h-sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    h_high_th = miu_h+sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    
    % Sat again
    tmp=value_mask.*sat;
    x = tmp(mask);
    clust = kmeans(x,2);
    [miu_h1,sigma_h1]=normfit(x(clust==1));
    [miu_h2,sigma_h2]=normfit(x(clust==2));
    if miu_h1>miu_h2
        miu_h=miu_h1;sigma_h=sigma_h1;
    else
        miu_h=miu_h2;sigma_h=sigma_h2;
    end
    
    sat_low_th = miu_h-sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    sat_high_th = miu_h+sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));

end

