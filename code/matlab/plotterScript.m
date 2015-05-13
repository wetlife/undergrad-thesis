% creates separate scatter plots of data from csv

% initialize variables
csvDirectory = '../../data/3-segmented';
csvFiles = ls(fullfile(csvDirectory,'*.csv'));

% initialize figures and set each to hold
eccentricityDotPlot = figure('Name',['Relative Change in'...
                                     'Eccentricity vs. Time'],...
                             'NumberTitle','off');
hold all;
eccentricityPlot = figure('Name','Eccentricity vs. Time',...
                          'NumberTitle','off');
hold all;
areaDotPlot = figure('Name','Relative Change in Area vs. Time',...
                     'NumberTitle','off');
hold all;
areaPlot = figure('Name','Area vs. Time','NumberTitle','off');
hold all;

for csvFileIndex = 1:size(csvFiles,1)
    csvFile         = csvFiles(csvFileIndex,:);
    csvData         = csvread(fullfile(csvDirectory,csvFile));

    time            = csvData(:,1);
    area            = csvData(:,2);
    eccentricity    = csvData(:,3);
    
    % calculate the time derivative of relative area
    areaDot = zeros(length(area)-1,1);
    for areaDotIndex = 1:length(areaDot)
        areaDot(areaDotIndex) =...
            (area(areaDotIndex+1)-area(areaDotIndex));%/...
%             area(1);
    end
        
    % calculate the time derivative of relative eccentrivity
    eccentricityDot = zeros(length(eccentricity)-1,1);
    for eccentricityDotIndex = 1:length(eccentricityDot)
        eccentricityDot(eccentricityDotIndex) =...
            (eccentricity(eccentricityDotIndex+1)...
             -eccentricity(eccentricityDotIndex));%/...
%             /eccentricity(1);
    end

    
    figure(areaPlot);
    scatter(time,area,'+');
    figure(eccentricityPlot);
    scatter(time,eccentricity,'*');
    figure(areaDotPlot);
    scatter(time(1:end-1),areaDot,'.');
    figure(eccentricityDotPlot);
    scatter(time(1:end-1),eccentricityDot,'x');
end  