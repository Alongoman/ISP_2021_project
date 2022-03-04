
function [counts, center_of_mass] = count_fingers(handles)
img = handles.hand.mask;
% harsh = handles.harsh;
harsh = 1;
palm_center = handles.hand.palm_center;

w_center_of_mass = 0.7;
threshold = 0.95;
r_scale = 1.15;
if handles.harsh
    r_scale = 1.35;
end
img = uint8(img);
[n,m,k] = size(img);
if k > 1
    img = imbinarize(rgb2gray(img));
else
    img = imbinarize(img);
end

stats=regionprops(img,'Centroid');

center_of_mass = double(w_center_of_mass*double(stats(1).Centroid) + (1-w_center_of_mass)*double(palm_center));

se = strel('disk',20);
b = handles.hand.mask;
c = imopen(b,se);
areas_ratio = sum(b,'all')/sum(c,'all');

if areas_ratio<1.1
    counts = 0;
    return
end

bw = edge(img);

x_cent = double(round(center_of_mass(1)));
y_cent = double(round(center_of_mass(2)));

%find radius
[py,px] = find(bw==1);
radii = vecnorm([px,py]-[x_cent,y_cent],2,2);
r_orig = max(radii);
r = ceil(r_orig/2)*r_scale;

I = zeros(size(bw));

elipse1 = get_elipse(r,[1.4,0.9], [x_cent,y_cent]);
A1 = imbinarize(rgb2gray(insertShape(I,'Polygon',elipse1)));
intersect1 = A1.*bw;
[~,counts1] = bwlabel(intersect1);
counts = ceil(counts1/2) - 1;

if harsh
    elipse2 = get_elipse(r,[1.42,1.1], [x_cent,y_cent]);
    elipse3 = get_elipse(r,[1.2,0.9], [x_cent,y_cent]);
    elipse4 = get_elipse(r,[1.2,1.1], [x_cent,y_cent]);
    elipse5 = get_elipse(r,[1,0.9], [x_cent,y_cent]);
    elipse6 = get_elipse(r,[1,1.1], [x_cent,y_cent]);
    
    A2 = imbinarize(rgb2gray(insertShape(I,'Polygon',elipse2)));
    A3 = imbinarize(rgb2gray(insertShape(I,'Polygon',elipse3)));
    A4 = imbinarize(rgb2gray(insertShape(I,'Polygon',elipse4)));
    A5 = imbinarize(rgb2gray(insertShape(I,'Polygon',elipse5)));
    A6 = imbinarize(rgb2gray(insertShape(I,'Polygon',elipse6)));
    %A = rgb2gray(insertShape(I,'circle',[x_cent,y_cent,r],'LineWidth',1));
    
    intersect2 = A2.*bw;
    intersect3 = A3.*bw;
    intersect4 = A4.*bw;
    intersect5 = A5.*bw;
    intersect6 = A6.*bw;
    cell_inter={intersect2,intersect3,intersect4, intersect5, intersect6};
    % counts = ceil((sum(intersect,'all'))/2);
    for i=1:length(cell_inter)
        [~,counts1] = bwlabel(cell_inter{i});
        counts = [counts (ceil(counts1/2) - 1)];
    end
    counts=ceil(median(counts));
end

counts = min(counts,5);

end
