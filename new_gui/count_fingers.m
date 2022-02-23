% img = imread("A5.jpeg");
% c = count_fingers1(img)






function [counts, center_of_mass] = count_fingers(handles)
img = handles.hand.mask;
palm_center = handles.hand.palm_center;
% fist = handles.hand.fist;

w_center_of_mass = 0.7;
threshold = 0.95;
r_scale = 1.15;
if handles.harsh
    r_scale = 1.35;
end
img = uint8(img);
[n,m,k] = size(img);
center_of_mass = [floor(n/2), floor(m/2)];
if k > 1
    img = imbinarize(rgb2gray(img));
else
    img = imbinarize(img);
end

stats=regionprops(img,'Centroid');


% try
%if (isZero(img,stats))

%    counts = 0;
 %   return;
%end
% catch e
%     disp(e)
%     counts = -1;
%     return;
% end


bw = edge(img);

center_of_mass = double(w_center_of_mass*double(stats(1).Centroid) + (1-w_center_of_mass)*double(palm_center));
x_cent = double(round(center_of_mass(1)));
y_cent = double(round(center_of_mass(2)));

% remove all below center
bw2 = bw;
% bw2(y_cent:end,:) = 0;


%find radius
[py,px] = find(bw2==1);
radii = vecnorm([px,py]-[x_cent,y_cent],2,2);
r_orig = max(radii);
r = ceil(r_orig/2)*r_scale;

I = zeros(size(bw2));
elipse = get_elipse(r,[1.6,0.9], [x_cent,y_cent]);
A = imbinarize(rgb2gray(insertShape(I,'Polygon',elipse)));
%A = rgb2gray(insertShape(I,'circle',[x_cent,y_cent,r],'LineWidth',1));

intersect = A.*bw2;
% counts = ceil((sum(intersect,'all'))/2);
[g,counts] = bwlabel(intersect);
counts = ceil(counts/2) - 1;



if(counts<3)
%fill_ratio = sum(img,"all")/(r_orig^2);

se = strel('disk',20);
b = handles.hand.mask;
c = imopen(b,se);
areas_ratio = sum(b,'all')/sum(c,'all');

if areas_ratio<1.1 %fill_ratio > threshold*fist || 
    counts = 0;
end
end

    
    
    
% var_th = 600;
% 
% [py,px] = find(img==1);
% center_of_mass = stats(1).Centroid;
% variance = mean(([px,py]-center_of_mass).^2,'all');
% if(variance<var_th)
%     counts=0;
% end
% end

% figure(1); imshow(img);title("orig");
% figure(2);imshow(bw);
% figure(3);imshow(bw2);
% figure(4);imshow(img);title(strcat("fingers:",num2str(counts)));
% figure(5);imshow(A.*bw2,[]);title("masked");

% B = rgb2gray(insertShape(uint8(255*bw2),'circle',[x_cent,y_cent,r],'LineWidth',1));
% 
% figure();imshow(g,[]);title(num2str(ceil(counts/2)));
% figure();imshow(B,[]);title(num2str(ceil(counts/2)));

counts = min(counts,5);

end

% function out = isZero(img, stats)
% 
% 
% var_th = 3e3;
% 
% [py,px] = find(img==1);
% center_of_mass = stats(1).Centroid;
% variance = mean(([px,py]-center_of_mass).^2,'all');
% if(variance>var_th)
%     
%     out = 0;
%     return
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     out =1;
% return;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% k = boundary(px,py);
% 
% 
% x = px(k);
% y = py(k);
% 
% polygon = [x,y];%,circshift(x,1),circshift(y,1)];
% filled_img = zeros(size(img));
% filled_img = imbinarize(rgb2gray(insertShape(filled_img,'FilledPolygon',polygon)));
% 
% fill_ratio = sum(filled_img,'all')/sum(img,'all');
% if(fill_ratio>1.1)
%     
%     out = 0;
%     return
% end
% 
%     
% % stats=regionprops(img,'Centroid');
% % center_of_mass = stats(1).Centroid;
% % radii = vecnorm([px,py]-center_of_mass,2,2);
% % max_ratio = max(radii)/mean(radii,'all');
% % if(max_ratio>2.4)
% %     disp("second out")
% %     
% %     out=0;
% %     return
% % end
%     out =1;
%         %disp("third out")
%         %
% 
% 
% end