function handles = calibrate_fist(handles)

try
m1 = handles.hand.mask;
m2 = flip(m1);
fist = m2.*m1;

stats=regionprops(fist,'Centroid');
center_of_mass = stats(1).Centroid;
x_cent = double(round(center_of_mass(1)));
y_cent = double(round(center_of_mass(2)));
[py,px] = find(fist==1);
radii = vecnorm([px,py]-[x_cent,y_cent],2,2);
r_orig = max(radii);

handles.hand.fist = sum(fist,'all')/(r_orig^2);
catch 
    disp("using default fist ratio")
    handles.hand.fist = 1.4
end
end