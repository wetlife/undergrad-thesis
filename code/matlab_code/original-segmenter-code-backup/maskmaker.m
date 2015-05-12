% graphically select region to be masked in nth image of stack
function mask = maskmaker(stack)
n = 1;
imshow(stack(:,:,n));
[r,c] = ginput();
mask = roipoly(stack(:,:,1),r,c);
close all;
%imshow(mask);