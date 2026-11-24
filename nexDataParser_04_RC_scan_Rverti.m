clc
clear all
close all
tic
%%%%these series of analysis files are modified for my data format

%%%%enter matlab files folder
cd('F:\IMARIS Computer Backup 2025_06_23\k21166257\Documents\MATLAB\Rceptive_Field_mapping_codes_2')

addpath('F:\IMARIS Computer Backup 2025_06_23\k21166257\Documents\MATLAB\ReadWriteNexNex5Files');%%%%%%nex5 read and write folder path


% addpath('')
% % filename='.nex5';event=1;%%%only weak response in bar 7
% addpath('');
% % filename='.nex5';event=1;
% 
% %%%%%%%%%%%%%%%%%%%%%GNAT1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('H:\GNAT1_spatial\14092023_GNAT1_PI_9months_Old_04_05_ANNA ANALYSED');%%%Data folder path
filename='04_merged_2023-09-14T14-12-12McsRecording.nex5';event=1;%%%%there
% % is an unknown problem with this file for heatmap plotting


nexFile=readNex5File(filename);

neurons=nexFile.neurons;

%%%%to check events and neurons names
AAA_events_check=cell2mat(nexFile.events);
BBB_neurons_check=cell2mat(nexFile.neurons);


%%%%%%%%%%%%%%events selection
% events=nexFile.events;
% events=nexFile.events(2:end);

%%%%event selection
events=nexFile.events(event);
%%%%finding selected events
EV=events{1,1}.timestamps;
L1=length(EV);
I1=2:2:L1;
% I1=2:2:161;%%%%%this is only for 2023-05-30T15-32-57McsRecording-sorted-units.nex5
%%%this line extract timestamps of all bars
EV2=EV(I1);%%%%EV2 contains all time-stamps of bars, without the blank timestamps
L2=length(EV2);%%%%this only for 

Stim_num=30;%%%%number of stimuli
RC_verti_map_vector=zeros(1,30);%%%%firing rate for example neuron
RC_verti_map_matrix = zeros(12,12,30);
RC_verti_Neuron_amp=cell(30,1);
neuronClassType_verti_bar = zeros(30,1);

All_MEA_map_max_amp_04=0;

for id=1:Stim_num
    Ibar=id:Stim_num:L2;
%     Ibar=25;





bar_number = Ibar;
%%%%just to see which bar is being processed
bar_number(1)

EV3=EV2(bar_number);
events{1,1}.timestamps=EV3;




% intervals=nexFile.intervals;


%%%%%%removing non data Neurons
[neuronsSorted,neuronsNamesSorted,namesAllChar,namesAll]=nexSortNeurons(neurons);

%%%%%Input values assignment

prevTime=0.1;
postTime=.3;
binSize=.01;
sm_coef=10;%%%%%%this is a constant to calculate smoothing span based on this formula:(1/binSize)/sm_coef)  forr functions neuronsPSTH_Delay and neuronsClass

%%%%%%plotting events and calculating Firing rates and PSTH cells and
%%%%%%Matrices for single trial and single event correspondent to each neuron
[all_FR_trial,all_FR_event,all_PSTH_trial,all_PSTH_event,all_FR_trial_baseline,all_FR_event_baseline,all_PSTH_trial_baseline,all_PSTH_event_baseline,all_stimWidth_event,eventsNameCell,trialRepeat]=nexSortEvents(events,neuronsSorted,filename,prevTime,postTime);

%%%%%Both save and load variables take too much time especially for
%%%%%all_PSTH_event and all_PSTH_trial
%%%%%it takes less time if I run the codes from beginnig than saving
%%%%%variables and loading
% filename2=strcat(filename(1:end-5),'.mat');

% save (filename2, 'all_FR_trial', 'all_FR_event', 'all_PSTH_trial', 'all_PSTH_event', 'all_FR_trial_baseline', 'all_FR_event_baseline', 'all_PSTH_trial_baseline', 'all_PSTH_event_baseline','all_stimWidth_event','eventsNameCell','all_FR_event','all_FR_event_baseline','filename','prevTime','postTime')
% % save (filename2,'-v7.3','-nocompression')


[stdRatio,histFrValues,binSize,meanBaseline]=neuronsPSTH_Delay(namesAll,all_PSTH_event,all_PSTH_event_baseline,all_stimWidth_event,eventsNameCell,all_FR_event,all_FR_event_baseline,trialRepeat,filename,prevTime,postTime,binSize,sm_coef,20,1);

[resPercent,responsiveNeuron,respHistPeak,NonReHistPeak,lookupTable,DelayIRtON,DelayAverage,neuronClassType,neuronClasses]=neuronsClass(stdRatio,all_stimWidth_event,histFrValues,meanBaseline,neuronsNamesSorted,prevTime,postTime,binSize,sm_coef,3,-1,1);

% filename3=strcat(filename(1:end-5),'_',num2str(binSize),'s_HistPeaks.mat');
% save (filename3,'respHistPeak','NonReHistPeak','resPercent','prevTime','postTime','binSize')

% filename3=strcat(filename(1:end-5),'_',num2str(binSize),'s_neuronClasses.mat');
% save (filename3,'resPercent','prevTime','postTime','binSize','neuronClasses','neuronClassType','all_stimWidth_event')


%%%%assign the neuron index
Neuron_index_verti=76;

run('MEA_Electrode_RC_Map_Plot_Rverti.m')

RC_verti_map_vector(31-id) = RC_verti_map;%%%%example for C5
% % % this gets the heatmap value not the single neuron
RC_verti_map_matrix(:,:,31-id) = MEA_map_max_amp; 
RC_verti_Neuron_amp{31-id}=cell2mat(abc(:,4));

%%%%assigning neurons class
neuronClassType_verti_bar(31-id)= neuronClassType(Neuron_index_verti);


All_MEA_map_max_amp_04= All_MEA_map_max_amp_04 +MEA_map_max_amp;

filename3=strcat(filename(1:end-5),'_04_RC_scan_real_vert_eventNo_',num2str(event),'_barNo_',num2str(bar_number(1)),'_',num2str(binSize),'s_neuronClasses.mat');
% save (filename3,'resPercent','prevTime','postTime','binSize','neuronClasses','neuronClassType','all_stimWidth_event','namesAll')

% %save all variables in the workspace
% save(filename3)
end

% figure
% h=heatmap(All_MEA_map_max_amp_04/Stim_num,'Colormap',jet);
% % Set specific color limits for the scale bar
% % colorLimits = [heatleftlim, heatrightlim];
% % h.ColorLimits = colorLimits;
% title(' Max Amplitude ')

toc
