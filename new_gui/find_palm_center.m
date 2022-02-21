function handles = find_palm_center(handles)
dist = floor(handles.hand.dist_to_center);
dx = floor(handles.bracelet.BB(3)/2);
dy = floor(handles.bracelet.BB(4)/2);
bx = handles.bracelet.BB(1)+dx;
by = handles.bracelet.BB(2)-dy;
py = by - dist(2) - handles.hand.BB(2);
px = bx - handles.hand.BB(1);
handles.hand.palm_center = uint16([px,py]);
end