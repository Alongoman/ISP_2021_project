function [handles,first_time_hand_BB] = initial_hand_rep_hs(handles,img,points, isLeft)
%initial_hand_rep_hs finds the hand color limitation
%   in order to find the hand in the image using color we first need to
%   find the correct spectrum of the hand in the image, we do it repeatedly 
%   different lighting conditions will give us different results.
%   first_time_hand_BB - while performing the gui we  noticed that it help
%   a lot to know if rthe original hand that was found is good, so using this
%   parameter we can mark the location where the hand was found. 


    err_sat=2;
    if handles.harsh
        err_hue=4;
    else
        err_hue=3;
    end
    err_sat_final=6;
    err_hue_final=4;
    err_val=3;
    % the distance we accept from the mean, which is where the
%   value is of size mean*exp(-err) the bigger it is the more the
%   segmentation will include
    point = floor(points(2,:));
    bracelet = handles.bracelet;
    [n,m]=size(img(:,:,1));
    hand.BB=initial_hand_BB(bracelet.BB,zeros(1,4));
    Yl=max(hand.BB(2),1);
    Yh=min(hand.BB(2)+hand.BB(4),n);
    Xl=max(hand.BB(1),1);
    Xh=min(hand.BB(1)+floor(0.8*hand.BB(3)),m);
    point(1)=point(1)-Xl;
    point(2)=point(2)-Yl;
    [point(1),point(2)] = make_valid(point(1),point(2), m,n);

    [hue,sat,v]=rgb2hsv(img);
    hue_small=hue(Yl:Yh,Xl:Xh);sat_small=sat(Yl:Yh,Xl:Xh);v_small=v(Yl:Yh,Xl:Xh);
    % we have no need to search for the hand in the entire image, so we
    % chose a rectangle around the hand (we dont want to find the face)
    hue_small=hue_small+0.5;
    mask_hue=hue_small>=1;
    hue_small(mask_hue)=hue_small(mask_hue)-1;


    sat_mask=logical(sat_small>0);

    value_mask=logical((v_small>0.35).*sat_mask); %in regions where the 
    % light is too strong or too weak the sturation and hue are not stable.  

    x = [hue_small(value_mask) sat_small(value_mask) v_small(value_mask)];
    x_point=[hue_small(point(2),point(1));sat_small(point(2),point(1));v_small(point(2),point(1))];
    
    if handles.harsh
        num_of_obj=4;
    else
        num_of_obj=3;
    end

    AIC = zeros(1,num_of_obj);
    GMModels = cell(1,num_of_obj);
    options = statset('MaxIter',500);
    for k = 2:num_of_obj
      GMModels{k} = fitgmdist(x,k,'Options',options,'CovarianceType','diagonal');
      AIC(k)= GMModels{k}.AIC;
    end

    [~,numComponents] = min(AIC);
    gmodel = GMModels{numComponents};

    Sigma=zeros(3,numComponents);
    Mu=zeros(3,numComponents);
    dist_vec=zeros(1,numComponents);
    sigma=gmodel.Sigma;
    for k=1:numComponents
        Sigma(:,k)=sigma(:,:,k);
        Mu(:,k)=gmodel.mu(k,:)';
        dist_vec(k)=norm(x_point-Mu(:,k),2);
    end
    [~,hand_k]=min(dist_vec);
    miu_h=Mu(:,hand_k);sigma_h=Sigma(:,hand_k);

    
    hand.sat_low_th = miu_h(2)-sqrt(2*sigma_h(2)*err_sat);
    hand.sat_high_th = miu_h(2)+sqrt(2*sigma_h(2)*err_sat);
    hand.hue_low_th = miu_h(1)-sqrt(2*sigma_h(1)*err_hue);
    hand.hue_high_th = miu_h(1)+sqrt(2*sigma_h(1)*err_hue);
    hand.val_low_th = miu_h(3)-sqrt(2*sigma_h(3)*err_val);
    hand.val_high_th = miu_h(3)+sqrt(2*sigma_h(3)*err_val);
    
    mask=logical(value_mask.*(sat_small>=hand.sat_low_th).*(sat_small<=hand.sat_high_th));
    mask=logical(mask.*(hue_small>=hand.hue_low_th).*(hue_small<=hand.hue_high_th));

    
%     % Hue
%     tmp=hue_small;
%     x = tmp(mask);%here we take the hue that are part of sat group (the hue of object with high sat)
%     x_point=hue_small(point(2),point(1));
% 
% %     gmodel=fitgmdist(x,2);
% %     Sigma=gmodel.Sigma;
% %     sigma_h1=Sigma(:,:,1);
% %     sigma_h2=Sigma(:,:,2);
% %     miu_h1=gmodel.mu(1);
% %     miu_h2=gmodel.mu(2);
% %     if abs(x_point-miu_h1)<=abs(x_point-miu_h2)
% %         miu_h=miu_h1;sigma_h=sigma_h1;
% %     else
% %         miu_h=miu_h2;sigma_h=sigma_h2;
% %     end
%     
%     clust = kmeans(x,2);
%     [miu_h1,sigma_h1]=normfit(x(clust==1));
%     [miu_h2,sigma_h2]=normfit(x(clust==2));
%     if abs(x_point-miu_h2)>abs(x_point-miu_h1)
%         miu_h=miu_h1;sigma_h=sigma_h1^2;
%     else
%         miu_h=miu_h2;sigma_h=sigma_h2^2;
%     end
%     
%     
%     hand.hue_low_th = miu_h-sqrt(2*sigma_h*(err_hue_final));
%     hand.hue_high_th = miu_h+sqrt(2*sigma_h*(err_hue_final));
%     
%     mask=logical(mask.*(tmp>=hand.hue_low_th).*(tmp<=hand.hue_high_th));
% 
% %     % Sat again
%     tmp=sat_small;
%     x = tmp(mask);
%     x_point=sat_small(point(2),point(1));
% %     gmodel=fitgmdist(x,2);
% %     Sigma=gmodel.Sigma;
% %     sigma_h1=Sigma(:,:,1);
% %     sigma_h2=Sigma(:,:,2);
% %     miu_h1=gmodel.mu(1);
% %     miu_h2=gmodel.mu(2);
% %     if abs(x_point-miu_h1)<=abs(x_point-miu_h2)
% %         miu_h=miu_h1;sigma_h=sigma_h1;
% %     else
% %         miu_h=miu_h2;sigma_h=sigma_h2;
% %     end
%     
%     clust = kmeans(x,2);
%     [miu_h1,sigma_h1]=normfit(x(clust==1));
%     [miu_h2,sigma_h2]=normfit(x(clust==2));
%     if abs(x_point-miu_h2)>abs(x_point-miu_h1)
%         miu_h=miu_h1;sigma_h=sigma_h1^2;
%     else
%         miu_h=miu_h2;sigma_h=sigma_h2^2;
%     end
%     
%     
%     hand.sat_low_th = miu_h-sqrt(2*sigma_h*(err_sat_final));
%     hand.sat_high_th = miu_h+sqrt(2*sigma_h*(err_sat_final));


    handles.hand = hand;

    tmpmask=logical((sat_small>=hand.sat_low_th).*(sat_small<=hand.sat_high_th).*(hue_small>=hand.hue_low_th).*(hue_small<=hand.hue_high_th));
   
    tmpmask=bwareafilt(tmpmask,1,"largest");
    
    se90=strel('line',2,90);se0=strel('line',2,0);%changed
    tmpmask=imdilate(tmpmask,[se90 se0]);%changed
    
    tmpmask=imfill(tmpmask,'holes');
    first_time_hand_mask=zeros(size(hue));
    first_time_hand_mask(Yl:Yh,Xl:Xh)=tmpmask;
         % BB Computation
    [poly_x,poly_y] = find(first_time_hand_mask==1);
    polyin = polyshape(poly_x,poly_y);
    [ylim,xlim] = boundingbox(polyin);
    
    handles.hand.mask = first_time_hand_mask;
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

