% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function half_img = Thanos_snap(img)
    N = length(img(:));
    idx = randi([1,N],[1,round(N/2)]);
    half_img = img;
    half_img(idx) = 0;
end