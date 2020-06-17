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
dataSchirra_1996_GLP_1_intact = read.table(paste0(expDataFolder, "/Schirra_1996_GLP_1_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym);
dataSchirra_1996_GIP_total = read.table(paste0(expDataFolder, "/Schirra_1996_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym);


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
modelNames = c("/Schirra_1996_id_H_high",
               "/Schirra_1996_id_H_low"
);

#Simulate the models.
DCIs = sim_Models(modelNames);

#Define converstion factor from simulated ?mol/L to pmol/L
convFac = 1e6;

plotSchirra_GLP = function(){
  pchArr = c(0, 1)
  ltyArr = c(1, 2)
  cols = esqLABS_colors(2);
  
  #GLP-1 1.1 kcal/min
  idx = 1;
  currData = dataSchirra_1996_GLP_1_intact;
  currPath = resultsPath_GLP1_active_PVB;
  currIdx = grep("Schirra_1996_id_H_low", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  plot(currResult[,1][100:length(currResult[,1])] - 100, (currResult[,2][100:length(currResult[,2])])*1e6,
       log="", type="l", xlab="Time [min]", ylab = "Intact GLP-1 [pmol/l]",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 180),
       ylim=c(0, 6), lwd=2);
  
  points(currData$Time..min. - 100, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 100, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 100, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  #GLP-1 2.2 kcal/min
  idx = idx + 1;
  currData = dataSchirra_1996_GLP_1_intact;
  currPath = resultsPath_GLP1_active_PVB;
  currIdx = grep("Schirra_1996_id_H_high", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1][400:length(currResult[,2])] - 400, (currResult[,2][400:length(currResult[,2])])*1e6,
         type = "l",
         lty=ltyArr[idx],
         col=cols[idx],
         lwd=2);
  
  points(currData$Time..min. - 400, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 400, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 400, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  legend("topleft", c("1.1 kcal/min id glucose", "2.2 kcal/min id glucose"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

plotSchirra_GIP = function(){
  pchArr = c(0, 1)
  ltyArr = c(1, 2)
  cols = esqLABS_colors(2);
  
  #GLP-1 1.1 kcal/min
  idx = 1;
  currData = dataSchirra_1996_GIP_total;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Schirra_1996_id_H_low", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  plot(currResult[,1][100:length(currResult[,1])] - 100, (currResult[,2][100:length(currResult[,2])])*1e6,
       log="", type="l", xlab="Time [min]", ylab = "Total GIP [pmol/l]",
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 180),
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
  
  #GLP-1 2.2 kcal/min
  idx = idx + 1;
  currData = dataSchirra_1996_GIP_total;
  currPath = resultsPath_GIP_total_PVB;
  currIdx = grep("Schirra_1996_id_H_high", DCIs$Names);
  currSim = DCIs$DCIs[,currIdx];
  currResult = getSimulationResult(path_id = currPath, DCI_Info = currSim);
  points(currResult[,1][400:length(currResult[,2])] - 400, (currResult[,2][400:length(currResult[,2])])*1e6,
         type = "l",
         lty=ltyArr[idx],
         col=cols[idx],
         lwd=2);
  
  points(currData$Time..min. - 400, currData$Concentration..pmol.l.,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(currData$Time..min. - 400, currData$Concentration..pmol.l. - currData$Error..pmol.l.,
         currData$Time..min. - 400, currData$Concentration..pmol.l. + currData$Error..pmol.l.,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  legend("topleft", c("1.1 kcal/min id glucose", "2.2 kcal/min id glucose"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

pdf(file=paste0(figureFolder, "/Figure_4.pdf"),
    width = 7,
    height = 3.5,
    pointsize = 8)

par(mfrow = c(1, 2), cex=1, oma=c(0,0,0,0))
par(mar=c(4,5,0.4,0.1))

plotSchirra_GLP();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.26, par("usr")[4], "A",cex=1,font=1.5, xpd=T)
plotSchirra_GIP();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.3, par("usr")[4], "B",cex=1,font=1.5, xpd=T)
dev.off();
