library(tidyverse)
library(cowplot)
library(ggthemes)
library(scales)

source("common.R")


X = d_seq %>% select(run, rt, id)
X = X %>% group_by(id) %>% mutate(rt_med = median(rt),
								  rt_med_dist = rt - rt_med) %>% ungroup

round_digits = 0
perc = seq(0,1,by=.1)
perc = c(.15, .5, .85)
top_down = perc[c(1,3)]

Y = filter(X, rt_med_dist != 0, abs(rt_med_dist) < 2) %>%
	mutate(rt_med_dist = rt_med_dist*60)

rt_stats = Y %>% group_by(run, rt = round(rt, round_digits)) %>%
	do(data.frame(p=perc, quantile=quantile(.$rt_med_dist, probs=perc))) %>% ungroup

rt_stats = mutate(rt_stats, run=ordered(run))
rt_top_down = filter(rt_stats, p %in% top_down) %>% spread(p, quantile)
colnames(rt_top_down)[3:4] = c('down', 'top')

rt_dist_focus = ggplot() +
	geom_hline(yintercept=0, color='red', linetype="dashed") +
	geom_ribbon(
		aes(x=rt, group=run, ymin=down, ymax=top),
		rt_top_down,
		alpha=.3
	) +
	geom_line(
		aes(x = rt, group=run, y=quantile, color=run),
		filter(rt_stats, p==.5),
		size=1
	) +
	xlab("retention time [min]") +
	ylab("RT - Median(RT)  [s]") +
	guides(color=guide_legend(title="technical\nreplicate"))

noise_points = inner_join(
		filter(X, rt_med_dist != 0) %>% 
		mutate(rt_med_dist=rt_med_dist*60, 
			   rt_round=round(rt, round_digits),
			   run=ordered(run)),
		rt_top_down, by=c('run'='run', 'rt_round'='rt')
	) %>%
	filter(rt_med_dist > top | rt_med_dist < down) %>%
	select(run, rt, id, rt_med_dist)

rt_dist_plt = ggplot() +
	geom_hex(
		aes(x=rt, y=rt_med_dist),
		noise_points,
		size = .1,
		bins = 300) +
	xlab("retention time [min]") +
	ylab("RT - Median(RT)  [s]") +
	guides(color=guide_legend(title="technical\nreplicate")) +
	scale_fill_gradient(low='black', high='red')

plot_grid(rt_dist_plt, rt_dist_focus, nrow=2, align='v')

cowplot::ggsave(file.path(oppath, 'rt_dists.pdf'), width=12, height=6)
