directory = 'C:\Users\thomasky\Research\2D-fibertraction\binary';
files = dir(fullfile(directory,'*.tif'));
outputPath = fullfile(directory,'..','ready');
for k=1:length(files)
    stack = stackreader(directory,files(k).name);
    for page=1:length(stack(1,1,:))
        stack(:,:,page) = ExtractNLargestBlobs(stack(:,:,page),1);
    end
    implay(stack);
    saveness = input(sprintf(['Enter 1 to save, 0 to skip, or'...
                              ' press enter to exit.\n']));
    if saveness==0
        fprintf('\n\nSKIPPING SAVING STACK\n');
        continue
    elseif saveness==1
        stackwriter(stack,directory,files(k).name,'ready-','')
    else
        break
    end
end