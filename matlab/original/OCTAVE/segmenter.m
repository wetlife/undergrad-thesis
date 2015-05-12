% this script segments each object in a tiff-stack in its own stack
% by asking the user to mask a region constaining only one object.
% user decides how much to brighten and threshold the image for
% segmentation
directory = ['/home/thomasky/winhome/Research/2D-fibertraction/_prep-to-mask-and-binarize/good-images-no-beads'];
%directory = ['C:\Users\thomasky\Research\2D-fibertraction\'...
%    '_prep-to-mask-and-binarize\good-images-no-beads'];
outputPath = fullfile(directory, '..', '..', 'binary-from-octave');
threshold = 0.15;
defaultBrighteningFactor = 15;
folders = ls(directory);
startingfolder = 1;
%% attempt to resume from the folder that the program left off at
%%%%%%%%%%%%%%%%%%commented for scripting%%%%%%%%%%%%%%%%
% if exist('k','var')
%     resume = input(sprintf(['Enter the folder number to start'...
%         ' with or press enter to attempt\nresuming where the'...
%         ' program left off.\n']));
%     if isempty(resume)
%         startingfolder = k;
%     else
%         startingfolder = resume;
%     end
% else
%     startingfolder = 1;
% end

for k=startingfolder:length(folders(:,1))
    
    
    %% read all folders in directory and skip folders with no tiffs
    stackDirectory = fullfile(directory,strtrim(folders(k,:)));
    if size(dir(fullfile(stackDirectory,'*.tif')),1)==0 &&...
            isdir(stackDirectory)
        continue
    end

    %% read stack in current folder
    disp(['FOLDER #' num2str(k) ': ' folders(k,:)]);
    stack = stackreader(stackDirectory,'*.tif');
    
    %% Loop through binarizing stack until ok
    
    %%%%%%%%%%%%%%%%%%commented for scripting%%%%%%%%%%%%%%%%
    %     if exist('brightenedStack','var')
    %         clear('brightenedStack');
    %     end
    %     ok = 0;
    %     while ~isempty(ok)
    %         
    %         % get brightening factor from user or use default
    %         if ok ~= 0
    %             brighteningFactor = ok;
    %         end
    %         if ~exist('brighteningFactor','var')
    %             brighteningFactor = defaultBrighteningFactor;
    %         end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % brighten, binarize, and fill the stack
        bwStack = zeros(size(stack));
        for page=1:size(stack,3)
            bwStack(:,:,page) =...
              imfill(im2bw(brighteningFactor*stack(:,:,page)),...
                     'holes');
        end
        
        % show stack and ask if ok, not ok => redo w/ new parameters
    
    %%%%%%%%%%%%%%%%%%commented for scripting%%%%%%%%%%%%%%%%
    %         implay(bwStack);
    %         ok = input(['PRESS ENTER IF B&W STACK IS OK OR ENTER NEW '...
    %                    'BRIGHTENING FACTOR: ']);
    
end
%% let user mask region containing mth object amd decide whether to 
%  save the selected object's stack

    % ask how many objects in the current stack will be masked
    numobjects = input(sprintf(['How many objects will be'...
        ' segmented in this stack?\n']));

    % for each object, let user create mask
    for m = 1:numobjects
        disp(['MASKING OBJECT #' num2str(m)...
              ' IN STACK ' folders(k,:)]);
        mask = maskmaker(bwStack);
        while 1==1
            appendObjectToFilename = ['object-' num2str(m)];
            maskedstack = stackmasker(bwStack,mask,threshold);
            for page=1:size(maskedstack,3)
                maskedstack(:,:,page) = ExtractNLargestBlobs(maskedstack(:,:,page),1);
            end
            
            % show masked stack. ask if ok. ok => save 1-object-stack
            implay(maskedstack);
            ok = input(sprintf(['Either enter 1 to save'...
                ' the binary stack, press enter to skip,\nor enter'...
                ' anything else to tinker.\n']));
            if ok == 1
                disp(['WRITING BINARY STACK:' folders(k,:) '.tif']);
                stackwriter(maskedstack,outputPath,...
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
end
