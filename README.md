These files allow for processing of single unit electrophysiological data to analyze vertical and horizontal bar receptive field mapping protocols using a Matlab Analysis pipeline. 

Sorting Neurons

You need Neuroexplorer and Plexon Offline Sorter softwares.
Merge 04(vertical bars) and 05(Horizontal bars) .nex5 files in Neuroexplorer.
Insert a 5 second gap between the 2 files and save it as merged file.
Open merged .nex5 file in Plexon offline sorter and Spike Sort neurons.
After finishing neurons sorting; export the first section of the merged file and select the segment of the merged file equal to the duration of 04. Nex5 which is about the 5 seconds gap you entered before. Export and save it as split_04.nex5.
Do the same for the second segment after 5 sec gap, enter the onset and offset of the time trace and export it as split_05.nex5.  



MATLAB Code Analysis


Open the following three analysis files in MATLAB:


1.	nexDataParser_04_RC_scan_Rverti.m
   
In lines 6, 8 and 13 insert the requested folder paths.
path of the folder that contains the MATLAB files, path of the folder that has nexreader files and finally path of the folder that contains data file in .nex5 format.
In line 14 insert the name of the .nex5 file
Insert the index of your favourite neuron at line 127


2.	nexDataParser_05_RC_scan_Rhori.m
   
in lines 6, 8 and 13 insert the requested folder paths.
path of the folder that contains the MATLAB files, path of the folder that has nexreader files and finally path of the folder that contains data file in nex5 format.
In line 14 insert the name of the .nex5 file
Insert the index of your favourite neuron at line 128


3.	Main_RC_batch_file_process023.m
	
Run the file to calculate the multiplication matrix for each neuron and plot a heatmap of the peak amplitude output of each neurone.
Repeat for each spike sorted unit in a given .Nex5 file. 
Create a folder which contains the multiplication matrix of peak amplitude, RF heatmap, fits a 2D gaussian and smoothed Gaussian to the heatmaps for each neurone for an individual animal / recording (smoothing is 2 pixels)


The next set of analysis uses the outputs of the previous code in the following order.


4.	matfile_merge.m

In line 15 input folder location for data generated in Main_RC_batch_file_process023
Run the file to merge all single units into one Matlab file


5.	load_Plot_RFM.m
   
Calculates RF area by using pixel dimension of the 25um bar and multiplying all non 0 pixels (below the 25% threshold of the peak) to generate area value.
Diameter is calculated from larger value of the RF if not circular
Generates the centred picture of the RF Heatmap plot
This is where you select neurones based on the criteria described in the methods (multiple peaks, vague and diffuse activity across the array are discarded).


6.	load_Plot_RFM_selection.m
   
Load all valid RF map unit numbers to generates figure of all valid RFs in the field of view of the projector, per animal.


