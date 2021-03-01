#!/usr/bin/env Rscript
options(warn=-1)
args = commandArgs(trailingOnly=TRUE)
library(countrycode)
library(ggplot2)

#Part1: read data
sr <- read.table(args[1], header = TRUE)
sr$date <- as.Date(sr$date)
s <- subset(sr,!is.na(sr$date))
s$date <- s$date - as.Date("2019-12-26")
s$date <-as.numeric(s$date)
s$location <- as.character(s$location)
s$dist <-as.numeric(s$dist)
#dim(s)
#s <- s[s$dist!=0,]
#dim(s)

#Part2: data processing
df <- data.frame("location"=s$location)
df$location <- as.character(df$location)
df[df=="Beijing"|df=="Chongqing"|df=="Foshan"|df=="Fujian"|df=="Fuyang"|df=="Ganzhou"|df=="Guangdong"|df=="Guangzhou"|df=="Hangzhou"|df=="Hefei"|df=="Hong_10_Kong"|df=="Hong_12_Kong"|df=="Hong_13_Kong"|df=="Hong_16_Kong"|df=="Hong_17_Kong"|df=="Hong_18_Kong"|df=="Hong_19_Kong"|df=="Hong_2_Kong"|df=="Hong_20_Kong"|df=="Hong_21_Kong"|df=="Hong_23_Kong"|df=="Hong_24_Kong"|df=="Hong_28_Kong"|df=="Hong_3_Kong"|df=="Hong_30_Kong"|df=="Hong_33_Kong"|df=="Hong_35_Kong"|df=="Hong_36_Kong"|df=="Hong_37_Kong"|df=="Hong_5_Kong"|df=="Hong_7_Kong"|df=="Hong_8_Kong"|df=="Hong_9_Kong"|df=="Jian"|df=="Jiangsu"|df=="Jiangxi"|df=="Jingzhou"|df=="Jiujiang"|df=="NanChang"|df=="Pingxiang"|df=="Shandong"|df=="Shanghai"|df=="Shangrao"|df=="Shenzen"|df=="Sichuan"|df=="Tianmen"|df=="Wuhan"|df=="Wuhan-Hu-1"|df=="Xinyu"|df=="Yunnan"|df=="Zhejiang"|df=="Nanchang"|df=="Shenzhen"] <- "China"
df[df=="South_10_Korea"|df=="South_11_Korea"|df=="South_16_Korea"|df=="South_17_Korea"|df=="South_18_Korea"|df=="South_2_Korea"|df=="South_3_Korea"|df=="South_4_Korea"|df=="South_5_Korea"|df=="South_6_Korea"|df=="South_7_Korea"|df=="South_8_Korea"|df=="South_9_Korea"] <- "South Korea"
df[df=="England"|df=="Wales"|df=="Scotland"] <- "UK"
df[df=="Nonthaburi"] <- "Thailand"
df[df=="New_2_Zealand"|df=="New_3_Zealand"|df=="New_4_Zealand"] <- "New Zealand"
df[df=="South_12_Africa"|df=="South_15_Africa"] <- "South Africa"
df[df=="Sri_2_Lanka"|df=="Sri_3_Lanka"|df=="Sri_4_Lanka"] <- "Sri Lanka"
df$continent <- countrycode(sourcevar = df[,1],origin = "country.name",destination = "continent")
s$continent <- df$continent
s$continent <- as.character(s$continent)


#Part3: lm
fit1 <- lm(formula = dist ~ date - 1, data = s)
#summary(fit1)
gene <- strsplit(args[1], ".list")[[1]]
ndf <- data.frame(gene, "all", fit1$coef[[1]]*365, coef(summary(fit1))[, 2]*365,stringsAsFactors=FALSE)
names(ndf) <-c ("gene","catalogue","coef","sd")

tmp <- with(s, by(s, s$continent ,function(x) lm(formula = dist ~ date - 1, data = x )))
list <- sapply(tmp, coef)
for(i in 1:length(tmp)){
  add <- c(gene, names(tmp)[i], list[[i]]*365, coef(summary(tmp[[i]]))[, 2]*365)
  ndf <- rbind(ndf, add)
}
write.table(ndf,file=paste0(gene,".table"))

#Part4: print the plot
s[s=="Africa"] <- paste("Africa:",format(list[[1]]*365, scientific = TRUE,digits = 3))
s[s=="Americas"] <- paste("Americas:",format(list[[2]]*365, scientific = TRUE,digits = 3))
s[s=="Asia"] <- paste("Asia:",format(list[[3]]*365, scientific = TRUE,digits = 3))
s[s=="Europe"] <- paste("Europe:",format(list[[4]]*365, scientific = TRUE,digits = 3))
s[s=="Oceania"] <- paste("Oceania:",format(list[[5]]*365, scientific = TRUE,digits = 3))
plot1 <- ggplot(data=s, aes(x=date, y=dist, color=continent)) + geom_point(alpha=0.05) + stat_smooth(method="lm",formula = y ~ 0 + x) + xlab("Date") + ylab("Genetic divergence") + xlim(0, NA) + ylim(0, NA) + labs(color="Continents")
ggsave(filename=paste0(args[1],".continent.pdf"), width = 12, height = 6)
plot2 <- ggplot(data=s, aes(x=date, y=dist)) + geom_point(alpha=0.05) + stat_smooth(method="lm",formula = y ~ 0 + x) + xlab("Date") + ylab("Genetic divergence") + labs(title = paste("Clock rate:",format(fit1$coef[[1]]*365, scientific = TRUE,digits = 3),"Std Error:",format(coef(summary(fit1))[, 2]*365, scientific = TRUE,digits = 3))) + xlim(0, NA) + ylim(0, NA)
ggsave(filename=paste0(args[1],".pdf"), width = 12, height = 6)

