function displayCYMK(C,Y,M,K)
%Usage: displayCYMK(C,Y,M,K)
%This function displays the CYMK channels in the correct colors.
%The inputs are:
%C - an NxM matrix of type double of the cayen channel in the range [0,1]
%Y - an NxM matrix of type double of the yellow channel in the range [0,1]
%M - an NxM matrix of type double of the magenta channel in the range [0,1]
%K - an NxM matrix of type double of the black channel in the range [0,1]
%The function opens a new figure and displays all four channels in subplots
%
%Author: Assaf Arbelle {arbellea@post.bgu.ac.il}


W = zeros(size(C));

Yout = cat(3, Y, Y, W);
Mout = cat(3, M, W, M);
Cout = cat(3, W, C, C);
Kout = cat(3, 1-K, 1-K, 1-K);

figure();
subplot(2,2,1)
title('C')
imshow(Cout);

subplot(2,2,2)
title('Y')
imshow(Yout);

subplot(2,2,3)
title('M')
imshow(Mout);

subplot(2,2,4)
title('K')
imshow(Kout);