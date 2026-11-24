clc
clear all
close all
%%%%this code multiply and sum the matrices
%%%%both of Main_RC_batch_file_process are applicable for different
%%%%purposes
tic



run('nexDataParser_04_RC_scan_Rverti.m')
save RC_verti_map_vector.mat RC_verti_map_vector RC_verti_Neuron_amp RC_verti_map_matrix neuronClassType_verti_bar
% RC_verti_map_vector=zeros(1,30);%%%%firing rate for example neuron

%%%RC_verti_map_vector(1x30)  contains the single neuron amplitude values
%%%RC_verti_Neuron_amp(30x1)cell  contains the amplitude values for all neurons
%%%RC_verti_map_matrix(12x12x30)  contains 12x12 heatmap matrix values for each bar

run('nexDataParser_05_RC_scan_Rhori.m')
save RC_hori_map_vector.mat RC_hori_map_vector RC_hori_Neuron_amp RC_hori_map_matrix neuronClassType_hori_bar
% RC_hori_map_vector=zeros(60,1);%%%%firing rate for example neuron

%%%RC_hori_map_vector(60x1)  contains the single neuron amplitude values
%%%RC_hori_Neuron_amp(60x1)cell  contains the amplitude values for all neurons
%%%RC_hori_map_matrix(12x12x60)  contains 12x12 heatmap matrix values for each bar

%%
%%%reevaluate from here%%%%
%%%%%set scale bar limits 
heatleftlim=0; 
heatrightlim=100;


load('RC_verti_map_vector.mat')
load('RC_hori_map_vector.mat')

%%%this cell save 3 matrices values for mapped receptive fields
qcell_RFM=cell(1,5);


row_ind=60;col_ind=30;
%%%this line give a matrix with repititive columns or rows
% row_ind=1:60;col_ind=1:30;

RC_heatmap_matrix_verti=zeros(60,30);%%%%firing rate for example neuron
RC_heatmap_matrix2_hori=zeros(60,30);%%%%firing rate for example neuron

% RC_heatmap_matrix_verti(row_ind,:)= RC_verti_map_vector;
% RC_heatmap_matrix2_hori(:,col_ind)= RC_hori_map_vector;


% % Repeat the column vector to create a matrix with 10 columns
% matrix = repmat(column_vector, 1, 10)  %%%this can be used too

for i=1:row_ind
RC_heatmap_matrix_verti(i,:)= normalize(RC_verti_map_vector,'range');
% RC_heatmap_matrix_verti(i,:)= RC_verti_map_vector;
end
for j=1:col_ind
RC_heatmap_matrix2_hori(:,j)= normalize(RC_hori_map_vector,'range');
% RC_heatmap_matrix2_hori(:,j)= RC_hori_map_vector;
end


RC_heatmap_mltply=RC_heatmap_matrix_verti.*RC_heatmap_matrix2_hori;
RC_heatmap_plus=(RC_heatmap_matrix_verti+RC_heatmap_matrix2_hori)./2;




% RC_heatmap=normalize(RC_heatmap,'zscore');
%%%%average for overlapping value
% RC_heatmap(row_ind,col_ind)= RC_heatmap(row_ind,col_ind)/2;


close all

figure;
h=heatmap(RC_verti_map_vector,'Colormap',jet);
% Set specific color limits for the scale bar
colorLimits = [heatleftlim, heatrightlim];
h.ColorLimits = colorLimits;
title('RC verti map Max Amplitude ')

figure;
h=heatmap(RC_hori_map_vector,'Colormap',jet);
% Set specific color limits for the scale bar
colorLimits = [heatleftlim, heatrightlim];
h.ColorLimits = colorLimits;
title('RC hori map Max Amplitude ')




%%%%%set scale bar limits 
heatleftlim=0; 
heatrightlim=1;


figure;
h=heatmap(RC_heatmap_mltply,'Colormap',jet);
% Set specific color limits for the scale bar
% colorLimits = [heatleftlim, heatrightlim];
% h.ColorLimits = colorLimits;
title(' Multiplification of Max Amplitude ')

%%%%to save the value in mat file
qcell_RFM{1,3}= RC_heatmap_mltply;%%%Multiplification of Max Amplitude

% figure;surfc(RC_heatmap_mltply)
% view(2)

% %%%%%set scale bar limits 
% heatleftlim=0; 
% heatrightlim=1;


figure;
h=heatmap(RC_heatmap_plus,'Colormap',jet);
% Set specific color limits for the scale bar
% colorLimits = [heatleftlim, heatrightlim];
% h.ColorLimits = colorLimits;
title(' sum of Max Amplitude ')

% figure;surfc(RC_heatmap_plus)
% view(2)

% RC_heatmap_matrix=zeros(60,30);%%%%firing rate for example neuron
% RC_heatmap_matrix=zeros(60,30);%%%%firing rate for example neuron
%%%heatmap for heatmap matirces
verti_sum_matrices = sum(RC_verti_map_matrix,3)./30;
hori_sum_vertices = sum(RC_hori_map_matrix,3)./60;
total_matrices=(verti_sum_matrices+hori_sum_vertices)./2;

heatleftlim=0; heatrightlim=10;

figure;
h=heatmap(total_matrices,'Colormap',jet);
% Set specific color limits for the scale bar
colorLimits = [heatleftlim, heatrightlim];
h.ColorLimits = colorLimits;
title(' total heatmap matrices average for Max Amplitude ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Gaussina fitting
% figure;
% imagesc(RC_heatmap_mltply)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gaussian fitting for multiplied matrices
% Define the threshold
threshold = 0.4;
% Replace all values below the threshold with zero
RC_heatmap_mltply(RC_heatmap_mltply < threshold) = 0;

% Define the 2D Gaussian function
gaussian2D = @(b, x) b(1) * exp(-((x(:,1)-b(2)).^2 / (2*b(4)^2) + (x(:,2)-b(3)).^2 / (2*b(5)^2))) + b(6);

% Step 1: Smooth the data using a Gaussian filter
sigma = 2; % Standard deviation for Gaussian filter (adjust as necessary)
smoothedDataMatrix2 = imgaussfilt(RC_heatmap_mltply, sigma);
smoothedDataMatrix = RC_heatmap_mltply;

% %median filtering can be used instead of thresholding
% % Apply median filtering
% filteredDataMatrix = medfilt2(smoothedDataMatrix);



% Create a grid for the data
[xData, yData] = meshgrid(1:size(smoothedDataMatrix, 2), 1:size(smoothedDataMatrix, 1));
xData = xData(:);
yData = yData(:);
zData = smoothedDataMatrix(:);

% Initial guesses for the parameters [amplitude, x0, y0, sigma_x, sigma_y, offset]
initialGuess = [max(zData), mean(xData), mean(yData), std(xData), std(yData), min(zData)];

% Fit the Gaussian model to the data
% fitParams = nlinfit([xData, yData], zData, gaussian2D, initialGuess);
% % Perform the optimization using lsqcurvefit
% fitParams = lsqcurvefit(gaussian2D, initialGuess, [xData, yData], zData);
% Step 5: Set options for lsqcurvefit to refine tolerances
options = optimoptions('lsqcurvefit', 'FunctionTolerance', 1e-8, 'OptimalityTolerance', 1e-8, 'Display', 'iter');

% Step 6: Perform the optimization using lsqcurvefit with refined tolerances
fitParams = lsqcurvefit(gaussian2D, initialGuess, [xData, yData], zData, [], [], options);


% Create a grid for visualization
[X, Y] = meshgrid(1:size(smoothedDataMatrix, 2), 1:size(smoothedDataMatrix, 1));

% Calculate the fitted Gaussian
Z_fit = gaussian2D(fitParams, [X(:), Y(:)]);
Z_fit = reshape(Z_fit, size(smoothedDataMatrix, 1), size(smoothedDataMatrix, 2));

% Plot the original data
figure;
% subplot(1, 2, 1);
imagesc(smoothedDataMatrix2);
title('Fitted Gaussian for Multiplication Matrix');
colorbar;
axis image;

% Plot the fitted Gaussian
figure
% subplot(1, 2, 2);
imagesc(RC_heatmap_mltply);
title('Original Data for Multiplication Matrix');
colorbar;
axis image;

qcell_RFM{1,1}= smoothedDataMatrix2;%%Fitted Gaussian for Multiplication Matrix
qcell_RFM{1,2}= RC_heatmap_mltply; %%Original Data for Multiplication Matrix
qcell_RFM{1,4}= neuronClassType_verti_bar;
qcell_RFM{1,5}= neuronClassType_hori_bar;
%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%gaussian fitting for summed matrices

% Define the threshold
threshold = 0.7;
% Replace all values below the threshold with zero
RC_heatmap_plus(RC_heatmap_plus < threshold) = 0;

% Define the 2D Gaussian function
gaussian2D = @(b, x) b(1) * exp(-((x(:,1)-b(2)).^2 / (2*b(4)^2) + (x(:,2)-b(3)).^2 / (2*b(5)^2))) + b(6);

% Step 1: Smooth the data using a Gaussian filter
sigma = 2; % Standard deviation for Gaussian filter (adjust as necessary)
smoothedDataMatrix = imgaussfilt(RC_heatmap_plus, sigma);

% Create a grid for the data
[xData, yData] = meshgrid(1:size(smoothedDataMatrix, 2), 1:size(smoothedDataMatrix, 1));
xData = xData(:);
yData = yData(:);
zData = smoothedDataMatrix(:);

% Initial guesses for the parameters [amplitude, x0, y0, sigma_x, sigma_y, offset]
initialGuess = [max(zData), mean(xData), mean(yData), std(xData), std(yData), min(zData)];

% Fit the Gaussian model to the data
% fitParams = nlinfit([xData, yData], zData, gaussian2D, initialGuess);

% % Perform the optimization using lsqcurvefit
% fitParams = lsqcurvefit(gaussian2D, initialGuess, [xData, yData], zData);

% Step 5: Set options for lsqcurvefit to refine tolerances
options = optimoptions('lsqcurvefit', 'FunctionTolerance', 1e-8, 'OptimalityTolerance', 1e-8, 'Display', 'iter');

% Step 6: Perform the optimization using lsqcurvefit with refined tolerances
fitParams = lsqcurvefit(gaussian2D, initialGuess, [xData, yData], zData, [], [], options);

% Create a grid for visualization
[X, Y] = meshgrid(1:size(smoothedDataMatrix, 2), 1:size(smoothedDataMatrix, 1));

% Calculate the fitted Gaussian
Z_fit = gaussian2D(fitParams, [X(:), Y(:)]);
Z_fit = reshape(Z_fit, size(smoothedDataMatrix, 1), size(smoothedDataMatrix, 2));

% Plot the original data
figure;
subplot(1, 2, 1);
imagesc(smoothedDataMatrix);
title('Original Data for sum Matrix');
colorbar;
axis image;

% Plot the fitted Gaussian
subplot(1, 2, 2);
imagesc(Z_fit);
title('Fitted Gaussian for sum Matrix');
colorbar;
axis image;
%}
filename3=strcat(filename3,'_RFM.mat');
save (filename3,'qcell_RFM')

toc