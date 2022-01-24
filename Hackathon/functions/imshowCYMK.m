function imshowCYMK(C,Y,M,K)
%Usage: imshowCYMK(C,Y,M,K)
%This function is equivilent to imshow but displays the CYMK as a color image.
%The inputs are:
%C - an NxM matrix of type double of the cayen channel in the range [0,1]
%Y - an NxM matrix of type double of the yellow channel in the range [0,1]
%M - an NxM matrix of type double of the magenta channel in the range [0,1]
%K - an NxM matrix of type double of the black channel in the range [0,1]
%The function does not open a new figure
%
%Author: Assaf Arbelle {arbellea@post.bgu.ac.il}

Ci = (1-C);
Yi = (1-Y);
Mi = (1-M);
Ki = (1-K);
RGB = cat(3, Ci.*Ki, Mi.*Ki,Yi.*Ki);
imshow(RGB)
end
