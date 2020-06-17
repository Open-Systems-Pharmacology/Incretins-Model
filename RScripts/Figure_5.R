#The below loaded libraries must be installed before running this script.
library(MoBiToolboxForR)
library(parallel)

#Define here the path to the folder with the experimental data extracted from literature.
#For the description of the datasets, refer to the main text.
projectFolder <- getwd()
expDataFolder <- file.path(projectFolder, "../ExpData/Sita_PK", fsep = .Platform$file.sep)
#Define here the path to the folder with the simulation files.
simFolder <- file.path(projectFolder, "../Models_XML/Sita_PK", fsep = .Platform$file.sep)
#Define here the path to the folder where the output figure will be stored.
figureFolder <- file.path(projectFolder, "../Figures", fsep = .Platform$file.sep)
decSym <- '.'

source(file.path(projectFolder, "utilities.R", fsep = .Platform$file.sep))

#Read experimental data
dataBergman_2007 = read.table(paste0(expDataFolder, "/Bergman_2007.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataBergman_2007 = split(dataBergman_2007, dataBergman_2007$Group);
dataBergman_2007_po = read.table(paste0(expDataFolder, "/Bergman_2007_po.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataBergman_2007_po = split(dataBergman_2007_po, dataBergman_2007_po$Group);
dataHerman_2005 = read.table(paste0(expDataFolder, "/Herman_2005.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataHerman_2005 = split(dataHerman_2005, dataHerman_2005$Group);
dataVincent_2007 = read.table(paste0(expDataFolder, "/Vincent_2007.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym);
dataBergman_2006 = read.table(paste0(expDataFolder, "/Bergman_2006.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataBergman_2006 = split(dataBergman_2006, dataBergman_2006$Group);
dataDPP_inhib = read.table(paste0(expDataFolder, "/PLasma_DPP-inhib.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym); dataDPP_inhib = split(dataDPP_inhib, dataDPP_inhib$Group);

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

resultsPath_Sitagliptin_PVB = "*|Organism|PeripheralVenousBlood|Sitagliptin|Plasma (Peripheral Venous Blood)";

resultsPath_plasmaDPP_inhib = "*|Organism|VenousBlood|Plasma|Sitagliptin-DPP4_plasma Complex|Receptor Occupancy-Sitagliptin-DPP4_plasma Complex";

#Names of the xml-model files to be simulated.
modelNames = c("/83mg",
               "/100mg_iv",
               "/25mg_iv",
               "/50mg_iv",
               "/1.5mg_po",
               "/100mg_po",
               "/12.5mg_po",
               "/200mg_po",
               "/25mg_po",
               "/400mg_po",
               "/50mg_po",
               "/5mg_po",
               "/600mg_po",
               "/800mg_po"
);

#Simulate the models.
DCIs = sim_Models(modelNames);

#Define converstion factor from simulated ?mol/L to pmol/L
convFac = 1e3;

#Plot time-concentration profiles of iv administrations
plotIV = function(){
  pchArr = c(0, 1, 2)
  ltyArr = c(1, 2, 4)
  cols = esqLABS_colors(3);
  
  #25 mg
  idx = 1;
  currData = dataBergman_2007$`25_mg_iv`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/25mg_iv", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  plot(currResult[,1]/60, (currResult[,2])*convFac,
       log="y", 
       type="l",
       xlab="Time [h]",
       ylab = "Concentration [nmol/l]",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 24),
       ylim=c(10, 5000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #50 mg
  idx = idx + 1;
  currData = dataBergman_2007$`50_mg_iv`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/50mg_iv", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
        type="l",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 24),
       ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #100 mg
  idx = idx + 1;
  currData = dataBergman_2007$`100_mg_iv`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/100mg_iv", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         xlim=c(0, 24),
         ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  legend("topright", c("25 mg iv", "50 mg iv", "100 mg iv"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

#Plot time-concentration profiles of po administrations
plotPO = function(){
  pchArr = c(0, 1, 2, 3, 4, 5, 6, 7, 8)
  ltyArr = c(1, 2, 4, 5, 6, 7, 8, 9, 10)
  cols = esqLABS_colors(9);
  
  #1.5 mg
  idx = 1;
  currData = dataHerman_2005$`1.5_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/1.5mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  plot(currResult[,1]/60, (currResult[,2])*convFac,
       log="y", 
       type="l",
       xlab="Time [h]",
       ylab = "Concentration [nmol/l]",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 24),
       ylim=c(1, 50000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #5 mg
  idx = idx + 1;
  currData = dataHerman_2005$`5_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/5mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         xlim=c(0, 24),
         ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #12.5 mg
  idx = idx + 1;
  currData = dataHerman_2005$`12.5_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/12.5mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         xlim=c(0, 24),
         ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #25 mg
  idx = idx + 1;
  currData = dataHerman_2005$`25_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/25mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         xlim=c(0, 24),
         ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #50 mg
  idx = idx + 1;
  currData = dataHerman_2005$`50_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/50mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         xlim=c(0, 24),
         ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #100 mg
  idx = idx + 1;
  currData = dataHerman_2005$`100_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/100mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         xlim=c(0, 24),
         ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #200 mg
  idx = idx + 1;
  currData = dataHerman_2005$`200_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/200mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         xlim=c(0, 24),
         ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #400 mg
  idx = idx + 1;
  currData = dataHerman_2005$`400_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/400mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         xlim=c(0, 24),
         ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)
  
  #600 mg
  idx = idx + 1;
  currData = dataHerman_2005$`600_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/600mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*convFac,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         xlim=c(0, 24),
         ylim=c(10, 1000), lwd=1);
  
  points(currData$Time..h., currData$Concentration..nM.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..h., currData$Concentration..nM. - currData$Error..nM.,
         currData$Time..h., currData$Concentration..nM. + currData$Error..nM.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=1)

  legend("topright", c("1.5 mg po", "5 mg po", "12.5 mg po", "25 mg po", "50 mg po", "100 mg po", "200 mg po", "400 mg po", "600 mg po"),
         ncol = 2,
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

#Create a simulated-vs-observed plot of intact GLP-1
simulatedVsObserved = function(){
  pchArr = c(0:23)
  cols = esqLABS_colors(23);
  
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
  
  #Plot identity line, representing perferct accordance.
  curve(identity(x), from = 1, to = 50000, log="xy", xlab="Observed concentration [nmol/L]", ylab="Simulated concentration [nmol/L]")
  #Plot the 0.5 and 2 fold deviation lines.
  curve(plusDev(x), from = 0.1, to = 100000, add = TRUE, lty = 2);
  curve(minusDev(x), from = 0.1, to = 100000, add = TRUE, lty = 2);
  
  #The list devCurr stores the deviations of simulated values from the reported ones for the current data set.
  devCurr = c();
  idxPlot = 1;
  #25 mg iv
  currData = dataBergman_2007$`25_mg_iv`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/25mg_iv", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2007_iv_25: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2007_iv_25: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #50 mg iv
  idxPlot = idxPlot + 1;
  currData = dataBergman_2007$`50_mg_iv`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/50mg_iv", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2007_iv_50: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2007_iv_50: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #100 mg iv
  idxPlot = idxPlot + 1;
  currData = dataBergman_2007$`100_mg_iv`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/100mg_iv", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2007_iv_100: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2007_iv_100: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #1.5 mg po Herman_2005
  idxPlot = idxPlot + 1;
  currData = dataHerman_2005$`1.5_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/1.5mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Herman_2005_po_1.5: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Herman_2005_po_1.5: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #5 mg po Herman_2005
  idxPlot = idxPlot + 1;
  currData = dataHerman_2005$`5_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/5mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Herman_2005_po_5: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Herman_2005_po_5: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #12.5 mg po Herman_2005
  idxPlot = idxPlot + 1;
  currData = dataHerman_2005$`12.5_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/12.5mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Herman_2005_po_12.5: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Herman_2005_po_12.5: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #25 mg po Herman_2005
  idxPlot = idxPlot + 1;
  currData = dataHerman_2005$`25_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/25mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Herman_2005_po_25: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Herman_2005_po_25: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #25 mg po Bergman_2007
  idxPlot = idxPlot + 1;
  currData = dataBergman_2007_po$`25_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/25mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2007_po_25: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2007_po_25: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #50 mg po Herman_2005
  idxPlot = idxPlot + 1;
  currData = dataHerman_2005$`50_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/50mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Herman_2005_po_50: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Herman_2005_po_50: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #50 mg po Bergman_2007
  idxPlot = idxPlot + 1;
  currData = dataBergman_2007_po$`50_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/50mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2007_po_50: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2007_po_50: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #50 mg po Bergman_2006
  idxPlot = idxPlot + 1;
  currData = dataBergman_2006$`50_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/50mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2006_po_50: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2006_po_50: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #100 mg po Herman_2005
  idxPlot = idxPlot + 1;
  currData = dataHerman_2005$`100_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/100mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Herman_2005_po_100: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Herman_2005_po_100: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #100 mg po fasted Bergman_2007
  idxPlot = idxPlot + 1;
  currData = dataBergman_2007$`100_mg_po_fasted`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/100mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2007_po_100_fasted: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2007_po_100_fasted: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #100 mg po Bergman_2006
  idxPlot = idxPlot + 1;
  currData = dataBergman_2006$`100_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/100mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2006_po_100: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2006_po_100: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #100 mg po Bergman_2007
  idxPlot = idxPlot + 1;
  currData = dataBergman_2007_po$`100_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/100mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2007_po_100: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2007_po_100: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #200 mg po Bergman_2006
  idxPlot = idxPlot + 1;
  currData = dataBergman_2006$`200_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/200mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2006_po_200: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2006_po_200: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #200 mg po Herman_2005
  idxPlot = idxPlot + 1;
  currData = dataHerman_2005$`200_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/200mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Herman_2005_po_200: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Herman_2005_po_200: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #200 mg po Bergman_2007
  idxPlot = idxPlot + 1;
  currData = dataBergman_2007_po$`200_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/200mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2007_po_200: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2007_po_200: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #400 mg po Bergman_2006
  idxPlot = idxPlot + 1;
  currData = dataBergman_2006$`400_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/400mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2006_po_400: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2006_po_400: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #400 mg po Herman_2005
  idxPlot = idxPlot + 1;
  currData = dataHerman_2005$`400_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/400mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Herman_2005_po_400: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Herman_2005_po_400: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #400 mg po Bergman_2007
  idxPlot = idxPlot + 1;
  currData = dataBergman_2007_po$`400_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/400mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2007_po_400: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2007_po_400: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #600 mg po Herman_2005
  idxPlot = idxPlot + 1;
  currData = dataHerman_2005$`600_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/600mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Herman_2005_po_600: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Herman_2005_po_600: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #800 mg po Bergman_2006
  idxPlot = idxPlot + 1;
  currData = dataBergman_2006$`600_mg`;
  currPath = resultsPath_Sitagliptin_PVB;
  currIdx = match("/800mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$Time..h.*60)){
    dataTime = currData$Time..h.[i]*60;
    dataVal = currData$Concentration..nM.[i];
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
  print(paste('Bergman_2006_po_800: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  print(paste('Bergman_2006_po_800: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  print(paste('Sitagliptin: Deviation higher then 2x resp. 0.5x:', (sum(devs > (1/0.5)) + sum(devs < 0.5)), "out of total", length(devs), "points."));
  print(paste('Sitagliptin: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devs > (1/0.7)) + sum(devs < 0.7)), "out of total", length(devs), "points."));
  
  return(devs);
}

#Plot inhibition of plasma DPP4 activity
plotDPP_inhibition = function(){
  pchArr = c(0:6)
  ltyArr = c(1, 2, 4:8)
  cols = esqLABS_colors(7);
  
  #1.5 mg
  idx = 1;
  currData = dataDPP_inhib$`1.5_mg_Herman_2005`;
  currPath = resultsPath_plasmaDPP_inhib;
  currIdx = match("/1.5mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  plot(currResult[,1]/60, (currResult[,2])*100,
       log="",
       type="l",
       xlab="Time [h]",
       ylab = "Plasma DPP4 inhibition [%]",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 24),
       ylim=c(0, 120), lwd=1);

  points(currData$Time..h., currData$Inhibition....,
         pch = pchArr[idx],
         col=cols[idx],
         lwd=1)
  
  #5 mg
  # idx = idx + 1;
  # currData = dataDPP_inhib$`5_mg_Herman_2005`
  # currPath = resultsPath_plasmaDPP_inhib;
  # currIdx = match("/5mg_po", DCIs$Names);
  # currSim = DCIs$DCIs[,currIdx];
  # currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  # points(currResult[,1]/60, (currResult[,2])*100,
  #        type="l",
  #        lty=ltyArr[idx],
  #        col=cols[idx],
  #        lwd=1);
  # 
  # points(currData$Time..h., currData$Inhibition....,
  #        pch = pchArr[idx], 
  #        col=cols[idx],
  #        lwd=1)
  
  #12.5 mg
  # idx = idx + 1;
  # currData = dataDPP_inhib$`12.5_mg_Herman_2005`
  # currPath = resultsPath_plasmaDPP_inhib;
  # currIdx = match("/12.5mg_po", DCIs$Names);
  # currSim = DCIs$DCIs[,currIdx];
  # currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  # points(currResult[,1]/60, (currResult[,2])*100,
  #        type="l",
  #        lty=ltyArr[idx],
  #        col=cols[idx],
  #        lwd=1);
  # 
  # points(currData$Time..h., currData$Inhibition....,
  #        pch = pchArr[idx], 
  #        col=cols[idx],
  #        lwd=1)
  
  #25 mg
  idx = idx + 1;
  currData = dataDPP_inhib$`25_mg_Herman_2005`
  currPath = resultsPath_plasmaDPP_inhib;
  currIdx = match("/25mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*100,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         lwd=1);
  
  points(currData$Time..h., currData$Inhibition....,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  
  #50 mg
  idx = idx + 1;
  currData = dataDPP_inhib$`50_mg_Herman_2005`;
  currPath = resultsPath_plasmaDPP_inhib;
  currIdx = match("/50mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*100,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         lwd=1);
  
  points(currData$Time..h., currData$Inhibition....,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)
  
  #100 mg
  idx = idx + 1;
  currData = dataDPP_inhib$`100_mg_Herman_2005`;
  currPath = resultsPath_plasmaDPP_inhib;
  currIdx = match("/100mg_po", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1]/60, (currResult[,2])*100,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         lwd=1);
  
  points(currData$Time..h., currData$Inhibition....,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=1)

  
  legend("topright", c("1.5 mg", "25 mg", "50 mg", "100 mg"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

#Plot into a png file.
# png(file=paste0(figureFolder, "/Figure_5.png"),
#     width=16,
#     height=16,
#     units = "cm",
#     res=400,
#     pointsize=8)

pdf(file=paste0(figureFolder, "/Figure_5.pdf"),
    width = 7,
    height = 7,
    pointsize = 8)

par(mfrow = c(2, 2), cex=1, oma=c(0,0,0,0))
par(mar=c(4,4,0.4,0.1))

plotIV();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.25, par("usr")[4], "A",cex=1,font=1.5, xpd=T)

plotPO();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.25, par("usr")[4], "B",cex=1,font=1.5, xpd=T)

devs = simulatedVsObserved();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.25, par("usr")[4], "C",cex=1,font=1.5, xpd=T)

plotDPP_inhibition();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.25, par("usr")[4], "D",cex=1,font=1.5, xpd=T)

dev.off();
