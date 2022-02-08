% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function [C,Y,M,K] = dip_rgb2cymk(img) % get a N x M x 4 matrix
    img = norm_pic(img);
    K = min(1-img,[],3);
    C = (1-K-img(:,:,1))./(1-K);
    M = (1-K-img(:,:,2))./(1-K);
    Y = (1-K-img(:,:,3))./(1-K);
end