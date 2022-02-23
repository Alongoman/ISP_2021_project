function out = get_elipse(r,ratio, center)

t = [0:1:230 , 310:360]-180;
t = deg2rad(t);
a = ratio(1)*r ; b = ratio(2)*r ;
x = a*cos(t) ;
y = b*sin(t) ;
out = [x.',y.']+[center(1),center(2)];
end