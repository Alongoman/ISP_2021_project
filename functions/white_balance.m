% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function out = white_balance(img)
 
    gray = rgb2gray(img); 
    R = img(:, :, 1);
    G = img(:, :, 2);
    B = img(:, :, 3);
    
    meanR = mean2(R);
    meanG = mean2(G);
    meanB = mean2(B);
    meanGray = mean2(gray);
    
    R = uint8(double(R) * meanGray / meanR);
    G = uint8(double(G) * meanGray / meanG);
    B = uint8(double(B) * meanGray / meanB);

    out = cat(3, R, G, B);
end


