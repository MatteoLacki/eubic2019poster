library(tidyverse)
library(cowplot)
library(ggthemes)
library(scales)

source("common.R")

# Getting only those peptides that appear uniquely in each run (there are no others anywawy)
# and writing which id is in which runs
d_seq_single =  d_seq %>% 
	group_by(run, id) %>% count %>% filter(n==1) %>% group_by(id) %>% 
	summarize(runs = paste0(run, sep='', collapse='_'), runs_no=n())

simple_venn = d_seq_single %>% group_by(runs_no) %>% count

# almost all of 1024 groups
venn = d_seq_single %>% group_by(runs, runs_no) %>% count %>% ungroup

venn_plot = 
	venn %>% group_by(runs_no) %>% summarize(n=sum(n)) %>%
	ggplot(aes(x=ordered(runs_no), y=n)) +
	geom_bar(stat='identity', fill='orange') +
	xlab("No of technical replicates") +
	ylab("Peptides") +
	scale_y_continuous(labels=comma, breaks=c(10000,50000,100000))

max_pept = sum(venn$n)

save(venn_plot, file='img/venn_plot.Rd')
cowplot::ggsave(file.path(oppath, 'runs_n_peptides.pdf'), width=4, height=4)