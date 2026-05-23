#install.packages("foreign")
#install.packages("dplyr")
library(foreign)
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




dataWhtUnstd$desert_rich_tot_scl <- dataWhtUnstd$desert_rich_tot /6
dataWhtUnstd$diff_large_scl <- dataWhtUnstd$diff_large /3

table(dataWhtUnstd$desert_rich_tot_scl, dataWhtUnstd$diff_large_scl)


### Gather data for graphing
library(plyr)
dfHeat <- count(dataWhtUnstd, c("desert_rich_tot_scl", "diff_large_scl"))

### Make sure there are entries for every possible combintaion of "control" and
### "ideal importance".
dfHeat <- complete(dfHeat, desert_rich_tot_scl, diff_large_scl)

### Combinations without responses should be treated as zero (0).
dfHeat[is.na(dfHeat)] <- 0

### Calculate percentage responses.
dfHeat$percentage <- dfHeat$freq / length(dataWhtUnstd$id)

### Make sure count and percentage variables add up to appropriate totals.
summarise(dfHeat, stdev = sd(freq), 
          totNum = sum(freq), totPer = sum(percentage))

## Fonts

library(extrafont)
extrafont::loadfonts(device="win")
#font_import(pattern = 'Roboto')
loadfonts()
fonts()



vidInferno_wideInv <- ggplot(dfHeat,aes(x=desert_rich_tot_scl, y=diff_large_scl, 
                                   fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="percentage\nof responses\n", 
                     direction = -1, option="B") +
  labs(x="Do the rich deserve their wealth?",
       y="Are income differences too large?") +
  scale_y_continuous(breaks=seq(-1, 1, 1)) +
  scale_x_continuous(breaks=seq(-1, 1, 0.5)) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=10),
        axis.title=element_text(size=10, face="bold", hjust=0),
        panel.border=element_blank(), 
        plot.title=element_text(hjust=0, size=10),
        strip.text.x=element_text(size=10, hjust=0.5, vjust=1,
                                  margin=margin(t=0, r=0, b=0, l=0, unit="pt")),
        panel.spacing.x=unit(0.2, "cm"), panel.spacing.y=unit(0.2, "cm"), 
        legend.title=element_text(size=10),
        legend.title.align=0, legend.text=element_text(size=10),
        legend.position="right", legend.key.size=unit(.65, "cm"),
        legend.key.width=unit(0.25, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidInferno_wideInv

ggsave("vidInferno_wideInv.png", plot = vidInferno_wideInv, 
       width = 6.5, height = 5, units = "in", dpi = 600)


###################### ALTERNATE GRAPHS ###################### 

vidInferno_tallInv <- ggplot(dfHeat,aes(x=desert_rich_tot_scl, y=diff_large_scl, 
                                   fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="percentage \nof responses     ", 
                     direction = -1, option="B") +
  coord_equal() +
  labs(x="Do the rich deserve their wealth?",
       y="Are income differences too large?") +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, hjust=0.5),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidInferno_tallInv

ggsave("vidInferno_tallInv.png", plot = vidInferno_tallInv, 
       width = 4, height = 4.5, units = "in", dpi = 600)


vidInferno_wideInv <- ggplot(dfHeat,aes(x=desert_rich_tot_scl, y=diff_large_scl, 
                                   fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="percentage \nof responses     ", 
                     direction = -1, option="B") +
  labs(x="Do the rich deserve their wealth?",
       y="Are income differences too large?") +
  scale_y_continuous(breaks=seq(-1, 1, 1)) +
  scale_x_continuous(breaks=seq(-1, 1, 0.5)) +
  theme_tufte(base_family="Garamond") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, face="plain", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidInferno_wideInv

ggsave("vidInferno_wideInv.png", plot = vidInferno_wideInv, 
       width = 4.5, height = 4, units = "in", dpi = 600)


vidMagma_tall <- ggplot(dfHeat,aes(x=desert_rich_tot_scl, y=diff_large_scl, 
                              fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="percentage \nof responses     ", 
                     direction = 1, option="B") +
  coord_equal() +
  labs(x="Do the rich deserve their wealth?",
       y="Are income differences too large?") +
  theme_tufte(base_family="Roboto") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, hjust=0.5),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidMagma_tall

ggsave("vidMagma_tall.png", plot = vidMagma_tall, 
       width = 4, height = 4.5, units = "in")


vidMagma_wide <- ggplot(dfHeat,aes(x=desert_rich_tot_scl, y=diff_large_scl, 
                                   fill=percentage)) +
  geom_tile(color="white", size=0.1) +
  scale_fill_viridis(name="percentage \nof responses     ", 
                     direction = 1, option="B") +
  labs(x="Do the rich deserve their wealth?",
       y="Are income differences too large?") +
  theme_tufte(base_family="Roboto") +
  theme(axis.ticks=element_blank(), axis.text=element_text(size=8),
        axis.title=element_text(size=8, face="bold", hjust=0),
        panel.border=element_blank(), plot.title=element_text(hjust=0),
        legend.title=element_text(size=8),
        legend.title.align=0, legend.text=element_text(size=8),
        legend.position="bottom", legend.key.size=unit(0.15, "cm"),
        legend.key.width=unit(1, "cm"),
        plot.margin=grid::unit(c(0,0,0,0), "mm"))
vidMagma_wide

ggsave("vidMagma_wide.png", plot = vidMagma_wide, 
       width = 4.5, height = 4, units = "in")
########################################



########## RICH DESERT ASSESSMENT v PERCEIVED INCOME DIFFERENCES

##### Percentage of respondents who think:
# (1) income differences are too large and (2) rich deserve their wealth
# (1) income differences are too large and (2) rich DON'T deserve their wealth
# (1) income differences are NOT too large and (2) rich deserve their wealth
# (1) income differences are NOT too large and (2) rich DON'T deserve their wealth
rDes_largeDiff <- sum(newData$desert_rich_tot > 0 & newData$diff_large > 0 , na.rm=TRUE ) / sum(!is.na(newData$justice_str))
rNoDes_largeDiff <- sum(newData$desert_rich_tot < 0 & newData$diff_large > 0 , na.rm=TRUE ) / sum(!is.na(newData$justice_str))
rDes_noLargeDiff <- sum(newData$desert_rich_tot > 0 & newData$diff_large < 0 , na.rm=TRUE ) / sum(!is.na(newData$justice_str))
rNoDes_noLargeDiff <- sum(newData$desert_rich_tot < 0 & newData$diff_large < 0 , na.rm=TRUE ) / sum(!is.na(newData$justice_str))
