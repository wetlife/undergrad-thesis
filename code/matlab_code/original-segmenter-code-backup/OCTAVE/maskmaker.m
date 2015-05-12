function mask = maskmaker(brightenedstack)
imshow(brightenedstack(:,:,1));
[r,c] = ginput();
mask = roipoly(brightenedstack(:,:,1),r,c);
close all;
imshow(mask);