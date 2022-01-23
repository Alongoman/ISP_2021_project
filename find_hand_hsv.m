function [tmpmask,BB] = find_hand_hsv(braclet_BB,hue,sat,h_low_th,h_high_th,sat_low_th,sat_high_th,old_hand_BB)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    BB=adaptive_hand_BB(braclet_BB,old_hand_BB);
    mask=zeros(size(hue));
    [n,m]=size(hue);

    Yl=max(BB(2),1);
    Yh=min(BB(2)+BB(4),n);
    Xl=max(BB(1),1);
    Xh=min(BB(1)+BB(3),m);

    tmp=hue(Yl:Yh,Xl:Xh);
    tmp1=sat(Yl:Yh,Xl:Xh);
    tmpmask=logical((tmp1>=sat_low_th).*(tmp1<=sat_high_th).*(tmp>=h_low_th).*(tmp<=h_high_th));
   
    se90=strel('line',3,90);se0=strel('line',3,0);%changed
    tmpmask=imdilate(tmpmask,[se90 se0]);%changed
    tmpmask=bwareafilt(tmpmask,1,"largest");
    tmpmask=imfill(tmpmask,'holes');

    mask(Yl:Yh,Xl:Xh)=tmpmask;
end

