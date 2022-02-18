function img = painter(img,center,finger_num)

color_array = [1,0,0; 0,1,0; 0,0,1;1,1,1;1,1,1;1,1,1];

if finger_num<1 || finger_num > length(color_array)
    return;
end


r=8;
x = center(1);
y = center(2);
%color_array = ["black","yellow","cyan","magenta","blue","white","black"];
color_vec = reshape(color_array(finger_num,:),[1,1,3]);
if color_vec == [1,1,1]
    r = r*5;
end
a = uint16(max(x-r,1));
b = uint16(min(r+x,size(img,2)));
left = min(a,b);
right = max(a,b);
up = uint16(max(y-r,1));
down = uint16(min(y+r, size(img,1)));

right = min(right, size(img,2));
down = min(down,size(img,1));

img(up:down, left:right, :) = ones(down-up+1, right-left+1, 3).*color_vec;
%img=insertShape(img,"FilledCircle",[center,15],"Color",color_array(finger_num+1));
end