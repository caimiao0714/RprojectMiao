颈椎手术 <- read.csv('E:\\雕龙软件公司\\201606雕龙\\@@数据\\颈椎手术.csv',sep=',',stringsAsFactors = FALSE)
胸椎手术 <- read.csv('E:\\雕龙软件公司\\201606雕龙\\@@数据\\胸椎手术.csv',sep=',',stringsAsFactors = FALSE)
腰椎手术 <- read.csv('E:\\雕龙软件公司\\201606雕龙\\@@数据\\腰椎手术.csv',sep=',',stringsAsFactors = FALSE)
save(颈椎手术, file = "E:\\雕龙软件公司\\201606雕龙\\颈椎手术.Rdata")
save(胸椎手术, file = "E:\\雕龙软件公司\\201606雕龙\\胸椎手术.Rdata")
save(腰椎手术, file = "E:\\雕龙软件公司\\201606雕龙\\腰椎手术.Rdata")

N17_N23$p433[1:20]
N17_N23$p434[1:20]

install.packages('RODBC')
help('RODBC')
library(RODBC)

# 20171204 DL data
myconn <- odbcConnect('dl20171204', uid='sa', pwd='123456')
DL20171204_I <- sqlFetch(myconn, 'DL20171204_I')
save(DL20171204_I, file = "DL20171204_I.Rdata")


#SELECT O&P FOR CHANG XU
myconn <- odbcConnect('updated_dl1317', uid='sa', pwd='123456')
UPDATEOP1317 <- sqlFetch(myconn, 'UPDATEOP1317')
save(UPDATEOP1317, file = "UPDATEOP1317.Rdata")

#head and neck cancer
UPDATEC00C14 <- sqlFetch(myconn, 'UPDATEC00C14')
save(UPDATEC00C14, file = "UPDATEC00C14.Rdata")

#cardiac disease I00 - I99
UPDATEI00I99 <- sqlFetch(myconn, 'UPDATEI00I99')
save(UPDATEI00I99, file = "UPDATEI00I99.Rdata")

#pulmonary disease J00 - J99
UPDATEJ00J99 <- sqlFetch(myconn, 'UPDATEJ00J99')
save(UPDATEJ00J99, file = "UPDATEJ00J99.Rdata")

#updated hospital names
Uhospital_names<- sqlFetch(myconn, 'hospital_names')
save(Uhospital_names, file = "Uhospital_names.Rdata")

load("E:\\雕龙软件公司\\2017雕龙\\hospital_names.Rdata")
library(dplyr)
hospital_names <- hospital_names %>% arrange(医院名称)
Uhospital_names <- Uhospital_names %>% arrange(医院编码)
merged_hospitalname <- full_join(Uhospital_names, hospital_names, by = c("医院编码" = "医院名称")) %>% arrange(医院编码)

save(merged_hospitalname, file = "merged_hospitalname.Rdata")
readr::write_csv(merged_hospitalname, "merged_hospitalname.csv")
readr::read_csv("merged_hospitalname.csv")

#J00-J47
myconn <- odbcConnect('wasd', uid='sa', pwd='123456')
J00_J47 <- sqlFetch(myconn, 'homepage_J00_J47')
save(J00_J47, file = "E:\\雕龙软件公司\\201606雕龙\\@@@数据.Rdata\\J00_J47.Rdata")
write.csv(J00_J47,file = 'E:\\雕龙软件公司\\201606雕龙\\@@@数据_csv\\J00_J47.csv')
#K20-K46
myconn <- odbcConnect('wasd', uid='sa', pwd='123456')
K20_K46 <- sqlFetch(myconn, 'homepage_K20_K46')
save(K20_K46, file = "E:\\雕龙软件公司\\201606雕龙\\@@@数据.Rdata\\K20_K46.Rdata")
write.csv(K20_K46,file = 'E:\\雕龙软件公司\\201606雕龙\\@@@数据_csv\\K20_K46.csv')
#N17-N23
myconn <- odbcConnect('wasd', uid='sa', pwd='123456')
N17_N23 <- sqlFetch(myconn, 'homepage_N17_N23')
save(N17_N23, file = "E:\\雕龙软件公司\\201606雕龙\\@@@数据.Rdata\\N17_N23.Rdata")
write.csv(N17_N23,file = 'E:\\雕龙软件公司\\201606雕龙\\@@@数据_csv\\N17_N23.csv')
#医师姓名对应编码
myconn <- odbcConnect('wasd', uid='sa', pwd='123456')
W_BA_YS <- sqlFetch(myconn, 'W_BA_YS')
save(W_BA_YS, file = "E:\\雕龙软件公司\\201606雕龙\\@@@数据.Rdata\\W_BA_YS.Rdata")
write.csv(W_BA_YS,file = 'E:\\雕龙软件公司\\201606雕龙\\@@@数据_csv\\W_BA_YS.csv')
#筛程兆辉用的数据 J10-J18
J10_J18 <- J00_J47[substr(J00_J47$p321,1,3)%in%c(paste("J",10:18,sep = "")),]
save(J10_J18, file = "E:\\雕龙软件公司\\201606雕龙\\@@@数据.Rdata\\J10_J18.Rdata")
write.csv(J10_J18, file = 'E:\\雕龙软件公司\\201606雕龙\\@@@数据_csv\\J10_J18.csv')


myconn <- odbcConnect('MPEHR_NEW', uid='sa', pwd='123456')
I21 <- sqlFetch(myconn, 'HOMEPAGE_I21')
save(I21, file = "E:\\雕龙软件公司\\201606雕龙\\I21.Rdata")

I61 <- sqlFetch(myconn, 'HOMEPAGE_I61')
save(I61, file = "E:\\雕龙软件公司\\201606雕龙\\I61.Rdata")

O10 <- sqlFetch(myconn, 'HOMEPAGE_O10')
save(O10, file = "E:\\雕龙软件公司\\201606雕龙\\O10.Rdata")

close(myconn)

setwd('E:\\雕龙软件公司\\201606雕龙\\@@数据\\')
write.csv(I21,'I21.csv', sep = ',')
write.csv(I61,'I61.csv', sep = ',')
write.csv(O10,'O10.csv', sep = ',')

load('E:\\雕龙软件公司\\201606雕龙\\@@数据\\I61.Rdata')
load('E:\\雕龙软件公司\\201606雕龙\\@@数据\\O10.Rdata')

#重新筛的I21
library(RODBC)
myconn <- odbcConnect('wasd', uid='sa', pwd='123456')
I21_new <- sqlFetch(myconn, 'HOMEPAGE_I21_NEW')
save(I21_new, file = "E:\\雕龙软件公司\\201606雕龙\\I21_new.Rdata")
write.csv(I21_new,'I21_new.csv', sep = ',')

#癌症数据
library(RODBC)
myconn <- odbcConnect('wasd', uid='sa', pwd='123456')
癌症 <- sqlFetch(myconn, 'dbo.HOMEPAGE_癌症')
save(癌症, file = "E:\\雕龙软件公司\\201606雕龙\\@@@数据.Rdata\\癌症.Rdata")
write.csv(癌症, file = "E:\\雕龙软件公司\\201606雕龙\\@@@数据.Rdata\\癌症.csv")

#重新筛的I50
library(RODBC)
myconn <- odbcConnect('wasd', uid='sa', pwd='123456')
I50 <- sqlFetch(myconn, 'HOMEPAGE_I50')
save(I50, file = "E:\\雕龙软件公司\\201606雕龙\\I50.Rdata")
write.csv(I50,'I50.csv', sep = ',')
#用R筛一遍
load('E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\I21.Rdata')
I50 <- I21[substr(I21$p321,1,3)%in%'I50',]
save(I50, file = 'E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\I50.Rdata')

setwd('E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\')
load('E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\I21_new.Rdata')
load('E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\I50.Rdata')
load('E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\I61.Rdata')
load('E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\o10.Rdata')
write.csv(I21_new,'I21_new.csv')

rm(myconn)

#1导入二三级医院的腹股沟疝手术数据
library(RODBC)
myconn <- odbcConnect('MPEHR_NEW', uid='sa', pwd='123456')
腹股沟疝 <- sqlFetch(myconn, 'HOMEPAGE_腹股沟疝修补术')
save(腹股沟疝, file = "E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\腹股沟疝.Rdata")
write.csv(腹股沟疝,'腹股沟疝.csv')

#2导入二三级医院的髋关节置换手术数据
library(RODBC)
myconn <- odbcConnect('MPEHR_NEW', uid='sa', pwd='123456')
髋关节置换手术 <- sqlFetch(myconn, 'HOMEPAGE_007_815')
save(髋关节置换手术, file = "E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\髋关节置换手术.Rdata")
write.csv(髋关节置换手术,'髋关节置换手术.csv')

#3导入二三级医院的膝关节置换手术数据
library(RODBC)
myconn <- odbcConnect('MPEHR_NEW', uid='sa', pwd='123456')
膝关节置换手术 <- sqlFetch(myconn, 'HOMEPAGE_008')
save(膝关节置换手术, file = "E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\膝关节置换手术.Rdata")
write.csv(膝关节置换手术,'膝关节置换手术.csv')

#4导入二三级医院的静脉曲张手术数据
library(RODBC)
myconn <- odbcConnect('MPEHR_NEW', uid='sa', pwd='123456')
静脉曲张手术 <- sqlFetch(myconn, 'HOMEPAGE_静脉曲张手术')
save(静脉曲张手术, file = "E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\静脉曲张手术.Rdata")
write.csv(静脉曲张手术,'静脉曲张手术.csv')

#将髋关节膝关节数据合并
髋膝关节置换手术 <- rbind(膝关节置换手术, 髋关节置换手术)
save(髋膝关节置换手术, file = "E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\髋膝关节置换手术.Rdata")
write.csv(髋膝关节置换手术,'髋膝关节置换手术.csv')

#筛选I21的病人
dat1<-I21[substr(I21$p321,1,4) %in% strsplit(c('I21.','i21.'),","),]

head(dat1)

#PART A ---COMORBIDITIES
# 合并症筛选1-心肌梗塞MI, myocardial infarction
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%c("I25.2"))|any(c(substr(dat1$p324[i],1,4),substr(dat1$p327[i],1,4),substr(dat1$p3291[i],1,4),substr(dat1$p3294[i],1,4),substr(dat1$p3297[i],1,4),substr(dat1$p3281[i],1,4),substr(dat1$p3284[i],1,4),substr(dat1$p3287[i],1,4),substr(dat1$p3271[i],1,4),substr(dat1$p3274[i],1,4))%in%c("I21.","I22.")))dat1$MI[i]=1 else dat1$MI[i]=0}

# 合并症筛选2-充血性心力衰竭CCF, congestive cardiac failure
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%strsplit(c("I09.9,I11.0,I13.0,I13.2,I25.5,I42.0,I42.5,I42.6,I42.7,I42.8,I42.9,P29.0"),",")[[1]])|any(c(substr(dat1$p324[i],1,4),substr(dat1$p327[i],1,4),substr(dat1$p3291[i],1,4),substr(dat1$p3294[i],1,4),substr(dat1$p3297[i],1,4),substr(dat1$p3281[i],1,4),substr(dat1$p3284[i],1,4),substr(dat1$p3287[i],1,4),substr(dat1$p3271[i],1,4),substr(dat1$p3274[i],1,4))%in%c("I50.","I43.")))dat1$CCF[i]=1 else dat1$CCF[i]=0}

# 合并症筛选3-周围性血管疾病PVD, peripheral vascular disease
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%strsplit(c("I73.1,I73.8,I73.9,I77.1,I79.0,I79.2,K55.1,K55.8,K55.9,Z95.8,Z95.9"),",")[[1]])|any(c(substr(dat1$p324[i],1,4),substr(dat1$p327[i],1,4),substr(dat1$p3291[i],1,4),substr(dat1$p3294[i],1,4),substr(dat1$p3297[i],1,4),substr(dat1$p3281[i],1,4),substr(dat1$p3284[i],1,4),substr(dat1$p3287[i],1,4),substr(dat1$p3271[i],1,4),substr(dat1$p3274[i],1,4))%in%c("I70.","I71.")))dat1$PVD[i]=1 else dat1$PVD[i]=0}

# 合并症筛选4-脑血管疾病 CD, Cerebrovascular disease
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%c("H34.0"))|any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c("G45","G46","I60","I61","I62","I63","I64","I65","I66","I67","I68","I69")))dat1$CD[i]=1 else dat1$CD[i]=0}

# 合并症筛选5-痴呆Dementia
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%strsplit(c("F05.1,G31.1"),",")[[1]])|any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c("F00","F01","F02","F03","G30")))dat1$Dementia[i]=1 else dat1$Dementia[i]=0}

# 合并症筛选6 - 慢性阻塞性肺病COPD, chronic obstructive pulmonary disease
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%strsplit(c("I27.8,I27.9,J68.4,J70.1,J70.3"),",")[[1]])|any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c(paste("J",40:47,sep = ""),paste("J",60:67,sep = ""))))dat1$COPD[i]=1 else dat1$COPD[i]=0}

# 合并症筛选7 -结缔组织病 RD - Connective tissue disease
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%strsplit(c("M31.5,M35.1,M35.3,M36.0"),",")[[1]])|any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c(paste("M",32:34,sep=""),"M05","M06")))dat1$RD[i]=1 else dat1$RD[i]=0}

# 合并症筛选8 –溃疡PUD, Ulcers
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c("K25","K26","K27","K28"))) dat1$PUD[i]=1 else dat1$PUD[i]=0}

# 合并症筛选9-轻微的肝脏疾病MLD, Mild liver disease
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%strsplit(c("K70.0,K70.1,K70.2,K70.3,K70.9,K71.3,K71.4,K71.5,K71.7,K76.0,K76.2,K76.3,K76.4,K76.8,K76.9,Z94.4"),",")[[1]])|any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c("B18","K73","K74")))dat1$MLD[i]=1 else dat1$MLD[i]=0}

# 合并症筛选10 - 糖尿病（没有终末器官损害）DMnotEOD (without end-organ damage)
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%c("E10.2","E10.3","E10.4","E10.5","E10.7","E11.2","E11.3","E11.4","E11.5","E11.77","E12.2","E12.3","E12.4","E12.5","E12.7","E13.2","E13.3","E13.4","E13.5","E13.7","E14.2","E14.3","E14.4","E14.5","E14.7"))) dat1$DMnotEOD[i]=1 else dat1$DMnotEOD [i]=0}

# 合并症筛选 11 -糖尿病（有终末器官损害）DMandEOD (with end-organ damage)
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%c("E10.0","E10.1","E10.6","E10.8","E10.9","E11.0","E11.1","E11.6","E11.8","E11.9","E12.0","E12.1","E12.6","E12.8","E12.9","E13.0","E13.1","E13.6","E13.8","E13.9","E14.0","E14.1","E14.6","E14.8","E14.9"))) dat1$DMandEOD[i]=1 else dat1$DMandEOD[i]=0}

# 合并症筛选 12 - 偏瘫Hemiplegia
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%strsplit(c("G04.1,G11.4,G80.1,G80.2,G83.0,G83.1,G83.2,G83.4,G83.9"),",")[[1]])|any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c("G81","G82")))dat1$Hemiplegia [i]=1 else dat1$Hemiplegia [i]=0}

# 合并症筛选 13 - 中度到重度的慢性肾脏疾病MSCKD, Moderate to Severe Chronic Kidney Disease
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in%strsplit(c("I12.0,I13.1,N03.2,N03.3,N03.4,N03.5,N03.6,N03.7,N05.2,N05.3,N05.4,N05.5,N05.6,N05.7,N25.0,Z49.0,Z49.1,Z49.2,Z94.0,Z99.2"),",")[[1]])|any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c("N18","N19")))dat1$MSCKD [i]=1 else dat1$MSCKD [i]=0}

# 合并症筛选 14 - 恶性（肿瘤等）Malignancy
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c(paste("C",00:26,sep = ""),paste("C",30:34,sep = ""), paste("C",37:41,sep = ""), paste("C",45:58,sep = ""), paste("C",60:76,sep = ""), paste("C",81:85,sep = ""), paste("C",90:97,sep = ""),"C43","C88")))dat1$ Malignancy [i]=1 else dat1$ Malignancy [i]=0}

# 合并症筛选 15 - 中等到重度肝脏疾病MSLD, Moderate–severe liver disease
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,5),substr(dat1$p327[i],1,5),substr(dat1$p3291[i],1,5),substr(dat1$p3294[i],1,5),substr(dat1$p3297[i],1,5),substr(dat1$p3281[i],1,5),substr(dat1$p3284[i],1,5),substr(dat1$p3287[i],1,5),substr(dat1$p3271[i],1,5),substr(dat1$p3274[i],1,5))%in% strsplit(c("I85.0,I85.9,I86.4,I98.2,K70.4,K71.1,K72.1,K72.9,K76.5,K76.6,K76.7"),",")[[1]])) dat1$MSLD [i]=1 else dat1$MSLD [i]=0}

# 合并症筛选 16 - 转移固体肿瘤MST, Metastatic solid tumour
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c(paste("C",77:80,sep = ""))))dat1$MST [i]=1 else dat1$MST [i]=0}

# 合并症筛选 17 - 艾滋病AIDS
for (i in 1:45564) 
{if(any(c(substr(dat1$p324[i],1,3),substr(dat1$p327[i],1,3),substr(dat1$p3291[i],1,3),substr(dat1$p3294[i],1,3),substr(dat1$p3297[i],1,3),substr(dat1$p3281[i],1,3),substr(dat1$p3284[i],1,3),substr(dat1$p3287[i],1,3),substr(dat1$p3271[i],1,3),substr(dat1$p3274[i],1,3))%in%c(paste("B",20:22,sep = ""),"B24")))dat1$AIDS [i]=1 else dat1$AIDS [i]=0}

#PART B---AGE
dat1$年龄[dat1$p7 <=59]<-1
dat1$年龄[dat1$p7 <= 69 &dat1$p7 >=60]<-2
dat1$年龄[dat1$p7 <= 79 &dat1$p7 >=70]<-3
dat1$年龄[dat1$p7 >=80]<-4
#identical codes
dat1 <- within(dat1,{
  年龄[p7 <=59]<-1
  年龄[p7 <= 69 &p7 >=60]<-2
  年龄[p7 <= 79 &p7 >=70]<-3
  年龄[p7 >=80]<-4
  })

# 原始CCI的计算
#1 loop
for (i in 1:45564)
{dat1$CCI_1987[i]<-dat1$MI[i]+dat1$CCF[i]+dat1$PVD[i]+dat1$CD[i]+dat1$Dementia[i]+dat1$COPD[i]+dat1$RD[i]+dat1$PUD[i]+dat1$MLD[i]+dat1$DMnotEOD[i]+dat1$DMandEOD[i]*2+dat1$Hemiplegia[i]*2+dat1$MSCKD[i]*2+dat1$ Malignancy[i]*2+dat1$MSLD[i]*3+dat1$MST[i]*6+dat1$AIDS[i]*6+dat1$年龄[i]}
#2 non-loop(recommended)
dat1 <- within(dat1,{
  CCI_1987_nonloop<-MI+CCF+PVD+CD+Dementia+COPD+RD+PUD+MLD+DMnotEOD+DMandEOD*2+Hemiplegia*2+MSCKD*2+ Malignancy*2+MSLD*3+MST*6+AIDS*6+年龄
})
dat1$CCI_1987_nonloop[1:50]
dat1$CCI_1987[1:50]

#2011 Quan 等人调整的CCI
for (i in 1:45564) 
{dat1$CCI_2011[i]<-dat1$CCF[i]*2+dat1$Dementia[i]*2+dat1$COPD[i]+dat1$RD[i]+dat1$MLD[i]*2+dat1$DMandEOD[i]+dat1$Hemiplegia[i]*2+dat1$MSCKD[i]+dat1$ Malignancy[i]*2+dat1$MSLD[i]*4+dat1$MST[i]*6+dat1$AIDS[i]*4+dat1$年龄[i]}

#不用for循环
dat1$CCI_2011_nonloop <- dat1$CCF*2+dat1$Dementia*2+dat1$COPD+dat1$RD+dat1$MLD*2+dat1$DMandEOD+dat1$Hemiplegia*2+dat1$MSCKD+dat1$Malignancy*2+dat1$MSLD*4+dat1$MST*6+dat1$AIDS*4+dat1$年龄
dat1$CCI_2011_nonloop[1:50]
dat1$CCI_2011[1:50]

save(dat1, file = "E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\dat1.Rdata")

#数据分析
installed.packages('dplyr')
help('dplyr')

#将医院信息进行导入
load('E:\\雕龙软件公司\\201606雕龙\\CCI_QUAN(2011)数据\\dat1_merge.Rdata')
load('E:\\雕龙软件公司\\201606雕龙\\CCI_QUAN(2011)数据\\机构代码信息_修改过医院等级级别.Rdata')
dat1_merge <- read.csv("C:\\Users\\MIAO\\Desktop\\23级医院\\zzz.csv", header = TRUE)
dat1_merge <- merge(dat1_merge, 机构代码信息_修改过医院等级级别, by.x = 'GID', by.y='GID')
save(dat1_merge, file = 'E:\\雕龙软件公司\\201606雕龙\\CCI_QUAN(2011)数据\\dat1_merge.Rdata')


aggregate(dat1_merge$CCI_2011, by = list(dat1_merge$医院级别, dat1_merge$医院等级), FUN = mean)
aggregate(dat1_merge$CCI_2011, by = list(dat1_merge$医院级别, dat1_merge$医院等级), FUN = length)

#产生一个新的变量“医院等级级别”
for (i in 1:45564)
{dat1_merge$医院等级级别[i] <- paste(dat1_merge$医院级别[i], dat1_merge$医院等级[i], sep = '', collapse = NULL)}

aggregate(dat1_merge$CCI_2011, by = list(dat1_merge$医院等级级别), FUN = mean)
aggregate(dat1_merge$CCI_1987, by = list(dat1_merge$医院等级级别), FUN = mean)
aggregate(dat1_merge$CCI_2011, by = list(dat1_merge$医院等级级别), FUN = length)

#把三级乙等和二级甲等抽出来
dat1_23_new <- subset(dat1_merge, dat1_merge$医院等级级别 == '二级甲等' | dat1_merge$医院等级级别 =='三级乙等')
#identical functions1
dat1_23 <- dat1_merge[dat1_merge$医院等级级别 %in% c('二级甲等','三级乙等'),]
mode(dat1_merge$医院等级级别)
#identical functions2 
dat1_23_new2 <- dat1_merge[which(dat1_merge$医院等级级别%in%c('二级甲等','三级乙等')),]                          ]
#comparison
dat1_23_new2$GID[1:20]
dat1_23_new$GID[1:20]
dat1_23$GID[1:20]

rm(dat1_23_new2)
rm(dat1_23_new)
rm(dat1_23)

save(机构代码信息, file = "E:\\雕龙软件公司\\201606雕龙\\数据.Rdata\\机构代码信息.Rdata")
save(dat1_merge, file = "E:\\雕龙软件公司\\201606雕龙\\test_Data.Rdata\\dat1_merge.Rdata")
save(dat1_23, file = "E:\\雕龙软件公司\\201606雕龙\\test_Data.Rdata\\dat_23.Rdata")
#找出三级NULL的医院
fix(机构代码信息)
Three_null <- dat1_merge[dat1_merge$医院等级级别 == '三级NULL',]
aggregate(Three_null$CCI_2011, by = list(Three_null$GID), FUN = length)
#                               Group.1   x
# 1 3DC024EA-7B22-4281-A044-EBEFCF2273E8 517
# 2 7030C67A-E24D-4252-A7D7-A6863772A579  12

with(dat1_merge, {
  医院等级级别[GID == '3DC024EA-7B22-4281-A044-EBEFCF2273E8' | GID == '7030C67A-E24D-4252-A7D7-A6863772A579'] <- '三级甲等'
  aggregate(CCI_2011, by = list(医院等级级别), FUN = length)
})
with(dat1_merge, {
  医院等级级别[GID == '3DC024EA-7B22-4281-A044-EBEFCF2273E8' | GID == '7030C67A-E24D-4252-A7D7-A6863772A579'] <- '三级甲等'
  aggregate(CCI_2011, by = list(医院等级级别), FUN = mean)
})
with(dat1_merge, {
  医院等级级别[GID == '3DC024EA-7B22-4281-A044-EBEFCF2273E8' | GID == '7030C67A-E24D-4252-A7D7-A6863772A579'] <- '三级甲等'
  aggregate(CCI_1987, by = list(医院等级级别), FUN = mean)
})

dat1_merge$医院等级级别[dat1_merge$GID == '3DC024EA-7B22-4281-A044-EBEFCF2273E8' | dat1_merge$GID == '7030C67A-E24D-4252-A7D7-A6863772A579'] <- '三级甲等'

#二级三级医院方差分析
install.packages("lattice")
with(dat1_merge, {
aggregate(CCI_2011, by=list(医院等级级别), FUN=mean)
  library(lattice)
bwplot(CCI_2011~医院等级级别)
model=aov(CCI_2011~医院等级级别)
summary(model)
(result=TukeyHSD(model))
plot(result)
#假设检验
#shapiro.test(CCI_2011)
#bartlett.test(CCI_2011~医院等级级别)  
}
  )

load('E:\\雕龙软件公司\\201606雕龙\\test_Data.Rdata\\dat1_merge.Rdata')

aggregate(dat1_merge$CCI_2011, by=list(dat1_merge$医院等级级别), FUN=mean)
library(lattice)
bwplot(dat1_merge$CCI_2011~dat1_merge$医院等级级别)
model=aov(dat1_merge$CCI_2011~dat1_merge$医院等级级别)
summary(model)
(result=TukeyHSD(model))
plot(result)
#假设检验
#
install.packages('sm')
library(sm)
sm.density.compare(dat1_merge$CCI_2011, dat1_merge$医院等级级别)
shapiro.test(dat1_merge$CCI_2011)
bartlett.test(dat1_merge$CCI_2011~dat1_merge$医院等级级别) 

rm(list = ls())

#箱线图画出二三级医院之间的
dat1_merge$医院等级级别[dat1_merge$GID == '3DC024EA-7B22-4281-A044-EBEFCF2273E8' | dat1_merge$GID == '7030C67A-E24D-4252-A7D7-A6863772A579'] <- '三级甲等'
attach(dat1_merge)
boxplot(CCI_2011 ~ 医院等级级别, data = dat1_merge,
        notch = TRUE,
        main = '不同医院等级级别之间的CCI箱线图',
        xlab = '医院等级级别',
        ylab = 'Quan (2011)版CCI')
detach(dat1_merge)

#二级甲等与三级乙等的t检验
#首先将两个数据集分开
rm(CCI_2011)
二级甲等 <- subset(dat1_merge, dat1_merge$医院等级级别 == '二级甲等' )
三级乙等 <- subset(dat1_merge, dat1_merge$医院等级级别 =='三级乙等')
jia_2 <- 二级甲等$CCI_2011
yi_3 <- 三级乙等$CCI_2011
#t检验
t.test(jia_2, yi_3)
#Wilcoxon秩和检验 Mann - Whitney U 检验
table(dat1_merge$医院等级)
table(dat1_merge$医院级别)
dat1_merge$医院等级[dat1_merge$GID == '3DC024EA-7B22-4281-A044-EBEFCF2273E8' | dat1_merge$GID == '7030C67A-E24D-4252-A7D7-A6863772A579'] <- '甲等'
wilcox.test(CCI_2011 ~ 医院等级, dat1_merge)

#	Wilcoxon rank sum test with continuity correction
# data:  CCI_2011 by 医院等级
# W = 50546000, p-value < 2.2e-16
# alternative hypothesis: true location shift is not equal to 0

wilcox.test(CCI_2011 ~ 医院级别, dat1_merge)
# Wilcoxon rank sum test with continuity correction
# data:  CCI_2011 by 医院级别
# W = 106670000, p-value < 2.2e-16
# alternative hypothesis: true location shift is not equal to 0

wilcox.test(jia_2, yi_3)
# Wilcoxon rank sum test with continuity correction
# data:  jia_2 and yi_3
# W = 6173800, p-value = 0.08063
# alternative hypothesis: true location shift is not equal to 0

#比较整体不同医院等级级别的CCI(2011)
# 思路1 方差分析 One-way ANOVA
tapply(dat1_merge$CCI_2011, dat1_merge$医院等级级别, mean)
aov_23 <- aov(dat1_merge$CCI_2011 ~ dat1_merge$医院等级级别)
summary(aov_23)
# Df Sum Sq Mean Sq F value Pr(>F)    
# dat1_merge$医院等级级别     3   3078    1026   336.6 <2e-16 ***
#  Residuals               45560 138873       3                   
# ---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# pair-wise comparison
# 'bonf' method
pairwise.t.test(dat1_merge$CCI_2011, dat1_merge$医院等级级别, p.adjust.method = 'bonf')
# 	Pairwise comparisons using t tests with pooled SD 
# data:  dat1_merge$CCI_2011 and dat1_merge$医院等级级别 
# 二级甲等 二级乙等 三级甲等
# 二级乙等 4.0e-06  -        -       
# 三级甲等 < 2e-16  < 2e-16  -       
# 三级乙等 0.52     8.2e-05  < 2e-16 
#  P value adjustment method: bonferroni 

# 'holm' method
pairwise.t.test(dat1_merge$CCI_2011, dat1_merge$医院等级级别, p.adjust.method = 'holm')
# Pairwise comparisons using t tests with pooled SD 
# data:  dat1_merge$CCI_2011 and dat1_merge$医院等级级别 
# 二级甲等 二级乙等 三级甲等
# 二级乙等 2.0e-06  -        -       
# 三级甲等 < 2e-16  < 2e-16  -       
# 三级乙等 0.086    2.7e-05  < 2e-16 
# P value adjustment method: holm 

# TukeyHSD (Tukey Honest Significant Differences)
TukeyHSD(aov_23)
#   Tukey multiple comparisons of means
# 95% family-wise confidence level

# Fit: aov(formula = dat1_merge$CCI_2011 ~ dat1_merge$医院等级级别)

# $`dat1_merge$医院等级级别`
# diff        lwr        upr     p adj
# 二级乙等-二级甲等 -0.78022482 -1.1834958 -0.3769538 0.0000040
# 三级甲等-二级甲等  0.62529717  0.5660479  0.6845464 0.0000000
# 三级乙等-二级甲等 -0.07987835 -0.1995093  0.0397526 0.3155671
# 三级甲等-二级乙等  1.40552198  1.0052621  1.8057819 0.0000000
# 三级乙等-二级乙等  0.70034647  0.2868141  1.1138789 0.0000800
# 三级乙等-三级甲等 -0.70517552 -0.8142262 -0.5961248 0.0000000

# 思路2 Kruskal - Wallis 检验
dat1_merge$医院等级级别.f <- as.factor(dat1_merge$医院等级级别)
with(dat1_merge, kruskal.test(CCI_2011 ~ 医院等级级别.f, dat1_merge))
# Kruskal-Wallis rank sum test
# data:  CCI_2011 by 医院等级级别.f
# Kruskal-Wallis chi-squared = 1053.4, df = 3, p-value < 2.2e-16

# Kruskal-Wallis符号秩检验拒绝了相同的原假设，因此需要用M检验到底是哪两组之间存在显著性差异
install.packages('npmc', repos='http://cran.r-project.org')
CCI_医院等级级别 <- subset(dat1_merge, select = c(CCI_2011, 医院等级级别))
library(npmc)
summary(npmc(CCI_医院等级级别), type = 'BF')

# PMCMR包
# https://cran.r-project.org/web/packages/PMCMR/vignettes/PMCMR.pdf
install.packages('PMCMR')
require(PMCMR)

# Pairwise comparisons using Tukey and Kramer (Nemenyi) test with Tukey-Dist approximation for independent samples 
dat1_merge$医院等级级别 <- as.factor(dat1_merge$医院等级级别)
with(dat1_merge, posthoc.kruskal.nemenyi.test(x=CCI_2011, g=医院等级级别, dist="Tukey"))

# Pairwise comparisons using Nemenyi-test with Chi-squared approximation for independent samples
(out <- with(dat1_merge, posthoc.kruskal.nemenyi.test(x=CCI_2011, g=医院等级级别, dist="Chisquare")))

# Pairwise comparisons using Dunn's-test for multiple	comparisons of independent samples 
with(dat1_merge, posthoc.kruskal.dunn.test(x=CCI_2011, g=医院等级级别, p.adjust.method="none"))
with(dat1_merge, posthoc.kruskal.dunn.test(x=CCI_2011, g=医院等级级别, p.adjust.method="bonferroni"))

# Pairwise comparisons using Conover's-test for multiple comparisons of independent samples 
with(dat1_merge, posthoc.kruskal.conover.test(x=CCI_2011, g=医院等级级别, p.adjust.method="none"))
with(dat1_merge, posthoc.kruskal.conover.test(x=CCI_2011, g=医院等级级别, p.adjust.method="bonferroni"))

rm(list = ls())


