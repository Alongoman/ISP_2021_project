%Config:
warning('off');
cam=webcam(2);

% Initial 
img=snapshot(cam);
frames=100;
mean_filter = ones(3)/9;
figure
imshow(img,[])
title("Point to the center of the bracelet");
init_point = ginput(1);
[bracelet_BB,hue_low_th_br,hue_high_th_br,sat_low_th_br,sat_high_th_br]= initial_bracelet_rep_hs(img,init_point);
[BB,h_low_th_hand,h_high_th_hand,sat_low_th_hand,sat_high_th_hand]= initial_hand_rep_hs(bracelet_BB,img);
figure
prev_img = zeros(size(image));
for i = 1:frames
    img=(snapshot(cam));
    diff_im=abs(rgb2gray(imfilter(img-prev_img,mean_filter)));
    diff_im = double(imgaussfilt(diff_im,100));
    BW=double(diff_im>1.5);
    BW=imclearborder(BW);
    diff_im=diff_im.*BW;
    
    diff_im = imgaussfilt(diff_im,20);

    diff_im=logical(diff_im>2.2);



    [hue,sat,~]=rgb2hsv(img);
    hue1=hue.*diff_im;
    sat1=sat.*diff_im;

    [~,braclet_BB]=find_bracelet_hs(hue1,sat1,hue_low_th_br,hue_high_th_br,sat_low_th_br,sat_high_th_br);
    if braclet_BB(1)~=0
        [mask,BB] = find_hand_hsv(braclet_BB,hue,sat,h_low_th_hand,h_high_th_hand,sat_low_th_hand,sat_high_th_hand);
        center=[braclet_BB(1)+braclet_BB(3)/2 braclet_BB(2)+braclet_BB(4)/2]; 

    end

    subplot(2,1,1)
    imshow(mask,[])
    subplot(2,1,2)
    if BB(1)~=0
        img2=insertShape(img,'Rectangle',BB,'Color','red','LineWidth',5);
    end
    B=double(img2).*double(diff_im);
    imshow(uint8(B),[])
    hold on
    plot(center(1),center(2),'b+','MarkerSize',15,'LineWidth',3)
    hold off
    prev_img = img;
end
