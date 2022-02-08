% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function manipulation(img, img_title,type)
sigma = 20*(type=="RGB")+2;
channel_lin = 1+1*(type=="HSV" | type=="LAB");
lin_im = -1*img(:,:,channel_lin)+1;
new_img = cat(3,lin_im,img(:,:,2:end));

lin_cell={img_title + " Channel" + num2str(channel_lin),img(:,:,channel_lin)};
lin_cell(2,:)={img_title + " linear manipulation",lin_im};
lin_cell(3,:)={"original image",img};
lin_cell(4,:)={img_title + " linear manipulation whole image",new_img};

new_img = circshift(img,1,3);
switch_cell={"original image",img};
switch_cell(2,:)={"switch color image",new_img};

lpf_im = imgaussfilt(img(:,:,3),sigma);
new_img = cat(3,img(:,:,1:2),lpf_im,img(:,:,4:end));
lpf_cell={img_title + " Channel3",img(:,:,3)};
lpf_cell(2,:)={img_title + " Channel3 LPF",lpf_im};
lpf_cell(3,:)={"original image",img};
lpf_cell(4,:)={img_title + " Channel3 LPF whole",new_img};

if type=="RGB"
    disp("linear manipulation")
    do_subplot(lin_cell);
    disp("switch colors")
    do_subplot(switch_cell)
    disp("LPF")
    do_subplot(lpf_cell);
elseif type=="CYM"
    disp("linear manipulation")
    do_subplot(lin_cell(1:2,:));
    figure
    imshowCYMK(img(:,:,1),img(:,:,2),img(:,:,3),img(:,:,4))
    new_img = lin_cell{4,2};
    figure
    imshowCYMK(new_img(:,:,1),new_img(:,:,2),new_img(:,:,3),new_img(:,:,4))
    disp("switch colors")
    figure
    imshowCYMK(img(:,:,1),img(:,:,2),img(:,:,3),img(:,:,4))
    new_img = switch_cell{2,2};
    figure
    imshowCYMK(new_img(:,:,1),new_img(:,:,2),new_img(:,:,3),new_img(:,:,4))
    disp("LPF")
    do_subplot(lpf_cell(1:2,:));
    figure
    imshowCYMK(img(:,:,1),img(:,:,2),img(:,:,3),img(:,:,4))
    new_img = lpf_cell{4,2};
    figure
    imshowCYMK(new_img(:,:,1),new_img(:,:,2),new_img(:,:,3),new_img(:,:,4))
elseif type=="HSV"
    disp("linear manipulation")
    do_subplot(lin_cell(1:2,:));
    figure
    imshowHSV(img(:,:,1),img(:,:,2),img(:,:,3))
    new_img = cat(3,img(:,:,1),lin_im,img(:,:,3));
    figure
    imshowHSV(new_img(:,:,1),new_img(:,:,2),new_img(:,:,3))
    disp("switch colors")
    figure
    imshowHSV(img(:,:,1),img(:,:,2),img(:,:,3))
    new_img = switch_cell{2,2};
    figure
    imshowHSV(new_img(:,:,1),new_img(:,:,2),new_img(:,:,3))
    disp("LPF")
    do_subplot(lpf_cell(1:2,:));
    figure
    imshowHSV(img(:,:,1),img(:,:,2),img(:,:,3))
    new_img = lpf_cell{4,2};
    figure
    imshowHSV(new_img(:,:,1),new_img(:,:,2),new_img(:,:,3))
elseif type=="LAB"
    disp("linear manipulation")
    do_subplot_lab(lin_cell(1:2,:));
    figure
    imshowLab(img(:,:,1),img(:,:,2),img(:,:,3))
    new_img = cat(3,img(:,:,1),lin_im,img(:,:,3));
    figure
    imshowLab(new_img(:,:,1),new_img(:,:,2),new_img(:,:,3))
    disp("switch colors")
    figure
    imshowLab(img(:,:,1),img(:,:,2),img(:,:,3))
    new_img = switch_cell{2,2};
    figure
    imshowLab(new_img(:,:,1),new_img(:,:,2),new_img(:,:,3))
    disp("LPF")
    do_subplot_lab(lpf_cell(1:2,:));
    figure
    imshowLab(img(:,:,1),img(:,:,2),img(:,:,3))
    new_img = lpf_cell{4,2};
    figure
    imshowLab(new_img(:,:,1),new_img(:,:,2),new_img(:,:,3))
end


end