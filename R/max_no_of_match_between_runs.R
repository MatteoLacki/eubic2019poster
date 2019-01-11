library(tidyverse)
library(cowplot)
library(ggthemes)
library(scales)

source("common.R")

W = bind_rows(
	d_unseq %>% group_by(run) %>% count %>% mutate(status='unsequenced') %>% ungroup,
	d_seq %>% group_by(run) %>% count %>% mutate(status='sequenced') %>% ungroup
) %>% 
mutate(run=ordered(run))

max_pept = length(levels(d_seq$id))

W %>% ggplot(aes(x=run, y=n, fill=status)) +
geom_bar(stat='identity', position='dodge') +
scale_y_continuous(labels=comma)+
fills +
xlab("technical replicate") +
ylab("Peptides") +
geom_hline(yintercept=max_pept,
		   linetype='dashed') +
theme(legend.title=element_blank(), legend.position=c(.85,.9)) +
annotate("text", x=12, y=max_pept , label = "") +
annotate("text", x=11.2, y=max_pept * 1.2, label = "best x-annotation")

cowplot::ggsave(file.path(oppath, 'x-annotation.pdf'), width=12, height=3)

