# README for UCI HAR Dataset means and standard deviations

## Scripts
run_analysis.r is the only script used, and it needs no command line arguments. The script must be placed in the same directory as the "getdata-projectfiles-UCI HAR Dataset" folder after the zip file is unzipped. It outputs a tab-delimited file "tidy_data.txt" containing the final dataset in the working directory.

## Methodology
Six files of data exist containing training and testing data aligning subject, activity, and measurements. All six were read and concatenated.

Next the data were trimmed to include only the means and standard deviations contained in the measurements. These include all of the variable names containing "mean()" and "std()". Another feature, "meanFreq()", appears to be a mean, but was trimmed because it is a weighted average of frequency components determined through FFT calculation rather than measurements.

Transformations to improve readability such as column names and activity factor labels are added, then the table is written out to "tidy_data.txt" in the working directory.