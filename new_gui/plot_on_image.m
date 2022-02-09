function img = plot_on_image(img,center,finger_num)

color_array = ['red','yellow','cyan','magenta','blue','green','black'];
img=insertShape(img,'FilledCircle',[center,20],'Color',color_array(finger_num+1));

end