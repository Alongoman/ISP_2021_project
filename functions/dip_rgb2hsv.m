% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function [H,S,V] = dip_rgb2hsv(img) % get a N x M x 3 matrix
    img = norm_pic(img);
    
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    c_max = max(R,G);
    c_max = max(c_max,B);
    c_min = min(R,G);
    c_min = min(c_min,B);
    d = c_max-c_min;
    
    V = c_max;
    S = 0*(c_max == 0) + (d./c_max).*(c_max ~= 0);
    
    H = zeros(size(R));
    temp=mod(((G-B)./d),6);
    H(c_max==R)=temp(c_max==R);

    temp=(B-R)./d +2;
    H(c_max==G)=temp(c_max==G);

    temp=(R-G)./d +4;
    H(c_max==B)=temp(c_max==B);

    H(d==0)=0;

    H=H/6;
    end