library(ggplot2)
files <- list.files(pattern=".table")
DF <- NULL
for (f in files) {
   dat <- read.table(f, header=T)
   DF <- rbind(DF, dat)
}
write.table(DF,file="sum.table")
DF$catalogue_f = factor(DF$catalogue, levels=c('all','Africa','Americas','Asia','Europe','Oceania'))
DF$gene_f = factor(DF$gene, levels=c('ORF1ab','S','ORF3a','E','M','ORF6','ORF7a','ORF7b','ORF8','ORF10','N'))

p1 <- ggplot(DF, aes(x=gene_f, y=coef, fill=catalogue_f)) + 
  geom_bar(stat="identity", color="black", position=position_dodge()) + 
  geom_errorbar(aes(ymin=coef, ymax=coef+2*sd), width=.4, position=position_dodge(.9)) 
p1 <- p1 + xlab("") + ylab("Mutation Rate") + labs(fill="")
p1 <- p1 + scale_fill_manual(values=c("dark grey", "yellow", "blue", "green", "cyan", "purple"))
ggsave(filename="mutationRate.pdf", width = 12, height = 6)

