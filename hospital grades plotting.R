#load packages
library(plyr)
require(dplyr)
require(ggplot2)
require(scales)
library(gridExtra)
library(grid)
library(extrafont)
library(Cairo)

#load data
load("E:\\MY PAPER\\二三级医院\\@21_23.Rdata")

#delete the tertiary grade B samples
I21_23 <- I21_23[!(I21_23$grade == "二级乙等"),]
I21_23$grade <- factor(I21_23$grade)

# rename hospital level
I21_23$grade <- revalue(I21_23$grade, c("二级甲等" = "Secondary_A", "三级乙等" = "Tertiary_B", "三级甲等" = "Tertiary_A"))

# aggregate data on hospital grade & CCI_2011
CCI_stackplot <- aggregate(I21_23$GID, by = list(grade = I21_23$grade, CCI_2011 = I21_23$CCI_2011), length)

# stacked bar plot for CCI_2011
Stacked_CCI <- ggplot(CCI_stackplot, aes(x = grade, y = x, fill = factor(CCI_2011))) + 
  geom_bar(position = "fill", stat = "identity")+ 
  scale_y_continuous(labels = percent_format())+ scale_x_discrete(name = "Hospital grade",limits = c( "Secondary_A", "Tertiary_B", "Tertiary_A")) + scale_y_discrete(name = "Constitutes of Charlson comorbidity index") + ggtitle("Composition of Charlson comorbidity index of AMI patients \nin different levels of hospitals,Shanxi, China") + scale_fill_manual(breaks = c("15", "14", "13", "12", "11", "10","9", "8", "7", "6", "5", "4", "3", "2", "1", "0"), values = c("#458B00","#A2CD5A", "#CAFF70", "#C1FFC1",  "#E9967A", "#EE6363", "#CD5555","#FF4500","#CD2626","#CD2626","#CD2626","#CD2626","#CD2626", "#CD2626", "#CD2626"), name = "Charlson \nComorbidity index") +  coord_flip() + theme(text=element_text(family = "Times New Roman"))

# stacked bar plot for Elixhauser Index
EI_stackplot <- aggregate(I21_23$GID, by = list(grade = I21_23$grade, Elixhauser_Index = I21_23$Elix_Index), length)

Stacked_EI <- ggplot(EI_stackplot, aes(x = grade, y = x, fill = factor(Elixhauser_Index))) + 
  geom_bar(position = "fill", stat = "identity")+ 
  scale_y_continuous(labels = percent_format())+ scale_x_discrete(name = "Hospital grade",limits = c( "Secondary_A", "Tertiary_B", "Tertiary_A")) + scale_y_discrete("Constitutes of Elixhauser index") + ggtitle("Composition of Elixhauser index of AMI patients \nin different levels of hospitals,Shanxi, China") + coord_flip() + scale_fill_manual(values = c("#458B00","#458B00","#458B00","#458B00","#A2CD5A","#A2CD5A","#A2CD5A","#A2CD5A", "#CAFF70","#CAFF70","#CAFF70","#CAFF70", "#C1FFC1","#C1FFC1","#C1FFC1",  "#E9967A", "#E9967A", "#E9967A", "#EE6363","#EE6363", "#EE6363", "#EE6363", "#CD5555","#CD5555","#CD5555","#CD5555","#FF4500","#FF4500","#FF4500","#FF4500","#CD2626","#CD2626","#CD2626","#CD2626","#CD2626","#CD2626","#CD2626", "#CD2626", "#CD2626"), name = "Elixhauser \nIndex") + theme(text=element_text(family = "Times New Roman"))

# add the plots to the same page
tiff("Figure 1. Compositions of Charlson Comorbidity Index and Elixhauser Index of AMI patients across different levels of hospital, Shanxi China.tiff", units="px", width=4039, height=1743, res = 300, pointsize = 8)

grid.arrange(Stacked_CCI, Stacked_EI, ncol = 2, nrow = 1, top = textGrob("Figure 1. Compositions of Charlson Comorbidity Index and Elixhauser Index of AMI patients across different levels of hospital, Shanxi China", gp=gpar(fontsize=15,font=8)))

dev.off()

#--------------------------------------------------------------
library(dplyr)
load("E:\\MY PAPER\\二三级医院\\@@non_IM.Rdata")


Riskadj <- non_IM %>%
  group_by(GID, grade) %>%
  summarise(RSdeath_CCI = sum(pdeath_CCI), RSdeath_EI = sum(pdeath_EI), RSNI_CCI = sum(pNI_CCI), RSNI_EI = sum(pNI_EI), actual_death = sum(death), actual_NI = sum(nosocomial_infection), volume = length(pdeath_CCI))

Riskadj$RSMR_CCI <- Riskadj$RSdeath_CCI / Riskadj$actual_death
Riskadj$RSMR_EI <- Riskadj$RSdeath_EI / Riskadj$actual_death
Riskadj$RSNR_CCI <- Riskadj$RSNI_CCI / Riskadj$actual_NI
Riskadj$RSNR_EI <- Riskadj$RSNI_EI / Riskadj$actual_NI

Riskadj$newadjdeath_CCI <- Riskadj$RSMR_CCI
Riskadj$newadjdeath_CCI[is.infinite(Riskadj$RSMR_CCI)] <- 0 
Riskadj$crude_mortality <- Riskadj$actual_death/Riskadj$volume

NOinf <- Riskadj[Riskadj$RSMR_EI < 100, ]
Crude <- Riskadj[Riskadj$crude_mortality > 0, ]

# visualization

box_crude <- ggplot(Crude, aes(x= grade, y = crude_mortality, color = grade))+ geom_boxplot() + scale_x_discrete(name = "Hospital grade", limits = c("Secondary_A", "Tertiary_B", "Tertiary_A")) + ylab("Crude Mortality Rates") + ggtitle("Crude Mortality Rates across \ndifferent levels of hospitals") + theme(text=element_text(family = "Times New Roman"))

box_CCI <- ggplot(NOinf, aes(x= grade, y = RSMR_CCI, color = grade))+ geom_boxplot() + scale_x_discrete(name = "Hospital grade", limits = c("Secondary_A", "Tertiary_B", "Tertiary_A")) + ylab("Risk Standardized Mortality Rate (Charlson Comorbidity Index)") + ggtitle("Risk Standardized Mortality Rates across different levels \nof hospitals (Charlson Comorbidity Index standardized)") + theme(text=element_text(family = "Times New Roman"))

box_EI <- ggplot(NOinf, aes(x= grade, y = RSMR_EI, color = grade))+ geom_boxplot() + scale_x_discrete(name = "Hospital grade", limits = c("Secondary_A", "Tertiary_B", "Tertiary_A")) + ylab("Risk Standardized Mortality Rates (Elixhauser Index)") + ggtitle("Risk Standardized Mortality Rate across different levels \nof hospitals (Elixhauser Index standardized)") + theme(text=element_text(family = "Times New Roman"))


tiff("Figure 2. Boxplots of Risk Standardized Mortality Rate of AMI patients across different levels of hospitals, Shanxi China.tiff", units="px", width=4039, height=1743, res = 300, pointsize = 8)

grid.arrange(box_crude, box_CCI, box_EI, ncol = 3, nrow = 1, top = textGrob("Figure 2. Boxplots of Risk Standardized Mortality Rate of AMI patients across different levels of hospitals, Shanxi China", gp=gpar(fontsize=15,font=8)))

dev.off()





















