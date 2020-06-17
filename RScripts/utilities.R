executeSim <- function(simPath){
  #Load the simulation
  myDCI <- initSimulation(XML = paste0(simPath, ".xml"), whichInitParam = "none")
  myDCI <- processSimulation(DCI_Info = myDCI)
}

#Run all the simulations specified in the list "modelNames" in parallel, and return the results.
sim_Models = function(modelNames){
  # Calculate the number of cores
  no_cores = detectCores() - 1;
  
  # Initiate cluster
  cl = makeCluster(no_cores);
  #Make the variable "simFolder" visible to the cluster.
  clusterExport(cl, "simFolder");
  #Make the MoBi-Toolbox visible to the cluster.
  clusterEvalQ(cl, library(MoBiToolboxForR));
  simPaths = paste0(simFolder, modelNames)
  #Run the method "executeSim" in parallel.
  results = parSapply(cl = cl, simPaths, FUN = executeSim);
  stopCluster(cl)
  return(list(Names = modelNames, DCIs = results));
}

esqLABS_colors = function(nrOfColors){
  #esqLABS colors in HSV model
  esqRed_hsv = rgb2hsv(235, 23, 51, maxColorValue = 255);
  esqBlue_hsv = rgb2hsv(13, 141, 218, maxColorValue = 255);
  esqGreen_hsv = rgb2hsv(38, 176, 66, maxColorValue = 255);
  #default color palette.
  esq_palette = c(hsv(esqBlue_hsv[1], esqBlue_hsv[2], esqBlue_hsv[3]),
                  hsv(esqRed_hsv[1], esqRed_hsv[2], esqRed_hsv[3]),
                  hsv(esqGreen_hsv[1], esqGreen_hsv[2], esqGreen_hsv[3]));
  
  #pre-calculate distances between blue and red and red and green.
  deltaH_b_r = (esqRed_hsv[1] - esqBlue_hsv[1]);
  deltaS_b_r = max(esqRed_hsv[2], esqBlue_hsv[2]) - min(esqRed_hsv[2], esqBlue_hsv[2]);
  deltaV_b_r = max(esqRed_hsv[3], esqBlue_hsv[3]) - min(esqRed_hsv[3], esqBlue_hsv[3]);
  
  deltaH_r_g = abs(esqRed_hsv[1] - (esqGreen_hsv[1]+1));
  deltaS_r_g = max(esqRed_hsv[2], esqGreen_hsv[2]) - min(esqRed_hsv[2], esqGreen_hsv[2]);
  deltaV_r_g = max(esqRed_hsv[3], esqGreen_hsv[3]) - min(esqRed_hsv[3], esqGreen_hsv[3]);
  
  if (nrOfColors < 0){
    stop("nrOfColors must be positive, value ", nrOfColors, " is not valid!");
  }
  if (nrOfColors == 0){
    return(c());
  }
  if (nrOfColors == 2){
    palette = c(esq_palette[1], esq_palette[3]);
    return(palette);
  }
  if (nrOfColors <= 3){
    palette = esq_palette[1:nrOfColors];
    return(palette);
  }
  
  nrOfColorsToGenerate = nrOfColors - 3;
  
  palette = esq_palette[1];
  nrOfColors_first = nrOfColorsToGenerate%/%2 + nrOfColorsToGenerate%%2;
  nrOfColors_second = nrOfColorsToGenerate%/%2;
  #calculate the first half - blue to red.
  # Index starts with 1 as it defines the number of colors.
  for (i in 1 : nrOfColors_first){
    deltaH =  deltaH_b_r / (nrOfColors_first + 1);
    deltaS =  deltaS_b_r / (nrOfColors_first + 1);
    deltaV =  deltaV_b_r / (nrOfColors_first + 1);
    
    h = esqBlue_hsv[1] + deltaH * i;
    if (h > 1){
      h = h - 1;
    }
    s = min(esqBlue_hsv[2], esqRed_hsv[2]) + deltaS * i;
    v = min(esqBlue_hsv[3], esqRed_hsv[3]) + deltaV * i;
    
    palette = c(palette, hsv(h, s, v));
  }
  
  palette = c(palette, esq_palette[2]);
  #calculate the second half - red to green.
  # Index starts with 1 as it defines the number of colors.
  if (nrOfColors_second > 0){
    for (i in 1 : nrOfColors_second){
      deltaH =  deltaH_r_g / (nrOfColors_second + 1);
      deltaS =  deltaS_r_g / (nrOfColors_second + 1);
      deltaV =  deltaV_r_g / (nrOfColors_second + 1);
      
      h = esqRed_hsv[1] + deltaH * i;
      if (h > 1){
        h = h - 1;
      }
      s = min(esqGreen_hsv[2], esqRed_hsv[2]) + deltaS * i;
      v = min(esqGreen_hsv[3], esqRed_hsv[3]) + deltaV * i;
      
      palette = c(palette, hsv(h, s, v));
    }
  }
  palette = c(palette, esq_palette[3]);
  
  return(palette)
}