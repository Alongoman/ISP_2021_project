% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function adjusted_img = adjust_contrast_clip_inv(img,range_low,range_high)
    adjusted_img = img;
    adjusted_img(img<range_high & img>range_low) = 0;
    
end