% Run all first stage analysis
addpath('\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\MATLAB\TDMS')
addpath('\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\MATLAB\TDMS\tdmsSubfunctions')


dataDir  = '\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\Projects\BioWaMet\data\membFouling\';
resultsDir = '\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\Projects\BioWaMet\results\membFouling';


% list = DataCleaning(dataDir,resultsDir); % ,{'20170821112611.tdms'}

[data,fluxData,fluxTime] = CalculateFlux(resultsDir,'20170821112611',100);

% timeData = data.data(:,1);
% dt = data.data(2,1)-data.data(1,1);
% pumpData = data.data(:,7);
% massData = data.data(:,3);
% massNorm = (massData-min(massData))/(max(massData)-min(massData));
% 
% [massData2] = EliminatePumpOnValues(pumpData,massData,dt);
% massNorm2 = (massData2-min(massData2))/(max(massData2)-min(massData2));
% 
% figure(10)
% plot(timeData,massData,timeData,massData2);

figure(10)
plot(fluxTime,fluxData)
axis([0 100000 0 0.22])

% dataFile = TDMS_getStruct([DataDir '\' list(1).name]);