% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function normalized_pic = dip_GN_imread(file_name)
pic = imread(file_name);
disp(file_name);
gs_pic = double(rgb2gray(pic)); %gray scale pic
normalized_pic = norm_pic(gs_pic);
end