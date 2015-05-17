% mip returns the 2D maximum intensity projection of all same-sized 
% images matching fileString in folder folderString.
% Most of this code was taken from Mathworks' Matlab tutorial, titled
% working-with-image-sequences.
function outputImage = mip(folder,filenameMatchingString)
% Create an array of filenames that make up the image sequence
%%%%fileFolder = fullfile(folder);
files = dir( fullfile( folder, filenameMatchingString));
filenames = {files.name};
numFrames = numel(filenames);

I = imread(fullfile( folder, filenames{1}));

% Preallocate the array
sequence = zeros([size(I) numFrames],class(I));
sequence(:,:,1) = I;

% Create image sequence array
for p = 2:numFrames
    sequence(:,:,p) = imread(fullfile( folder, filenames{p})); 
end

% Process sequence
outputImage = max(sequence,[],3);

% View results
% figure;
% imshow(outputImage);
end