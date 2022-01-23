warning('off');
cam=webcam(2);
img=snapshot(cam);
frames=200;
figure
imshow(img,[])
title("Point to the center of the bracelet");
init_point = ginput(1);
[valid_mask,BB,hue_low_th,hue_high_th,sat_low_th,sat_high_th]= initial_bracelet_rep_hs(img,init_point,'green');
figure
for i = 1:frames
    img=(snapshot(cam));
    [hue,sat,~]=rgb2hsv(img);
    [mask,BB]=find_bracelet_hs(valid_mask.*hue,valid_mask.*sat,hue_low_th,hue_high_th,sat_low_th,sat_high_th);
    subplot(2,1,1)
    imshow(mask,[])
    subplot(2,1,2)
    if BB(1)~=0
        img2=insertShape(img,'Rectangle',BB,'Color','red','LineWidth',5);
    end
    imshow(uint8(img2),[])

end
