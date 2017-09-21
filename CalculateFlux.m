function [data,fluxData,fluxTime] = CalculateFlux(resultsDir,file,TimeConstant)
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
% Other m-files required: EliminatePumpOnValues.m
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Dr. Craig N Dolder
% Universiy of Southampton
% email: C.N.Dolder@soton.ac.uk
% Website: https://github.com/DapperVibes
% Sep 2017; Last revision: 21-Sep-2017
%
%   Done:
%   - Eliminate data where pump is on
%   To Do:
%   - Average over periods of the time constant
%   - Save meta-data
%   - Save intermediate data


SelfVersion =  'V 002';
disp(['CalculateFlux Version ' SelfVersion])
%------------- BEGIN CODE --------------

data = importdata([resultsDir '\' file 'StepOne.csv']);

timeData = data.data(:,1)-data.data(1,1);
dt = data.data(2,1)-data.data(1,1); % Time step
pumpData = data.data(:,7);
massData = data.data(:,3);

massData2 = EliminatePumpOnValues(pumpData,massData,dt);

% Split into chunks of length TimeConstant
Bins = floor(timeData(end)/TimeConstant);

fluxData = zeros(1,Bins);
fluxTime = zeros(1,Bins);
for i = 1:Bins
    window = (timeData<(i*TimeConstant) & timeData>=((i-1)*TimeConstant));
    tempData = massData2(window);
    tempTime = timeData(window);
    if sum(isnan(tempData))>0
        fluxData(i) = NaN;
        fluxTime(i) = mean(tempTime);
    else
        P = polyfit(tempTime,tempData,1);
        fluxData(i) = P(1);
        fluxTime(i) = mean(tempTime);
    end
end

% slope = diff(data.data(:,3));


%% Figures

% figure(1);
% plot(data.data(:,1),(data.data(:,3)-min(data.data(:,3)))/(max(data.data(:,3))-min(data.data(:,3))),...
%     data.data(:,1),data.data(:,7),subTime,subData,'*')
% 
% 
% figure(2); plot(data.data(2:end,1),slope)


%------------- END OF CODE --------------