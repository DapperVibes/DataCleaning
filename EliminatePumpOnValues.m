function [massData] = EliminatePumpOnValues(pumpData,massData,dt)
%FUNCTION_NAME - Replace mass values when pump is on plus a given constant
%   time after pump has shut off with NaN.
%
% Syntax:  [massData] = EliminatePumpOnValues(pumpData,massData,dt)
%
% Inputs:
%    pumpData   - Data on the state of the pump [1/0]
%    massData   - Mass measurements [g]
%    dt         - Time step [s]
%
% Outputs:
%    massData   - Mass measurement with useless data points as NaN [g]
%
% Example: 
%    None
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
% Sep 2017; Last revision: 21-Sep-2017

%------------- BEGIN CODE --------------

%% Determine the indicies when the pump turns on or off
pumpData = pumpData(:);

% Differentiate the pump status to determine when the pump turns on or off
pumpState = [diff(pumpData); 0];

% If the value is 1 the pump has turned on, if the value is -1 the pump has
% turned off
pumpOn = find(pumpState==1);
pumpOff = find(pumpState==-1);

% Assume there is a lag between the pump turning off and the tube starting
% to fill again. Add this time to the pumpOff indexes.
tLag = 8; % Time lag in seconds

nPoints = ceil(tLag/dt);
pumpOff = pumpOff + nPoints;
% Make sure that this doesn't make any indicies higher than the length of
% the data.
pumpOff(pumpOff>length(pumpState)) = [];

% Determine if sections where the pump is on. There are four cases
% iterating over whether the pump is on or off when the sampling started.
% Then determine the periods where the data can't be used.
if pumpData(1)==1 % Was pump on when data staretd
    if pumpData(end)==1 % Was the pump on then data stopped
        disp('Pump was on when DAQ stared and on when DAQ finished')
        badData(:,1) = [1; pumpOn];
        badData(:,2) = [pumpOff; length(pumpState)];
    else % Was the pump off when the data stopped  
        disp('Pump was on when DAQ stared and off when DAQ finished')
        badData(:,1) = [1; pumpOn];
        badData(:,2) = pumpOff;
    end
else % Was pump off when data staretd
    if pumpData(end)==1 % Was the pump on then data stopped
        disp('Pump was off when DAQ stared and on when DAQ finished')
        badData(:,1) = pumpOn;
        badData(:,2) = [pumpOff; length(pumpState)];
    else % Was the pump off when the data stopped   
        disp('Pump was off when DAQ stared and off when DAQ finished')
        badData(:,1) = pumpOn;
        badData(:,2) = pumpOff;
    end
end

for i = 1:length(badData)
    massData(badData(i,1):badData(i,2)) = NaN;
end

%------------- END OF CODE --------------
