function [handles,first_time_hand_BB] = initial_hand_rep_hs(handles,img)
%initial_hand_rep_hs finds the hand color limitation
%   in order to find the hand in the image using color we first need to
%   find the correct spectrum of the hand in the image, we do it repeatedly 
%   different lighting conditions will give us different results.
%   first_time_hand_BB - while performing the gui we  noticed that it help
%   a lot to know if rthe original hand that was found is good, so using this
%   parameter we can mark the location where the hand was found. 

    err=2.25;  % the distance we accept from the mean, which is where the
%   value is of size mean*exp(-err) the bigger it is the more the
%   segmentation will include
    bracelet = handles.bracelet;
    [n,m]=size(img(:,:,1));
    hand.BB=adaptive_hand_BB(bracelet.BB,zeros(1,4));
    Yl=max(hand.BB(2),1);
    Yh=min(hand.BB(2)+hand.BB(4),n);
    Xl=max(hand.BB(1),1);
    Xh=min(hand.BB(1)+hand.BB(3),m);

    [hue,sat,v]=rgb2hsv(img);
    hue_small=hue(Yl:Yh,Xl:Xh);sat_small=sat(Yl:Yh,Xl:Xh);v_small=v(Yl:Yh,Xl:Xh);
    % we have no need to search for the hand in the entire image, so we
    % chose a rectangle around the hand (we dont want to find the face)

    value_mask=(v_small<0.95).*(v_small>0.05); %in regions where the 
    % light is too strong or too weak the sturation and hue are not stable.  
    tmp=value_mask.*sat_small; %so we ignore those areas.

    x = tmp(:);
    clust = kmeans(x,2); %here we assume that the hand sat is higher than the surroundings 
    [miu_h1,sigma_h1]=normfit(x(clust==1));%we also assume that there are only 2 groups
    % the hand and the background.
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
    x = tmp(mask);%here we take the hue that are part of sat group (the hue of object with high sat)
    clust = kmeans(x,2);
    [miu_h1,sigma_h1]=normfit(x(clust==1));
    [miu_h2,sigma_h2]=normfit(x(clust==2));
    if miu_h1<miu_h2 %here we take the low hue
        miu_h=miu_h1;sigma_h=sigma_h1;
    else
        miu_h=miu_h2;sigma_h=sigma_h2;
    end
    
    hand.hue_low_th = miu_h-sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    hand.hue_high_th = miu_h+sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    
    mask=logical(mask.*(tmp>=hand.hue_low_th).*(tmp<=hand.hue_high_th));

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

