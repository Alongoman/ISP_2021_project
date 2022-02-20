function [x,y] = make_valid(px,py,xlim,ylim)

x = uint16(min(max(px,1),xlim));
y = uint16(min(max(py,1),ylim));



end