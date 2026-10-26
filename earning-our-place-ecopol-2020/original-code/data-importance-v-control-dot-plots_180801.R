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




# Prepare data for a dotplot showing means


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




# Create a dotplot showing means, organized by CONTROL

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



### Dot graph with space for labels to be inserted
xLabels = c("-1.0\n", "-0.5", "0.0\n", "0.5", "1.0\n")

conVideal_dotPlot_byControl <- ggplot(controlVidealSUM, 
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
conVideal_dotPlot_byControl

ggsave("conVideal_dotPlot_byControl.pdf", plot = conVideal_dotPlot_byControl, 
       width = 6.5, height = 5, units = "in", dpi = 600)




# Create a dotplot showing means, organized by IDEAL IMPORTANCE

### Reorder the "quality" variable by the mean values of "control", descending.
### This will effect the display of the final graph.
library(forcats)    # for fct_reorder()

controlSUM$statusSource <- 
  fct_reorder(controlSUM$statusSource, idealSUM$mean)
idealSUM$statusSource <- 
  fct_reorder(idealSUM$statusSource, idealSUM$mean)
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


### Dot graph with space for labels to be inserted
xLabels = c("-1.0\n", "-0.5", "0.0\n", "0.5", "1.0\n")

conVideal_dotPlot_byImport <- ggplot(controlVidealSUM, 
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
conVideal_dotPlot_byImport

ggsave("conVideal_dotPlot_byImport.pdf", plot = conVideal_dotPlot_byImport, 
       width = 6.5, height = 5, units = "in", dpi = 600)









######################## OLD GRAPHS ########################

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

ggsave("conVideal_dot_TEST.png", plot = conVideal_dot, 
       width = 6.5, height = 4, units = "in", dpi = 600)



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

ggsave("conVideal_dotGuide_TEST.png", plot = conVideal_dotGuide, 
       width = 6.5, height = 4, units = "in", dpi = 600)





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