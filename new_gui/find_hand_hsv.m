function handles = find_hand_hsv(handles,img,hue,sat,v, isLeft)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    bracelet = handles.bracelet;
    hand = handles.hand;
    BB=adaptive_hand_BB(bracelet.BB,hand.BB, isLeft);
    [n,m]=size(hue);

    hue=hue+0.5;
    mask_hue=hue>=1;
    hue(mask_hue)=hue(mask_hue)-1;

    sat=sat.*(sat>0);

    Yl=max(BB(2),1);
    Yh=min(BB(2)+BB(4),n);
    Xl=max(BB(1),1);
    Xh=min(BB(1)+BB(3),m);
    GMModel=hand.gm;
    tmp=hue(Yl:Yh,Xl:Xh);
    tmp1=sat(Yl:Yh,Xl:Xh);
    tmp2=v(Yl:Yh,Xl:Xh);
    YCBCR = rgb2ycbcr(img);
    YCBCR=YCBCR(Yl:Yh,Xl:Xh,:);
    Cb_small=double(YCBCR(:,:,2))/255;
    Cr_small=double(YCBCR(:,:,3))/255;
    Y_small=double(YCBCR(:,:,1))/255;
    tmpmask=creat_mask_from_gm(GMModel,tmp,tmp1,Cr_small,Cb_small);
    tmpmask=tmpmask.*(tmp2<=0.98).*(tmp2>=0.1);

%     tmpmask=logical((tmp1>=hand.sat_low_th).*(tmp1<=hand.sat_high_th).*(tmp>=hand.hue_low_th).*(tmp<=hand.hue_high_th));
%     tmpmask=logical(tmpmask.*(tmp2>=hand.val_low_th).*(tmp2<=hand.val_high_th));
%     tmpmask=logical(tmpmask.*(Cb_small>=hand.Cb_low_th).*(Cb_small<=hand.Cb_high_th).*(Cr_small>=hand.Cr_low_th).*(Cr_small<=hand.Cr_high_th));
%     tmpmask=logical(tmpmask.*(Y_small>=hand.Y_low_th).*(Y_small<=hand.Y_high_th));
     se90=strel('line',5,90);se0=strel('line',5,0);%changed
     tmpmask=logical(imdilate(tmpmask,[se90 se0]));%changed
     tmpmask=bwareafilt(tmpmask,1,"largest");
     tmpmask=imfill(tmpmask,'holes');

    %mask(Yl:Yh,Xl:Xh)=tmpmask;
    hand.mask = tmpmask;
    hand.BB = BB;
    handles.hand = hand;
end

