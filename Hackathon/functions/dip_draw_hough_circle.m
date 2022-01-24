% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function H = dip_draw_hough_circle(img, peaks,R0)
    Rmin = 80;
    Rmax = 100;
    R = Rmin:R0:Rmax;
    c = ["blue","red","green","yellow","magenta"];
    H = img;
    
        a = peaks(1,1);
        b = peaks(1,2);
        r = peaks(1,3);
        H = insertShape(H,'circle',[b,a,R(r)],'LineWidth',4,'Color',{c(1)});
    
   
end