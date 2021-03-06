#############################################################
### Construct visual features for training/testing images ###
#############################################################

### Authors: Jingtian Yao
### Project 3
### ADS Spring 2017

featureRGB <- function(img_dir, export = T){
  ### Input: a directory that contains images ready for processing
  ### Output: a dataframe contains processed RGB features for the images  
  
  library(EBImage)
  library(grDevices)
  
  # number of R,G,B
  nR <- 5
  nG <- 5
  nB <- 5
  rBin <- seq(0, 1, length.out=nR)
  gBin <- seq(0, 1, length.out=nG)
  bBin <- seq(0, 1, length.out=nB)
  mat=array()
  freq_rgb=array()
  rgb_feature=matrix(nrow=3000, ncol=nR*nG*nB)
  
  n_files <- length(list.files(img_dir))
  
  ########extract RGB features############
  for (i in 1:3000){
    mat <- imageData(readImage(paste0(img_dir,"images/",sprintf("%04.f",i), ".jpg")))
    mat_as_rgb <-array(c(mat,mat,mat),dim = c(nrow(mat),ncol(mat),3))
    freq_rgb <- as.data.frame(table(factor(findInterval(mat_as_rgb[,,1], rBin), levels=1:nR), 
                                    factor(findInterval(mat_as_rgb[,,2], gBin), levels=1:nG),
                                    factor(findInterval(mat_as_rgb[,,3], bBin), levels=1:nB)))
    rgb_feature[i,] <- as.numeric(freq_rgb$Freq)/(ncol(mat)*nrow(mat)) # normalization
    
    mat_rgb <-mat_as_rgb
    dim(mat_rgb) <- c(nrow(mat_as_rgb)*ncol(mat_as_rgb), 3)
  }
  
  ### output constructed features
  if(export){
    saveRDS(rgb_feature, file = "../output/rgb_feature_new.RData")
  }
  return(data.frame(rgb_feature))
}