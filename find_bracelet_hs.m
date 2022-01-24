function [mask,BB]=find_bracelet_hs(hue,sat,hue_low_th,hue_high_th,sat_low_th,sat_high_th,braclet_BB)
      [n,m]=size(hue);

    if braclet_BB(1)~=0
        xlim=braclet_BB(1);
        ylim=braclet_BB(2);
        dx=braclet_BB(3);
        Xl=max(1,xlim-3*dx);
        Xh=min(m,xlim+3*dx);
        Yl=max(1,ylim-3*dx);
        Yh=min(n,ylim+3*dx);

    else
        Xl=1;
        Xh=m;
        Yl=1;
        Yh=n;
    end
    mask=(zeros(size(hue)));
    tmp_hue=hue(Yl:Yh,Xl:Xh);
    tmp_sat=sat(Yl:Yh,Xl:Xh);
    tmpmask=logical((tmp_hue>=hue_low_th).*(tmp_hue<=hue_high_th).*(tmp_sat>=sat_low_th).*(tmp_sat<=sat_high_th));
    se90=strel('line',3,90);se0=strel('line',3,0);%changed
    tmpmask=imdilate(tmpmask,[se90 se0]);%changed
    tmpmask=bwareafilt(tmpmask,1,"largest");
    tmpmask=imfill(tmpmask,'holes');%changed
    mask(Yl:Yh,Xl:Xh)=tmpmask;
        %% BB Computation
    [poly_x,poly_y] = find(mask==1);
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
    
    BB = uint16(rec_params);


end