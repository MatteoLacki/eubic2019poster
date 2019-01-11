library(tidyverse)
library(cowplot)
library(ggthemes)
library(scales)

source("common.R")

# simplifying data
D_stat = D %>%
    group_by(sequenced, rt_rounded = round(rt,0)) %>%
    count %>%
    group_by(sequenced) %>%
    mutate(freq = n/sum(n)) %>%
    ungroup

rt_freq_plot = D_stat %>%
    ggplot(aes(x = rt_rounded, y=freq, group=sequenced, color=sequenced)) +
    geom_line(size=linesize) +
    xlab("Retention Time [min]") +
    ylab("Frequency") +
    theme_tufte() +
    colors +
    scale_y_continuous(labels=percent)

counts1 = D %>%
    group_by(sequenced) %>% count %>%
    ggplot(aes(x=sequenced, y=n, fill=sequenced)) +
    geom_bar(stat="identity") +
    xlab("") +
    ylab("Peptides No") +
    scale_y_continuous(labels=comma) +
    fills +
    theme_tufte()

seq_vs_unsqeq_plot = plot_grid(
    counts1 + theme(legend.position="none"),
    rt_freq_plot + theme(legend.position=c(.8,.9),
                     legend.title=element_blank()),
    align='h', rel_widths=c(1,4),
    labels='AUTO'
)

cowplot::ggsave(file.path(oppath, 'seq_vs_unseq_plot.pdf'), 
    width=12, height=2)

mass_freq_plot = D %>%
    group_by(sequenced, mass_rounded = round(mass,-1)) %>%
    count %>%
    group_by(sequenced) %>%
    mutate(freq = n/sum(n)) %>%
    ungroup %>%
    ggplot(aes(x = mass_rounded, y=freq, group=sequenced, color=sequenced)) +
    geom_line(size=linesize) +
    xlab("Mass [Da]") +
    ylab("Frequency") +
    theme_tufte() +
    colors +
    scale_y_continuous(labels=percent)

dt_freq_plot = D %>%
    group_by(sequenced, dt_rounded = round(dt,0)) %>%
    count %>%
    group_by(sequenced) %>%
    mutate(freq = n/sum(n)) %>%
    ungroup %>%
    ggplot(aes(x = dt_rounded, y=freq, group=sequenced, color=sequenced)) +
    geom_line(size=linesize) +
    xlab("Drift Time [bins of around 13 milliseconds]") +
    ylab("Frequency") +
    theme_tufte() +
    colors +
    scale_y_continuous(labels=percent)

# freq_plots = plot_grid(
#     rt_freq_plot + theme(legend.position=c(.9,.9)),
#     mass_freq_plot + theme(legend.position="none"),
#     dt_freq_plot + theme(legend.position="none"),
#     nrow=3,
#     align='v'
# )
# seq_vs_unsqeq_plot = plot_grid(
#     counts1 + theme(legend.position="none"),
#     freq_plots,
#     align='h', rel_widths=c(1,3),
#     labels='AUTO'
# )
# cnt_mass_plot = plot_grid(
#     counts1 + theme(legend.position="none") + coord_flip(),
#     mass_freq_plot + theme(legend.position="none"),
#     ncol=2
# )
# rt_dt_plot = plot_grid(
#     rt_freq_plot + theme(legend.position="none"),
#     dt_freq_plot + theme(legend.position="none"),
#     ncol=2
# )

save(rt_freq_plot, file='img/rt_freq_plot.Rd')
save(mass_freq_plot, file='img/mass_freq_plot.Rd')
save(dt_freq_plot, file='img/dt_freq_plot.Rd')

plt=plot_grid(counts1 + theme(legend.position="none") + coord_flip(),
              rt_freq_plot + theme(legend.position=c(.9,.8), legend.title=element_blank()),
              mass_freq_plot + theme(legend.position=c(.9,.8), legend.title=element_blank()),
              dt_freq_plot + theme(legend.position=c(.9,.8), legend.title=element_blank()),
              ncol=2, nrow=2)

cowplot::ggsave(file.path(oppath, 'seq_vs_unseq_plot.pdf'), 
    width=12, height=3)

