% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function adjusted_img = adjust_contrast(img,range_low,range_high)
    adjusted_img = range_low + img*(range_high-range_low);
end