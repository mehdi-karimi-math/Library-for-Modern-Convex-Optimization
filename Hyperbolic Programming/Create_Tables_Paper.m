%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Creating the tables in the paper

%% Copyright (c) 2025, by
%% Mehdi Karimi
%% Levent Tuncel
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

short_version = true;

scriptDir_table = fileparts(mfilename('fullpath'))


% Creating Table 1 in the paper. The result will be saved in the current 
% folder as a file 'Table-1.txt', given in Latex format. 

% run(fullfile(scriptDir_table,'Entropy-ESP\HB_entropy_Table'));

% Creating Table 2 in the paper. The result will be saved in the current 
% folder as a file 'Table-2.txt', given in Latex format. 

scriptDir = fileparts(mfilename('fullpath'));
addpath(fullfile(scriptDir, 'solver'));  % This if for adding the Frank-Wolfe code if it was already downloaded and added to the folder. 

run(fullfile(scriptDir_table,'Projection-Hyper Cone\Proj_DDS_FW_Table'));

% Creating Table 3 in the paper. The result will be saved in the current 
% folder as a file 'Table-3.txt', given in Latex format. 

run(fullfile(scriptDir_table,'Vamos-like Hyper Poly\Proj_DDS_Vamos_Table'));


% Creating Table 4 in the paper. The result will be saved in the current 
% folder as a file 'Table-4.txt', given in Latex format. 

run(fullfile(scriptDir_table,'Composite Hyperbolic\Proj_DDS_Comp_Table'));

% Creating Table 5 in the paper. The result will be saved in the current 
% folder as a file 'Table-5.txt', given in Latex format. 

run(fullfile(scriptDir_table,'QRE-Hyper Cone\HB_QRE_Table'));


