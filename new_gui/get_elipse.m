function out = get_elipse(r,ratio, center)

t = linspace(0,2*pi);
a = ratio(1)*r ; b = ratio(2)*r ;
x = a*cos(t) ;
y = b*sin(t) ;
out = [x.',y.']+[center(1),center(2)];
end