
## Generate dataframe to replicate distributions from old surveys.

agree <- c(0.665343915, 0.591587517, 0.45)
disagree <- c(0.16468254, 0.408412483, 0.52)
unsure <- 1 - agree - disagree

response <- factor(c(rep("agree", round(agree[1] * 1000)), 
                     rep("disagree", round(disagree[1] * 1000)),
                     rep("unsure", round(unsure[1] * 1000)),
                     rep("agree", round(agree[2] * 1000)), 
                     rep("disagree", round(disagree[2] * 1000)),
                     rep("unsure", round(unsure[2] * 1000)),
                     rep("agree", round(agree[3] * 1000)), 
                     rep("disagree", round(disagree[3] * 1000)),
                     rep("unsure", round(unsure[3] * 1000))),
                   levels = c("disagree", "unsure", "agree"))
question <- factor(c(rep("differences in\nincome are\ntoo large*", 1000), 
                     rep("there are strong\nconflicts between\nthe rich and poor*",
                         1000),
                     rep("the income gap is\na problem that\nneeds fixing**",
                         1000)),
                   levels=c("the income gap is\na problem that\nneeds fixing**",
                            "there are strong\nconflicts between\nthe rich and poor*",
                            "differences in\nincome are\ntoo large*"))

data <- data.frame(response, question)



## Fonts

### Helvetica displays nicely.
library(extrafont)
extrafont::loadfonts(device="win")
#font_import(pattern = 'Roboto')
loadfonts()
fonts()


library(plyr) # ddply() for data reformatting
library(Cairo) # better aliasing of output images
library(ggplot2)


grphPuzzle_bw <- ggplot(data, aes(x = question, fill = response)) + 
  geom_bar(position = "fill") +
  geom_hline(yintercept = 0.5, linetype = "dotted", size = 0.5) +
  coord_flip() +
  guides(fill = guide_legend(reverse = TRUE)) +
  labs(x = "", y = "percentage", fill = "") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        text=element_text(family="Garamond"),
        axis.text.y=element_text(hjust=0.0)) +
  scale_fill_brewer(palette="Greys")
grphPuzzle_bw

ggsave("PubOpPuzzle_bw.png", plot = grphPuzzle_bw, 
       width = 6.5, height = 2, units = "in", dpi = 600)

########## USE THE ABOVE GRAPH








munch <- c("#E69253", "#4378A0", "#E4502E", "#5059A1", "#EDB931")
bw <- c("red", "blue", "green")

grphPuzzle_munch <- ggplot(data, aes(x = question, fill = response)) + 
  geom_bar(position = "fill") +
  geom_hline(yintercept = 0.5, linetype = "dotted", size = 0.75) +
  coord_flip() +
  guides(fill = guide_legend(reverse = TRUE)) +
  labs(x = "", y = "percentage", fill = "") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) +
  scale_fill_manual(values = munch)
grphPuzzle_much


grphPuzzle_RdYlBu <- ggplot(data, aes(x = question, fill = response)) + 
  geom_bar(position = "fill") +
  geom_hline(yintercept = 0.5, linetype = "dotted", size = 0.5) +
  coord_flip() +
  guides(fill = guide_legend(reverse = TRUE)) +
  labs(x = "", y = "percentage", fill = "") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) +
  scale_fill_brewer(palette="RdYlBu")
grphPuzzle_RdYlBu

