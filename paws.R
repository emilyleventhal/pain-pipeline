##### install paws #######
install.packages("devtools") 
devtools::install_github("crtwomey/paws", force=TRUE)

### set working directory + load package that reads hdf5 files
setwd("path/to/folder") # folder where the hdf5 file is on your computer 
library(rhdf5) 
h5ls("path/to/hdf5 file") 
library(paws)
library(ggplot2)

### read data with package ###
mydata <- h5read("path/to/hdf5 file", “tracks”)

### inspect data ### 
dim(mydata)
# mydata is frames / body parts / coordinates / animal 

# first, get the conversion factor from pixels to mm
# get x value of LEFT and x value of RIGHT 
left_x <- mydata[,2,,1][1]
right_x <- mydata[,3,,1][1]

width_pixels = right_x - left_x 

width_mm = 115 # will depend on chamber we use 

conversion = width_mm / width_pixels
 
# xy_coordinates for toe for one animal 
xy_coordinates <- mydata[, 1, , 1] 
x <- (xy_coordinates[,1]) * conversion 
y <- xy_coordinates[,2]
# SLEAP determines pixels from top (as paw goes higher, y value decreases) 
# flip y values (analogous to flipping an inverse curve)
y <- ((y - max(y))* conversion)* -1 

### extract features ###
paw.features <- extract_features(x, y) 

### calculate scores ### 
scores <- pain_score(paw.features, strains="C57B6-")
scores
