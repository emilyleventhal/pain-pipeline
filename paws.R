##### install paws #######
install.packages("devtools") 
devtools::install_github("crtwomey/paws", force=TRUE)

### set working directory + load package that reads hdf5 files
library(rhdf5) 
library(paws)
library(ggplot2)

### read data with hdf5 package ###
h5ls("test-files/C57_left_right.v000.analysis.h5.h") # path to hdf5 file
mydata <- h5read("test-files/C57_left_right.v000.analysis.h5.h", “tracks”)

### inspect data ### 
dim(mydata)
# mydata is frames / body parts / coordinates / animal 

# first, get the conversion factor from pixels to mm
# get x value of LEFT and x value of RIGHT 
left_x <- mydata[,2,,1][1]
right_x <- mydata[,3,,1][1]

width_pixels = right_x - left_x 

width_mm = 115 # width of chamber in mm, will depend on chamber we use 

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
