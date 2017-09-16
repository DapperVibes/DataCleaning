% Run all first stage analysis
addpath('\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\MATLAB\TDMS')
addpath('\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\MATLAB\TDMS\tdmsSubfunctions')


DataDir  = '\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\Projects\BioWaMet\data\membFouling\';
SaveDir = '\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\Projects\BioWaMet\results\membFouling';


list = DataCleaning(DataDir,SaveDir); % 

% dataFile = TDMS_getStruct([DataDir '\' list(1).name]);