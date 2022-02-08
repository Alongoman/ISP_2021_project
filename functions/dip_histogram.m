% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273
function h = dip_histogram(img,nbins) % assume log2(nbins)=N >0
    if sum(img(img>1))>0 % if not normalaized -> norm
        img = round(255*norm_pic(img));
    else
        img = round(255*img);
    end
    img = img(:);
    centers = floor(linspace(0,255,nbins));
    step = floor(255/(nbins-1));
    level = step/2;
    for i=1:nbins
        h(i) = sum((-level)<=(img-centers(i)) & (img-centers(i))<level);
    end
    figure 
    disp(strcat("dip histogram() bins =",num2str(nbins)))
    bar(centers,h);
   
end