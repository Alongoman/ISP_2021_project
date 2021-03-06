%Config:
clc
clear
close all

warning('off');
cam=webcam('MicrosoftÂ® LifeCam HD-3000');

% Initial 
img=snapshot(cam);
img=snapshot(cam);
frames=2000;
figure
imshow(img,[])
title("Point to the center of the bracelet");
init_point = ginput(1);
[valid_mask,braclet_BB,hue_low_th_br,hue_high_th_br,sat_low_th_br,sat_high_th_br]= initial_bracelet_rep_hs(img,init_point,'green');
[hand_BB,h_low_th_hand,h_high_th_hand,sat_low_th_hand,sat_high_th_hand]= initial_hand_rep_hs(braclet_BB,img);
figure
counter=0;
center=uint16(zeros(1,2));
alpha=0.5;
for i = 1:frames
    img=(snapshot(cam));
    [hue,sat,v]=rgb2hsv(img);
    v_mask=(v<0.95).*(v>0.05);
    old_hand_BB=hand_BB;
    center_old=center;
    [~,braclet_BB]=find_bracelet_hs(valid_mask.*hue,valid_mask.*sat,hue_low_th_br,hue_high_th_br,sat_low_th_br,sat_high_th_br,braclet_BB);
    if braclet_BB(1)~=0
        [mask,hand_BB] = find_hand_hsv(braclet_BB,v_mask.*hue,v_mask.*sat,h_low_th_hand,h_high_th_hand,sat_low_th_hand,sat_high_th_hand,old_hand_BB);
        new_center=[braclet_BB(1)+braclet_BB(3)/2 braclet_BB(2)+braclet_BB(4)/2]; 
        center=alpha*new_center+(1-alpha)*center_old;
        subplot(2,1,1)
        imshow(mask,[])
        subplot(2,1,2)
        if hand_BB(1)~=0
        img2=insertShape(img,'Rectangle',hand_BB,'Color','red','LineWidth',5);
        end
        imshow(uint8(img2),[])
        hold on
        plot(center(1),center(2),'b+','MarkerSize',15,'LineWidth',3)
        hold off

    else
        counter=counter+1
    end

end
