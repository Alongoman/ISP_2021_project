% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function normalized_pic = norm_pic(gs_pic)
gs_pic = double(gs_pic);
normalized_pic = (gs_pic - min(gs_pic(:)))/(max(gs_pic(:))-min(gs_pic(:)));
end