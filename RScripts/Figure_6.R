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

resultsPath_plasmaDPP_inhib = "*|Organism|VenousBlood|Plasma|Sitagliptin-DPP4_plasma Complex|Receptor Occupancy-Sitagliptin-DPP4_plasma Complex"

paramPath <- "*|Applications|po_Sitagliptin|Sitagliptin_tablet|Application_1|ProtocolSchemaItem|Dose"
modelPath <- paste0(simFolder, "/Andersen_2018_placebo.xml")
initStruct <- initParameter(c(), path_id = paramPath)
modelDCI <- initSimulation(XML = modelPath, ParamList = initStruct)

#Simulate without sita
modelDCI <- setParameter(value = 0, paramPath, DCI_Info = modelDCI)
modelDCI <- processSimulation(modelDCI)
GLP1_placebo <- getSimulationResult(resultsPath_GLP1_active_AVB, DCI_Info = modelDCI)
GIP_placebo <- getSimulationResult(resultsPath_GIP_AVB, DCI_Info = modelDCI)

#Simulate with 100mg sita
modelDCI <- setParameter(value = 200e-6, paramPath, DCI_Info = modelDCI)
modelDCI <- processSimulation(modelDCI)
GLP1_sita <- getSimulationResult(resultsPath_GLP1_active_AVB, DCI_Info = modelDCI)
GIP_sita <- getSimulationResult(resultsPath_GIP_AVB, DCI_Info = modelDCI)



# png(file=paste0(figureFolder, "/Figure_6.png"),
#     width=36,
#     height=18,
#     units = "cm",
#     res=600,
#     pointsize = 18)

pdf(file=paste0(figureFolder, "/Figure_6.pdf"),
    width = 7,
    height = 3.5,
    pointsize = 8)

par(mfrow = c(1, 2), cex=1, oma=c(0,0,0,0))
par(mar=c(4,5,0.4,0.1))

pchArr = c(0, 1, 2, 3, 4, 5, 6, 7)
ltyArr = c(1, 2, 4, 5, 6, 7, 8, 10)
cols = esqLABS_colors(2);

timeOffset <- 40

idx = 1;
plot(GLP1_placebo[,1][timeOffset : length(GLP1_placebo[,1])] - timeOffset, (GLP1_placebo[,2][timeOffset : length(GLP1_placebo[,2])])*1e6,
     log="", type="l", xlab="Time [min]", ylab = "GLP-1 (7-36)amide [pmol/l]",
     ygap.axis = 0.5,
     lty=ltyArr[idx],
     col=cols[idx],
     xlim=c(0, 440),
     ylim=c(0, 50), lwd=2);

idx <- idx + 1
points(GLP1_sita[,1][timeOffset : length(GLP1_sita[,1])] - timeOffset, (GLP1_sita[,2][timeOffset : length(GLP1_sita[,2])])*1e6,
       type = "l",
       pch = pchArr[idx],
       lty = ltyArr[idx],
       col=cols[idx],
       lwd=2)

legend("topright", c("Placebo", "100 mg sitagliptin"),
       col=cols,
       lty=ltyArr,
       pch=pchArr,
       bty="n", y.intersp = 1.1)

par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.26, par("usr")[4], "A",cex=1,font=1.5, xpd=T)

idx = 1;
plot(GIP_placebo[,1][timeOffset : length(GIP_placebo[,1])] - timeOffset, (GIP_placebo[,2][timeOffset : length(GIP_placebo[,2])])*1e6,
     log="", type="l", xlab="Time [min]", ylab = "GIP (1-42) [pmol/l]",
     ygap.axis = 0.5,
     lty=ltyArr[idx],
     col=cols[idx],
     xlim=c(0, 440),
     ylim=c(0, 500), lwd=2);

idx <- idx + 1
points(GIP_sita[,1][timeOffset : length(GIP_sita[,1])] - timeOffset, (GIP_sita[,2][timeOffset : length(GIP_sita[,2])])*1e6,
       type = "l",
       pch = pchArr[idx],
       lty = ltyArr[idx],
       col=cols[idx],
       lwd=2)

legend("topright", c("Placebo", "100 mg sitagliptin"),
       col=cols,
       lty=ltyArr,
       pch=pchArr,
       bty="n", y.intersp = 1.1)

par(new = TRUE)
plot(10,0, axes = FALSE, pch=NA, xlab = "", ylab = "")
text(par("usr")[1] - par("usr")[1]*0.3, par("usr")[4], "B",cex=1,font=1.5, xpd=T)
dev.off()

