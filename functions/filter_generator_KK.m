% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function filter = filter_generator_KK(img_dim, idx, K)% assume odd dimention, square filter, idx is in range
    k = (K-1)/2; 
    n = img_dim(1);
    N = repelem(n*(-k:1:k),K).';
    vec = (idx-k:1:idx+k).';
    I = repmat(eye(K),K,1);
    filter = I*vec + N;
end