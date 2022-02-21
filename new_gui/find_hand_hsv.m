function handles = find_hand_hsv(handles,hue,sat,v)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    bracelet = handles.bracelet;
    hand = handles.hand;
    BB=adaptive_hand_BB(bracelet.BB,hand.BB);
    [n,m]=size(hue);

    hue=hue+0.5;
    mask_hue=hue>=1;
    hue(mask_hue)=hue(mask_hue)-1;

    sat=sat.*(sat>0.1);

    Yl=max(BB(2),1);
    Yh=min(BB(2)+BB(4),n);
    Xl=max(BB(1),1);
    Xh=min(BB(1)+BB(3),m);

    tmp=hue(Yl:Yh,Xl:Xh);
    tmp1=sat(Yl:Yh,Xl:Xh);
    tmp2=v(Yl:Yh,Xl:Xh);
    tmpmask=logical((tmp1>=hand.sat_low_th).*(tmp1<=hand.sat_high_th).*(tmp>=hand.hue_low_th).*(tmp<=hand.hue_high_th));
    tmpmask=logical(tmpmask.*(tmp2>=hand.val_low_th).*(tmp2<=hand.val_high_th));
    
    tmpmask=medfilt2(tmpmask);
    tmpmask=bwareafilt(tmpmask,1,"largest");

    se90=strel('line',2,90);se0=strel('line',2,0);%changed
%    tmpmask=imdilate(tmpmask,[se90 se0]);%changed

%    tmpmask=imfill(tmpmask,'holes');

    %mask(Yl:Yh,Xl:Xh)=tmpmask;
    hand.mask = tmpmask;
    hand.BB = BB;
    handles.hand = hand;
end

