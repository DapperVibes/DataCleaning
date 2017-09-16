% Run all first stage analysis
addpath('\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\MATLAB\TDMS')
addpath('\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\MATLAB\TDMS\tdmsSubfunctions')


DataDir  = '\\filestore.soton.ac.uk\users\cnd1g15\mydocuments\Projects\BioWaMet\data\membFouling\';

list = DataCleaning(DataDir,{'20170823094547.tdms'}); % 

% dataFile = TDMS_getStruct([DataDir '\' list(1).name]);