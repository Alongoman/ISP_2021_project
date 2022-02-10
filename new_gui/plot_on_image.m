function img = plot_on_image(img,center,finger_num)

if ~finger_num
    return;
end
color_array = ["black","yellow","cyan","magenta","blue","white","black"];
img=insertShape(img,"FilledCircle",[center,15],"Color",color_array(finger_num+1));
end