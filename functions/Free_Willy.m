% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function willy = Free_Willy(prisoned_willy,prison)
prison_f = fft2(prison);
prison_willy_f = fft2(prisoned_willy);

willy_f = prison_willy_f - prison_f;
willy = ifft2(willy_f);

figure
imshow(willy,[])
title("willy is free");
end
