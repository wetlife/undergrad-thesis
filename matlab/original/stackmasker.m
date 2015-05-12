% mask stack to observe only the user-specified region of each image
function maskedstack = stackmasker(brightenedstack,mask,threshold)

maskedstack = zeros(size(brightenedstack));

for k=1:length(maskedstack(1,1,:))
    bw = im2bw(brightenedstack(:,:,k),threshold);
    maskedstack(:,:,k) = immultiply(mask,bw);
end
close all