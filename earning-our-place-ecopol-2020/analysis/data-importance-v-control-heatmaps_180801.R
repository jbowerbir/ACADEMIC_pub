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

font_import()
loadfonts(device = "win")






### Graph

library(forcats)  # to reverse the levels of factor variables ("ascend" vs "desc")

vidInfernoT_stdVert_desc <- ggplot(dfHeatT, 
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
vidInfernoT_stdVert_desc

ggsave("vidInfernoT_stdVert_desc.pdf", plot = vidInfernoT_stdVert_desc, 
       width = 6.5, height = 4.5, units = "in", dpi = 600)





vidInferno_stdVert_desc <- ggplot(dfHeat,
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
vidInferno_stdVert_desc
  # Note: removed "coord_equal()" and seemed to produce larger graph.

ggsave("vidInferno_stdVert_desc.pdf", plot = vidInferno_stdVert_desc, 
       width = 6.5, height = 5.5, units = "in", dpi = 600)



vidInferno_stdVert_ascend <- ggplot(dfHeat,
                                  aes(x=control_std, y=ideal_std, fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="%", direction = -1, option="B") +
  facet_wrap(~ fct_rev(statusSource), ncol=5) +
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
vidInferno_stdVert_ascend
# Note: removed "coord_equal()" and seemed to produce larger graph.

ggsave("vidInferno_stdVert_ascend.pdf", plot = vidInferno_stdVert_ascend, 
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

