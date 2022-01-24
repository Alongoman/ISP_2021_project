% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function plot_mag_phase(img,title_str)
f_img = dip_fft2(img);
f_img = dip_fftshift(f_img);
A1 = abs(f_img);
A2 = angle(f_img);

figure
subplot(1,2,1)
imagesc(A1)
colorbar();
title(title_str+" magnitude")
subplot(1,2,2)
imagesc(A2)
colorbar();
title(title_str+" phase")
end