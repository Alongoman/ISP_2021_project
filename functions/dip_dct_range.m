% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function res = dip_dct_range(dct,range)
    high = max(range);
    low = min(range);
    res = dct;
    res(abs(dct)<=high & abs(dct)>=low) = 0;
end