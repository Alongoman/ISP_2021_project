% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function F_S = dip_fftshift(I)
    [m,n] = size(I);
    n = floor(n/2);
    m = floor(m/2);
    F_S = circshift(I,[m,n]);
end