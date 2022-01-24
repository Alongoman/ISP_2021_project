% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function I = dip_ifft2(FFT)
 [M,N] = size(FFT);
    m = 0:(M-1);
    n = 0:(N-1);
    u = 0:(M-1);
    v = 0:(N-1);
    
    e1 = exp(2*pi*j*(u.')*m/M);
    e2 = exp(2*pi*j*(n.')*v/N);
    I = e1*FFT*e2/(M*N);
end