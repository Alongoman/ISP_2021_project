% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function F = dip_fft2(I)
    [M,N] = size(I);
    m = 0:(M-1);
    n = 0:(N-1);
    u = 0:(M-1);
    v = 0:(N-1);
    
    e1 = exp(-2*pi*j*(u.')*m/M);
    e2 = exp(-2*pi*j*(n.')*v/N);
    F = e1*I*e2;
end


 