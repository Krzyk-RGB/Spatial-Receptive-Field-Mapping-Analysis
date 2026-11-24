clc
clear
close all

%%%%the inoutput mat file from 'load_Plot_RFM' is the the input for this
%%%%file. This code refines the ambigoues and doggy receptive field
addpath('C:\Users\k21166257\Documents\MATLAB\Rceptive_Field_mapping_codes_2')

%%%%%%%%%%%%%%%%%%%%%%%%  WT  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('C:\Users\k21166257\Documents\MATLAB\Rceptive_Field_mapping_codes_2\RFM_GNAT1_22052024')
filename='GNAT1_22052024_mat_N1to30_sample_RF.mat_RF_dimensions.mat';
selected_neurons = [4,5,6,8,9,11,19,20,21,22,23,25,28];
selected_neurons = sort(selected_neurons);



% filename='.mat';
% selected_neurons = [];
% selected_neurons = sort(selected_neurons);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
load(filename)
%%%it loads RF_dimensions cell
%%%indices name: 1:diameter 2:area 3: i 4:Fitted Gaussian for
%%%Multiplication Matrix 5:thresholded matrix 6: centered_matrix


% Select and separate the rows from the cell array
selectedRows = RF_dimensions(selected_neurons,:);
[ms ns]=size(selectedRows);

%{
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Extract the  4:Fitted Gaussian for Multiplication Matrix of each row
for i = 1:ms
    FGMM_matrixElements{i} = selectedRows{i, 4}; % Extract the favorite element of each row
end

% Plot each favorite element in a new figure
for i = 1:length(FGMM_matrixElements)
    figure;
    imagesc(FGMM_matrixElements{i});
    xlabel('Index');
    ylabel('Value');
    title(['Plot of First Element of Row ', num2str(selected_neurons(i))]);
    axis off
    colorbar;
end
%}





% %{
% %%%%%%%%%%%%%%%%%%%%%%%%%%Extract the centered_matrix element of each row
for i = 1:ms
    centered_matrixElements{i} = selectedRows{i, 6}; % Extract the favorite element of each row
end

% Plot each favorite element in a new figure
for i = 1:length(centered_matrixElements)
    figure;
    imagesc(centered_matrixElements{i});
    xlabel('Index');
    ylabel('Value');
    title(['Plot of First Element of Row ', num2str(selected_neurons(i))]);
    axis off
    
end
%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Extract the thresholded matrix element of each row
for i = 1:ms
    thresholded_matrixElements{i} = selectedRows{i, 5}; % Extract the favorite element of each row
end

% Plot each thresholded matrix element in a new figure
figure
for i = 1:length(thresholded_matrixElements)
    %{
    figure;
    imagesc(thresholded_matrixElements{i});
    xlabel('Index');
    ylabel('Value');
    title(['Plot of First Element of Row ', num2str(selected_neurons(i))]);
    axis off
    %}

%%%%plotting circle or oval around the RF
matrix = thresholded_matrixElements{i};  %%%%%assine the matrix value

%{
Find the indices of positive values
[rowIdx, colIdx] = find(matrix > 0);
% Determine the bounding box for positive values
rowStart = min(rowIdx);
rowEnd = max(rowIdx);
colStart = min(colIdx);
colEnd = max(colIdx);

% Calculate the center and dimensions of the bounding box
centerRow = (rowStart + rowEnd) / 2; % Center row
centerCol = (colStart + colEnd) / 2; % Center column
height = rowEnd - rowStart + 1; % Height of the box
width = colEnd - colStart + 1; % Width of the box

% Scale the dimensions slightly for the oval/circle
scaleFactor = .2; % Adjust to make the oval larger
ovalHeight = height * scaleFactor;
ovalWidth = width * scaleFactor;

% Plot the matrix grid (optional, for visual reference)
% figure;
% imagesc(matrix);
% colormap hot;

% hold on;

% Plot the oval/circle around the region
rectangle('Position', [centerCol - ovalWidth/2, centerRow - ovalHeight/2, ovalWidth, ovalHeight], ...
          'Curvature', [1, 1], ... % Make it an oval/circle
          'EdgeColor', 'k', ... % Color of the outline
          'LineWidth', 2); % Thickness of the outline
%}

% Find the indices and values of positive elements
[rowIdx, colIdx, values] = find(matrix > 0.01);
%{
% Calculate the weighted center
totalValue = sum(values);
weightedRow = sum(rowIdx .* values) / totalValue; % Weighted mean of row indices
weightedCol = sum(colIdx .* values) / totalValue; % Weighted mean of column indices

% Determine the bounding box for positive values
rowStart = min(rowIdx);
rowEnd = max(rowIdx);
colStart = min(colIdx);
colEnd = max(colIdx);

% Calculate the dimensions of the bounding box
height = rowEnd - rowStart + 1; % Height of the box
width = colEnd - colStart + 1; % Width of the box

% Scale the dimensions slightly for the oval/circle
scaleFactor = .3; % Adjust to make the oval larger
ovalHeight = height * scaleFactor;
ovalWidth = width * scaleFactor;

% Plot the matrix grid using imagesc
% figure;
imagesc(matrix);
% colormap('hot'); % Adjust the colormap
% hold on;

% Plot the oval/circle around the region using the weighted center
rectangle('Position', [weightedCol - ovalWidth/2, weightedRow - ovalHeight/2, ovalWidth, ovalHeight], ...
          'Curvature', [1, 1], ... % Make it an oval/circle
          'EdgeColor', 'b', ... % Color of the outline
          'LineWidth', 2); % Thickness of the outline
%}

% Calculate the weighted center (enhanced accuracy)
totalValue = sum(values);
weightedRow = sum(rowIdx .* values) / totalValue; % Weighted mean of row indices
weightedCol = sum(colIdx .* values) / totalValue; % Weighted mean of column indices

% Refine the bounding box dimensions based on weighted values
weightedRowStd = sqrt(sum(values .* ((rowIdx - weightedRow) .^ 2)) / totalValue);
weightedColStd = sqrt(sum(values .* ((colIdx - weightedCol) .^ 2)) / totalValue);

% Scale the dimensions slightly for the oval/circle
scaleFactor = 0.6; % Adjust to make the oval larger
ovalHeight = 2 * weightedRowStd * scaleFactor; % Based on weighted standard deviation
ovalWidth = 2 * weightedColStd * scaleFactor;

% Plot the matrix grid using imagesc
% figure;
% imagesc(matrix);
% colormap('hot'); % Adjust the colormap
% colorbar;
% hold on;
% Plot the oval/circle around the region using the refined center
rectangle('Position', [weightedCol - ovalWidth/2, weightedRow - ovalHeight/2, ovalWidth, ovalHeight], ...
          'Curvature', [1, 1], ... % Make it an oval/circle
          'EdgeColor', 'b', ... % Color of the outline
          'LineWidth', 2); % Thickness of the outline



% Configure plot
% [mp np]=size(matrix);
% axis ([0 np 0 np]);
axis equal
xlim([1 30])
ylim([1 60])
set(gca, 'YDir', 'reverse'); % Flip Y-axis to align with matrix indexing


% title('Circular/Oval Boundary Around Positive Values');
% xlabel('Columns');
% ylabel('Rows');

% Set the background color to yellow
set(gca, 'Color', [1, 1, 1]); % RGB color for yellow =[1, 1, 0] background

% % Remove tick marks and labels
set(gca, 'XTick', [], 'YTick', []); % Remove ticks
% set(gca, 'XColor', 'y', 'YColor', 'y'); % Keep frame in black
set(gca, 'YTickLabel',[],'XTickLabel',[] );
box on; % Ensure the axes box remains visible

  
end

%%%%%%adding a scale to the RFM plot%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on;

% Define scale bar properties
scale_length_units = 3.5; % 4 units in your figure corresponds to 100 µm
x_start = 26; % Starting position on the x-axis
y_start = 58; % Position slightly above the x-axis for visibility

% Draw the scale bar
line([x_start, x_start + scale_length_units], [y_start, y_start], ...
    'Color', 'k', 'LineWidth', 3); % White scale bar, 3px thick

% Add text label for scale
text(x_start + scale_length_units / 2, y_start + 1, '100 µm', ...
    'Color', 'k', 'FontSize', 10,'FontWeight', 'bold', 'HorizontalAlignment', 'center');

hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%Ploting line correspondent too light bar positions

% % % Plot the vertical line at x = 1
% for ii=2:3.7:30
% xline(ii, 'y', 'LineWidth', 10); % Red vertical line with a thickness of 2
% hold on
% end
% axis off



% Plot the horizontal line at y = 1
% for ii=5.53:4.615:60
% yline(ii, 'y', 'LineWidth', 10); % Red vertical line with a thickness of 2
% set(gca, 'XTick', [], 'YTick', []); % Remove ticks
% hold on
% end


%{

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%statistics  selected neurons%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the thresholded matrix element of each row
%%%1: diameter  2: area
%%%%%RF Diameter comparison
for ii = 1:ms
    thresholded_matrixElements_2{ii} = selectedRows{ii, 1}; % Extract the favorite element of each row
end

data=cell2mat(thresholded_matrixElements_2);


fontsize =25;
% Box plot showing mean and standard deviation
figure;
boxplot(data, 'Whisker', 1.5); % The whiskers will show the data spread

% Overlay mean and standard deviation on boxplot
hold on;
meanValue = mean(data);
stdValue = std(data);
plot(1, meanValue, 'ro', 'MarkerSize', 9, 'LineWidth', 3); % Mean as red circle
plot([1, 1], [meanValue - stdValue, meanValue + stdValue], 'b-', 'LineWidth', 3); % Std deviation as blue line
hold off;

% Labeling
title('Box Plot with Mean and Standard Deviation','FontSize',fontsize)
ylabel('Diameter(micron)','FontSize',fontsize)
set(gca, 'XTick', []) % Remove x-tick if single dataset
set(gca, 'YTickLabel', get(gca, 'YTickLabel'), 'FontSize', fontsize);

%%%%%%%%or violin plot%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
% full violin plots with white embedded boxplots for 3x2 data

h = daviolinplot(data','xtlabels', 'WT', 'violin','full',...
    'boxcolors','w');  
ylabel('Diameter');
% xl = xlim; xlim([xl(1), xl(2)+0.25]);    % make space for the legend
% legend([h.ds(1,:)],group_names(1:3));    % add the legend manually
set(gca,'FontSize',20);


figure
[h,L,MX,MED]=violin(data');
ylabel('Diameter','FontSize',14)



%%%%%%%%or%%%%%%%%%%%%%%%%

% Calculate mean and standard deviation
meanValue = mean(data);
stdValue = std(data);

% Plot data points
figure;
plot(data, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'cyan', 'MarkerEdgeColor', 'black');
hold on;

% Plot mean line
yline(meanValue, 'r--', 'LineWidth', 3); % Mean as red dashed line

% Plot standard deviation lines
yline(meanValue + stdValue, 'b-.', 'LineWidth', 2); % Mean + Std Dev as blue dot-dash line
yline(meanValue - stdValue, 'b-.', 'LineWidth', 2); % Mean - Std Dev as blue dot-dash line

% Labeling
title('Data Plot with Mean and Standard Deviation Lines','FontSize',fontsize)
xlabel('Data Index','FontSize',fontsize)
ylabel('Diameter(micron)','FontSize',fontsize)
set(gca, 'YTickLabel', get(gca, 'YTickLabel'), 'FontSize', fontsize);
legend('Data points', 'Mean', 'Mean ± Std Dev','FontSize',fontsize)
hold off;


% save data_diameter_19092023_WT_RFM data
% save data_diameter_25092024_WT_RFM_RFM data
% save data_diameter_170723_rd1_transplant_RFM data

%%
%%%%%%%%%%%Area comparison  2:
%%%%%%%%%%%area%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1:ms
    thresholded_matrixElements_2{ii} = selectedRows{ii, 2}; % Extract the favorite element of each row
end

data=cell2mat(thresholded_matrixElements_2);


fontsize =25;
% Box plot showing mean and standard deviation
figure;
boxplot(data, 'Whisker', 1.5); % The whiskers will show the data spread

% Overlay mean and standard deviation on boxplot
hold on;
meanValue = mean(data);
stdValue = std(data);
plot(1, meanValue, 'ro', 'MarkerSize', 9, 'LineWidth', 3); % Mean as red circle
plot([1, 1], [meanValue - stdValue, meanValue + stdValue], 'b-', 'LineWidth', 3); % Std deviation as blue line
hold off;

% Labeling
title('Box Plot with Mean and Standard Deviation','FontSize',fontsize)
ylabel('Area(um2)','FontSize',fontsize)
set(gca, 'XTick', []) % Remove x-tick if single dataset
set(gca, 'YTickLabel', get(gca, 'YTickLabel'), 'FontSize', fontsize);

%%%%%%%%or violin plot%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
% full violin plots with white embedded boxplots for 3x2 data

h = daviolinplot(data','xtlabels', 'WT', 'violin','full',...
    'boxcolors','w');  
ylabel('Area');
% xl = xlim; xlim([xl(1), xl(2)+0.25]);    % make space for the legend
% legend([h.ds(1,:)],group_names(1:3));    % add the legend manually
set(gca,'FontSize',20);


figure
[h,L,MX,MED]=violin(data');
ylabel('Area','FontSize',14)



%%%%%%%%or%%%%%%%%%%%%%%%%

% Calculate mean and standard deviation
meanValue = mean(data);
stdValue = std(data);

% Plot data points
figure;
plot(data, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'cyan', 'MarkerEdgeColor', 'black');
hold on;

% Plot mean line
yline(meanValue, 'r--', 'LineWidth', 3); % Mean as red dashed line

% Plot standard deviation lines
yline(meanValue + stdValue, 'b-.', 'LineWidth', 2); % Mean + Std Dev as blue dot-dash line
yline(meanValue - stdValue, 'b-.', 'LineWidth', 2); % Mean - Std Dev as blue dot-dash line

% Labeling
title('Data Plot with Mean and Standard Deviation Lines','FontSize',fontsize)
xlabel('Data Index','FontSize',fontsize)
ylabel('Area(um2)','FontSize',fontsize)
set(gca, 'YTickLabel', get(gca, 'YTickLabel'), 'FontSize', fontsize);
legend('Data points', 'Mean', 'Mean ± Std Dev','FontSize',fontsize)
hold off;


% save data_area_19092023_WT_RFM data
% save data_area_25092024_WT_RFM_RFM data
% save data_area_170723_rd1_transplant_RFM data



%}




