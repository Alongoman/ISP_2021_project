% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function F = sep_fft2(v1,v2)
    N1 = length(v1);
    N2 = length(v2);
    v1 = reshape(v1,[N1,1]);
    v2 = reshape(v2,[1,N2]);
    F = v1*v2;
end


 