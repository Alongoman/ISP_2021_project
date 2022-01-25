function handles=find_bracelet_hs(handles,hue,sat)
    [n,m]=size(hue);
    bracelet = handles.bracelet;
    hue = bracelet.valid_mask.*hue;
    sat = bracelet.valid_mask.*sat;
    if bracelet.BB(1)~=0
        xlim=bracelet.BB(1);
        ylim=bracelet.BB(2);
        dx=bracelet.BB(3);
        if dx <=45
            dx=45;
        end
        Xl=max(1,xlim-9*dx);
        Xh=min(m,xlim+9*dx);
        Yl=max(1,ylim-9*dx);
        Yh=min(n,ylim+9*dx);

    else
        Xl=1;
        Xh=m;
        Yl=1;
        Yh=n;
    end
    mask=(zeros(size(hue)));
    tmp_hue=hue(Yl:Yh,Xl:Xh);
    tmp_sat=sat(Yl:Yh,Xl:Xh);
    tmpmask=logical((tmp_hue>=bracelet.hue_low_th).*(tmp_hue<=bracelet.hue_high_th).*(tmp_sat>=bracelet.sat_low_th).*(tmp_sat<=bracelet.sat_high_th));
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
    
    old_center = bracelet.center;
    BB = uint16(rec_params);
    new_center = [BB(1)+BB(3)/2 BB(2)+BB(4)/2];
    bracelet.center=bracelet.alpha*new_center+(1-bracelet.alpha)*old_center;
    bracelet.BB = BB;
    handles.bracelet = bracelet;
end