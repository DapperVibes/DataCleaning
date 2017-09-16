function [list] = DataCleaning(DataDir,varargin)
%FUNCTION_NAME - File to process first stage of membrane cleaning data.
% Remove NaNs and fix errant data points. The mass data occasionally omits
% the first digit. The algorhythm corrects those data points.
%
% Syntax:  [] = DataCleaning()
%
% Inputs:
%    input1 - Description
%    input2 - Description
%    input3 - Description
%
% Outputs:
%    output1 - Description
%    output2 - Description
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Dr. Craig N Dolder
% Universiy of Southampton
% email: C.N.Dolder@soton.ac.uk
% Website: https://github.com/DapperVibes
% Sep 2017; Last revision: 16-Sep-2017

%------------- BEGIN CODE --------------

disp(nargin)

if exist('FilesToAnalyze','var')
    list = filesToAnalyze;
else
    list = dir([DataDir '\*.tdms']);
end

for i = 1:length(list)
    % Load individual files
    dataFile = TDMS_getStruct([DataDir '\' list(i).name]);
    % Display summary of files loaded
    disp([dataFile.Props.name(7:8) '-' dataFile.Props.name(5:6)...
        '-' dataFile.Props.name(1:4) ' - '  dataFile.Membranes.Props.Note])
end


% Collect raw data files from DataDir directory

% Loop over either FilesToAnalyze or all files

% Fix mass files

% % Locate errant data points
% % Add 100 until it matches local points

% Save cleaned data and meta-data to csv files

%------------- END OF CODE --------------

