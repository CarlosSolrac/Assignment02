CodeBook
---------------------------------------------------------------
##Dataset Used
See Readme.md for a description of the data


##Transformations

The list of column names is shorter than the number of columns in the x_test and y_test files. The assumption is made that the extra columns are garbage and are discarded. Also all columns that do not have "mean" or "std" in the name are also discarded.

The "x" data sets contain more rows than the "y" and "subject" files. The assumption is made that the rows in "x" makes more measurements. So we use "rep" function to fill in the missing values.

##Output Data Set

tidydata.txt contains a delimited file with the mean of the measurements by subject and by activity.
