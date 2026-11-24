clc
clear
close all

%%%%%this file find mat files in the specified folder and merge them

% folders={
% 'C:\Users\majid\Documents\MATLAB\09Spatial_pattern_illuminator\signal_variance_plot\MEA_map_vertical\Rd1_control_verti',...
% 'C:\Users\majid\Documents\MATLAB\09Spatial_pattern_illuminator\signal_variance_plot\MEA_map_vertical\Rd1_transplant_verti',...
% 'C:\Users\majid\Documents\MATLAB\09Spatial_pattern_illuminator\signal_variance_plot\MEA_map_vertical\WT_verti',...
% 'C:\Users\majid\Documents\MATLAB\09Spatial_pattern_illuminator\signal_variance_plot\MEA_map_horizontal\Rd1_control_hori',...
% 'C:\Users\majid\Documents\MATLAB\09Spatial_pattern_illuminator\signal_variance_plot\MEA_map_horizontal\Rd1_transplant_hori',...
% 'C:\Users\majid\Documents\MATLAB\09Spatial_pattern_illuminator\signal_variance_plot\MEA_map_horizontal\WT_hori',...
% };
folders={'F:\IMARIS Computer Backup 2025_06_23\k21166257\Documents\MATLAB\Rceptive_Field_mapping_codes_2\RMF_GNAT1_14092023_9months'};
% Add each folder to MATLAB's search path
for i = 1:length(folders)
    addpath(folders{i});
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%loading vertical bar data
folderPath = folders{1}; % Change this to your target directory
files_verti = dir(fullfile(folderPath, '*.mat'));
qcell_RFM = cell( length(files_verti), 6); % Preallocate cell array

for i = 1:length(files_verti)
    fname_verti = files_verti(i).name;
    a = load(fname_verti) % Load each file into a cell
    A= struct2cell(a);
    b=A{1,1};
    % Transfer elements from the original cell to the new cell array
    for ii = 1:5
        qcell_RFM(i, ii) = b(ii);
    end
    qcell_RFM{i, 6}=fname_verti;    
end

save ('GNAT1_14092023_mat_sample_RF.mat','qcell_RFM')