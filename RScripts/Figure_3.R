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

#Read experimental data
dataAsmar_intact = read.table(paste0(expDataFolder, "/Asmar_2016.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE); dataAsmar_intact = split(dataAsmar_intact, dataAsmar_intact$Group);
dataAsmar_metab = read.table(paste0(expDataFolder, "/Asmar_2016_metab.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE); dataAsmar_metab = split(dataAsmar_metab, dataAsmar_metab$Group);
dataAsmar_total = read.table(paste0(expDataFolder, "/Asmar_2016_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE); dataAsmar_total = split(dataAsmar_total, dataAsmar_total$Group);
dataCreutzfeld_1996_total = read.table(paste0(expDataFolder, "/Creutzfeld_1996_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataElahi_1994_total = read.table(paste0(expDataFolder, "/Elahi_1994_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataIdorn_2014_total = read.table(paste0(expDataFolder, "/Idorn_2014_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE); dataIdorn_2014_total = split(dataIdorn_2014_total, dataIdorn_2014_total$Group);
dataIdorn_2014_intact = read.table(paste0(expDataFolder, "/Idorn_2014_GLP_1_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE); dataIdorn_2014_intact = split(dataIdorn_2014_intact, dataIdorn_2014_intact$Group);
dataKjems_2003_total = read.table(paste0(expDataFolder, "/Kjems_2003_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE); dataKjems_2003_total = split(dataKjems_2003_total, dataKjems_2003_total$Group);
dataKreymann_1987_total = read.table(paste0(expDataFolder, "/Kreymann_1987_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataMeier_2003_total = read.table(paste0(expDataFolder, "/Meier_2003_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataNauck_1993_total = read.table(paste0(expDataFolder, "/Nauck_1993_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataNauck_2002_total = read.table(paste0(expDataFolder, "/Nauck_2002_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataOrskov_1996_total = read.table(paste0(expDataFolder, "/Orskov_1996_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataRyan_1998_total = read.table(paste0(expDataFolder, "/Ryan_1998_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataSchirra_1998_intact = read.table(paste0(expDataFolder, "/Schirra_1998.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataNielsen_1996_total = read.table(paste0(expDataFolder, "/Toft-Nielsen_1996_GLP_1.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE); dataNielsen_1996_total = split(dataNielsen_1996_total, dataNielsen_1996_total$`ï»¿Group`);
dataNielsen_2001_total = read.table(paste0(expDataFolder, "/Toft-Nielsen_2001_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataNielsen_2001_intact = read.table(paste0(expDataFolder, "/Toft-Nielsen_2001_GLP_1_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataVella_2000_total = read.table(paste0(expDataFolder, "/Vella_2000_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE); dataVella_2000_total = split(dataVella_2000_total, dataVella_2000_total$Group);
dataVella_2000_intact = read.table(paste0(expDataFolder, "/Vella_2000_GLP_1_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE); dataVella_2000_intact = split(dataVella_2000_intact, dataVella_2000_intact$Group);
dataVilsboll_2002_intact = read.table(paste0(expDataFolder, "/Vilsboll_2002_GLP_1_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataVilsboll_2002_total = read.table(paste0(expDataFolder, "/Vilsboll_2002_GLP_1_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataBeglinger_GLP = read.table(paste0(expDataFolder, "/Beglinger_2008_GLP_1_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataKoffert_GLP = read.table(paste0(expDataFolder, "/Koffert_2017_GLP_1_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);


#GIP data
dataVilsboll_2002_GIP_intact = read.table(paste0(expDataFolder, "/Vilsboll_2002_GIP_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataVilsboll_2002_GIP_total = read.table(paste0(expDataFolder, "/Vilsboll_2002_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataChristensen_2015_GIP_intact = read.table(paste0(expDataFolder, "/Christensen_2015_GIP_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataKoffert_2017_GIP_total = read.table(paste0(expDataFolder, "/Koffert_2017_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataKreymann_1987_GIP_total = read.table(paste0(expDataFolder, "/Kreymann_1987_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataLund_2011_GIP_total = read.table(paste0(expDataFolder, "/Lund_2011_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataNauck_1989_GIP_total = read.table(paste0(expDataFolder, "/Nauck_1989_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);
dataNauck_1993b_GIP_total = read.table(paste0(expDataFolder, "/Nauck_1993_b_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE);


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
modelNames = c("/Asmar_2016_H",
                 "/Creutzfeldt_1996",
                "/Elahi_1994",
                "/Idorn_2014_H_placebo",
                "/Kjems_2003",
                "/Koffert_2017",
                "/Kreymann_1987",
                "/Meier_2003",
                "/Nauck_1989",
                "/Nauck_1993_a",
                "/Nauck_2002",
                "/Orskov_1996",
                "/Ryan_1998",
                "/Schirra_1998",
                "/Toft-Nielsen_1996",
                "/Toft-Nielsen_2001",
                "/Vella_2000",
                "/Vilsboll_2002",
                "/Christensen_2015",
                "/Lund_2011",
                "/Nauck_1993_b",
               "/Beglinger_2008"
);

#Simulate the models.
DCIs = sim_Models(modelNames);

#Define converstion factor from simulated ?mol/L to pmol/L
convFac = 1e6;

#Create a simulated-vs-observed plot of intact GLP-1
simulatedVsObserved_intact = function(logAxes = "", minLim = 0){
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
  
  #Plot identity line, representing perferct accordance.
  curve(identity(x), from = minLim, to = 40, log = logAxes, xlab="Observed intact GLP-1 [pmol/L]", ylab="Simulated intact GLP-1 [pmol/L]")
  #Plot the 0.5 and 2 fold deviation lines.
  curve(plusDev(x), from = minLim, to = 40, add = TRUE, lty = 2);
  curve(minusDev(x), from = minLim, to = 40, add = TRUE, lty = 2);
  
  #The list devCurr stores the deviations of simulated values from the reported ones for the current data set.
  devCurr = c();
  idxPlot = 1;
  #Asmar_T2DM_AB
  currData = dataAsmar_intact$T2DM_AB;
  currPath = resultsPath_GLP1_active_AB;
  currIdx = grep("Asmar_2016_H", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Asmar_T2DM_active_AB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Asmar_T2DM_active_AB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Asmar_T2DM_RB
  idxPlot = idxPlot + 1;
  currData = dataAsmar_intact$T2DM_RB;
  currPath = resultsPath_GLP1_active_RB;
  currIdx = grep("Asmar_2016_H", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Asmar_T2DM_active_RB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Asmar_T2DM_active_RB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Idorn_2014
  idxPlot = idxPlot + 1;
  currData = dataIdorn_2014_intact$H;
  currPath = resultsPath_GLP1_active_AVB;
  currIdx = grep("Idorn_2014_H", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Idorn_2014_H_active_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Idorn_2014_H_active_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Schirra_1998
  idxPlot = idxPlot + 1;
  currData = dataSchirra_1998_intact;
  currPath = resultsPath_GLP1_active_AVB;
  currIdx = grep("Schirra_1998", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Schirra_1998_active_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Schirra_1998_active_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Toft-Nielsen_2001
  idxPlot = idxPlot + 1;
  currData = dataNielsen_2001_intact;
  currPath = resultsPath_GLP1_active_PVB;
  currIdx = grep("Toft-Nielsen_2001", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Toft-Nielsen_2001_active_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Nielsen_2001_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Vella_2000_1
  idxPlot = idxPlot + 1;
  currData = dataVella_2000_intact$`1`;
  currPath = resultsPath_GLP1_active_AVB;
  currIdx = grep("Vella_2000", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Vella_2000_G1_active_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Vella_2000_G1_active_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Vella_2000_2
  idxPlot = idxPlot + 1;
  currData = dataVella_2000_intact$`2`;
  currPath = resultsPath_GLP1_active_AVB;
  currIdx = grep("Vella_2000", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Vella_2000_G2_active_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Vella_2000_G2_active_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Vilsboll_2002
  idxPlot = idxPlot + 1;
  currData = dataVilsboll_2002_intact;
  currPath = resultsPath_GLP1_active_PVB;
  currIdx = grep("Vilsboll_2002", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  print(paste('GLP-1 intact: Deviation higher then 2x resp. 0.5x:', (sum(devs > (1/0.5)) + sum(devs < 0.5)), "out of total", length(devs), "points."));
  
  return(devs);
}

#Create a simulated-vs-observed plot of total GLP-1
simulatedVsObserved_total = function(logAxes = "", minLim = 0){
  pchArr = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18)
  cols = esqLABS_colors(19);
  
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
  curve(identity(x), from = minLim, to = ,350, log = logAxes, xlab="Observed total GLP-1 [pmol/L]", ylab="Simulated total GLP-1 [pmol/L]")
  #Plot the 0.5 and 2 fold deviation lines.
  curve(plusDev(x), from = minLim, to = 350, add = TRUE, lty = 2);
  curve(minusDev(x), from = minLim, to = 350, add = TRUE, lty = 2);
  
  #The list devCurr stores the deviations of simulated values from the reported ones for the current data set.
  devCurr = c();
  idxPlot = 1;
  #Asmar_T2DM_AB
  currData = dataAsmar_total$T2DM_AB;
  currPath = resultsPath_GLP1_total_AB;
  currIdx = grep("Asmar_2016_H", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Asmar_T2DM_total_AB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Asmar_T2DM_total_AB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Asmar_T2DM_RB
  idxPlot = idxPlot + 1;
  currData = dataAsmar_total$T2DM_RB;
  currPath = resultsPath_GLP1_total_RB;
  currIdx = grep("Asmar_2016_H", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Asmar_T2DM_total_RB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Asmar_T2DM_total_RB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Creutzfeldt_1996
  idxPlot = idxPlot + 1;
  currData = dataCreutzfeld_1996_total;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Creutzfeldt_1996", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Creutzfeldt_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Creutzfeldt_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Elahi_1994
  idxPlot = idxPlot + 1;
  currData = dataElahi_1994_total;
  currPath = resultsPath_GLP1_total_AVB;
  currIdx = grep("Elahi_1994", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Elahi_1994_total_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Elahi_1994_total_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Idorn_2014
  idxPlot = idxPlot + 1;
  currData = dataIdorn_2014_total$H;
  currPath = resultsPath_GLP1_total_AVB;
  currIdx = grep("Idorn_2014_H", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Idorn_2014_H_total_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Idorn_2014_H_total_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Kjems_2003_H
  idxPlot = idxPlot + 1;
  currData = dataKjems_2003_total$H;
  currPath = resultsPath_GLP1_total_AVB;
  currIdx = grep("Kjems_2003", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Kjems_2003_H_total_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Kjems_2003_H_total_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Kjems_2003_T2DM
  idxPlot = idxPlot + 1;
  currData = dataKjems_2003_total$T2DM;
  currPath = resultsPath_GLP1_total_AVB;
  currIdx = grep("Kjems_2003", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Kjems_2003_T2DM_total_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Kjems_2003_T2DM_total_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Kreymann_1987
  idxPlot = idxPlot + 1;
  currData = dataKreymann_1987_total;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Kreymann_1987", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Kreymann_1987_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Kreymann_1987_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Meier_2003
  idxPlot = idxPlot + 1;
  currData = dataMeier_2003_total;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Meier_2003", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Meier_2003_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Meier_2003_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Nauck_1993_a
  idxPlot = idxPlot + 1;
  currData = dataNauck_1993_total;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Nauck_1993_a", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Nauck_1993_a_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Nauck_1993_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Nauck_2002
  idxPlot = idxPlot + 1;
  currData = dataNauck_2002_total;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Nauck_2002", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Nauck_2002_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Nauck_2002_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Orskov_1996
  idxPlot = idxPlot + 1;
  currData = dataOrskov_1996_total;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Orskov_1996", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Orskov_1996_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Orskov_1996_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Ryan_1998
  idxPlot = idxPlot + 1;
  currData = dataRyan_1998_total;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Ryan_1998", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Ryan_1998_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Ryan_1998_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();

  #Toft-Nielsen_1996_G1
  idxPlot = idxPlot + 1;
  currData = dataNielsen_1996_total$`1`;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Toft-Nielsen_1996", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Toft-Nielsen_1996_G1_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Toft-Nielsen_1996_G1_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Toft-Nielsen_1996_G2
  idxPlot = idxPlot + 1;
  currData = dataNielsen_1996_total$`2`;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Toft-Nielsen_1996", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Toft-Nielsen_1996_G2_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Toft-Nielsen_1996_G2_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Toft-Nielsen_2001
  idxPlot = idxPlot + 1;
  currData = dataNielsen_2001_total;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Toft-Nielsen_2001", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Toft-Nielsen_2001_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Toft-Nielsen_2001_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Vella_2000_1
  idxPlot = idxPlot + 1;
  currData = dataVella_2000_total$`1`;
  currPath = resultsPath_GLP1_total_AVB;
  currIdx = grep("Vella_2000", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Vella_2000_G1_total_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Vella_2000_G1_total_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Vella_2000_2
  idxPlot = idxPlot + 1;
  currData = dataVella_2000_total$`2`;
  currPath = resultsPath_GLP1_total_AVB;
  currIdx = grep("Vella_2000", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Vella_2000_G2_total_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Vella_2000_G2_total_AVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Vilsboll_2002
  idxPlot = idxPlot + 1;
  currData = dataVilsboll_2002_total;
  currPath = resultsPath_GLP1_total_PVB;
  currIdx = grep("Vilsboll_2002", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Vilsboll_2002_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
#  print(paste('Vilsboll_2002_total_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  print(paste('GLP-1 total: Deviation higher then 2x resp. 0.5x:', (sum(devs > (1/0.5)) + sum(devs < 0.5)), "out of total", length(devs), "points."));
  
  return(devs);
}

#Create a simulated-vs-observed plot of intact GIP
simulatedVsObserved_GIP_intact = function(logAxes = "", minLim = 0){
  pchArr = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18)
  cols = esqLABS_colors(2);
  
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
  curve(identity(x), from = minLim, to = 1500, log = logAxes, xlab="Observed intact GIP [pmol/L]", ylab="Simulated intact GIP [pmol/L]")
  #Plot the 0.5 and 2 fold deviation lines.
  curve(plusDev(x), from = minLim, to = 1500, add = TRUE, lty = 2);
  curve(minusDev(x), from = minLim, to = 1500, add = TRUE, lty = 2);
  
  #The list devCurr stores the deviations of simulated values from the reported ones for the current data set.
  devCurr = c();
  idxPlot = 1;

  #Vilsboll_2002
  currData = dataVilsboll_2002_GIP_intact;
  currPath = resultsPath_GIP_PVB;
  currIdx = grep("Vilsboll_2002", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Vilsboll_2002_GIP_active_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Christensen_2015_GIP_intact_AVB
  idxPlot = idxPlot + 1;
  currData = dataChristensen_2015_GIP_intact;
  currPath = resultsPath_GIP_AVB;
  currIdx = grep("Christensen_2015", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Christensen_2015_GIP_intact_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
 
  print(paste('GIP intact: Deviation higher then 2x resp. 0.5x:', (sum(devs > (1/0.5)) + sum(devs < 0.5)), "out of total", length(devs), "points."));
  
  return(devs);
}

#Create a simulated-vs-observed plot of total GIP
simulatedVsObserved_GIP_total = function(logAxes = "", minLim = 0){
  pchArr = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18)
  cols = esqLABS_colors(7);
  
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
  curve(identity(x), from = minLim, to = 2300, log = logAxes, xlab="Observed total GIP [pmol/L]", ylab="Simulated total GIP [pmol/L]")
  #Plot the 0.5 and 2 fold deviation lines.
  curve(plusDev(x), from = minLim, to = 2300, add = TRUE, lty = 2);
  curve(minusDev(x), from = minLim, to = 2300, add = TRUE, lty = 2);
  
  #The list devCurr stores the deviations of simulated values from the reported ones for the current data set.
  devCurr = c();
  idxPlot = 1;
  
  #Vilsboll_2002
  currData = dataVilsboll_2002_GIP_total;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Vilsboll_2002", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Vilsboll_2002_GIP_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Koffert_2017_GIP_total_PVB
  idxPlot = idxPlot + 1;
  currData = dataKoffert_2017_GIP_total;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Koffert_2017", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Koffert_2017_GIP_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Kreymann_1987_GIP_total_PVB
  idxPlot = idxPlot + 1;
  currData = dataKreymann_1987_GIP_total;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Kreymann_1987", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Kreymann_1987_GIP_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Lund_2011_GIP_total_AVB
  idxPlot = idxPlot + 1;
  currData = dataLund_2011_GIP_total;
  currPath = resultsPath_GIP_total_AVB;
  currIdx = grep("Lund_2011", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Lund_2011_GIP_total_AVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Nauck_1989_GIP_total_PVB
  idxPlot = idxPlot + 1;
  currData = dataNauck_1989_GIP_total;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Nauck_1989", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Nauck_1989_GIP_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  #Nauck_1993b_GIP_total_PVB
  idxPlot = idxPlot + 1;
  currData = dataNauck_1993b_GIP_total;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Nauck_1993_b", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  #For each dataset, iterate through the reported data points.
  for (i in 1:length(currData$`Time [min]`)){
    dataTime = currData$`Time [min]`[i];
    dataVal = currData$`Concentration [pmol/l]`[i];
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
  print(paste('Nauck_1993b_GIP_total_PVB: Deviation higher then 2x resp. 0.5x:', (sum(devCurr > (1/0.5)) + sum(devCurr < 0.5))));
  #  print(paste('Vilsboll_2002_active_PVB: Deviation higher then 1/0.7x resp. 0.7x:', (sum(devCurr > (1/0.7)) + sum(devCurr < 0.7))));
  devCurr = c();
  
  print(paste('GIP total: Deviation higher then 2x resp. 0.5x:', (sum(devs > (1/0.5)) + sum(devs < 0.5)), "out of total", length(devs), "points."));
  
  return(devs);
}

addCurveToPlot <- function(data, simResults, plotSettings){
  points(simResults[,1][plotSettings$timeOffset : length(simResults[,1])] - plotSettings$timeOffset, (simResults[,2][plotSettings$timeOffset : length(simResults[,2])]) * convFac,
       type = "l",
       lty = plotSettings$lty,
       col = plotSettings$color,
       lwd=2);
  
  points(data$`Time [min]` - plotSettings$timeOffset, data$`Concentration [pmol/l]`,
         pch = plotSettings$pch, 
         col = plotSettings$color,
         lwd = 2)
  arrows(data$`Time [min]` - plotSettings$timeOffset, data$`Concentration [pmol/l]` - data$`Error [pmol/l]`,
         data$`Time [min]` - plotSettings$timeOffset, data$`Concentration [pmol/l]` + data$`Error [pmol/l]`,
         length = 0.05,
         angle = 90,
         code = 3,
         col = plotSettings$color,
         lwd = 2)
}

getDciByName <- function(simName){
  currIdx <- grep(simName, DCIs$Names)
  return(DCIs$DCIs[,currIdx])
}

plotProfile <- function(dataArr, pathArr, currSim, plotSettings, plotToPng = TRUE){
  cols <- esqLABS_colors(length(dataArr))
  
  if (plotToPng){
    png(filename = plotSettings$figurePath,
        width = plotSettings$figureWidth,
        height = plotSettings$figureHeight,
        units = plotSettings$figureUnits,
        res = plotSettings$figureRes,
        pointsize = plotSettings$figurePointsize)
  }
  
  #initial plot
  plot(0,
       log="",
       type="n",
       xlab="Time [min]",
       ylab = "Concentration [pmol/l]",
       ygap.axis = 0.5,
       xlim = plotSettings$xLim,
       ylim = plotSettings$yLim,
       lwd=2)
  
  for (idx in seq_along(dataArr)){
    currResult <- getSimulationResult(path_id = pathArr[[idx]], DCI_Info = currSim)
    plotSettings$color <- cols[[idx]]
    plotSettings$lty <- plotSettings$ltyArr[[idx]]
    plotSettings$pch <- plotSettings$pchArr[[idx]]
    
    addCurveToPlot(data = dataArr[[idx]], simResults = currResult, plotSettings = plotSettings)
  }
  
  legend("topright", plotSettings$legendEntries,
         col = cols,
         lty = plotSettings$ltyArr,
         pch = plotSettings$pchArr,
         bty="n", y.intersp = 1.1)
  
  if (plotToPng)
  {
    dev.off()
  }
}

plotPkProfiles <- function(){
  plotSettings <- list()
  #pch and lty collection is equal for all plots
  plotSettings$pchArr <- c(0, 1, 2, 3, 4, 5, 6, 7)
  plotSettings$ltyArr <- c(1, 2, 4, 5, 6, 7, 8, 10)
  
  plotSettings$figureWidth <- 16
  plotSettings$figureHeight <- 16
  plotSettings$figureUnits <- "cm"
  plotSettings$figureRes <- 400
  plotSettings$figurePointsize <- 8
  
  # Asmar T2DM
  ###########INPUTS_START###########
  currSim <- getDciByName("Asmar_2016_H")
  
  dataArr <- list(dataAsmar_intact$T2DM_RB,
                  dataAsmar_intact$T2DM_AB,
                  dataAsmar_metab$T2DM_RB,
                  dataAsmar_metab$T2DM_AB,
                  dataAsmar_total$T2DM_RB,
                  dataAsmar_total$T2DM_AB)
  pathArr <- c(resultsPath_GLP1_active_RB,
               resultsPath_GLP1_active_AB,
               resultsPath_GLP1_metab_RB,
               resultsPath_GLP1_metab_AB,
               resultsPath_GLP1_total_RB,
               resultsPath_GLP1_total_AB)
  
  plotSettings$legendEntries <- c("GLP-1(7-36) RB", "GLP-1(7-36) AB", "GLP-1(9-36) RB", "GLP-1(9-36) AB", "GLP-1 total RB", "GLP-1 total AB")
  
  plotSettings$xLim <- c(0, 240)
  plotSettings$yLim <- c(0, 220)
  
  plotSettings$timeOffset <- 100
  ##########INPUTS_END###########
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S3_AsmarT2DM.png")
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  # Idorn_2014
  ###########INPUTS_START###########
  currSim <- getDciByName("Idorn_2014_H_placebo")
  
  dataArr <- list(dataIdorn_2014_intact$H,
                  dataIdorn_2014_total$H)
  pathArr <- c(resultsPath_GLP1_active_AVB,
               resultsPath_GLP1_total_AVB)
  
  plotSettings$legendEntries <- c("GLP-1(7-36) AVB", "GLP-1 total AVB")
  
  plotSettings$xLim <- c(0, 180)
  plotSettings$yLim <- c(0, 100)
  
  plotSettings$timeOffset <- 100
  ##########INPUTS_END###########
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S4_Idorn2014.png")
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Schirra_1998
  ###########INPUTS_START###########
  currSim <- getDciByName("Schirra_1998")
  
  dataArr <- list(dataSchirra_1998_intact
  )
  pathArr <- c(resultsPath_GLP1_active_AVB)
  
  plotSettings$legendEntries <- c("GLP-1(7-36) AVB")
  
  plotSettings$xLim <- c(0, 180)
  plotSettings$yLim <- c(0, 50)
  
  plotSettings$timeOffset <- 100
  ##########INPUTS_END###########
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S5_Schirra1998.png")
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings, plotToPng = FALSE)
  
  #Toft-Nielsen_2001
  ###########INPUTS_START###########
  currSim <- getDciByName("Toft-Nielsen_2001")
  
  dataArr <- list(dataNielsen_2001_intact,
                  dataNielsen_2001_total
  )
  pathArr <- c(resultsPath_GLP1_active_PVB,
               resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1(7-36) PVB",
                                  "GLP-1 total PVB")
  
  plotSettings$xLim <- c(0, 240)
  plotSettings$yLim <- c(0, 150)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S6_ToftNielsen2001.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Vella_2000
  ###########INPUTS_START###########
  currSim <- getDciByName("Vella_2000")
  
  dataArr <- list(dataVella_2000_intact$`1`,
                  dataVella_2000_intact$`2`,
                  dataVella_2000_total$`1`,
                  dataVella_2000_total$`2`
  )
  pathArr <- c(resultsPath_GLP1_active_AVB,
               resultsPath_GLP1_active_AVB,
               resultsPath_GLP1_total_AVB,
               resultsPath_GLP1_total_AVB)
  
  plotSettings$legendEntries <- c("GLP-1(7-36) AVB", "GLP-1(7-36) AVB", "GLP-1 total AVB", "GLP-1 total AVB")
  
  plotSettings$xLim <- c(0, 360)
  plotSettings$yLim <- c(0, 150)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S7_Vella2000.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Vilsboll_2002
  ###########INPUTS_START###########
  currSim <- getDciByName("Vilsboll_2002")
  
  dataArr <- list(dataVilsboll_2002_intact,
                  dataVilsboll_2002_total)
  pathArr <- c(resultsPath_GLP1_active_PVB,
               resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1(7-36) PVB", "GLP-1 total PVB")
  
  plotSettings$xLim <- c(0, 250)
  plotSettings$yLim <- c(0, 150)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S8_Vilsboll2002.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Creutzfeldt_1996
  ###########INPUTS_START###########
  currSim <- getDciByName("Creutzfeldt_1996")
  
  dataArr <- list(dataCreutzfeld_1996_total
  )
  pathArr <- c(resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 total PVB")
  
  plotSettings$xLim <- c(0, 260)
  plotSettings$yLim <- c(0, 150)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S3_Creutzfeldt1996.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Elahi_1994
  ###########INPUTS_START###########
  currSim <- getDciByName("Elahi_1994")
  
  dataArr <- list(dataElahi_1994_total
  )
  pathArr <- c(resultsPath_GLP1_total_AVB)
  
  plotSettings$legendEntries <- c("GLP-1 total AVB")
  
  plotSettings$xLim <- c(0, 90)
  plotSettings$yLim <- c(0, 400)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S10_Elahi1994.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Kjems_2003
  ###########INPUTS_START###########
  currSim <- getDciByName("Kjems_2003")
  
  dataArr <- list(dataKjems_2003_total$H,
                  dataKjems_2003_total$T2DM
  )
  pathArr <- c(resultsPath_GLP1_total_AVB,
               resultsPath_GLP1_total_AVB)
  
  plotSettings$legendEntries <- c("GLP-1 total AVB healthy", "GLP-1 total AVB T2DM")
  
  plotSettings$xLim <- c(0, 1100)
  plotSettings$yLim <- c(0, 252)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S11_Kjems2003.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Kreymann_1987
  ###########INPUTS_START###########
  currSim <- getDciByName("Kreymann_1987")
  
  dataArr <- list(dataKreymann_1987_total
  )
  pathArr <- c(resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 total PVB")
  
  plotSettings$xLim <- c(0, 140)
  plotSettings$yLim <- c(0, 100)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S12_Kreymann1987.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Meier_2003
  ###########INPUTS_START###########
  currSim <- getDciByName("Meier_2003")
  
  dataArr <- list(dataMeier_2003_total
  )
  pathArr <- c(resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 total PVB")
  
  plotSettings$xLim <- c(0, 1700)
  plotSettings$yLim <- c(0, 200)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S13_Meier2003.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Nauck_1993_a
  ###########INPUTS_START###########
  currSim <- getDciByName("Nauck_1993_a")
  
  dataArr <- list(dataNauck_1993_total
  )
  pathArr <- c(resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 total PVB")
  
  plotSettings$xLim <- c(0, 260)
  plotSettings$yLim <- c(0, 200)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S14_Nauck1993a.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Nauck_2002
  ###########INPUTS_START###########
  currSim <- getDciByName("Nauck_2002")
  
  dataArr <- list(dataNauck_2002_total
  )
  pathArr <- c(resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 total PVB")
  
  plotSettings$xLim <- c(0, 380)
  plotSettings$yLim <- c(0, 200)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S15_Nauck2002.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Ryan_1998
  ###########INPUTS_START###########
  currSim <- getDciByName("Ryan_1998")
  
  dataArr <- list(dataRyan_1998_total
  )
  pathArr <- c(resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 total PVB")
  
  plotSettings$xLim <- c(0, 120)
  plotSettings$yLim <- c(0, 150)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S17_Ryan_1998.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Orskov_1996
  ###########INPUTS_START###########
  currSim <- getDciByName("Orskov_1996")
  
  dataArr <- list(dataOrskov_1996_total
  )
  pathArr <- c(resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 total PVB")
  
  plotSettings$xLim <- c(0, 200)
  plotSettings$yLim <- c(0, 100)
  
  plotSettings$timeOffset <- 180
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S16_Orskov1996.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Toft-Nielsen_1996
  ###########INPUTS_START###########
  currSim <- getDciByName("Toft-Nielsen_1996")
  
  dataArr <- list(dataNielsen_1996_total$`1`,
                  dataNielsen_1996_total$`2`
  )
  pathArr <- c(resultsPath_GLP1_total_PVB,
               resultsPath_GLP1_total_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 total PVB 500 ?g/h SS", "GLP-1 total PVB 1000 ?g/h SS")
  
  plotSettings$xLim <- c(0, 180)
  plotSettings$yLim <- c(0, 100)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S18_Toft-Nielsen_1996.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Vilsboll_2002_GIP
  ###########INPUTS_START###########
  currSim <- getDciByName("Vilsboll_2002")
  
  dataArr <- list(dataVilsboll_2002_GIP_intact,
                  dataVilsboll_2002_GIP_total
  )
  pathArr <- c(resultsPath_GIP_PVB,
               resultsPath_GIP_total_PVB)
  
  plotSettings$legendEntries <- c("GIP(1-42) PVB", "GIP total PVB")
  
  plotSettings$xLim <- c(0, 600)
  plotSettings$yLim <- c(0, 2500)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S19_Vilsboll_2002_GIP.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Christensen_2015_GIP_intact_PVB
  ###########INPUTS_START###########
  currSim <- getDciByName("Christensen_2015")
  
  dataArr <- list(dataChristensen_2015_GIP_intact
  )
  pathArr <- c(resultsPath_GIP_PVB)
  
  plotSettings$legendEntries <- c("GIP(1-42) PVB")
  
  plotSettings$xLim <- c(0, 140)
  plotSettings$yLim <- c(0, 300)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S20_Christensen_2015_GIP_intact_PVB.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Koffert_2017_GIP_total_PVB
  ###########INPUTS_START###########
  currSim <- getDciByName("Koffert_2017")
  
  dataArr <- list(dataKoffert_2017_GIP_total
  )
  pathArr <- c(resultsPath_GIP_total_PVB)
  
  plotSettings$legendEntries <- c("GIP total PVB")
  
  plotSettings$xLim <- c(0, 100)
  plotSettings$yLim <- c(0, 300)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S21_Koffert_2017_GIP_total_PVB.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Kreymann_1987_GIP_total_PVB
  ###########INPUTS_START###########
  currSim <- getDciByName("Kreymann_1987")
  
  dataArr <- list(dataKreymann_1987_GIP_total
  )
  pathArr <- c(resultsPath_GIP_total_PVB)
  
  plotSettings$legendEntries <- c("GIP total PVB")
  
  plotSettings$xLim <- c(0, 160)
  plotSettings$yLim <- c(0, 250)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S22_Kreymann_1987_GIP_total_PVB.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Lund_2011_GIP_total_AVB
  ###########INPUTS_START###########
  currSim <- getDciByName("Lund_2011")
  
  dataArr <- list(dataLund_2011_GIP_total
  )
  pathArr <- c(resultsPath_GIP_total_AVB)
  
  plotSettings$legendEntries <- c("GIP total AVB")
  
  plotSettings$xLim <- c(0, 180)
  plotSettings$yLim <- c(0, 350)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S23_Lund_2011_GIP_total_AVB.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Nauck_1989_GIP_total_PVB
  ###########INPUTS_START###########
  currSim <- getDciByName("Nauck_1989")
  
  dataArr <- list(dataNauck_1989_GIP_total
  )
  pathArr <- c(resultsPath_GIP_total_PVB)
  
  plotSettings$legendEntries <- c("GIP total PVB")
  
  plotSettings$xLim <- c(0, 120)
  plotSettings$yLim <- c(0, 300)
  
  plotSettings$timeOffset <- 160
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S24_Nauck_1989_GIP_total_PVB.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Nauck_1993b_GIP_total_PVB
  ###########INPUTS_START###########
  currSim <- getDciByName("Nauck_1993_b")
  
  dataArr <- list(dataNauck_1993b_GIP_total
  )
  pathArr <- c(resultsPath_GIP_total_AVB)
  
  plotSettings$legendEntries <- c("GIP total PVB")
  
  plotSettings$xLim <- c(0, 180)
  plotSettings$yLim <- c(0, 1500)
  
  plotSettings$timeOffset <- 130
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S25_Nauck_1993b_GIP_total_PVB.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Beglinger_GLP
  ###########INPUTS_START###########
  currSim <- getDciByName("Beglinger_2008")
  
  dataArr <- list(dataBeglinger_GLP
  )
  pathArr <- c(resultsPath_GLP1_active_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 (7-36)amide PVB")
  
  plotSettings$xLim <- c(0, 60)
  plotSettings$yLim <- c(0, 100)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S26_Beglinger_GLP_PVB.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
  
  #Koffert_GLP
  ###########INPUTS_START###########
  currSim <- getDciByName("Koffert_2017")
  
  dataArr <- list(dataKoffert_GLP
  )
  pathArr <- c(resultsPath_GLP1_active_PVB)
  
  plotSettings$legendEntries <- c("GLP-1 (7-36)amide PVB")
  
  plotSettings$xLim <- c(0, 60)
  plotSettings$yLim <- c(0, 100)
  
  plotSettings$timeOffset <- 100
  plotSettings$figurePath <- paste0(figureFolder, "/Figure_S27_Koffert_GLP_PVB.png")
  ##########INPUTS_END###########
  plotProfile(dataArr = dataArr, pathArr = pathArr, currSim = currSim, plotSettings = plotSettings)
}

#Plot into a png file.
# png(file=paste0(figureFolder, "/Figure_3.png"),
#     width=16,
#     height=16,
#     units = "cm",
#     res=400,
#     pointsize=8)

pdf(file=paste0(figureFolder, "/Figure_3.pdf"),
    width = 7,
    height = 7,
    pointsize = 8)

logAxes = "xy"

par(mfrow = c(2, 2), cex=1, oma=c(0,0,0,0))
par(mar=c(5,5,0.4,0.1))

devs_intact = simulatedVsObserved_intact(logAxes = logAxes, minLim = 0.5);
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.26, par("usr")[4], "A",cex=1,font=1.5, xpd=T)

devs_total = simulatedVsObserved_total(logAxes = logAxes, minLim = 1);
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.3, par("usr")[4], "B",cex=1,font=1.5, xpd=T)

devs_GIP_intact = simulatedVsObserved_GIP_intact(logAxes = logAxes, minLim = 5);
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.26, par("usr")[4], "C",cex=1,font=1.5, xpd=T)

devs_GIP_total = simulatedVsObserved_GIP_total(logAxes = logAxes, minLim = 4);
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.3, par("usr")[4], "D",cex=1,font=1.5, xpd=T)
dev.off();
