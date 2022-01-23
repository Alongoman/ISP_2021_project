cam=webcam(2);
% preview(cam);
img=snapshot(cam);
imwrite(img,"green_bracelet/imo10.jpg")
figure
imshow(img,[])