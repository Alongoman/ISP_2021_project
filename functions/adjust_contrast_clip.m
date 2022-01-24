% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function adjusted_img = adjust_contrast_clip(img,range_low,range_high)
    adjusted_img = img;
    adjusted_img(img<range_low) = range_low;
    adjusted_img(img>range_high) = range_high;
end