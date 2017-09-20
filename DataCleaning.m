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
%    list           - List of files cleaned
%
% Example: 
% DataDir  = '\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\Projects\BioWaMet\data\membFouling\';
% SaveDir = '\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\Projects\BioWaMet\results\membFouling';
% 
% list = DataCleaning(DataDir,SaveDir)
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
% Sep 2017; Last revision: 20-Sep-2017
SelfVersion =  'V 005';

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
    
    saveMatrix = [dataFile.Membranes.Time.data.',...
        dataFile.Membranes.Distance_1__mm_.data.',...
        mass(:,1),...
        dataFile.Membranes.Pump_1__1_0_.data.',...
        dataFile.Membranes.Distance_1__mm_.data.',...
        mass(:,1),...
        dataFile.Membranes.Pump_1__1_0_.data.',...
        dataFile.Membranes.Temp_1__deg_C_.data.',...
        dataFile.Membranes.Temp_2__deg_C_.data.'];
    
    % Extract meta-data
    
    % Check if Code_Version exists, if so record version, of not assume 3
    if isfield(dataFile.Membranes.Props,'DAQ_Version')
        Version = dataFile.Membranes.Props.Code_Version;
    else
        Version = 'V 003';
    end
    
    %% Save meta-data to csv files
    
    MetaData = {'Parameter' 'Value';...
        'Data_Author',dataFile.Membranes.Props.Data_Author;...
        'Note',dataFile.Membranes.Props.Note;...
        'DateTime_Start',dataFile.Membranes.Props.DateTime_Start;...
        'Byte_Count',dataFile.Membranes.Props.Byte_Count;...
        'Sample_Period',dataFile.Membranes.Props.Sample_Period;...
        'DAQ_Version',Version;...
        'Clean_Version',SelfVersion};
        
    outMetaFile = [saveDir '\' list{i}(1:(end-5)) 'Meta.csv'];
    
    %write header to file
    fid = fopen(outMetaFile,'w');
    if fid == -1; error('Cannot open file: %s', outMetaFile); end
    for j = 1:length(MetaData)
        fprintf(fid,[MetaData{j,1} ',' MetaData{j,2} '\n']);
    end
    fclose(fid);

    %% Save cleaned data to csv files

    cHeader = {'Time [s]' 'Distance1 [mm]' 'Mass1 [g]' 'Pump1 [1/0]'...
        'Distance2 [mm]' 'Mass2 [g]' 'Pump1 [1/0]'...
        'Temp1 [degC]' 'Temp1 [degC]'}; % Data File Header
    textHeader = strjoin(cHeader, ',');
    
    outFile = [saveDir '\' list{i}(1:(end-5)) 'StepOne.csv'];
    
    %write header to file
    fid = fopen(outFile,'w');
    if fid == -1; error('Cannot open file: %s', outFile); end
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    
    dlmwrite(outFile,saveMatrix,'-append','delimiter',',','precision','%4.6f')
    
end





%------------- END OF CODE --------------

