#install.packages("foreign")
#install.packages("dplyr")
library(foreign)
library(dplyr)
library(ggplot2)
library(tidyr)
library(ggExtra)
library(ggthemes)
library(RColorBrewer)



# Clean data


## Load data

### Load weighted, standardized data
STATA1 <- read.dta("Economic-Justice_v7_2014-04-08_E_WORKING.dta")
dataWhtStd <- tbl_df(STATA1)

### Load weighted, unstandardized data
STATA2 <- read.dta("Economic-Justice_v7_2014-04-08_D_NON-STANDARD-WEIGHTED.dta")
dataWhtUnstd <- tbl_df(STATA2)
remove(STATA1, STATA2)

### Load raw (i.e., unweighted, unstandardized) data
STATA <- read.dta("Economic-Justice_v7_2014-04-08_B_NON-STANDARDIZED.dta")
fullData <- tbl_df(STATA)
remove(STATA)


## Purge duplicate entries

### Check for duplicate observations
n_occur <- data.frame(table(dataWhtUnstd$participant_id))
n_occur[n_occur$Freq > 1, ]
dupTest <- dataWhtUnstd[dataWhtUnstd$participant_id == "424269", ]

### Remove duplicate observations
dataWhtUnstd <-dataWhtUnstd[!(dataWhtUnstd$participant_id == "424269" &
                                dataWhtUnstd$id == "1157"),]
dataWhtStd <-dataWhtStd[!(dataWhtStd$participant_id == "424269" &
                            dataWhtStd$id == "1157"),]




# Create new _ideal variables where all responses that a factor should  be
# "unimportant" are coded as 0, and all other responses are increased by 1

### Create vector of 15 measured factors that influence socio-economic standing.
statusSource <- c("attitude", "wealth", "ambition", "parenteduc", "race",
                  "stablefam", "gender", "health", "hardwork", "econstate",
                  "education", "school", "connections", "iq", "creativity")

### New _ideal variable with 'T' indicates 'truncated'
for (n in 1:length(statusSource)) {
  idealVarOld <- paste(statusSource[n], "ideal", sep = "_")
  idealVarNew <- paste(statusSource[n], "idealT", sep = "_")
  dataWhtUnstd[[idealVarNew]] <- ifelse(dataWhtUnstd[[idealVarOld]] >= 0, 
                                        dataWhtUnstd[[idealVarOld]] + 1, 0)
}

### Check that new truncated _ideal variable was created properly.
table(dataWhtUnstd$attitude_ideal, dataWhtUnstd$attitude_idealT)
table(dataWhtUnstd$race_ideal, dataWhtUnstd$race_idealT)




# Calculate correlation coefficients for each factor.

## Specifically, calculate the correlation between (1) the Ideal Importance that 
## respondents whish a factor had in determinging economic standing and (2) the 
## Level of Control the respondents think people have over that factor.

### Create dataframe to hold correlations
factCorr <- data.frame()

### Calculate agency-ideal and agency-idealT correlations and place in dataframe
for (n in 1:length(statusSource)) {
  idealVar <- paste(statusSource[n], "ideal", sep = "_")
  idealVarT <- paste(statusSource[n], "idealT", sep = "_")
  agencyVar <- paste(statusSource[n], "agency", sep = "_")
  factCorr[n, "statusSource"] <- statusSource[n]
  factCorr[n, "idealAgencyCorr"] <- cor(dataWhtUnstd[[idealVar]], 
                                        dataWhtUnstd[[agencyVar]])
  factCorr[n, "idealAgencyCorrT"] <- cor(dataWhtUnstd[[idealVarT]], 
                                         dataWhtUnstd[[agencyVar]])
}

### Arrange correlation dataframe in descending order of agency-idealT corr.
factCorr <- arrange(factCorr, desc(idealAgencyCorrT))


# Create dataframe for facet graphing of correlations

### Create _agency, _ideal, and _idealT dataframes with relevant variables only
dataWhtUnstd_agency <- select(dataWhtUnstd, 
                             participant_id, attitude_agency:creativity_agency)
dataWhtUnstd_ideal <- select(dataWhtUnstd, 
                             participant_id, attitude_ideal:creativity_ideal)
dataWhtUnstd_idealT <- select(dataWhtUnstd, 
                             participant_id, attitude_idealT:creativity_idealT)

### Convert _agency, _ideal, and _idealT dataframs from wide to long
dataLong_agency <- gather(dataWhtUnstd_agency, statusSource, control,
                          attitude_agency:creativity_agency, factor_key=TRUE)
dataLong_ideal <- gather(dataWhtUnstd_ideal, statusSource, ideal,
                         attitude_ideal:creativity_ideal, factor_key=TRUE)
dataLong_idealT <- gather(dataWhtUnstd_idealT, statusSource, idealT,
                          attitude_idealT:creativity_idealT, factor_key=TRUE)

### Check that _agency, _ideal, and _idealT dataframes are in same order before
### merging
identical(dataLong_agency$participant_id, 
          dataLong_ideal$participant_id, dataLong_idealT$participant_id)

### Merge _agency, _ideal, and _idealT long dataframes into one
dataWhtUnstdLong <- dataLong_agency
dataWhtUnstdLong$ideal <- dataLong_ideal$ideal
dataWhtUnstdLong$idealT <- dataLong_idealT$idealT

### Remove the text after the "_" in the vals for the statusSource var
dataWhtUnstdLong$statusSource <- sub('_([^_]*)$', '',
                                     dataWhtUnstdLong$statusSource)


## Convert statusSource to a factor with appropriate levels in the long df

### Create new factor variable statusSourceT;
### factCorr df currently has statusOrigin var arrayed in descending order of
### the truncated idealAgencyCorrT var, which will be the order of the new
### factor var's levels
dataWhtUnstdLong$statusSourceT <- factor(dataWhtUnstdLong$statusSource,
                                         levels = factCorr$statusSource)

### Rearrange factCorr df so that statusOrigin var is arrayed in descending 
### order of the original (ie, not truncated) idealAgencyCorrT var
factCorr <- arrange(factCorr, desc(idealAgencyCorr))

### Reorder statusSource var in the Long df
dataWhtUnstdLong$statusSource <- factor(dataWhtUnstdLong$statusSource,
                                         levels = factCorr$statusSource)

levels(dataWhtUnstdLong$statusSource)
levels(dataWhtUnstdLong$statusSourceT)



########################################################

library(data.table)  # faster fread() and better weekdays()
library(dplyr)       # consistent data.frame operations
library(purrr)       # consistent & safe list/vector munging
library(tidyr)       # consistent data.frame cleaning
library(ggplot2)     # base plots are for Coursera professors
library(scales)      # pairs nicely with ggplot2 for plot label formatting
library(gridExtra)   # a helper for arranging individual ggplot objects
library(ggthemes)    # has a clean theme for ggplot2
library(viridis)     # best. color. palette. evar.
library(knitr)       # kable : prettier data.frame output


### Gather data for graphing
library(plyr)
dfHeatT <- count(dataWhtUnstdLong, c("statusSourceT", "control", "idealT")) 
dfHeat <- count(dataWhtUnstdLong, c("statusSource", "control", "ideal"))

### Make sure there are entries for every possible combintaion of "control" and
### "ideal importance".
dfHeatT <- complete(dfHeatT, statusSourceT, control, idealT)
dfHeat <- complete(dfHeat, statusSource, control, ideal)

### Combinations without responses should be treated as zero (0).
dfHeatT[is.na(dfHeatT)] <- 0
dfHeat[is.na(dfHeat)] <- 0

### Calculate percentage responses
dfHeatT$percentage <- dfHeatT$freq / length(dataWhtUnstd$id)
dfHeat$percentage <- dfHeat$freq / length(dataWhtUnstd$id)

### Check that the number of responses sum to 991 for each group, and 
### and percentages sum to 1 for each group
detach(package:plyr)  # summarizing by group needs dplyr rather than plyr
library(dplyr)
group_by(dfHeatT, statusSourceT) %>%
  summarise(stdev = sd(freq), totNum = sum(freq), totPer = sum(percentage))
group_by(dfHeat, statusSource) %>%
  summarise(stdev = sd(freq), totNum = sum(freq), totPer = sum(percentage))



factCorrT <- arrange(factCorr, desc(idealAgencyCorrT))
factCorr <- arrange(factCorr, desc(idealAgencyCorr))

factCorrT$statusSource
factCorr$statusSource

library(plyr)
dfHeatT$statusSourceT <- revalue(dfHeatT$statusSourceT, c(
  "race" = paste("race\nr =", 
                 sprintf("%.2f",factCorrT$idealAgencyCorrT[1],sep="")),
  "wealth" = paste("fam. wealth\nr =",
                   sprintf("%.2f",factCorrT$idealAgencyCorrT[2],sep="")),
  "connections" = paste("connections\nr =",
                        sprintf("%.2f",factCorrT$idealAgencyCorrT[3],sep="")),
  "ambition" = paste("ambition\nr =",
                     sprintf("%.2f",factCorrT$idealAgencyCorrT[4],sep="")),
  "gender" = paste("gender\nr =",
                   sprintf("%.2f",factCorrT$idealAgencyCorrT[5],sep="")),
  "hardwork" = paste("hardwork\nr =",
                     sprintf("%.2f",factCorrT$idealAgencyCorrT[6],sep="")),
  "parenteduc" = paste("parents' educ.\nr =",
                       sprintf("%.2f",factCorrT$idealAgencyCorrT[7],sep="")),
  "attitude" = paste("attitude\nr =",
                     sprintf("%.2f",factCorrT$idealAgencyCorrT[8],sep="")),
  "econstate" = paste("state of econ.\nr =",
                      sprintf("%.2f",factCorrT$idealAgencyCorrT[9],sep="")),
  "health" = paste("health\nr =",
                   sprintf("%.2f",factCorrT$idealAgencyCorrT[10],sep="")),
  "stablefam" = paste("fam. stability\nr =",
                      sprintf("%.2f",factCorrT$idealAgencyCorrT[11],sep="")),
  "creativity" = paste("creativity\nr =",
                       sprintf("%.2f",factCorrT$idealAgencyCorrT[12],sep="")),
  "education" = paste("education\nr =",
                      sprintf("%.2f",factCorrT$idealAgencyCorrT[13],sep="")),
  "school" = paste("schl. prestige\nr =",
                   sprintf("%.2f",factCorrT$idealAgencyCorrT[14],sep="")),
  "iq" = paste("intelligence\nr =",
               sprintf("%.2f",factCorrT$idealAgencyCorrT[15],sep=""))))


dfHeat$statusSource <- revalue(dfHeat$statusSource, c(
  "race" = paste("race\nr = ", 
                 sprintf("%.2f",factCorr$idealAgencyCorr[1]),sep=""),
  "wealth" = paste("fam. wealth\nr = ",
                   sprintf("%.2f",factCorr$idealAgencyCorr[2]),sep=""),
  "connections" = paste("connections\nr = ",
                        sprintf("%.2f",factCorr$idealAgencyCorr[3]),sep=""),
  "ambition" = paste("ambition\nr = ",
                     sprintf("%.2f",factCorr$idealAgencyCorr[4]),sep=""),
  "gender" = paste("gender\nr = ",
                   sprintf("%.2f",factCorr$idealAgencyCorr[5]),sep=""),
  "hardwork" = paste("hardwork\nr = ",
                     sprintf("%.2f",factCorr$idealAgencyCorr[6]),sep=""),
  "parenteduc" = paste("parents' educ.\nr = ",
                       sprintf("%.2f",factCorr$idealAgencyCorr[7]),sep=""),
  "attitude" = paste("attitude\nr = ",
                     sprintf("%.2f",factCorr$idealAgencyCorr[8]),sep=""),
  "econstate" = paste("state of econ.\nr = ",
                      sprintf("%.2f",factCorr$idealAgencyCorr[9]),sep=""),
  "health" = paste("health\nr = ",
                   sprintf("%.2f",factCorr$idealAgencyCorr[10]),sep=""),
  "stablefam" = paste("fam. stability\nr = ",
                      sprintf("%.2f",factCorr$idealAgencyCorr[11]),sep=""),
  "creativity" = paste("creativity\nr = ",
                       sprintf("%.2f",factCorr$idealAgencyCorr[12]),sep=""),
  "education" = paste("education\nr = ",
                      sprintf("%.2f",factCorr$idealAgencyCorr[13]),sep=""),
  "school" = paste("schl. prestige\nr = ",
                   sprintf("%.2f",factCorr$idealAgencyCorr[14]),sep=""),
  "iq" = paste("intelligence\nr = ",
               sprintf("%.2f",factCorr$idealAgencyCorr[15]),sep="")))



### Standardize data for graphing 
### [-1,1] for control and ideal, and [0,1] for controlT idealT

dfHeat$control_std <- (dfHeat$control - (max(dfHeat$control) /2)) / 
  (max(dfHeat$control) /2)
dfHeat$ideal_std <- dfHeat$ideal / max(dfHeat$ideal)

dfHeatT$control_std <- dfHeatT$control / max(dfHeatT$control)
dfHeatT$idealT_std <- dfHeatT$idealT / max(dfHeatT$idealT)


## Fonts

### Helvetica displays nicely.
library(extrafont)
extrafont::loadfonts(device="win")
#font_import(pattern = 'Roboto')
loadfonts()
fonts()



### Graph

vidInfernoT_stdVert <- ggplot(dfHeatT, 
                          aes(x=control_std, y=idealT_std, fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="%", direction = -1, option="B") +
  coord_equal() + facet_wrap(~statusSourceT, ncol=5) +
  scale_y_continuous(breaks=seq(0, 1, 0.5)) +
  scale_x_continuous(breaks=seq(0, 1, 0.5)) +
  labs(x="control over...", y="ideal importance of...") +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        strip.text.x=element_text(size=10, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.2, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_text(size=10, face="bold"),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="right", legend.key.size=unit(.55, "cm"),
        legend.key.width=unit(0.23, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidInfernoT_stdVert

ggsave("vidInfernoT_stdVert.png", plot = vidInfernoT_stdVert, 
       width = 6.5, height = 4.5, units = "in", dpi = 600)


vidInferno_stdVert <- ggplot(dfHeat,
                         aes(x=control_std, y=ideal_std, fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="%", direction = -1, option="B") +
  facet_wrap(~statusSource, ncol=5) +
  scale_y_continuous(breaks=seq(-1, 1, 1)) +
  scale_x_continuous(breaks=seq(-1, 1, 1)) +
  labs(x="control over...", y="ideal importance of...") +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        strip.text.x=element_text(size=10, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.2, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_text(size=10, face="bold"),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="right", legend.key.size=unit(.73, "cm"),
        legend.key.width=unit(0.23, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidInferno_stdVert
  # Note: removed "coord_equal()" and seemed to produce larger graph.

ggsave("vidInferno_stdVert.png", plot = vidInferno_stdVert, 
       width = 6.5, height = 5.5, units = "in", dpi = 600)



######################### ALTERNATIVE HEATMAPS ######################### 
vidInfernoT <- ggplot(dfHeatT, aes(x=control, y=idealT, fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="percentage \nof responses     ", 
                              direction = -1, option="B") +
  coord_equal() + facet_wrap(~statusSourceT, ncol=5) +
  scale_y_continuous(breaks=seq(0, 4, 2)) +
  scale_x_continuous(breaks=seq(0, 4, 2)) +
  labs(x="control over...", y="ideal importance of...") +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=8, hjust=0.5, vjust=1,
                                margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.1, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidInfernoT

ggsave("vidInfernoT.png", plot = vidInfernoT, 
       width = 4.5, height = 4, units = "in")


vidInfernoT_std <- ggplot(dfHeatT, 
                          aes(x=control_std, y=idealT_std, fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="percentage \nof responses     ", 
                              direction = -1, option="B") +
  coord_equal() + facet_wrap(~statusSourceT, ncol=5) +
  scale_y_continuous(breaks=seq(0, 1, 0.5)) +
  scale_x_continuous(breaks=seq(0, 1, 0.5)) +
  labs(x="control over...", y="ideal importance of...") +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=8, hjust=0.5, vjust=1,
                                margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.1, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidInfernoT_std

ggsave("vidInfernoT_std.png", plot = vidInfernoT_std, 
       width = 4.5, height = 4, units = "in")


vidInferno <- ggplot(dfHeat, aes(x=control, y=ideal, fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="percentage \nof responses     ", 
                     direction = -1, option="B") +
  coord_equal() + facet_wrap(~statusSource, ncol=5) +
  scale_x_continuous(breaks=seq(0, 4, 2)) +
  labs(x="control over...", y="ideal importance of...") +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=8, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.25, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidInferno

ggsave("vidInferno.png", plot = vidInferno, 
       width = 5, height = 5, units = "in")



vidInferno_std <- ggplot(dfHeat,
                         aes(x=control_std, y=ideal_std, fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="percentage \nof responses     ", 
                     direction = -1, option="B") +
  facet_wrap(~statusSource, ncol=5) +
  scale_y_continuous(breaks=seq(-1, 1, 1)) +
  scale_x_continuous(breaks=seq(-1, 1, 1)) +
  labs(x="control over...", y="ideal importance of...") +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=8, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.25, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidInferno_std
  # Note: removed "coord_equal()" and seemed to produce larger graph.

ggsave("vidInferno_std.png", plot = vidInferno_std, 
       width = 5, height = 5, units = "in")






heatBW <- ggplot(dfHeatT, aes(x=control, y=idealT, fill=percentage)) +
  geom_tile(color="grey90", size=0.1) +
  scale_fill_gradientn(colours = c("white", "grey100", "black"), 
                       values = c(0, 0.0001, 1)) +
  coord_equal() + facet_wrap(~statusSourceT, ncol=5) +
  scale_y_continuous(breaks=seq(0, 4, 2)) +
  scale_x_continuous(breaks=seq(0, 4, 2)) +
  labs(x="control over...", y="ideal importance of...") +
  theme_tufte(base_family="Roboto") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=8, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.1, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
heatBW

########################################################




# Create a dotplot showing means


### Standardize data for graphing 
### [-1,1] for control ideal

attach(dataWhtUnstdLong)
dataWhtUnstdLong$control_std <- (control - (max(control)/2)) / (max(control)/2)
dataWhtUnstdLong$ideal_std <- ideal / max(ideal)
range(control_std)
range(ideal_std)
detach(dataWhtUnstdLong)


## Calculate summary statistics for "control" and "ideal" variables and graph

### Save standard deviations, standard errors, and 95% CIs for "control" and 
### "ideal" variables into dataframes
library(Rmisc)    # for summarySE()

controlSUM <- summarySE(dataWhtUnstdLong, 
                        measurevar = "control_std", 
                        groupvars = c("statusSource"), na.rm=TRUE)
idealSUM <- summarySE(dataWhtUnstdLong, 
                      measurevar = "ideal_std", 
                      groupvars = c("statusSource"), na.rm=TRUE)

### Rename variables as needed.
names(controlSUM)[3] = c("mean")
names(idealSUM)[3] = c("mean")

### Add factor variables to differentiate between "control" and "ideal" when we
### combine the two dataframes into one long dataframe

controlSUM$quality <- factor(rep("control over", length(controlSUM$N)))
idealSUM$quality <- factor(rep("ideal importance of", length(idealSUM$N)))

### Reorder the "quality" variable by the mean values of "control", descending.
### This will effect the display of the final graph.
library(forcats)    # for fct_reorder()

controlSUM$statusSource <- 
  fct_reorder(controlSUM$statusSource, controlSUM$mean)
idealSUM$statusSource <- 
  fct_reorder(idealSUM$statusSource, controlSUM$mean)
  # Note: add .desc = TRUE to fct_reorder() if you want to reverse the display


### Combine the control and ideal dataframes into one long dataframe for 
### graphing.

controlVidealSUM <- rbind(controlSUM, idealSUM)


levels(controlVidealSUM$statusSource)
controlVidealSUM$statusSource <- revalue(controlVidealSUM$statusSource,
                                         c("stablefam" = "family stability",
                                           "parenteduc" = "parents' educ.", 
                                           "school" = "school prestige",
                                           "econstate" = "state of econ.",
                                           "wealth" = "family wealth",
                                           "hardwork" = "hard work",
                                           "iq" = "intelligence"))


### Helvetica displays nicely.
library(extrafont)
extrafont::loadfonts(device="win")
#font_import(pattern = 'Roboto')
loadfonts()
fonts()



conVideal_dot <- ggplot(controlVidealSUM, 
                        aes(x = mean, y = statusSource,
                            group = quality, color = quality)) +
  geom_errorbarh(aes(xmax = mean + ci, xmin = mean - ci), 
                 height = 0, size = 0.5) +
  geom_point(aes(x = mean), shape = 20, size = 4) + 
  geom_vline(xintercept = 0, linetype="dashed", color = "grey50", size = 0.5) +
  scale_color_manual(values=c("grey20", "grey60")) +
  scale_x_continuous(limits = c(-1, 1)) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        legend.title=element_blank(),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="bottom")
conVideal_dot

ggsave("conVideal_dot.png", plot = conVideal_dot, 
       width = 6.5, height = 5, units = "in", dpi = 600)



conVideal_dotGuide <- ggplot(controlVidealSUM, 
                             aes(x = mean, y = statusSource,
                                 group = quality, color = quality)) +
  geom_errorbarh(aes(xmax = mean + ci, xmin = mean - ci), 
                 height = 0, size = 0.5) +
  geom_point(aes(x = mean), shape = 20, size = 4) + 
  geom_vline(xintercept = 0, linetype="dashed", color = "grey50", size = 0.5) +
  scale_color_manual(values=c("grey20", "grey60")) +
  scale_x_continuous(limits = c(-1, 1)) +
  theme_tufte(base_family="Garamond") +
  theme(panel.grid.major.y = element_line(color = "grey99", linetype = "dotted"),
        panel.grid.minor.y = element_line(color = "grey99", linetype = "dotted"),
        axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        legend.title=element_blank(),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="bottom")
conVideal_dotGuide

ggsave("conVideal_dotGuide.png", plot = conVideal_dotGuide, 
       width = 6.5, height = 5, units = "in", dpi = 600)





### Dot graph with labels
xLabels = c("-1.0\nno control\nvery un-important", "-0.5",
            "0.0\nsome control\nneither un-/important", "0.5",
            "1.0\ntotal control\nvery important")

conVideal_dotGuide_labels <- ggplot(controlVidealSUM, 
                             aes(x = mean, y = statusSource,
                                 group = quality, color = quality)) +
  geom_errorbarh(aes(xmax = mean + ci, xmin = mean - ci), 
                 height = 0, size = 0.5) +
  geom_point(aes(x = mean), shape = 20, size = 4) + 
  geom_vline(xintercept = 0, linetype="dashed", color = "grey50", size = 0.5) +
  scale_color_manual(values=c("grey20", "grey60")) +
  scale_x_continuous(limits = c(-1, 1),
                     labels = xLabels, 
                     minor_breaks = dataWhtUnstdLong$control_std) +
  theme_tufte(base_family="Garamond") +
  theme(panel.grid.major.y = element_line(color = "grey99", linetype="dotted"),
        panel.grid.minor.y = element_line(color = "grey99", linetype="dotted"),
        axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        legend.title=element_blank(),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="bottom")
conVideal_dotGuide_labels

ggsave("conVideal_dotGuide_labels.png", plot = conVideal_dotGuide_labels, 
       width = 6.5, height = 5, units = "in", dpi = 600)


### Dot graph with space for labels to be inserted
xLabels = c("-1.0\n\n", "-0.5", "0.0\n\n", "0.5", "1.0\n\n")

conVideal_dotGuide_custLabels <- ggplot(controlVidealSUM, 
                             aes(x = mean, y = statusSource,
                                 group = quality, color = quality)) +
  geom_errorbarh(aes(xmax = mean + ci, xmin = mean - ci), 
                 height = 0, size = 0.5) +
  geom_point(aes(x = mean), shape = 20, size = 4) + 
  geom_vline(xintercept = 0, linetype="dashed", color = "grey50", size = 0.5) +
  scale_color_manual(values=c("grey20", "grey60")) +
  scale_x_continuous(limits = c(-1, 1),
                     labels = xLabels, 
                     minor_breaks = dataWhtUnstdLong$control_std) +
  theme_tufte(base_family="Garamond") +
  theme(panel.grid.major.y = element_line(color = "grey99", linetype="dotted"),
        panel.grid.minor.y = element_line(color = "grey99", linetype="dotted"),
        axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        legend.title=element_blank(),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="bottom")
conVideal_dotGuide_custLabels

ggsave("conVideal_dotGuide_custLabels.png", plot = conVideal_dotGuide_custLabels, 
       width = 6.5, height = 5, units = "in", dpi = 600)



######################### ALTERNATE DOTPLOTS ######################### 

## MISC CODE TO BE REINTERSTED ABOVE
annotate(geom = "text", x = 1, y = 1,
             label = "Some text\nSome more text",
             hjust = 1, vjust = 3)
annotation_custom(textGrob("xyz", gp = gpar(col = "red")), 
        xmin=0.5, xmax=1,ymin=-1, ymax=-1) 



conVideal_dotALT <- ggplot(controlVidealSUM, 
                        aes(x = statusSource, y = mean,
                            group = quality, color = quality)) + 
  geom_pointrange(aes(ymin = mean - ci, ymax = mean + ci)) +
  ylim(-1, 1) + coord_flip() +
  geom_hline(yintercept = 0, linetype="dashed", color = "grey75", size=0.5) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        legend.title=element_blank(),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="bottom")
conVideal_dotALT

ggsave("conVideal_dotALT.png", plot = conVideal_dotALT, 
       width = 6.5, height = 5, units = "in")



library(grid)

conVideal_dotLabel <- ggplot(controlVidealSUM, 
                        aes(x = mean, y = statusSource,
                            group = quality, color = quality)) +
  geom_errorbarh(aes(xmax = mean + ci, xmin = mean - ci), 
                 height = 0, size = 0.5) +
  geom_point(aes(x = mean), shape = 20, size = 4) + 
  geom_vline(xintercept = 0, linetype="dashed", color = "grey50", size = 0.5) +
  scale_color_manual(values=c("grey20", "grey60")) +
  scale_x_continuous(limits = c(-1, 1)) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        legend.title=element_blank(),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="bottom") +
  annotate(geom = "text", x = 1, y = 1,
           label = "total control\nvery important",
           hjust = 1, vjust = 2) +
  annotate(geom = "text", x = 0, y = 1,
           label = "some control\nneither un-/important",
           hjust = 0.5, vjust = 2) +
  annotate(geom = "text", x = -1, y = 1,
           label = "no control\nvery un-important",
           hjust = 0, vjust = 2)

g = ggplotGrob(conVideal_dot)
g$layout$clip[g$layout$name=="panel"] <- "off"
grid.draw(g)

conVideal_dotLabel

ggsave("conVideal_dotLabel.png", plot = conVideal_dotLabel, 
       width = 6.5, height = 5, units = "in")
########################################################



# Graph densities

## Use ggplot2 to plot denisty of corr_ideal_agency.

densControlVsIdeal <- ggplot(dataWhtUnstd, aes(x = corr_ideal_agency)) +
  geom_density(color = "grey20", fill = "grey20", alpha = 0.4) +
  geom_vline(xintercept = 0, linetype="dashed", color = "grey75", size=0.5) +
  scale_x_continuous(limits = c(-1, 1)) +
  xlab("correlation b/w control over and ideal importance of factors") +
  ylab("denisty") +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, hjust=0),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        legend.title=element_blank(),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="bottom")
densControlVsIdeal


ggsave("densControlVsIdeal_dens.png", plot = densControlVsIdeal, 
       width = 5, height = 3, units = "in", dpi = 600)



## Graph denisites of control and ideal by statusSource.

### Create new long dataframe with control and ideal variables standardized 
### [-1,1] for graphing densities by statusSource.

densWhtStdWide <- dataWhtUnstdLong
densWhtStdWide$idealT <- NULL
densWhtStdWide$statusSourceT <- NULL
densWhtStdWide$control_std <- NULL
densWhtStdWide$ideal_std <- NULL

attach(densWhtStdWide)
densWhtStdWide$control <- (control - (max(control)/2)) / (max(control)/2)
densWhtStdWide$ideal <- ideal / max(ideal)
detach(densWhtStdWide)


### Convert _agency, _ideal, and _idealT dataframs from wide to long
densWhtStdLong <- gather(densWhtStdWide, quality, value,
                          control:ideal, factor_key=TRUE)


### Revalue statusSource factors for displaying in graphs.
densWhtStdLong$statusSource <- revalue(densWhtStdLong$statusSource, c(
  "race" = paste("race\nr =", 
                 sprintf("%.2f",factCorr$idealAgencyCorr[1]),sep=""),
  "wealth" = paste("fam. wealth\nr =",
                   sprintf("%.2f",factCorr$idealAgencyCorr[2]),sep=""),
  "connections" = paste("connections\nr =",
                        sprintf("%.2f",factCorr$idealAgencyCorr[3]),sep=""),
  "ambition" = paste("ambition\nr =",
                     sprintf("%.2f",factCorr$idealAgencyCorr[4]),sep=""),
  "gender" = paste("gender\nr =",
                   sprintf("%.2f",factCorr$idealAgencyCorr[5]),sep=""),
  "hardwork" = paste("hardwork\nr =",
                     sprintf("%.2f",factCorr$idealAgencyCorr[6]),sep=""),
  "parenteduc" = paste("parents' educ.\nr =",
                       sprintf("%.2f",factCorr$idealAgencyCorr[7]),sep=""),
  "attitude" = paste("attitude\nr =",
                     sprintf("%.2f",factCorr$idealAgencyCorr[8]),sep=""),
  "econstate" = paste("state of econ.\nr =",
                      sprintf("%.2f",factCorr$idealAgencyCorr[9]),sep=""),
  "health" = paste("health\nr =",
                   sprintf("%.2f",factCorr$idealAgencyCorr[10]),sep=""),
  "stablefam" = paste("fam. stability\nr =",
                      sprintf("%.2f",factCorr$idealAgencyCorr[11]),sep=""),
  "creativity" = paste("creativity\nr =",
                       sprintf("%.2f",factCorr$idealAgencyCorr[12]),sep=""),
  "education" = paste("education\nr =",
                      sprintf("%.2f",factCorr$idealAgencyCorr[13]),sep=""),
  "school" = paste("schl. prestige\nr =",
                   sprintf("%.2f",factCorr$idealAgencyCorr[14]),sep=""),
  "iq" = paste("intelligence\nr =",
               sprintf("%.2f",factCorr$idealAgencyCorr[15]),sep="")))


conVidealDens <- ggplot(densWhtStdLong, 
                        aes(x = value, fill = quality, color = quality, 
                            linetype = quality)) +
  geom_density(adjust = 2.5, alpha = 0.4) +
  facet_wrap(~statusSource, ncol=5) +
  geom_vline(xintercept = 0, linetype="dotted", color = "grey50") +
  scale_color_manual(values = c("grey20", "grey20"),
                     name = "quality",
                     breaks = c("control", "ideal"),
                     labels = c("control over", "ideal importance of")) +
  scale_fill_manual(values = c("grey20", "grey70"),
                    name = "quality",
                    breaks = c("control", "ideal"),
                    labels = c("control over", "ideal importance of")) +
  scale_linetype_manual(values = c("solid", "dashed"),
                        name = "quality",
                        breaks = c("control", "ideal"),
                        labels = c("control over", "ideal importance of")) + 
  scale_x_continuous(breaks=seq(-1, 1, 1)) +
  scale_y_continuous(breaks=seq(0, 2, 1)) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=10, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.1, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_blank(), legend.position="bottom",
        legend.key.width=unit(1, "cm"), legend.text=element_text(size=10),
        legend.key.size=unit(0.3, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
conVidealDens


ggsave("conVidealDens.png", plot = conVidealDens, 
       width = 6.5, height = 5, units = "in", dpi = 600)



######################### ALTERNATE DENSITY GRAPHS ######################### 

conVidealDens <- ggplot(densWhtStdLong, 
                        aes(x = value, fill = quality, linetype = quality)) +
  geom_density(adjust = 2.5, alpha = 0.4, size = 0.3) +
  facet_wrap(~statusSource, ncol=5) +
  geom_vline(xintercept = 0, linetype="solid", color = "grey50", size = 0.3) +
  scale_fill_grey() +
  scale_linetype_manual(values = c("solid", "dashed")) + 
  scale_x_continuous(breaks=seq(-1, 1, 1)) +
  scale_y_continuous(breaks=seq(0, 2, 1)) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=10, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.1, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_blank(), legend.position="bottom",
        legend.key.width=unit(1, "cm"), legend.text=element_text(size=10),
        legend.key.size=unit(0.3, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
conVidealDens


ggsave("conVidealDens.png", plot = conVidealDens, 
       width = 6.5, height = 5, units = "in", dpi = 600)


conVidealDens <- ggplot(densWhtStdLong, 
                        aes(x = value, linetype = quality)) +
  geom_density(adjust = 2.5, alpha = 0.4) +
  facet_wrap(~statusSource, ncol=5) +
  geom_vline(xintercept = 0, linetype="dotted", color = "grey50") +
  scale_linetype_manual(values = c("solid", "dashed"),
                        name = "quality",
                        breaks = c("control", "ideal"),
                        labels = c("control over", "ideal importance of")) + 
  scale_x_continuous(breaks=seq(-1, 1, 1)) +
  scale_y_continuous(breaks=seq(0, 2, 1)) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=10, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.1, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_blank(), legend.position="bottom",
        legend.key.width=unit(1, "cm"), legend.text=element_text(size=10),
        legend.key.size=unit(0.3, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
conVidealDens


ggsave("conVidealDens.png", plot = conVidealDens, 
       width = 6.5, height = 5, units = "in", dpi = 600)



conVidealDens <- ggplot(densWhtStdLong, 
                        aes(x = value, fill = quality, color = quality)) +
  geom_density(adjust = 2.5, alpha = 0.2) +
  facet_wrap(~statusSource, ncol=5) +
  geom_vline(xintercept = 0, linetype="dotted", color = "grey75") +
  scale_fill_brewer(palette = "Set1") +
  scale_color_brewer(palette = "Set1") +
  scale_x_continuous(breaks=seq(-1, 1, 1)) +
  scale_y_continuous(breaks=seq(0, 2, 1)) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=10, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.1, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_blank(), legend.position="bottom",
        legend.key.width=unit(1, "cm"), legend.text=element_text(size=10),
        legend.key.size=unit(0.3, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
conVidealDens

ggsave("conVidealDens.png", plot = conVidealDens, 
       width = 6.5, height = 5, units = "in", dpi = 600)



conVidealDens <- ggplot(densWhtStdLong, 
                        aes(x = value, fill = quality, color = quality)) +
  geom_density(adjust = 2.5, alpha = 0.2) +
  facet_wrap(~statusSource, ncol=5) +
  geom_vline(xintercept = 0, linetype="dotted", color = "grey75") +
  scale_fill_discrete(name  ="quality",
                      breaks=c("control", "ideal"),
                      labels=c("control over", "ideal importance of")) +
  scale_colour_discrete(name  ="quality",
                        breaks=c("control", "ideal"),
                        labels=c("control over", "ideal importance of")) +
  scale_x_continuous(breaks=seq(-1, 1, 1)) +
  scale_y_continuous(breaks=seq(0, 2, 1)) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=10, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.1, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_blank(), legend.position="bottom",
        legend.key.width=unit(1, "cm"), legend.text=element_text(size=10),
        legend.key.size=unit(0.3, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
conVidealDens

ggsave("conVidealDens.png", plot = conVidealDens, 
       width = 6.5, height = 5, units = "in", dpi = 600)



## Old density plotting code for review.

d_whtStd <- density(dataWhtStd$corr_ideal_agency, na.rm = TRUE)
    # returns the density data
d_whtUnstd <- density(dataWhtUnstd$corr_ideal_agency, na.rm = TRUE) 
    # returns the density data
plot(d_whtStd)  # plots the results 
plot(d_whtUnstd)

plot(d_whtStd)
lines(d_whtUnstd) # plots new density in same chart as previous

plot(dataWhtUnstd$corr_ideal_agency, dataWhtStd$corr_ideal_agency)
summary(dataWhtUnstd$corr_ideal_agency)



conVidealDens <- ggplot() +
  geom_density(aes(x=ideal, linetype="solid"), data=densWhtStdWide, 
               adjust=bw(2)) +
  geom_density(aes(x=control, linetype="dash"), data=densWhtStdWide, 
               adjust=bw(2)) +
  facet_wrap(~statusSource, ncol=5) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        strip.text.x=element_text(size=8, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.1, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
conVidealDens

# aply below to above
bw<-function(b, x) { b/bw.nrd0(x) }

1.5/bw.nrd0(densWhtStdWide$control)

ggplot() +
  geom_density(aes(x=ideal, linetype="real data"), data=densWhtStdWide, 
               adjust=bw(2, densWhtStdWide$ideal)) +
  geom_density(aes(x=control, linetype="simulation"), data=densWhtStdWide, 
               adjust=bw(2, densWhtStdWide$control)) +
  facet_wrap(~statusSource, ncol=5) +
  theme_tufte(base_family="Garamond")


  scale_linetype_manual(name="data", 
                        values=c("real data"="solid", "simulation"="dashed")) +

ggsave("vidInfernoT.png", plot = vidInfernoT, 
       width = 4.5, height = 4, units = "in")





  scale_fill_viridis(name="percentage \nof responses     ", 
                              direction = -1, option="B") +
  coord_equal() +
    scale_y_continuous(breaks=seq(0, 4, 2)) +
  scale_x_continuous(breaks=seq(0, 4, 2)) +
  labs(x="control over...", y="ideal importance of...") +





?density
d_whtStd <- density(dataWhtStd$corr_ideal_agency, na.rm = TRUE) # returns the density data
d_whtUnstd <- density(dataWhtUnstd$corr_ideal_agency, na.rm = TRUE) # returns the density data
plot(d_whtStd) # plots the results 
plot(d_whtUnstd)

plot(d_whtUnstd)
lines(d_whtStd)


plot(dataWhtUnstd$corr_ideal_agency, dataWhtStd$corr_ideal_agency)
summary(dataWhtUnstd$corr_ideal_agency)




factCorrT <- arrange(factCorr, desc(idealAgencyCorrT))
factCorr <- arrange(factCorr, desc(idealAgencyCorr))

factCorrT$statusSource
factCorr$statusSource

########################################################



# Summary data regarding control-ideal correlations

summary(factCorr$idealAgencyCorr)
summary(factCorr$idealAgencyCorrT)

