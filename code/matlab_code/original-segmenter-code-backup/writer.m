% writer writes a stack to a set of images
function writer(stack,outputpath,step,baseFilename)
    for k = 1:size(stack,3)
        filename = ['step',num2str(step),baseFilename,num2str(k),'.png'];
        imwrite(stack(:,:,k), fullfile(outputpath, filename));
    end
end