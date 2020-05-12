##Llamar a los paquetes
library(metafor)
library(dplyr)
library(tidyverse)
library(gt)
library(installr)
library(tidyverse)
library(grid)
library(grImport)
library(readxl)
library(lme4)
library(forestplot)
library(lattice)
library(rmarkdown)
library(tinytex)

a <- c("metafor", "dplyr", "tidyverse", "gt", "tidyverse", "grid", "grImport",
       "readxl", "lme4", "forestplot", "lattice", "rmarkdown", "installr")
install.packages(a)


#Asignar directorio o lugar de trabajo
getwd()
setwd("C:/Users/Oscar Ponce/Documents/Research/Paola/Thymectomy/7 Analysis/Final Analysis")
list.files()

#Llamando al archivo
pao <- read_excel("C:/Users/Oscar Ponce/Documents/Research/Paola/Thymectomy/7 Analysis/Final Analysis/thymectomy_final.xlsx",
                  sheet = "Outcomes") 
pao <- data.frame(pao)

colnames(pao)
names(pao)[1] <- "refid"
names(pao)[2] <- "int"
names(pao)[3] <- "comp"
names(pao)[4] <- "group"
names(pao)[5] <- "outcome"
names(pao)[6] <- "followup"
names(pao)[7] <- "totaln"
names(pao)[8:11] <- c("n1","n2","events1","events2")
names(pao)[12:14] <- c("eff", "cill", "ciul")
names(pao)[15] <- "pvalue"
names(pao)[16] <- "app"

table(pao[2])
str(pao[2])
pao$int[pao$int %in% c("extended transsternal\r\nthymectomies", "Extended Transternal thymectomy")] <- "ETsT"
pao$int[pao$int == "Infrasternal mediastinoscopic thymectomy (IMT)"] <- "IMT"
pao$int[pao$int == "transcervical-subxiphoidvideothoracoscopic\r\n‘maximal’ thymectomy"] <- "TcSxVT"
pao$int[pao$int == "Transcervical thymectomy"] <- "BTcT"
pao$int[pao$int == "VATS unilateral alone"] <- 'VATS unilateral'
pao$int[pao$int == " VATET (bilateral)"] <- 'VATET bilateral'
pao$int[pao$int == " VATET (unilateral)"] <- 'VATET unilateral'

pao$comp[pao$comp %in% c("Extended median sternotomy", "Extended Transternal thymectomy")] <- "ETsT"
pao$comp[pao$comp %in% c("\r\ntranscervical-subxiphoidvideothoracoscopic\r\n‘maximal’ thymectomy", 
                         "transcervical-subxiphoidvideothoracoscopic\r\n‘maximal’ thymectomy",
                         "transcervical-subxiphoidvideothoracoscopic\r\n‘maximal’ thymectomy\r\n")] <- "TcSxVT"
pao$comp[pao$comp == "basic transsternal\r\nthymectomies"] <- "STsT"
pao$comp[pao$comp == "VATS unilateral alone"] <- 'VATS unilateral'
pao$comp[pao$comp == " VATET (bilateral)"] <- "VATET bilateral"
pao$comp[pao$comp == "Anterolateral thoracotomy"] <- 'STsT'

#TcSxVMT - TcSxVT
#TcT - BTcT
#BTsT - STsT
#ALT - STsT

pao[63,] <- pao[63,c(1, 3, 2, 4:7, 9, 8, 11, 10,12:17)]
pao[64,] <- pao[64,c(1, 3, 2, 4:7, 9, 8, 11, 10,12:17)]

pao$comparison <- paste(pao$int, " vs. ", pao$comp)


round2 = function(x, n=0) {scale<-10^n; sign(x)*trunc(abs(x)*scale+0.5)/scale}
pao$events1 <- round2(pao$events1, 0)
pao$events2 <- round2(pao$events2, 0)

print(pao[pao$int =="BTcT" |  pao$comp=="STsT" , 1])



########################ETsT vs. STsT#################################
table(pao$comparison)

print(pao[pao$comparison=="ETsT  vs.  STsT",c(1,4,6,8:11,12:14,18)])


ma1 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
           data=pao, subset=(followup==3 & comparison=="ETsT  vs.  STsT"), method="REML")
ma1
expma1 <- predict(ma1, transf = exp, digits=2)

ma2 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
           data=pao, subset=(followup==4 & comparison=="ETsT  vs.  STsT"), method="REML")
ma2
expma2<- predict(ma2, transf = exp, digits=2)

ma3 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
           data=pao, subset=(followup==5 & comparison=="ETsT  vs.  STsT"), method="REML")
ma3
expma3 <- predict(ma3, transf = exp, digits=2)



########################TcSxVT vs. STsT#################################
table(pao$comparison)

print(pao[pao$comparison=="TcSxVT  vs.  STsT",c(1,4,6,8:11,12:14,18)])

ma4 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
           data=pao, subset=(followup==3 & comparison=="TcSxVT  vs.  STsT"), method="REML")
expma4 <- predict(ma4, transf = exp, digits=2)

ma5 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
           data=pao, subset=(followup==4 & comparison=="TcSxVT  vs.  STsT"), method="REML")
expma5 <- predict(ma5, transf = exp, digits=2)

ma6 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
           data=pao, subset=(followup==5 & comparison=="TcSxVT  vs.  STsT"), method="REML")
expma6 <-predict(ma6, transf = exp, digits=2)


########################ETsT vs. TcSxVT#################################
table(pao$comparison)

print(pao[pao$comparison=="ETsT  vs.  TcSxVT",c(1,4,6,8:11,12:14,18)])

ma7 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
           data=pao, subset=(followup==3 & comparison=="ETsT  vs.  TcSxVT"), method="REML")
expma7 <- predict(ma7, transf = exp, digits=2)

ma8 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
           data=pao, subset=(followup==4 & comparison=="ETsT  vs.  TcSxVT"), method="REML")
expma8 <- predict(ma8, transf = exp, digits=2)

ma9 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
           data=pao, subset=(followup==5 & comparison=="ETsT  vs.  TcSxVT"), method="REML")
expma9 <- predict(ma9, transf = exp, digits=2)

expma9

########################BTcT vs. ETsT#################################
table(pao$comparison)

print(pao[pao$comparison=="ETsT  vs.  BTcT",c(1,4,6,8:11,12:14,18)])

ma10 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==10 & comparison=="ETsT  vs.  BTcT"), method="REML")
expma10 <- predict(ma10, transf = exp, digits=2)




########################IMT vs. ETsT#################################
table(pao$comparison)

print(pao[pao$comparison=="IMT  vs.  ETsT",c(1,4,6,8:11,12:14,18)])

ma11 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, 
            subset=(followup==5 & comparison=="IMT  vs.  ETsT"), method="REML")
expma11 <- predict(ma11, transf = exp, digits=2)


########################VATET bilateral vs. ETsT#################################
table(pao$comparison)

print(pao[pao$comparison=="VATET (bilateral) vs. ETsT",c(1,4,6,8:11,12:14,18)])

ma12 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, 
            subset=(followup==3 & comparison=="VATET (bilateral)  vs.  ETsT"),
            method="REML")

expma12 <- predict(ma12, transf = exp, digits=2)

ma13 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==4 & comparison=="VATET (bilateral)  vs.  ETsT"), method="REML")
expma13 <- predict(ma13, transf = exp, digits=2)

ma14 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==5 & comparison=="VATET (bilateral)  vs.  ETsT"), method="REML")
expma14 <- predict(ma14, transf = exp, digits=2)


########################VATET unilateral vs. ETsT#################################
table(pao$comparison)

print(pao[pao$comparison=="VATET unilateral  vs.  ETsT",c(1,4,6,8:11,12:14,18)])

pao$group[pao$group=="high\r\ndegree of myasthenia gravis (MG) severity (classes I and IIa)"] <- "high in severity"
pao$group[pao$group=="mild\r\ndegree of myasthenia gravis (MG) severity (classes I and IIa)"] <- "mild in severity"


ma15 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==3 & comparison=="VATET unilateral  vs.  ETsT" & group=="Overall"), method="REML")
expma15 <- predict(ma15, transf = exp, digits=2)

ma16 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==4 & comparison=="VATET unilateral  vs.  ETsT" & group=="Overall"), method="REML")
expma16 <- predict(ma16, transf = exp, digits=2)

ma17 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==5 & comparison=="VATET unilateral  vs.  ETsT" & group=="Overall"), method="REML")
expma17 <- predict(ma17, transf = exp, digits=2)

ma18 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==6 & comparison=="VATET unilateral  vs.  ETsT" & group=="Overall"), method="REML")
expma18 <- predict(ma18, transf = exp, digits=2)

ma19 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==7 & comparison=="VATET unilateral  vs.  ETsT" & group=="Overall"), method="REML")
expma19 <- predict(ma19, transf = exp, digits=2)

ma20 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==8 & comparison=="VATET unilateral  vs.  ETsT" & group=="Overall"), method="REML")
expma20 <- predict(ma20, transf = exp, digits=2)


ma21 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==3 & comparison=="VATET unilateral  vs.  ETsT" & group=="high in severity"), method="REML")
expma21 <- predict(ma21, transf = exp, digits=2)

ma22 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==4 & comparison=="VATET unilateral  vs.  ETsT" & group=="high in severity"), method="REML")
expma22 <- predict(ma22, transf = exp, digits=2)

ma23 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==5 & comparison=="VATET unilateral  vs.  ETsT" & group=="high in severity"), method="REML")
expma23 <- predict(ma23, transf = exp, digits=2)

ma24 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==6 & comparison=="VATET unilateral  vs.  ETsT" & group=="high in severity"), method="REML")
expma24 <- predict(ma24, transf = exp, digits=2)


ma25 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==3 & comparison=="VATET unilateral  vs.  ETsT" & group=="mild in severity"), method="REML")
expma25 <- predict(ma25, transf = exp, digits=2)

ma26 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==4 & comparison=="VATET unilateral  vs.  ETsT" & group=="mild in severity"), method="REML")
expma26 <- predict(ma26, transf = exp, digits=2)

ma27 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==5 & comparison=="VATET unilateral  vs.  ETsT" & group=="mild in severity"), method="REML")
expma27 <- predict(ma27, transf = exp, digits=2)

ma28 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, data=pao, 
            subset=(followup==6 & comparison=="VATET unilateral  vs.  ETsT" & group=="mild in severity"), method="REML")
expma28 <- predict(ma28, transf = exp, digits=2)





########################VATET unilateral vs.  VATET bilateral#################################
table(pao$comparison)

print(pao[pao$comparison=="VATET unilateral  vs.  VATET bilateral",c(1,4,6,8:11,12:14,18)])

ma33 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==3 & comparison=="VATET unilateral  vs.  VATET bilateral"), method="REML")
expma33 <- predict(ma33, transf = exp, digits=2)

ma34 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==4 & comparison=="VATET unilateral  vs.  VATET bilateral"), method="REML")
expma34 <- predict(ma34, transf = exp, digits=2)

ma35 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==5 & comparison=="VATET unilateral  vs.  VATET bilateral"), method="REML")
expma35 <- predict(ma35, transf = exp, digits=2)

ma36 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==6 & comparison=="VATET unilateral  vs.  VATET bilateral"), method="REML")
expma36 <- predict(ma36, transf = exp, digits=2)


########################VATS unilateral alone vs. Anterolateral thoracotomy#################################
table(pao$comparison)

print(pao[pao$comparison=="VATS unilateral  vs.  STsT",c(1,4,6,8:11,12:14,18)])

ma37 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==3 & comparison=="VATS unilateral  vs.  STsT"), method="REML")
expma37 <- predict(ma37, transf = exp, digits=2)

ma38 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==4 & comparison=="VATS unilateral  vs.  STsT"), method="REML")
expma38 <- predict(ma38, transf = exp, digits=2)

ma39 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==5 & comparison=="VATS unilateral  vs.  STsT"), method="REML")
expma39 <- predict(ma39, transf = exp, digits=2)



########################VATS unilateral alone vs. ETsT#################################
table(pao$comparison)

print(pao[pao$comparison=="VATS unilateral  vs.  ETsT",c(1,4,6,8:11,12:14,18)])

ma40 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==3 & comparison=="VATS unilateral  vs.  ETsT"), method="REML")
expma40 <- predict(ma40, transf = exp, digits=2)

ma41 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==4 & comparison=="VATS unilateral  vs.  ETsT"), method="REML")
expma41 <- predict(ma41, transf = exp, digits=2)

ma42 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==5 & comparison=="VATS unilateral  vs.  ETsT"), method="REML")
expma42 <- predict(ma42, transf = exp, digits=2)

ma43 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==6 & comparison=="VATS unilateral  vs.  ETsT"), method="REML")
expma43 <-predict(ma43, transf = exp, digits=2)

ma44 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==7 & comparison=="VATS unilateral  vs.  ETsT"), method="REML")
expma44 <-predict(ma44, transf = exp, digits=2)

ma45 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==8 & comparison=="VATS unilateral  vs.  ETsT"), method="REML")
expma45 <- predict(ma45, transf = exp, digits=2)

ma46 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==9 & comparison=="VATS unilateral  vs.  ETsT"), method="REML")
expma46 <- predict(ma46, transf = exp, digits=2)


########################VATS left vs. VATS right#################################
table(pao$comparison)

print(pao[pao$comparison=="VATS left  vs.  VATS right",c(1,4,6,8:11,12:14,18)])

ma47 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==3 & comparison=="VATS left  vs.  VATS right"), method="REML")
expma47 <- predict(ma47, transf = exp, digits=2)

ma48 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==4 & comparison=="VATS left  vs.  VATS right"), method="REML")
expma48 <- predict(ma48, transf = exp, digits=2)




########################VATS unilateral with robotic vs. VATS unilateral alone#################################
table(pao$comparison)

print(pao[pao$comparison=="VATS unilateral with robotic  vs.  VATS unilateral",c(1,4,6,8:11,12:14,18)])

ma49 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==3 & comparison=="VATS unilateral with robotic  vs.  VATS unilateral"), method="REML")
expma49 <- predict(ma49, transf = exp, digits=2)

ma50 <- rma(measure="RR", ai=events1, ci=events2, n1i=n1, n2i=n2, 
            data=pao, subset=(followup==5 & comparison=="VATS unilateral with robotic  vs.  VATS unilateral"), method="REML")
expma50 <- predict(ma50, transf = exp, digits=2)


summary <- list(
  "ETsT  vs.  STsT" = c(1:3),
  "TcSxVT  vs.  STsT" = c(4:6),
  "ETsT  vs.  TcSxVT" = c(7:9),
  "ETsT  vs.  BTcT" = 10,
  "IMT  vs.  ETsT" = 11,
  "VATET bilateral  vs.  ETsT" = c(12:14),
  "VATET unilateral  vs.  ETsT - overall" = c(15:20),
  "VATET unilateral  vs.  ETsT - high" = c(21:24),
  "VATET unilateral  vs.  ETsT - mild" = c(25:28),
  "VATET unilateral  vs.  VATET bilateral" = c(33:36),
  "VATS unilateral  vs.  STsT" = c(37:39),
  "VATS unilateral  vs.  ETsT" = c(40:46),
  "VATS left  vs.  VATS right" = c(47:48),
  "VATS unilateral with robotic  vs.  VATS unilateral" = c(49:50))

summary

####BUILDING OVERALL FOREST PLOT####


x <- data.frame(rbind (
  c("comparison", "group", "followup", "k", "ai", "bi", "ci", "di", "i2", "eff", "llci", "ulci"),
  c("ETsT  vs.  STsT", "overall", "3 years", ma1[[15]], sum(ma1[[42]]), sum(ma1[[43]]), sum(ma1[[44]]),sum(ma1[[45]]), ma1[[25]], expma1[[1]], expma1[[3]], expma1[[4]]), 
  c("", "overall", "4 years", ma2[[15]], sum(ma2[[42]]), sum(ma2[[43]]), sum(ma2[[44]]),sum(ma2[[45]]), ma2[[25]], expma2[[1]], expma2[[3]], expma2[[4]]), 
  c("", "overall", "5 years", ma3[[15]], sum(ma3[[42]]), sum(ma3[[43]]), sum(ma3[[44]]),sum(ma3[[45]]), ma3[[25]], expma3[[1]], expma3[[3]], expma3[[4]]), 
  
  c("TcSxVT  vs.  STsT", "overall", "3 years", ma4[[15]], sum(ma4[[42]]), sum(ma4[[43]]), sum(ma4[[44]]),sum(ma4[[45]]), ma4[[25]], expma4[[1]], expma4[[3]], expma4[[4]]), 
  c("", "overall", "4 years", ma5[[15]], sum(ma5[[42]]), sum(ma5[[43]]), sum(ma5[[44]]),sum(ma5[[45]]), ma5[[25]], expma5[[1]], expma5[[3]], expma5[[4]]), 
  c("", "overall", "5 years", ma6[[15]], sum(ma6[[42]]), sum(ma6[[43]]), sum(ma6[[44]]),sum(ma6[[45]]), ma6[[25]], expma6[[1]], expma6[[3]], expma6[[4]]), 
  
  c("ETsT  vs.  TcSxVT", "overall", "3 years", ma7[[15]], sum(ma7[[42]]), sum(ma7[[43]]), sum(ma7[[44]]),sum(ma7[[45]]), ma7[[25]], expma7[[1]], expma7[[3]], expma7[[4]]), 
  c("", "overall", "4 years", ma8[[15]], sum(ma8[[42]]), sum(ma8[[43]]), sum(ma8[[44]]),sum(ma8[[45]]), ma8[[25]], expma8[[1]], expma8[[3]], expma8[[4]]), 
  c("", "overall", "5 years", ma9[[15]], sum(ma9[[42]]), sum(ma9[[43]]), sum(ma9[[44]]),sum(ma9[[45]]), ma9[[25]], expma9[[1]], expma9[[3]], expma9[[4]]),
  
  c("ETsT  vs.  BTcT", "overall", "10 years", ma10[[15]], sum(ma10[[42]]), sum(ma10[[43]]), sum(ma10[[44]]),sum(ma10[[45]]), ma10[[25]], expma10[[1]], expma10[[3]], expma10[[4]]), 
  
  c("IMT  vs.  ETsT", "overall", "5 years", ma11[[15]], sum(ma11[[42]]), sum(ma11[[43]]), sum(ma11[[44]]),sum(ma11[[45]]), ma11[[25]], expma11[[1]], expma11[[3]], expma11[[4]]),
  
  c("VATET bi  vs.  ETsT", "overall", "3 years", ma12[[15]], sum(ma12[[42]]), sum(ma12[[43]]), sum(ma12[[44]]),sum(ma12[[45]]), ma12[[25]], expma12[[1]], expma12[[3]], expma12[[4]]),
  c("", "overall", "4 years", ma13[[15]], sum(ma13[[42]]), sum(ma13[[43]]), sum(ma13[[44]]),sum(ma13[[45]]), ma13[[25]], expma13[[1]], expma13[[3]], expma13[[4]]),
  c("", "overall", "5 years", ma14[[15]], sum(ma14[[42]]), sum(ma14[[43]]), sum(ma14[[44]]),sum(ma14[[45]]), ma14[[25]], expma14[[1]], expma14[[3]], expma14[[4]]),
  
  c("VATET uni  vs.  ETsT", "overall", "3 years", ma15[[15]], sum(ma15[[42]]), sum(ma15[[43]]), sum(ma15[[44]]),sum(ma15[[45]]), ma15[[25]], expma15[[1]], expma15[[3]], expma15[[4]]),
  c("", "overall", "4 years", ma16[[15]], sum(ma16[[42]]), sum(ma16[[43]]), sum(ma16[[44]]),sum(ma16[[45]]), ma16[[25]], expma16[[1]], expma16[[3]], expma16[[4]]),
  c("", "overall", "5 years", ma17[[15]], sum(ma17[[42]]), sum(ma17[[43]]), sum(ma17[[44]]),sum(ma17[[45]]), ma17[[25]], expma17[[1]], expma17[[3]], expma17[[4]]),
  c("", "overall", "6 years", ma18[[15]], sum(ma18[[42]]), sum(ma18[[43]]), sum(ma18[[44]]),sum(ma18[[45]]), ma18[[25]], expma18[[1]], expma18[[3]], expma18[[4]]),
  c("", "overall", "7 years", ma19[[15]], sum(ma19[[42]]), sum(ma19[[43]]), sum(ma19[[44]]),sum(ma19[[45]]), ma19[[25]], expma19[[1]], expma19[[3]], expma19[[4]]),
  c("", "overall", "8 years", ma20[[15]], sum(ma20[[42]]), sum(ma20[[43]]), sum(ma20[[44]]),sum(ma20[[45]]), ma20[[25]], expma20[[1]], expma20[[3]], expma20[[4]]),
  
  c("VATET uni  vs.  VATET bi", "overall", "3 years", ma33[[15]], sum(ma33[[42]]), sum(ma33[[43]]), sum(ma33[[44]]),sum(ma33[[45]]), ma33[[25]], expma33[[1]], expma33[[3]], expma33[[4]]),
  c("", "overall", "4 years", ma34[[15]], sum(ma34[[42]]), sum(ma34[[43]]), sum(ma34[[44]]),sum(ma34[[45]]), ma34[[25]], expma34[[1]], expma34[[3]], expma34[[4]]),
  c("", "overall", "5 years", ma35[[15]], sum(ma35[[42]]), sum(ma35[[43]]), sum(ma35[[44]]),sum(ma35[[45]]), ma35[[25]], expma35[[1]], expma35[[3]], expma35[[4]]),
  c("", "overall", "6 years", ma36[[15]], sum(ma36[[42]]), sum(ma36[[43]]), sum(ma36[[44]]),sum(ma36[[45]]), ma36[[25]], expma36[[1]], expma36[[3]], expma36[[4]]),
  
  c("VATS uni  vs.  STsT", "overall", "3 years", ma37[[15]], sum(ma37[[42]]), sum(ma37[[43]]), sum(ma37[[44]]),sum(ma37[[45]]), ma37[[25]], expma37[[1]], expma37[[3]], expma37[[4]]),
  c("", "overall", "4 years", ma38[[15]], sum(ma38[[42]]), sum(ma38[[43]]), sum(ma38[[44]]),sum(ma38[[45]]), ma38[[25]], expma38[[1]], expma38[[3]], expma38[[4]]),
  c("", "overall", "5 years", ma39[[15]], sum(ma39[[42]]), sum(ma39[[43]]), sum(ma39[[44]]),sum(ma39[[45]]), ma39[[25]], expma39[[1]], expma39[[3]], expma39[[4]]),
  
  c("VATS uni  vs.  ETsT", "overall", "3 years", ma40[[15]], sum(ma40[[42]]), sum(ma40[[43]]), sum(ma40[[44]]),sum(ma40[[45]]), ma40[[25]], expma40[[1]], expma40[[3]], expma40[[4]]),
  c("", "overall", "4 years", ma41[[15]], sum(ma41[[42]]), sum(ma41[[43]]), sum(ma41[[44]]),sum(ma41[[45]]), ma41[[25]], expma41[[1]], expma41[[3]], expma41[[4]]),
  c("", "overall", "5 years", ma42[[15]], sum(ma42[[42]]), sum(ma42[[43]]), sum(ma42[[44]]),sum(ma42[[45]]), ma42[[25]], expma42[[1]], expma42[[3]], expma42[[4]]),
  c("", "overall", "6 years", ma43[[15]], sum(ma43[[42]]), sum(ma43[[43]]), sum(ma43[[44]]),sum(ma43[[45]]), ma43[[25]], expma43[[1]], expma43[[3]], expma43[[4]]),
  c("", "overall", "7 years", ma44[[15]], sum(ma44[[42]]), sum(ma44[[43]]), sum(ma44[[44]]),sum(ma44[[45]]), ma44[[25]], expma44[[1]], expma44[[3]], expma44[[4]]),
  c("", "overall", "8 years", ma45[[15]], sum(ma45[[42]]), sum(ma45[[43]]), sum(ma45[[44]]),sum(ma45[[45]]), ma45[[25]], expma45[[1]], expma45[[3]], expma45[[4]]),
  c("", "overall", "9 years", ma46[[15]], sum(ma46[[42]]), sum(ma46[[43]]), sum(ma46[[44]]),sum(ma46[[45]]), ma46[[25]], expma46[[1]], expma46[[3]], expma46[[4]]),
  
  c("VATS left  vs.  VATS right", "overall", "3 years", ma47[[15]], sum(ma47[[42]]), sum(ma47[[43]]), sum(ma47[[44]]),sum(ma47[[45]]), ma47[[25]], expma47[[1]], expma47[[3]], expma47[[4]]),
  c("", "overall", "4 years", ma48[[15]], sum(ma48[[42]]), sum(ma48[[43]]), sum(ma48[[44]]),sum(ma48[[45]]), ma48[[25]], expma48[[1]], expma48[[3]], expma48[[4]]),
  
  c("VATS uni robotic  vs.  VATS uni", "overall", "3 years", ma49[[15]], sum(ma49[[42]]), sum(ma49[[43]]), sum(ma49[[44]]),sum(ma49[[45]]), ma49[[25]], expma49[[1]], expma49[[3]], expma49[[4]]),
  c("", "overall", "4 years", ma50[[15]], sum(ma50[[42]]), sum(ma50[[43]]), sum(ma50[[44]]),sum(ma50[[45]]), ma50[[25]], expma50[[1]], expma50[[3]], expma50[[4]])),
  stringsAsFactors = FALSE
)

colnames(x) <- x[1,]
x <- x[-1, ] 
x[,4:12]<- sapply((x[,4:12]), as.numeric)
x$n <- rowSums(x[, c(5,7)])
x$N <- rowSums(x[, c(5:8)])
x <- transform(x, prop=paste(n, N, sep="/"))
x$ci1 <- paste("[",formatC(x$llci, format='f', digits =2),", ",formatC(x$ulci, format='f', digits=2),"]")
round2 = function(x, n=0) {scale<-10^n; sign(x)*trunc(abs(x)*scale+0.5)/scale}
x$eff2 <- formatC( round2(x$eff, n=2), format='f', digits=2)
x$i2 <- round2(x$i2, n=0)

x$n1 <- ifelse(is.na(x$ai), NA, paste(x$ai, "/", rowSums(x[, c(5,6)])))
x$n2 <- ifelse(is.na(x$ci), NA, paste(x$ci, "/", rowSums(x[, c(7,8)])))

x$ci2 <- paste(x$eff2, " ", x$ci1)
x$prop <- as.character(x$prop)

x$i2 <- ifelse(x$k==1, paste("na"), x$i2)
x$i2 <- ifelse(x$k==1, x$i2, paste(x$i2, "%"))

x <- x %>% add_row(.before = 1)
x <- x %>% add_row(.before = 5)
x <- x %>% add_row(.before = 9)
x <- x %>% add_row(.before = 13)
x <- x %>% add_row(.before = 15)
x <- x %>% add_row(.before = 17)
x <- x %>% add_row(.before = 21)
x <- x %>% add_row(.before = 28)
x <- x %>% add_row(.before = 33)
x <- x %>% add_row(.before = 37)
x <- x %>% add_row(.before = 45)
x <- x %>% add_row(.before = 48)
x <- x %>% add_row(.before = 51)

x <- x[, -2]

###First graph
x1 <- x[c(1:17),]

x1 <- x1 %>% add_row(followup='ETsT   vs.  STsT', .before = 2)
x1 <- x1 %>% add_row(followup='TcSxVT vs.  STsT', .before = 7)
x1 <- x1 %>% add_row(followup='ETsT   vs.  TcSxVT', .before = 12)
x1 <- x1 %>% add_row(followup='ETsT   vs.  BTcT', .before = 17)
x1 <- x1 %>% add_row(followup='IMT    vs.  ETsT', .before = 20)

sub1 <- c(3:5, 8:10, 13:15, 18, 21)
x1$followup[sub1] <- paste("     ",x1$followup[sub1]) 

tabletext <- cbind( 
  c( "Comparison by", "follow-up", x1$followup),
  c( "N of studies", NA, x1$k),
  c( "Treatment", "n/N", x1$n1),
  c( "Control", "n/N",  x1$n2),
  c( "I^2", NA, x1$i2),
  c( "RR    [95% CI]", NA, x1$ci2))


rrs <- structure(list(
  mean = c(NA,NA, x1$eff),
  lower = c(NA,NA, x1$llci),
  upper = c(NA,NA, x1$ulci)),
  .Names = c("mean", "lower", "upper"),
  row.names = c(NA, -24L),
  class = "data.frame")



trellis.device(device="windows", height = 25, width = 40, color=TRUE)

forestplot(tabletext,
           fn.ci_norm = fpDrawDiamondCI,
           graph.pos = 6,
           
           rrs,new_page = TRUE,
           colgap = unit(5, "mm"),
           hrzl_lines = list("3" = gpar (lwd=2, columns=c(1:7), col="black"), 
                             "25" = gpar (lwd=2, columns=c(1:7), col="black")),
           lineheight=unit(0.7,'cm'),
           line.margin = 2,
           is.summary = c(T, T, F, T, rep(F, 4), T, rep(F, 4), T, rep(F, 4), T, F, F, T, F,F),
           align = c("l",rep("c", 4), "l"),
           ci.vertices = TRUE,
           txt_gp = fpTxtGp(ticks = gpar(cex = 1.2, fontface="bold"),
                            xlab  = gpar(cex = 1.2),
                            label = gpar(cex = 1.2),
                            summary = gpar(cex = 1.2)),
           col=fpColors(box="black", 
                        line="darkgrey", 
                        summary="black", 
                        zero='black', 
                        axes='grey20'),
           xticks = c(0.5,1, 2, 4, 8),
           xlog=TRUE,
           clip=TRUE,
           boxsize = unit(0.3, "cm"), 
           lwd.xaxis = 1, 
           lwd.ci = 3.3,
           lwd.zero = 2)


##Second graph

x2 <- x[c(17:33),]

x2 <- x2 %>% add_row(followup='VATET bi  vs.  ETsT', .before = 2)
x2 <- x2 %>% add_row(followup='VATET uni  vs.  ETsT', .before = 7)
x2 <- x2 %>% add_row(followup='VATET uni  vs.  VATET bi', .before = 15)

sub2 <- c(3:5, 8:13, 16:19)
x2$followup[sub2] <- paste("     ", x2$followup[sub2]) 

tabletext2 <- cbind( 
  c( "Comparison by", "follow-up", x2$followup),
  c( "N of studies", NA, x2$k),
  c( "Treatment", "n/N", x2$n1),
  c( "Control", "n/N",  x2$n2),
  c( "I^2", NA, x2$i2),
  c( "RR    [95% CI]", NA, x2$ci2))


rrs2 <- structure(list(
  mean = c(NA,NA, x2$eff),
  lower = c(NA,NA, x2$llci),
  upper = c(NA,NA, x2$ulci)),
  .Names = c("mean", "lower", "upper"),
  row.names = c(NA, -22L),
  class = "data.frame")



trellis.device(device="windows", height = 25, width = 40, color=TRUE)

forestplot(tabletext2,
           fn.ci_norm = fpDrawDiamondCI,
           graph.pos = 6,
           
           rrs2,new_page = TRUE,
           colgap = unit(5, "mm"),
           hrzl_lines = list("3" = gpar (lwd=2, columns=c(1:7), col="black"), 
                             "23" = gpar (lwd=2, columns=c(1:7), col="black")),
           lineheight=unit(0.7,'cm'),
           line.margin = 2,
           is.summary = c(T, T, F, T, rep(F,4), T, rep(F,7), T, rep(F, 6)),
           align = c("l",rep("c", 4), "l"),
           ci.vertices = TRUE,
           txt_gp = fpTxtGp(ticks = gpar(cex = 1.2, fontface="bold"),
                            xlab  = gpar(cex = 1.2),
                            label = gpar(cex = 1.2),
                            summary = gpar(cex = 1.2)),
           col=fpColors(box="black", 
                        line="darkgrey", 
                        summary="black", 
                        zero='black', 
                        axes='grey20'),
           xticks = c(0.25, 0.5,1, 2, 4),
           xlog=TRUE,
           clip=TRUE,
           boxsize = unit(0.3, "cm"), 
           lwd.xaxis = 1, 
           lwd.ci = 3.3,
           lwd.zero = 2)


##graph 3
x3 <- x[c(33:51),]

View(x3)

x3 <- x3 %>% add_row(followup='VATS uni  vs.  STsT', .before = 2)
x3 <- x3 %>% add_row(followup='VATS uni  vs.  ETsT', .before = 7)
x3 <- x3 %>% add_row(followup='VATS left  vs.  VATS right', .before = 16)
x3 <- x3 %>% add_row(followup='VATS uni robotic  vs.  VATS uni', .before = 20)


sub3 <- c(3:5, 8:14, 17, 18, 21, 22)
x3$followup[sub3] <- paste("     ", x3$followup[sub3]) 

tabletext3 <- cbind( 
  c( "Comparison by", "follow-up", x3$followup),
  c( "N of studies", NA, x3$k),
  c( "Treatment", "n/N", x3$n1),
  c( "Control", "n/N",  x3$n2),
  c( "I^2", NA, x3$i2),
  c( "RR    [95% CI]", NA, x3$ci2))


rrs3 <- structure(list(
  mean = c(NA,NA, x3$eff),
  lower = c(NA,NA, x3$llci),
  upper = c(NA,NA, x3$ulci)),
  .Names = c("mean", "lower", "upper"),
  row.names = c(NA, -25L),
  class = "data.frame")



trellis.device(device="windows", height = 25, width = 40, color=TRUE)

forestplot(tabletext3,
           fn.ci_norm = fpDrawDiamondCI,
           graph.pos = 6,
           
           rrs3,new_page = TRUE,
           colgap = unit(5, "mm"),
           hrzl_lines = list("3" = gpar (lwd=2, columns=c(1:7), col="black"), 
                             "26" = gpar (lwd=2, columns=c(1:7), col="black")),
           lineheight=unit(0.7,'cm'),
           line.margin = 2,
           is.summary = c(T, T, F, T, rep(F,4), T, rep(F,8), T, rep(F,3), T, rep(F,3)),
           align = c("l",rep("c", 4), "l"),
           ci.vertices = TRUE,
           txt_gp = fpTxtGp(ticks = gpar(cex = 1.2, fontface="bold"),
                            xlab  = gpar(cex = 1.2),
                            label = gpar(cex = 1.2),
                            summary = gpar(cex = 1.2)),
           col=fpColors(box="black", 
                        line="darkgrey", 
                        summary="black", 
                        zero='black', 
                        axes='grey20'),
           xticks = c(0.25, 0.5,1, 2, 4),
           xlog=TRUE,
           clip=TRUE,
           boxsize = unit(0.3, "cm"), 
           lwd.xaxis = 1, 
           lwd.ci = 3.3,
           lwd.zero = 2)







########PRUEBA############
```{r, echo=FALSE}
trial <- rbind(tfma40, tfma41[3:10,], tfma42[3:9,],
               tfma43[3:8,], tfma44[3:8,], tfma45[3:7,])

trial <- as_tibble(trial)
trial <- trial %>% add_row(V1="3 years", .after = 2)
trial <- trial %>% add_row(V1="4 years", .after = 11)
trial <- trial %>% add_row(V1="5 years", .after = 20)
trial <- trial %>% add_row(V1="6 years", .after = 28)
trial <- trial %>% add_row(V1="7 years", .after = 35)
trial <- trial %>% add_row(V1="8 years", .after = 42)



rrstrial <- structure(list(
  mean = c(NA, NA, NA,  exp(prema40$yi), NA, expma45$pred, NA,
           NA,  exp(prema41$yi), NA, expma45$pred, NA,
           NA,  exp(prema42$yi), NA, expma45$pred, NA,
           NA,  exp(prema43$yi), NA, expma45$pred, NA,
           NA,  exp(prema44$yi), NA, expma45$pred, NA,
           NA,  exp(prema45$yi), NA, expma45$pred, NA),
  lower = c(NA, NA, NA,  exp(prema40$ci.lb), NA, expma45$ci.lb, NA,
            NA,  exp(prema41$ci.lb), NA, expma45$ci.lb, NA,
            NA,  exp(prema42$ci.lb), NA, expma45$ci.lb, NA,
            NA,  exp(prema43$ci.lb), NA, expma45$ci.lb, NA,
            NA,  exp(prema44$ci.lb), NA, expma45$ci.lb, NA,
            NA,  exp(prema45$ci.lb), NA, expma45$ci.lb, NA),
  upper = c(NA, NA, NA,  exp(prema40$ci.ub), NA, expma45$ci.ub, NA,
            NA,  exp(prema41$ci.ub), NA, expma45$ci.ub, NA,
            NA,  exp(prema42$ci.ub), NA, expma45$ci.ub, NA,
            NA,  exp(prema43$ci.ub), NA, expma45$ci.ub, NA,
            NA,  exp(prema44$ci.ub), NA, expma45$ci.ub, NA,
            NA,  exp(prema45$ci.ub), NA, expma45$ci.ub, NA)),
  .Names = c("mean", "lower", "upper"),
  row.names = c(NA, -48L),
  class = "data.frame")


trellis.device(device="windows", height = 30, width = 40, color=TRUE)
forestplot(trial,
           graph.pos = 4,
           zero=1,
           rrstrial,
           new_page = TRUE,
           colgap = unit(5, "mm"),
           hrzl_lines = list("3" = gpar (lwd=1, columns=c(1:5), col="black") 
           ),
           lineheight=unit(0.6,'cm'),
           line.margin = 2,
           boxsize = c(NA, NA, boxsize, NA, 1, NA),
           is.summary = c(T, T, rep(F, 3), T, F),
           align = c("l","c", "c"),
           ci.vertices = TRUE,
           txt_gp = fpTxtGp(label =gpar (cex=0.8), 
                            ticks = gpar(cex = 0.8, fontface="bold"),
                            summary = gpar(cex = 0.8),
                            xlab = gpar(cex=0.8)),
           xticks = c(0.25, 0.5, 1, 2, 4, 8),
           xlog=TRUE,
           clip = c(0.5, 4),
           lwd.xaxis = 1,
           lwd.ci = 2.2,
           graphwidth = unit(7,"cm"),
           col=fpColors(box="black",line="grey", 
                        axes="grey20", summary="black", zero="black"))

```
