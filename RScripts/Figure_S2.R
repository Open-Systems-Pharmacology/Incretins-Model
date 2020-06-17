#The below loaded libraries must be installed before running this script.
library(MoBiToolboxForR)
library(parallel)

#Define here the path to the folder with the experimental data extracted from literature.
#For the description of the datasets, refer to the main text.
projectFolder <- getwd()
expDataFolder <- file.path(projectFolder, "../ExpData", fsep = .Platform$file.sep)
#Define here the path to the folder with the simulation files.
simFolder <- file.path(projectFolder, "../Models_XML", fsep = .Platform$file.sep)
#Define here the path to the folder where the output figure will be stored.
figureFolder <- file.path(projectFolder, "../Figures", fsep = .Platform$file.sep)
decSym <- '.'

source(file.path(projectFolder, "utilities.R", fsep = .Platform$file.sep))

#Experimental data
dataDonovan_constant_GIP_total = read.table(paste0(expDataFolder, "/Donovan_2004_constant_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataDonovan_constant_GIP_total = split(dataDonovan_constant_GIP_total, dataDonovan_constant_GIP_total$Group);
dataDonovan_constant_GLP1_total = read.table(paste0(expDataFolder, "/Donovan_2004_constant_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataDonovan_constant_GLP1_total = split(dataDonovan_constant_GLP1_total, dataDonovan_constant_GLP1_total$Group);
dataDonovan_variable_GIP_total = read.table(paste0(expDataFolder, "/Donovan_2004_variable_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataDonovan_variable_GIP_total = split(dataDonovan_variable_GIP_total, dataDonovan_variable_GIP_total$Group);
dataDonovan_variable_GLP1_total = read.table(paste0(expDataFolder, "/Donovan_2004_variable_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataDonovan_variable_GLP1_total = split(dataDonovan_variable_GLP1_total, dataDonovan_variable_GLP1_total$Group);
dataMa_GLP1_total = read.table(paste0(expDataFolder, "/Ma_2012_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataMa_GLP1_total = split(dataMa_GLP1_total, dataMa_GLP1_total$Group);
dataMa_GIP_total = read.table(paste0(expDataFolder, "/Ma_2012_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataMa_GIP_total = split(dataMa_GIP_total, dataMa_GIP_total$Group);
dataSchirra_2006_GIP_intact = read.table(paste0(expDataFolder, "/Schirra_2006_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym);
dataSchirra_2006_GLP1_intact = read.table(paste0(expDataFolder, "/Schirra_2006_GLP_1_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym);

#Define results paths
resultsPath_GLP1_active_AB = "*|Organism|ArterialBlood|Plasma|GLP-1_7-36-amide|Concentration in container";
resultsPath_GLP1_active_RB = "*|Organism|Kidney|Medulla|Plasma|GLP-1_7-36-amide|Concentration in container";
resultsPath_GLP1_active_PVB = "*|Organism|PeripheralVenousBlood|GLP-1_7-36-amide|Plasma (Peripheral Venous Blood)";
resultsPath_GLP1_active_AVB = "*|Organism|PeripheralVenousBlood|GLP-1_7-36-amide|Plasma (Arterialized Peripheral Venous Blood)";

resultsPath_GLP1_metab_AB = "*|Organism|ArterialBlood|Plasma|GLP-1_9-36-amide|Concentration in container";
resultsPath_GLP1_metab_RB = "*|Organism|Kidney|Medulla|Plasma|GLP-1_9-36-amide|Concentration in container";
resultsPath_GLP1_metab_PVB = "*|Organism|PeripheralVenousBlood|GLP-1_9-36-amide|Plasma (Peripheral Venous Blood)";
resultsPath_GLP1_metab_AVB = "*|Organism|PeripheralVenousBlood|GLP-1_9-36-amide|Plasma (Arterialized Peripheral Venous Blood)";

resultsPath_GLP1_total_AB = "*|Organism|ArterialBlood|Plasma|GLP-1_7-36-amide|Concentration in container_GLP1_total";
resultsPath_GLP1_total_RB = "*|Organism|Kidney|Medulla|Plasma|GLP-1_7-36-amide|Concentration in container_GLP1_total";
resultsPath_GLP1_total_PVB = "*|Organism|PeripheralVenousBlood|GLP-1_7-36-amide|Plasma (Peripheral Venous Blood)_GLP1_total";
resultsPath_GLP1_total_AVB = "*|Organism|PeripheralVenousBlood|GLP-1_7-36-amide|Plasma (Arterialized Peripheral Venous Blood)_GLP1_total";

resultsPath_GIP_total_PVB = "*|Organism|PeripheralVenousBlood|GIP_1-42|Plasma (Peripheral Venous Blood)_GIP_total";
resultsPath_GIP_total_AVB = "*|Organism|PeripheralVenousBlood|GIP_1-42|Plasma (Arterialized Peripheral Venous Blood)_GIP_total";

resultsPath_GIP_PVB = "*|Organism|PeripheralVenousBlood|GIP_1-42|Plasma (Peripheral Venous Blood)";
resultsPath_GIP_AVB = "*|Organism|PeripheralVenousBlood|GIP_1-42|Plasma (Arterialized Peripheral Venous Blood)";

#Names of the xml-model files to be simulated.
modelNames = c("/Donovan_2004_const",
               "/Donovan_2004_var",
               "/Ma_2012_high",
               "/Ma_2012_low",
               "/Ma_2012_med",
               "/Schirra_2006_id"
);

#Simulate the models.
DCIs = sim_Models(modelNames);

#Define converstion factor from simulated ?mol/L to pmol/L
convFac = 1e6;

plotSchirra_2006_GIP = function(){
  pchArr = c(0, 1)
  ltyArr = c(1, 2)
  cols = esqLABS_colors(2);
  
  idx = 1;
  currData = dataSchirra_2006_GIP_intact;
  currPath = resultsPath_GIP_AVB;
  currIdx = grep("Schirra_2006_id", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  plot(currResult[,1][100:length(currResult[,1])] - 100, (currResult[,2][100:length(currResult[,2])])*1e6,
       log="", type="l", xlab="Time [min]", ylab = "GIP [pmol/l]",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 220),
       ylim=c(0, 250), lwd=2);
  
  points(currData$Time..min. - 100, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 100, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 100, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  idx = idx + 1;
  currPath = resultsPath_GIP_total_AVB;
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1][100:length(currResult[,1])] - 100, (currResult[,2][100:length(currResult[,2])])*1e6,
       lty=ltyArr[idx],
       col=cols[idx],
       type = "l",
       lwd=2);
  
  legend("topleft", c("1 kcal/min (30-90 min)\n2.5 kcal/min (90-210 min) intact GIP", "1 kcal/min (30-90 min)\n2.5 kcal/min (90-210 min) total GIP"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

plotMa_2012_GIP = function(){
  pchArr = c(0, 1, 2, 3)
  ltyArr = c(1, 2, 3, 4)
  cols = esqLABS_colors(4);
  
  idx = 1;
  currData = dataMa_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Ma_2012_low", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  plot(currResult[,1][100:length(currResult[,1])] - 100, (currResult[,2][100:length(currResult[,2])])*1e6,
       log="", type="l", xlab="Time [min]", ylab = "Total GIP [pmol/l]",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 130),
       ylim=c(0, 250), lwd=2);
  
  points(currData$Time..min. - 100, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 100, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 100, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  idx = idx + 1;
  currData = dataMa_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Ma_2012_low", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1][300:length(currResult[,1])] - 300, (currResult[,2][300:length(currResult[,2])])*1e6,
         lty=ltyArr[idx],
         col=cols[idx],
         type = "l",
         lwd=2);
  
  points(currData$Time..min. - 300, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 300, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 300, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  idx = 3;
  currData = dataMa_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Ma_2012_med", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1][500:length(currResult[,1])] - 500, (currResult[,2][500:length(currResult[,2])])*1e6,
         lty=ltyArr[idx],
         col=cols[idx],
         type = "l",
         lwd=2);
  
  points(currData$Time..min. - 500, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 500, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 500, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  idx = idx + 1;
  currData = dataMa_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Ma_2012_high", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1][700:length(currResult[,1])] - 700, (currResult[,2][700:length(currResult[,2])])*1e6,
         lty=ltyArr[idx],
         col=cols[idx],
         type = "l",
         lwd=2);
  
  points(currData$Time..min. - 700, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 700, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 700, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  legend("topleft", c("Saline", "1 kcal/min", "2 kcal/min", "4 kcal/min"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

plotDonovan_2004_constant_GIP = function(){
  pchArr = c(0, 1, 2, 3)
  ltyArr = c(1, 2, 3, 4)
  cols = esqLABS_colors(1);
  
  idx = 1;
  currData = dataDonovan_constant_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Donovan_2004_const", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  plot(currResult[,1][100:length(currResult[,1])] - 100, (currResult[,2][100:length(currResult[,2])])*1e6,
       log="", type="l", xlab="Time [min]", ylab = "Total GIP [pmol/l]",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 190),
       ylim=c(0, 140), lwd=2);
  
  points(currData$Time..min. - 100, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 100, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 100, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  legend("topleft", c("1 kcal/min"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

plotDonovan_2004_var_GIP = function(){
  pchArr = c(0, 1, 2, 3)
  ltyArr = c(1, 2, 3, 4)
  cols = esqLABS_colors(1);
  
  idx = 1;
  currData = dataDonovan_variable_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Donovan_2004_var", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  plot(currResult[,1][100:length(currResult[,1])] - 100, (currResult[,2][100:length(currResult[,2])])*1e6,
       log="", type="l", xlab="Time [min]", ylab = "Total GIP [pmol/l]",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 190),
       ylim=c(0, 180), lwd=2);
  
  points(currData$Time..min. - 100, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 100, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 100, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  legend("topleft", c("3 kcal/min (0-15 min)\n0.71 kcal/min (15-120 min)"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

simulatedVsObserved_GIP = function(){
  pchArr = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18)
  cols = esqLABS_colors(8);
  
  #This list stores all the deviations.
  devs = c();
  
  identity = function(x){
    x;
  }
  dev = 1
  #two-fold difference
  plusDev = function(x){
    x * (1/0.5);
  }
  minusDev = function(x){
    x * 0.5;
  }
  
  maxVal = 0;
  
  #Plot identity line, representing perfect accordance.
  curve(identity(x), from = 0, to = 250, log="", xlab="Observed intact GIP [pmol/L]", ylab="Simulated intact GIP [pmol/L]")
  #Plot the 0.5 and 2 fold deviation lines.
  curve(plusDev(x), from = 0, to = 250, add = TRUE, lty = 2);
  curve(minusDev(x), from = 0, to = 250, add = TRUE, lty = 2);
  
  #The list devCurr stores the deviations of simulated values from the reported ones for the current data set.
  devCurr = c();
  idxPlot = 1;
  #Donovan_2004_const
  currData = dataDonovan_constant_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Donovan_2004_const", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..min.)){
    dataTime = currData$Time..min.[i];
    dataVal = currData$Concentration..pmol.l.[i];
    #Find the corresponding data point in the simulation results.
    idx = which(abs(currResult[,1] - dataTime)==min(abs(currResult[,1] - dataTime)));
    simVal = currResult[idx,2]*convFac;
    #Draw a point with the coordinates equals to y = simulated value, x = observed value.
    points(dataVal, simVal, pch = pchArr[idxPlot],
           col = cols[idxPlot])
    #Calculate the fold deviation of simulated from observed value.
    devCurr = c(devCurr, simVal / dataVal);
    devs = c(devs, simVal / dataVal);
    maxVal = max(maxVal, simVal, dataVal);
  }
  #Print the number of points within a certain deviation range.
  print(paste('Donovan_2004_const: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Asmar_T2DM_active_AB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Donovan_2004_var
  idxPlot = idxPlot + 1;
  currData = dataDonovan_variable_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Donovan_2004_var", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..min.)){
    dataTime = currData$Time..min.[i];
    dataVal = currData$Concentration..pmol.l.[i];
    #Find the corresponding data point in the simulation results.
    idx = which(abs(currResult[,1] - dataTime)==min(abs(currResult[,1] - dataTime)));
    simVal = currResult[idx,2]*convFac;
    #Draw a point with the coordinates equals to y = simulated value, x = observed value.
    points(dataVal, simVal, pch = pchArr[idxPlot],
           col = cols[idxPlot])
    #Calculate the fold deviation of simulated from observed value.
    devCurr = c(devCurr, simVal / dataVal);
    devs = c(devs, simVal / dataVal);
    maxVal = max(maxVal, simVal, dataVal);
  }
  #Print the number of points within a certain deviation range.
  print(paste('Donovan_2004_var: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Asmar_T2DM_active_RB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Schirra_2006_total
  idxPlot = idxPlot + 1;
  currData = dataSchirra_2006_GIP_intact;
  currPath = resultsPath_GIP_total_AVB;
  currIdx = grep("Schirra_2006_id", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..min.)){
    dataTime = currData$Time..min.[i];
    dataVal = currData$Concentration..pmol.l.[i];
    #Find the corresponding data point in the simulation results.
    idx = which(abs(currResult[,1] - dataTime)==min(abs(currResult[,1] - dataTime)));
    simVal = currResult[idx,2]*convFac;
    #Draw a point with the coordinates equals to y = simulated value, x = observed value.
    points(dataVal, simVal, pch = pchArr[idxPlot],
           col = cols[idxPlot])
    #Calculate the fold deviation of simulated from observed value.
    devCurr = c(devCurr, simVal / dataVal);
    devs = c(devs, simVal / dataVal);
    maxVal = max(maxVal, simVal, dataVal);
  }
  #Print the number of points within a certain deviation range.
  print(paste('Schirra_2006_total: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Idorn_2014_H_active_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Ma_saline
  idxPlot = idxPlot + 1;
  currData = dataMa_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Ma_2012_low", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:7){
    dataTime = currData$Time..min.[i];
    dataVal = currData$Concentration..pmol.l.[i];
    #Find the corresponding data point in the simulation results.
    idx = which(abs(currResult[,1] - dataTime)==min(abs(currResult[,1] - dataTime)));
    simVal = currResult[idx,2]*convFac;
    #Draw a point with the coordinates equals to y = simulated value, x = observed value.
    points(dataVal, simVal, pch = pchArr[idxPlot],
           col = cols[idxPlot])
    #Calculate the fold deviation of simulated from observed value.
    devCurr = c(devCurr, simVal / dataVal);
    devs = c(devs, simVal / dataVal);
    maxVal = max(maxVal, simVal, dataVal);
  }
  #Print the number of points within a certain deviation range.
  print(paste('Ma_2012_saline: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Schirra_1998_H_active_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Ma_low
  idxPlot = idxPlot + 1;
  currData = dataMa_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Ma_2012_low", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 8:14){
    dataTime = currData$Time..min.[i];
    dataVal = currData$Concentration..pmol.l.[i];
    #Find the corresponding data point in the simulation results.
    idx = which(abs(currResult[,1] - dataTime)==min(abs(currResult[,1] - dataTime)));
    simVal = currResult[idx,2]*convFac;
    #Draw a point with the coordinates equals to y = simulated value, x = observed value.
    points(dataVal, simVal, pch = pchArr[idxPlot],
           col = cols[idxPlot])
    #Calculate the fold deviation of simulated from observed value.
    devCurr = c(devCurr, simVal / dataVal);
    devs = c(devs, simVal / dataVal);
    maxVal = max(maxVal, simVal, dataVal);
  }
  #Print the number of points within a certain deviation range.
  print(paste('Ma_2012_low: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Schirra_1998_H_active_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Ma_med
  idxPlot = idxPlot + 1;
  currData = dataMa_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Ma_2012_med", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 15:21){
    dataTime = currData$Time..min.[i];
    dataVal = currData$Concentration..pmol.l.[i];
    #Find the corresponding data point in the simulation results.
    idx = which(abs(currResult[,1] - dataTime)==min(abs(currResult[,1] - dataTime)));
    simVal = currResult[idx,2]*convFac;
    #Draw a point with the coordinates equals to y = simulated value, x = observed value.
    points(dataVal, simVal, pch = pchArr[idxPlot],
           col = cols[idxPlot])
    #Calculate the fold deviation of simulated from observed value.
    devCurr = c(devCurr, simVal / dataVal);
    devs = c(devs, simVal / dataVal);
    maxVal = max(maxVal, simVal, dataVal);
  }
  #Print the number of points within a certain deviation range.
  print(paste('Ma_2012_med: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Schirra_1998_H_active_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Ma_high
  idxPlot = idxPlot + 1;
  currData = dataMa_GIP_total$H;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Ma_2012_high", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 22:28){
    dataTime = currData$Time..min.[i];
    dataVal = currData$Concentration..pmol.l.[i];
    #Find the corresponding data point in the simulation results.
    idx = which(abs(currResult[,1] - dataTime)==min(abs(currResult[,1] - dataTime)));
    simVal = currResult[idx,2]*convFac;
    #Draw a point with the coordinates equals to y = simulated value, x = observed value.
    points(dataVal, simVal, pch = pchArr[idxPlot],
           col = cols[idxPlot])
    #Calculate the fold deviation of simulated from observed value.
    devCurr = c(devCurr, simVal / dataVal);
    devs = c(devs, simVal / dataVal);
    maxVal = max(maxVal, simVal, dataVal);
  }
  #Print the number of points within a certain deviation range.
  print(paste('Ma_2012_high: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Schirra_1998_H_active_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  print(paste('GIP: Deviation higher then 2x resp. 0.5x:', (sum(devs > (1/0.5)) + sum(devs < 0.5)), "out of total", length(devs), "points."));
  
  return(devs);
}

#Plot into a png file.
png(file=paste0(figureFolder, "/Figure_S2.png"),
    width=16,
    height=16,
    units = "cm",
    res=400,
    pointsize=8)

par(mfrow = c(2, 2), cex=1, oma=c(0,0,0,0))
par(mar=c(4,4,0.4,0.1));

plotSchirra_2006_GIP();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.25, par("usr")[4], "A",cex=1,font=1.5, xpd=T);
plotMa_2012_GIP();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.25, par("usr")[4], "B",cex=1,font=1.5, xpd=T)
plotDonovan_2004_constant_GIP();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.25, par("usr")[4], "C",cex=1,font=1.5, xpd=T)
plotDonovan_2004_var_GIP();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.25, par("usr")[4], "D",cex=1,font=1.5, xpd=T)
dev.off();

devsGIP = simulatedVsObserved_GIP();
