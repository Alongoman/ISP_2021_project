% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function disp_img_hist(img, bins, given_title)
    figure
    imshow(img)
    title(given_title)
    figure
    h_img = dip_histogram(img,bins);
    disp(strcat(given_title," histogram"))
end