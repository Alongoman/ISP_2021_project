function handles = initial_bracelet_rep_hs(handles,img,points,color)
    point = points(1,:);
    h=250;
    w=250;
    err=0.5;
    bracelet.alpha = 0.5;
    if strcmp(color,'green')
        init_low_th = 0.2;
        init_high_th = 0.45;
    else
        init_low_th = 0.72;
        init_high_th = 0.8;
    end
    %% Initial Mask computation
    mask=zeros(size(img(:,:,1)));
    [n,m]=size(mask);
    Yl=max(point(2)-h/2,1);
    Yh=min(point(2)+h/2,n);
    Xl=max(point(1)-w/2,1);
    Xh=min(point(1)+w/2,m);
    img_init=img(Yl:Yh,Xl:Xh,:);
    img_init=double(img_init-min(img_init(:))./(max(img_init(:))-min(img_init(:))));
    [hue,sat,~]=rgb2hsv(img_init);
    tmp_mask=(hue>init_low_th).*(hue<init_high_th).*(sat>0.2).*(sat<0.95);
    tmp_mask=bwareafilt(logical(tmp_mask),1,"largest");
    mask(Yl:Yh,Xl:Xh)=tmp_mask;
    %% BB Computation
    [poly_x,poly_y] = find(tmp_mask==1);
    polyin = polyshape(poly_x,poly_y);
    [ylim,xlim] = boundingbox(polyin);

    if(length(ylim)<2 || length(xlim)<2)
        BB=0;
        return;
    end

    
    %rectangular params
    dx = xlim(2) - xlim(1);
    dy = ylim(2) - ylim(1);
    
    rec_params(1) = xlim(1)+Xl;
    rec_params(2) = ylim(1)+Yl;
    rec_params(3) = dx;
    rec_params(4) = dy;
    
    BB = uint16(rec_params);
    mask = logical(mask);
    %% Adaptive Threshold Calculation
    x = hue(tmp_mask);
    clust = kmeans(x,2);
    if sum(clust==1)>sum(clust==2)
        x = x(clust==1);
    else
        x = x(clust==2);
    end
    [miu_h,sigma_h]=normfit(x);
    bracelet.hue_low_th = miu_h-sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    bracelet.hue_high_th = miu_h+sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));

%     clust = kmeans(x,2);
%     if sum(clust==1)>sum(clust==2)
%         x = x(clust==1);
%     else
%         x = x(clust==2);
%     end
%% Here We Calc the sat thresh
    x = sat(tmp_mask);
    clust = kmeans(x,2);
    [miu_h1,sigma_h1]=normfit(x(clust==1));
    [miu_h2,sigma_h2]=normfit(x(clust==2));
    if miu_h1>miu_h2
        miu_h=miu_h1;sigma_h=sigma_h1;
    else
        miu_h=miu_h2;sigma_h=sigma_h2;
    end

    bracelet.sat_low_th = miu_h-sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));
    bracelet.sat_high_th = miu_h+sqrt(2*sigma_h^2*(err-0.5*log(2*pi*sigma_h^2)));

%%
    [hue_tot, sat_tot,~]=rgb2hsv(img);
    mask_tot =logical((sat_tot>=bracelet.sat_low_th).*(sat_tot<bracelet.sat_high_th).*(hue_tot>=bracelet.hue_low_th).*(hue_tot<bracelet.hue_high_th));
    valid_mask=double(~(or((~mask_tot),mask)));
    se90=strel('line',3,90);se0=strel('line',3,0);%changed
    valid_mask=imdilate(valid_mask,[se90 se0]);%changed
    valid_mask=imfill(valid_mask,'holes');
    valid_mask=~valid_mask;
    bracelet.valid_mask = valid_mask;
    bracelet.BB = BB;
    bracelet.center = [BB(1)+BB(3)/2 BB(2)+BB(4)/2];
    handles.bracelet = bracelet;
end

