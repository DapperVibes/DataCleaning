function [data] = CalculateFlux(resultsDir,file,TimeConstant)
%FUNCTION_NAME - Calculated the flux from the mass data
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
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
% Sep 2017; Last revision: 20-Sep-2017
%
%   To Do:
%   - Eliminate data where pump is on
%   - Average over periods of the time constant
%   - Save meta-data
%   - Save intermediate data


SelfVersion =  'V 001';
disp(['CalculateFlux Version ' SelfVersion])
%------------- BEGIN CODE --------------

data = importdata([resultsDir '\' file 'StepOne.csv']);

subTime = data.data(logical(1-data.data(:,4)),1);
subData = data.data(logical(1-data.data(:,4)),3);

slope = diff(data.data(:,3));
%% Figures

figure(1);
plot(data.data(:,1),(data.data(:,3)-min(data.data(:,3)))/(max(data.data(:,3))-min(data.data(:,3))),...
    data.data(:,1),data.data(:,7))


figure(2); plot(data.data(2:end,1),slope)


%------------- END OF CODE --------------