function imshowHSV(H,S,V)
%Usage: imshowHSV(H,S,C)
%This function is equivilent to imshow but displays the HSV as a color image.
%The inputs are:
%H - an NxM matrix of type double of the hue channel in the range [0,1]
%S - an NxM matrix of type double of the saturation channel in the range [0,1]
%V - an NxM matrix of type double of the value channel in the range [0,1]

%The function does not open a new figure
%
%Author: Assaf Arbelle {arbellea@post.bgu.ac.il}


RGB = hsv2rgb(H,S,V);
imshow(RGB)
end

