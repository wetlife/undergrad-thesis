% this script segments each object in a tiff-stack in its own stack
% by asking the user to mask a region constaining only one object.
% user decides how much to brighten and threshold the image for
% segmentation
directory = ['C:\Users\thomasky\Research\2D-fibertraction\'...
    '_prep-to-mask-and-binarize\good-images-no-beads'];
outputpath = fullfile(directory, '..', '..', 'binary');
brighteningfactor = 1.;
threshold = 0.15; 
folders = ls(directory);
%% attempt to resume from the folder that the program left off at
if exist('k','var')
    resume = input(sprintf(['Enter the folder number to start'...
        ' with or press enter to attempt\nresuming where the'...
        ' program left off.\n']));
    if isempty(resume)
        startingfolder = k;
    else
        startingfolder = resume;
    end
else
    startingfolder = 1;
end

%% read all folders in directory
for k=startingfolder:length(folders(:,1))
% skip folders in directory with no tiffs
    stackdirectory = fullfile(directory,strtrim(folders(k,:)));
    if size(dir(fullfile(stackdirectory,'*.tif')),1)==0 &&...
            isdir(stackdirectory)
        continue
    end

% read stack in current folder
    disp(['FOLDER #' num2str(k) ': ' folders(k,:)]);
    stack = stackreader(stackdirectory,'*.tif');
% ask how many objects in the current stack will be masked and let
% the user brighten the stack to correct cell visibility for
% tranforming to bw, then shol
    if exist('brightenedstack','var')
        clear('brightenedstack');
    end
    while 1==1
        brighteningfactor = input(sprintf(['Enter the brightening'...
            ' factor or press enter to continue.\n']));
        if isempty(brighteningfactor)
            if ~exist('brightenedstack','var')
                brightenedstack = stack;
            end
            break;
        else
            brightenedstack = brighteningfactor*stack;
            implay(brightenedstack)
        end
    end
    numobjects = input(sprintf(['How many objects will be'...
        ' segmented in this stack?\n']));

%% let user mask region containing mth object, decide whether to 
%  extract biggest blob, and save the selected object's stack
    for m = 1:numobjects
        disp(['MASKING OBJECT #' m ' IN STACK ' folders(k,:)]);
        while 1 == 1
            try 
                mask = maskmaker(brightenedstack);
                break
            catch err
                tinkerings = input(sprintf(['Press enter to skip'...
                ' masking or type commands\nto be evaluated'...
                ' before masking.\n']), 's');
                if strcmp(tinkerings,'')
                    break
                else
                    tinker();
                end
            end
        end
        while 1==1
            appendObjectToFilename = ['object-' num2str(m)];
            maskedstack = stackmasker(brightenedstack,mask,threshold);
            for page=1:size(maskedstack,3)
                maskedstack(:,:,page) = ExtractNLargestBlobs(maskedstack(:,:,page),1);
            end
            implay(maskedstack);
            tinkerings = input(sprintf(['Either enter 1 to save'...
                ' the binary stack, press enter to skip,\nor enter'...
                ' anything else to tinker.\n']));
            if tinkerings == 1
                disp(['WRITING BINARY STACK:' folders(k,:) '.tif']);
                stackwriter(maskedstack,outputpath,...
                            ['binary-' folders(k,:)],...
                            '',appendObjectToFilename);
                disp(['SUCCESSFULLY WROTE THE STACK NAMED binary-',...
                      folders(k,:),appendObjectToFilename,'.tif' ])
                break
            elseif isempty(tinkerings)
                break
            else
                tinker
            end
        end
            continue
    end
end