% Run all first stage analysis
addpath('\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\MATLAB\TDMS')
addpath('\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\MATLAB\TDMS\tdmsSubfunctions')


dataDir  = '\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\Projects\BioWaMet\data\membFouling\';
resultsDir = '\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\Projects\BioWaMet\results\membFouling';


% list = DataCleaning(dataDir,resultsDir); % ,{'20170821112611.tdms'}

data = CalculateFlux(resultsDir,'20170821112611',10);

% dataFile = TDMS_getStruct([DataDir '\' list(1).name]);