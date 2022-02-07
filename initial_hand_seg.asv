cam=webcam(2);
img=snapshot(cam);
figure
imshow(img,[])
title("Point to the center of the bracelet");
init_point = ginput(1);
[hue,sat,~]=rgb2hsv(img);
[BB,~,~,~,~]= initial_bracelet_rep_hs(img,init_point);

center=[BB(1)+BB(3)/2 BB(2)+BB(4)/2];
xlim=[max(center(1)-120,0) min(center(1)+120,size(img,2))];
ylim=[max(center(2)-250,0) min(center(2)-30,size(img,1))];
dx = xlim(2) - xlim(1);
dy = ylim(2) - ylim(1);
rec_params(1) = xlim(1);
rec_params(2) = ylim(1);
rec_params(3) = dx;
rec_params(4) = dy;
BB = uint16(rec_params);

tmp=sat(BB(2):BB(2)+BB(4),BB(1):BB(1)+BB(3));

x = tmp(:);
clust = kmeans(x,2);
[miu_h1,sigma_h1]=normfit(x(clust==1));
[miu_h2,sigma_h2]=normfit(x(clust==2));
if miu_h1>miu_h2
    miu_h=miu_h1;sigma_h=sigma_h1;
else
    miu_h=miu_h2;sigma_h=sigma_h2;
end

sat_low_th = miu_h-sqrt(2*sigma_h^2*(3-0.5*log(2*pi*sigma_h^2)));
sat_high_th = miu_h+sqrt(2*sigma_h^2*(3-0.5*log(2*pi*sigma_h^2)));

mask=logical((tmp>=sat_low_th).*(tmp<=sat_high_th));

% Hue
tmp=hue(BB(2):BB(2)+BB(4),BB(1):BB(1)+BB(3));
x = tmp(mask);
clust = kmeans(x,2);
[miu_h1,sigma_h1]=normfit(x(clust==1));
[miu_h2,sigma_h2]=normfit(x(clust==2));
if miu_h1<miu_h2
    miu_h=miu_h1;sigma_h=sigma_h1;
else
    miu_h=miu_h2;sigma_h=sigma_h2;
end

h_low_th = miu_h-sqrt(2*sigma_h^2*(3-0.5*log(2*pi*sigma_h^2)));
h_high_th = miu_h+sqrt(2*sigma_h^2*(3-0.5*log(2*pi*sigma_h^2)));

% Sat again
tmp=sat(BB(2):BB(2)+BB(4),BB(1):BB(1)+BB(3));
x = tmp(mask);
clust = kmeans(x,2);
[miu_h1,sigma_h1]=normfit(x(clust==1));
[miu_h2,sigma_h2]=normfit(x(clust==2));
if miu_h1>miu_h2
    miu_h=miu_h1;sigma_h=sigma_h1;
else
    miu_h=miu_h2;sigma_h=sigma_h2;
end

sat_low_th = miu_h-sqrt(2*sigma_h^2*(3-0.5*log(2*pi*sigma_h^2)));
sat_high_th = miu_h+sqrt(2*sigma_h^2*(3-0.5*log(2*pi*sigma_h^2)));

tmp=hue(BB(2):BB(2)+BB(4),BB(1):BB(1)+BB(3));
tmp1=sat(BB(2):BB(2)+BB(4),BB(1):BB(1)+BB(3));
tmpmask=(tmp1>=sat_low_th).*(tmp1<=sat_high_th).*(tmp>=h_low_th).*(tmp<=h_high_th);figure;imshow(tmpmask,[])

