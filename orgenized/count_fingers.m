function counts = count_fingers(img)
% if size(img,3)>1
%     img = imbinarize(rgb2gray(img));
% else
%     img = imbinarize(img);
% end
try

if (isZero(img))
    counts = 0;
    return;
end

stats=regionprops(img,'Centroid');

bw = edge(img);

center_of_mass = stats(1).Centroid;
x_cent = round(center_of_mass(1));
y_cent = round(center_of_mass(2));

% remove all below center
bw2 = bw;
bw2(y_cent:end,:) = 0;


%find radius
[py,px] = find(bw2==1);
points = vecnorm([px,py]-center_of_mass,2,2);
r = ceil(max(points)/2)*1.2;

I = zeros(size(bw2));
A = rgb2gray(insertShape(I,'circle',[x_cent,y_cent,r],'LineWidth',1));

intersect = A.*bw2;
% counts = ceil((sum(intersect,'all'))/2);
[g,counts] = bwlabel(intersect);
counts = ceil(counts/2);

catch
    counts = 0;
end

% figure(1); imshow(img);title("orig");
% figure(2);imshow(bw);
% figure(3);imshow(bw2);
% figure(4);imshow(img);title(strcat("fingers:",num2str(counts)));
% figure(5);imshow(A.*bw2,[]);title("masked");

% B = rgb2gray(insertShape(uint8(255*bw2),'circle',[x_cent,y_cent,r],'LineWidth',1));

% figure();imshow(g,[]);title(num2str(ceil(counts/2)));
% figure();imshow(B,[]);title(num2str(ceil(counts/2)));

end

function out = isZero(img)
var_th = 2.8e3;

[py,px] = find(img==1);
stats=regionprops(img,'Centroid');
center_of_mass = stats(1).Centroid;
variance = mean(([px,py]-center_of_mass).^2,'all');
if(variance>var_th)
    out = 0;
    return
end


k = boundary(px,py);


x = px(k);
y = py(k);

polygon = [x,y];%,circshift(x,1),circshift(y,1)];
filled_img = zeros(size(img));
filled_img = imbinarize(rgb2gray(insertShape(filled_img,'FilledPolygon',polygon)));

fill_ratio = sum(filled_img,'all')/sum(img,'all');
if(fill_ratio>1.1)
    out = 0;
    return
end
% stats=regionprops(img,'Centroid');
% center_of_mass = stats(1).Centroid;
% radii = vecnorm([px,py]-center_of_mass,2,2);
% max_ratio = max(radii)/mean(radii,'all');
% if(max_ratio>2.4)
%     disp("second out")
%     toc
%     out=0;
%     return
% end
    out =1;


end