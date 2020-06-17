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

dataAsmar_intact <- read.table(paste0(expDataFolder, "/Asmar_2016.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE)
dataAsmar_metab <- read.table(paste0(expDataFolder, "/Asmar_2016_metab.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE)
dataAsmar_total <- read.table(paste0(expDataFolder, "/Asmar_2016_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE)

dataAsmar_intact <- split(dataAsmar_intact, dataAsmar_intact$Group)
dataAsmar_metab <- split(dataAsmar_metab, dataAsmar_metab$Group)
dataAsmar_total <- split(dataAsmar_total, dataAsmar_total$Group)

dataVilsboll_2002_GIP_intact <- read.table(paste0(expDataFolder, "/Vilsboll_2002_GIP_intact.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE)
dataVilsboll_2002_GIP_total <- read.table(paste0(expDataFolder, "/Vilsboll_2002_GIP_total.csv"), header = TRUE, sep=";", as.is = TRUE, stringsAsFactors = FALSE, dec = decSym, check.names = FALSE)

asmarSim <- executeSim(simPath = paste0(simFolder, "/Asmar_2016_H"))

sim_GLP1_7_36_AB <- getSimulationResult("*|Organism|ArterialBlood|Plasma|GLP-1_7-36-amide|Concentration in container", DCI_Info = asmarSim)
sim_GLP1_7_36_RB <- getSimulationResult("*|Organism|Kidney|Medulla|Plasma|GLP-1_7-36-amide|Concentration in container", DCI_Info = asmarSim)

sim_GLP1_9_36_AB <- getSimulationResult("*|Organism|ArterialBlood|Plasma|GLP-1_9-36-amide|Concentration in container", DCI_Info = asmarSim)
sim_GLP1_9_36_RB <- getSimulationResult("*|Organism|Kidney|Medulla|Plasma|GLP-1_9-36-amide|Concentration in container", DCI_Info = asmarSim)

sim_GLP1_total_AB <- getSimulationResult("*|Organism|ArterialBlood|Plasma|GLP-1_7-36-amide|Concentration in container_GLP1_total", DCI_Info = asmarSim)
sim_GLP1_total_RB <- getSimulationResult("*|Organism|Kidney|Medulla|Plasma|GLP-1_7-36-amide|Concentration in container_GLP1_total", DCI_Info = asmarSim)

vilsbollSim <- executeSim(simPath = paste0(simFolder, "/Vilsboll_2002"))

sim_GIP_PVB = getSimulationResult("*|Organism|PeripheralVenousBlood|GIP_1-42|Plasma (Peripheral Venous Blood)", DCI_Info = vilsbollSim);
sim_GIP_total_PVB = getSimulationResult("*|Organism|PeripheralVenousBlood|GIP_1-42|Plasma (Peripheral Venous Blood)_GIP_total", DCI_Info = vilsbollSim);                       

plotAsmar = function(){
  pchArr = c(0, 1, 2, 3, 4, 5, 6, 7)
  ltyArr = c(1, 2, 4, 5, 6, 7, 8, 10)
  cols = esqLABS_colors(6);

  #7-36 RB
  idx = 1;
  currResults = sim_GLP1_7_36_RB;
  plot(currResults[,1][100:length(currResults[,1])] - 100, (currResults[,2][100:length(currResults[,2])])*1e6,
       log="", type="l", xlab="Time [min]", ylab = "Concentration [pmol/l]",
       ygap.axis = 0.5,
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 240),
       ylim=c(0, 220), lwd=2);
  
  points(dataAsmar_intact$H_RB$`Time [min]` - 100, dataAsmar_intact$H_RB$`Concentration [pmol/l]`,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(dataAsmar_intact$H_RB$`Time [min]` - 100, dataAsmar_intact$H_RB$`Concentration [pmol/l]` - dataAsmar_intact$H_RB$`Error [pmol/l]`,
         dataAsmar_intact$H_RB$`Time [min]` - 100, dataAsmar_intact$H_RB$`Concentration [pmol/l]` + dataAsmar_intact$H_RB$`Error [pmol/l]`,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  #7-36 AB
  idx = idx + 1;
  currResults = sim_GLP1_7_36_AB;
  points(currResults[,1][100:length(currResults[,1])] - 100, (currResults[,2][100:length(currResults[,2])])*1e6,
    type="l",
    lty=ltyArr[idx],
    col=cols[idx],
    lwd=2);
  
  points(dataAsmar_intact$H_AB$`Time [min]` - 100, dataAsmar_intact$H_AB$`Concentration [pmol/l]`,
         pch = pchArr[idx],
         col=cols[idx],
         lwd=2)
  arrows(dataAsmar_intact$H_AB$`Time [min]` - 100, dataAsmar_intact$H_AB$`Concentration [pmol/l]` - dataAsmar_intact$H_AB$`Error [pmol/l]`,
         dataAsmar_intact$H_AB$`Time [min]` - 100, dataAsmar_intact$H_AB$`Concentration [pmol/l]` + dataAsmar_intact$H_AB$`Error [pmol/l]`,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  #9-36 RB
  idx = idx + 1;
  currResults = sim_GLP1_9_36_RB;
  points(currResults[,1][100:length(currResults[,1])] - 100, (currResults[,2][100:length(currResults[,2])])*1e6,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         lwd=2);
  points(dataAsmar_metab$H_RB$`Time [min]` - 100, dataAsmar_metab$H_RB$`Concentration [pmol/l]`,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(dataAsmar_metab$H_RB$`Time [min]` - 100, dataAsmar_metab$H_RB$`Concentration [pmol/l]` - dataAsmar_metab$H_RB$`Error [pmol/l]`,
         dataAsmar_metab$H_RB$`Time [min]` - 100, dataAsmar_metab$H_RB$`Concentration [pmol/l]` + dataAsmar_metab$H_RB$`Error [pmol/l]`,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  #9-36 AB
  idx = idx + 1;
  currResults = sim_GLP1_9_36_AB;
  points(currResults[,1][100:length(currResults[,1])] - 100, (currResults[,2][100:length(currResults[,2])])*1e6,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         lwd=2);
  points(dataAsmar_metab$H_AB$`Time [min]` - 100, dataAsmar_metab$H_AB$`Concentration [pmol/l]`,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(dataAsmar_metab$H_AB$`Time [min]` - 100, dataAsmar_metab$H_AB$`Concentration [pmol/l]` - dataAsmar_metab$H_AB$`Error [pmol/l]`,
         dataAsmar_metab$H_AB$`Time [min]` - 100, dataAsmar_metab$H_AB$`Concentration [pmol/l]` + dataAsmar_metab$H_AB$`Error [pmol/l]`,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  #metab
  idx = idx + 1;
  currResults = sim_GLP1_total_RB;
  points(currResults[,1][100:length(currResults[,1])] - 100, (currResults[,2][100:length(currResults[,2])])*1e6,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         lwd=2);
  points(dataAsmar_total$H_RB$`Time [min]` - 100, dataAsmar_total$H_RB$`Concentration [pmol/l]`,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(dataAsmar_total$H_RB$`Time [min]` - 100, dataAsmar_total$H_RB$`Concentration [pmol/l]` - dataAsmar_total$H_RB$`Error [pmol/l]`,
         dataAsmar_total$H_RB$`Time [min]` - 100, dataAsmar_total$H_RB$`Concentration [pmol/l]` + dataAsmar_total$H_RB$`Error [pmol/l]`,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)

  idx = idx + 1;
  currResults = sim_GLP1_total_AB;
  points(currResults[,1][100:length(currResults[,1])] - 100, (currResults[,2][100:length(currResults[,2])])*1e6,
         type="l",
       lty=ltyArr[idx],
       col=cols[idx],
       lwd=2);
  points(dataAsmar_total$H_AB$`Time [min]` - 100, dataAsmar_total$H_AB$`Concentration [pmol/l]`,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(dataAsmar_total$H_AB$`Time [min]` - 100, dataAsmar_total$H_AB$`Concentration [pmol/l]` - dataAsmar_total$H_AB$`Error [pmol/l]`,
         dataAsmar_total$H_AB$`Time [min]` - 100, dataAsmar_total$H_AB$`Concentration [pmol/l]` + dataAsmar_total$H_AB$`Error [pmol/l]`,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)

  legend("topright", c("GLP-1(7-36) RB", "GLP-1(7-36) AB", "GLP-1(9-36) RB", "GLP-1(9-36) AB", "GLP-1 total RB", "GLP-1 total AB"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}

plotVilsboll = function(){
  pchArr = c(0, 1)
  ltyArr = c(1, 2)
  cols = esqLABS_colors(2);
  
  #GIP PVB
  idx = 1;
  currResults = sim_GIP_PVB;
  plot(currResults[,1][100:length(currResults[,1])] - 100, (currResults[,2][100:length(currResults[,2])])*1e6,
       log="", type="l", xlab="Time [min]", ylab = "Concentration [pmol/l]",
       ygap.axis = 0.5,
       lty=ltyArr[idx],
       col=cols[idx],
       xlim=c(0, 600),
       ylim=c(0, 2500), lwd=2);
  
  points(dataVilsboll_2002_GIP_intact$`Time [min]` - 100, dataVilsboll_2002_GIP_intact$`Concentration [pmol/l]`,
         pch = pchArr[idx], 
         col=cols[idx],
         lwd=2)
  arrows(dataVilsboll_2002_GIP_intact$`Time [min]` - 100, dataVilsboll_2002_GIP_intact$`Concentration [pmol/l]` - dataVilsboll_2002_GIP_intact$`Error [pmol/l]`,
         dataVilsboll_2002_GIP_intact$`Time [min]` - 100, dataVilsboll_2002_GIP_intact$`Concentration [pmol/l]` + dataVilsboll_2002_GIP_intact$`Error [pmol/l]`,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
  
  #GIP total PVB
  idx = idx + 1;
  currResults = sim_GIP_total_PVB;
  points(currResults[,1][100:length(currResults[,1])] - 100, (currResults[,2][100:length(currResults[,2])])*1e6,
         type="l",
         lty=ltyArr[idx],
         col=cols[idx],
         lwd=2);
  
  points(dataVilsboll_2002_GIP_total$`Time [min]` - 100, dataVilsboll_2002_GIP_total$`Concentration [pmol/l]`,
         pch = pchArr[idx],
         col=cols[idx],
         lwd=2)
  arrows(dataVilsboll_2002_GIP_total$`Time [min]` - 100, dataVilsboll_2002_GIP_total$`Concentration [pmol/l]` - dataVilsboll_2002_GIP_total$`Error [pmol/l]`,
         dataVilsboll_2002_GIP_total$`Time [min]` - 100, dataVilsboll_2002_GIP_total$`Concentration [pmol/l]` + dataVilsboll_2002_GIP_total$`Error [pmol/l]`,
         length=0.05, angle=90, code=3,
         col=cols[idx],
         lwd=2)
 
  legend("topleft", c("GIP(1-42) PVB", "GIP total PVB"),
         col=cols,
         lty=ltyArr,
         pch=pchArr,
         bty="n", y.intersp = 1.1)
}


#Coomment this part if you do not want the create a file
 pdf(file=paste0(figureFolder, "/Figure_2.pdf"),
     width = 7,
     height = 3.5,
     pointsize = 8)

par(mfrow = c(1, 2), cex=1, oma=c(0,0,0,0))
par(mar=c(4,5,0.4,0.1))

plotAsmar();
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.26, par("usr")[4], "A",cex=1,font=1.5, xpd=T)

plotVilsboll()
par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.3, par("usr")[4], "B",cex=1,font=1.5, xpd=T)
dev.off()

