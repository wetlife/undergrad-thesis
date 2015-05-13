folder = '../../data/3-segmented';
files = ls(fullfile(folder,'*.tif'));
for file = 1:size(files,1) 

    % ask for time interval between z-stack acquisition
    stack = stackreader(folder,files(file,:));

    % get time, area, and eccetricity values of object for each page
    disp('######################################################');
    disp(['PROCESSING SEGMENTED OBJECT #' num2str(file) ':']);
    disp( files(file,:) );
    disp('######################################################');
    timeInterval = input('\nTIME BETWEEN Z-STACKS: ');
    timeOffset = input(['NUMBER OF Z-STACKS BEFORE '...
                    'TRYPLE SELECT WAS ADDED: ']);
    time            = zeros(size(stack,3),1);
    area            = zeros(size(stack,3),1);
    eccentricity    = zeros(size(stack,3),1);
    for page = 1:size(stack,3)
        time(page) = (page - timeOffset - 1)*timeInterval
        info = regionprops(stack(:,:,page),'Area','Eccentricity');
        for region = 1:size(info,1)
            if info(region).Area ~= 0
                area(page) = info(region).Area
            end
            if info(region).Eccentricity ~= 0
                eccentricity(page) = info(region).Eccentricity
            end
        end
    end
    % store time, area, and eccetricity values of object for each page
    data = cat(2,time,cat(2,area,eccentricity));

    % write time, area, and eccentricity to csv
    csvFilename = fullfile(folder,[files(file,:) '.csv']);
    dlmwrite(csvFilename,data,'newline','pc')
    disp(sprintf(['WROTE DATA TO FILE ' ]));

end