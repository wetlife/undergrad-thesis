% reads images in given directory matching given
% pattern into a stack
% stack = stackreader(stackDirectory, filenamematchingstring)
function stack = stackreader(stackDirectory, filenamematchingstring)

% reads cellarray of fileinfo for images in directory matching pattern
files = dir(fullfile(stackDirectory, filenamematchingstring));

% if only one matching image file then assume a multipage image
% (e.g., reads a multipage .tif)
if length(files) == 1
    fname = files.name;
    filenameWithPath = fullfile(stackDirectory, fname);
    info = imfinfo(filenameWithPath);
    numImages = numel(info);
    stack = zeros([1024 1024 numImages]);
    for page = 1:numImages
        stack(:,:,page) = imread(filenameWithPath, page, 'Info', info);
    end
    
% WARN: didn't find any matching files
elseif isempty(files)
    disp('ERROR: No matching image files');
    return


% else assumes each file is a single page tif and reads files as 2d
% images into an array named stack
% (reads filename-specified tifs in specified directory into stack)
else
    numImages = length(files);
    stack = zeros([1024 1024 numImages],'uint8');
    for page = 1:numImages
      filenameWithPath = fullfile(stackDirectory,files(page).name);
      stack(:,:,page) = imread(filenameWithPath);
    end
end