% mask the stack to observe only the user-specified region
function maskedstack = stackmasker(brightenedstack,mask,threshold)

% imshow(stack(:,:,1));
% 
% [r,c] = ginput();
% 
% mask = roipoly(stack(:,:,1),r,c);

% figure, imshow(mask)

maskedstack = zeros(size(brightenedstack));

for k=1:length(maskedstack(1,1,:))
    bw = im2bw(brightenedstack(:,:,k),threshold);
    maskedstack(:,:,k) = immultiply(mask,bw);
end
close all