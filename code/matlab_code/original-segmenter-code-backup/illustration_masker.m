numobjects = input(sprintf(['How many objects will be'...
    ' segmented in this stack?\n']));
for m = 1:numobjects
    disp(['MASKING OBJECT #' num2str(m)])
    mask = maskmaker(bwstack);
    while 1==1
        appendObjectToFilename = ['object-' num2str(m)];
        maskedstack = stackmasker(bwstack,mask,threshold);
        for page=1:size(maskedstack,3)
            maskedstack(:,:,page) =...
                ExtractNLargestBlobs(maskedstack(:,:,page),1);
        end

        % show masked stack. ask if ok. ok => save 1-object-stack
        implay(maskedstack);
        ok = input(sprintf(['Either enter 1 to save'...
            ' the binary stack, press enter to skip,\nor enter'...
            ' anything else to tinker.\n']));
        if ok == 1
            disp(['WRITING BINARY STACK:' folders(k,:) '.tif']);
            stackwriter(maskedstack,outputpath,...
                        ['binary-' folders(k,:)],...
                        '',appendObjectToFilename);
            disp(['SUCCESSFULLY WROTE THE STACK NAMED binary-',...
                  folders(k,:),appendObjectToFilename,'.tif' ])
            break
        elseif isempty(ok)
            break
        else
            tinker
        end
    end
        continue
end