function [list] = DataCleaning(sataDir,saveDir,varargin)
%FUNCTION_NAME - File to process first stage of membrane cleaning data.
% Remove and fix errant data points. The mass data occasionally omits
% the first digit or registers as zero. The algorhythm corrects those data
% points by setting all values below 200 g to NaN and then interpolating
% over NaNs. The corrected data is then saved in .csv format.
%
% Syntax:  [] = DataCleaning()
%
% Inputs:
%    DataDir        - Directory of raw data
%    SaveDir        - Directory of saving processed data
%    FilesToAnalyze - Cell array of files to analyze
%
% Outputs:
%    list           - List of files analyzed
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: TDMS toolbox
% Subfunctions: TDMS toolbox
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Dr. Craig N Dolder
% Universiy of Southampton
% email: C.N.Dolder@soton.ac.uk
% Website: https://github.com/DapperVibes
% Sep 2017; Last revision: 16-Sep-2017

%------------- BEGIN CODE --------------

if nargin == 3
    filesToAnalyze = varargin{1};
end

if exist('filesToAnalyze','var')
    list = filesToAnalyze;
else
    temp = dir([sataDir '\*.tdms']);
    list = cell(1,length(temp));
    for i = 1:length(temp)
        list{i} = temp(i).name;
    end
end

% Print summary (might be excluded later)
for i = 1:length(list)
    % Load individual files
    dataFile = TDMS_getStruct([sataDir '\' list{i}]);
    % Display summary of files loaded
    disp([dataFile.Props.name(7:8) '-' dataFile.Props.name(5:6)...
        '-' dataFile.Props.name(1:4) ' - '  dataFile.Membranes.Props.Note])
end

% Loop over either FilesToAnalyze or all files
for i = 1:length(list)
    disp(['Cleaning ' list{i}])
    
    % Load and display mass vectors
    dataFile = TDMS_getStruct([sataDir '\' list{i}]);
    
    
    % % Locate errant data points
    figure(1)
    subplot(2,1,1)
    plot(dataFile.Membranes.Time.data,dataFile.Membranes.Mass_1__g_.data)
    axis([dataFile.Membranes.Time.data(end)-1000 ... 
        dataFile.Membranes.Time.data(end) 0 800])
    hold on
    subplot(2,1,2)
    plot(dataFile.Membranes.Time.data,dataFile.Membranes.Mass_2__g_.data)
    axis([dataFile.Membranes.Time.data(end)-1000 ... 
        dataFile.Membranes.Time.data(end) 0 800])
    hold on
    

    % Interpolate over zeros and values less than 200 g;
    mass = ElimAndInterpZeros(dataFile.Membranes.Mass_1__g_.data).';
    mass(:,2) = ElimAndInterpZeros(dataFile.Membranes.Mass_2__g_.data);
    
    subplot(2,1,1)
    plot(dataFile.Membranes.Time.data,mass(:,1))
    axis([dataFile.Membranes.Time.data(end)-1000 ... 
        dataFile.Membranes.Time.data(end) 0 800])
    subplot(2,1,2)
    plot(dataFile.Membranes.Time.data,mass(:,2))
    axis([dataFile.Membranes.Time.data(end)-1000 ... 
        dataFile.Membranes.Time.data(end) 0 800])
    hold off
    
    pause(0.05)
    
    saveMatrix = [dataFile.Membranes.Time.data.', mass];
    
    % Save cleaned data and meta-data to csv files

    cHeader = {'Time' 'Mass1' 'Mass2'}; % Data File Header
    textHeader = strjoin(cHeader, ',');
    
    outFile = [saveDir '\' list{i}(1:(end-5)) '.csv'];
    
    %write header to file
    fid = fopen(outFile,'w');
    if fid == -1; error('Cannot open file: %s', outFile); end
    fprintf(fid,'%s\n',textHeader);
%     for i = 1:length(mass)
%         fprintf(fid, '%1.12f, %d, %d\n', saveMatrix(i,:));
%     end
    fclose(fid);
    
    %write data to end of file
%     dlmwrite([saveDir '\' list{i}(1:(end-5)) '.csv'],saveMatrix,...
%         '-append','precision',12);
    dlmwrite(outFile,saveMatrix,'-append','delimiter',',','precision','%4.6f')
    
end





%------------- END OF CODE --------------

