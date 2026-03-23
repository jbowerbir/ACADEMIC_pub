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




### Helvetica displays nicely.
library(extrafont)
extrafont::loadfonts(device="win")
#font_import(pattern = 'Roboto')
loadfonts()
fonts()


# Summary statistics for corr_ideal_agency.
summary(dataWhtUnstd$corr_ideal_agency, na.rm = TRUE)
sd(dataWhtUnstd$corr_ideal_agency, na.rm = TRUE)
IQR(dataWhtUnstd$corr_ideal_agency, na.rm = TRUE)


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


ggsave("densControlVsIdeal_dens_TALL.pdf", plot = densControlVsIdeal, 
       width = 5, height = 3, units = "in", dpi = 600)

ggsave("densControlVsIdeal_dens_SHORT.pdf", plot = densControlVsIdeal, 
       width = 4, height = 2, units = "in", dpi = 600)






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













# Graph densities by IDEAL IMPORTANCE mean value

## Calculate summary statistics for "control" and "ideal" variables and graph

### Save standard deviations, standard errors, and 95% CIs for "control" and 
### "ideal" variables into dataframes
library(Rmisc)    # for summarySE()

controlANDidealSUM <- summarySE(densWhtStdLong, 
                        measurevar = "value", 
                        groupvars = c("statusSource","quality"), na.rm=TRUE)

names(controlANDidealSUM)[4] = c("mean")    # rename variable

idealSUM <- controlANDidealSUM %>%
  group_by(statusSource) %>%
  filter(quality == "ideal") %>%
  arrange(mean)                       # arange factors by mean ascending value

### Reorder levels for "statusSource" variable in ascending order of "ideal
### importance" mean
levels(idealSUM$statusSource)
idealAscOrder <- fct_reorder(idealSUM$statusSource, idealSUM$mean, min)
levels(idealAscOrder)

densWhtStdLong$statusSource <- factor(densWhtStdLong$statusSource,
                                      levels = levels(idealAscOrder))

### Revalue statusSource factors for displaying in graphs.
densWhtStdLong$statusSource <- revalue(densWhtStdLong$statusSource, c(
  "race" = "race",
  "wealth" = "fam. wealth",
  "connections" = "connections",
  "ambition" = "ambition",
  "gender" = "gender",
  "hardwork" = "hardwork",
  "parenteduc" = "parents' educ.",
  "attitude" = "attitude",
  "econstate" = "state of econ.",
  "health" = "health",
  "stablefam" = "fam. stability",
  "creativity" = "creativity",
  "education" = "education",
  "school" = "school",
  "iq" = "intelligence"))



#densWhtStdLong$quality <- fct_rev(densWhtStdLong$quality)
#levels(densWhtStdLong$quality)


    ## Note the use of the '.' function to allow
    ## statusSource and quality to be used without quoting
mu <- ddply(densWhtStdLong, .(statusSource, quality), summarise, grp.mean=mean(value))
head(mu)

p<-ggplot(df, aes(x=weight, color=sex)) +
  geom_density()+
  geom_vline(data=mu, aes(xintercept=grp.mean, color=quality),
             linetype="dashed")


### plot graph
### FIX X-AXIS   xLabels = c("-1.0\n", "-0.5", "0.0\n", "0.5", "1.0\n")

conVidealDens_idealAsc <- ggplot(densWhtStdLong, 
                        aes(x = value, fill = quality, color = quality, 
                            linetype = quality)) +
  geom_density(adjust = 2.5, alpha = 0.4) +
  facet_wrap(~statusSource, ncol=5) +
  geom_vline(xintercept = 0, linetype="dotted", color = "grey50") +
  scale_color_manual(values = c("grey20", "grey20"),
                     name = "quality",
                     breaks = c("ideal", "control"),
                     labels = c("ideal importance of", "control over")) +
  scale_fill_manual(values = c("grey20", "grey70"),
                    name = "quality",
                    breaks = c("ideal", "control"),
                    labels = c("ideal importance of", "control over")) +
  scale_linetype_manual(values = c("solid", "dashed"),
                        name = "quality",
                        breaks = c("ideal", "control"),
                        labels = c("ideal importance of", "control over")) + 
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
conVidealDens_idealAsc

ggsave("conVidealDens_idealAsc.png", plot = conVidealDens_idealAsc, 
       width = 6.5, height = 5, units = "in", dpi = 600)




### plot graph with averages shown
### FIX X-AXIS   xLabels = c("-1.0\n", "-0.5", "0.0\n", "0.5", "1.0\n")

conVidealDens_idealAsc_wAVG <- ggplot(densWhtStdLong, 
                                 aes(x = value, fill = quality, color = quality, 
                                     linetype = quality)) +
  geom_density(adjust = 2.5, alpha = 0.4) +
  geom_vline(data=mu, aes(xintercept = grp.mean, color = quality,
                          linetype = quality)) +
  facet_wrap(~statusSource, ncol=5) +
  geom_vline(xintercept = 0, linetype="dotted", color = "grey50") +
  scale_color_manual(values = c("grey20", "grey20"),
                     name = "quality",
                     breaks = c("ideal", "control"),
                     labels = c("ideal importance of", "control over")) +
  scale_fill_manual(values = c("grey20", "grey70"),
                    name = "quality",
                    breaks = c("ideal", "control"),
                    labels = c("ideal importance of", "control over")) +
  scale_linetype_manual(values = c("solid", "dashed"),
                        name = "quality",
                        breaks = c("ideal", "control"),
                        labels = c("ideal importance of", "control over")) + 
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
conVidealDens_idealAsc_wAVG


ggsave("conVidealDens_idealAsc_wAVG.pdf", plot = conVidealDens_idealAsc_wAVG, 
       width = 6.5, height = 5, units = "in", dpi = 600)








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


ggsave("conVidealDens.pdf", plot = conVidealDens, 
       width = 6.5, height = 5, units = "in", dpi = 600)








##################### OLD GRAPH ##################### 


# Graph densities by CORRELATION value

## NOTE: If plotting this graph, must insert code BEFORE the section
## titled "Graph densities by IDEAL IMPORTANCE mean value"


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






