# README for UCI HAR Dataset means and standard deviations

## Scripts
run_analysis.r is the only script used, and it needs no command line arguments. The script must be placed in the same directory as the "getdata-projectfiles-UCI HAR Dataset" folder after the zip file is unzipped.

## Methodology
Six files of data exist containing training and testing data aligning subject, activity, and measurements. All six were read and concatenated.

Next the data were trimmed to include only the means and standard deviations contained in the measurements. These include all of the variable names containing "mean()" and "std()". "meanFreq()" was ignored because it is a weighted average of frequency components determined through FFT calculation rather than measurements.