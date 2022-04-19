library(ggplot2)
library(reshape2)
library(dplyr)
args <- commandArgs(trailingOnly = TRUE)
data2 <- read.csv(args[2], na.strings="")

test_data_long <- melt(data2, id="gene_position")

data_ready <- filter(test_data_long, !is.na(value))

names(data_ready)[2] <- "Sample" 

b<- ggplot(data_ready, aes(x=gene_position, y= value, colour=Sample)) + 
  geom_line() + theme_bw(base_size=14) + xlab("Position in gene") + scale_y_continuous(trans='log10')  + ylab("Number of reads") + ggtitle(args[1])
#+ facet_wrap(. ~ Sample)

ggsave(paste(args[2],'grouped.png',sep=''), width=10, height=6)

c<- ggplot(data_ready, aes(x=gene_position, y= value)) + 
  geom_line() + theme_bw(base_size=14) + xlab("Position in gene") + scale_y_continuous(trans='log10') + ylab("Number of reads") + ggtitle(args[1]) + facet_wrap(. ~ Sample)

ggsave(paste(args[2],'individual.png',sep=''), width=10, height=6)

f= data_ready %>%
  group_by(Sample)%>%
  summarise(mean_deep= mean(value), medium_deep = median(value),min_deep = min(value), max_deep = max(value))
f = mutate(f, gene=args[3])
head(df)
write.table(f,file=paste(args[2],'data.csv',sep=''),sep=",",row.names=FALSE,quote=FALSE)
