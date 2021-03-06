
cam=webcam(2);
img=snapshot(cam);
figure
imshow(img,[])
title("Point to the center of the bracelet");
init_point = ginput(1);
[hue,sat,~]=rgb2hsv(img);
[BB,hue_low_th,hue_high_th,sat_low_th,sat_high_th]= initial_bracelet_rep_hs(img,init_point);
nmask=(hue>=hue_low_th).*(hue<=hue_high_th).*(sat>=sat_low_th).*(sat<=sat_high_th);
nmask2=(hue>=hue_low_th).*(hue<=hue_high_th);

figure;
subplot(2,2,1)
imshow(nmask,[])
subplot(2,2,2)
if BB(1)~=0
    img2=insertShape(img,'Rectangle',BB,'Color','red','LineWidth',5);
end
imshow(uint8(img2),[])
subplot(2,2,3)
imshow(nmask2,[])

