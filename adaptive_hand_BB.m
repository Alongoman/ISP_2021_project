function hand_BB=adaptive_hand_BB(new_braclet_BB,old_hand_BB)
    if old_hand_BB(1)==0
        alpha=1;
        beta=1;
        dx_old=0;
        dy_old=0;
        old_xlim=0;
        old_ylim=0;

    else
        alpha=0.1;
        beta=0.5;
        old_xlim=old_hand_BB(1);
        old_ylim=old_hand_BB(2);
        dx_old=old_hand_BB(3);
        dy_old=old_hand_BB(4);

    end  
    xlim=new_braclet_BB(1);
    ylim=new_braclet_BB(2);
    dx=new_braclet_BB(3);
    new_dx=9*dx;
    new_dy=6*dx;
    new_ylim=max((ylim-5*dx),1);
    new_xlim=max((xlim-2*dx),1);

    new_dx=alpha*new_dx+(1-alpha)*dx_old;
    new_dy=alpha*new_dy+(1-alpha)*dy_old;
    new_xlim=beta*new_xlim+(1-beta)*old_xlim;
    new_ylim=beta*new_ylim+(1-beta)*old_ylim;
    hand_BB=uint16([new_xlim new_ylim max(new_dx,45) max(new_dy,45)]);
end
