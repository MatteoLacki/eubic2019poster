library(tidyverse)
library(cowplot)
library(ggthemes)
library(scales)

dpath = "/Users/matteo/Projects/retentiontimealignment/Data"

d_seq = read.csv(file.path(dpath, 'annotated_data.csv'))
d_unseq = read.csv(file.path(dpath, 'unannotated_data.csv'))

d_seq = as_tibble(d_seq)
d_unseq = as_tibble(d_unseq)

# D = bind_rows(
#     d_seq %>% filter(run == 1),
#     d_unseq %>% filter(run == 1)
# )
D = bind_rows(d_seq, d_unseq)
D = D %>% mutate(sequenced = ifelse(is.na(sequence), "sequenced", "unsequenced"))

# simplifying data
D_stat = D %>%
    group_by(sequenced, rt_rounded = round(rt,0)) %>%
    count %>%
    group_by(sequenced) %>%
    mutate(freq = n/sum(n)) %>%
    ungroup

colors = scale_color_manual(values = c("orange", "black"))
fills = scale_fill_manual(values = c("orange", "black"))

density1 = D_stat %>%
    ggplot(aes(x = rt_rounded, y=freq, group=sequenced, color=sequenced)) +
    geom_line() +
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

plot_grid(
    counts1 + theme(legend.position="none"),
    density1 + theme(legend.position=c(.8,.9),
                     legend.title=element_blank()),
    align='h', rel_widths=c(1,4))