library(tidyverse)
library(cowplot)

load(file='img/venn_plot.Rd')
load(file='img/rt_freq_plot.Rd')
load(file='img/mass_freq_plot.Rd')
load(file='img/dt_freq_plot.Rd')



features = plot_grid(
	rt_freq_plot + theme_cowplot() + theme(legend.position="none"),
	mass_freq_plot + theme_cowplot() + theme(legend.position=c(.8,.9), legend.title=element_blank()),
	dt_freq_plot + theme_cowplot() + theme(legend.position="none"),
	nrow=3,
	align='h'
)

plot_grid(venn_plot, features, ncol=2, rel_widths=c(1,3))
cowplot::ggsave(file.path(oppath, 'venn_and_similarfeatures.pdf'), width=12, height=6)