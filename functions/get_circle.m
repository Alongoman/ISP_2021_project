% DIP - Alon Goldmann 312592173, Yogev Hadadi 311436273

function [a,b,r] = get_circle(mask)
[y,x] = find(mask==1);
y_min = min(y);
y_max = max(y);
x_min = min(x);
x_max = max(x);
r = max(x_max-x_min,y_max-y_min);
a = mean([x_min,x_max]);
b = mean([y_min,y_max]);
end