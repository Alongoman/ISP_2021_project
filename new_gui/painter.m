function [img,color_vec] = painter(img,center,finger_num, cur_color)

color_array = [1,0,0; 0,1,0; 0,0,1;1,1,1;1,1,1;1,1,1];

color_chose_array = [1,2,3];
if sum(color_chose_array ==  finger_num)
    color_vec = reshape(color_array(finger_num,:),[1,1,3]);
    return
end
r=9;
x = center(1);
y = center(2);

if ~finger_num
    color_vec = cur_color;
else
    white = [1,1,1];
    color_vec = reshape(white,[1,1,3]);
    r = r*6;

end


a = uint16(max(x-r,1));
b = uint16(min(r+x,size(img,2)));
left = min(a,b);
right = max(a,b);

c = uint16(max(y-r,1));
d = uint16(min(y+r, size(img,1)));
up = min(c,d);
down = max(c,d);

right = min(right, size(img,2));
down = min(down,size(img,1));

up = max(up,1);
left = max(left,1);

img(up:down, left:right, :) = ones(down-up+1, right-left+1, 3).*color_vec;
%img=insertShape(img,"FilledCircle",[center,15],"Color",color_array(finger_num+1));
end