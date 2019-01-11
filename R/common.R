library(tidyverse)

colors = scale_color_manual(values = c("orange", "gray"))
fills = scale_fill_manual(values = c("orange", "gray"))

dpath = "/Users/matteo/Projects/retentiontimealignment/Data"
oppath = "/Users/matteo/Projects/retentiontimealignment/posters/eubic2019/R/img"
d_seq = as_tibble(read.csv(file.path(dpath, 'annotated_data.csv')))
d_unseq = as_tibble(read.csv(file.path(dpath, 'unannotated_data.csv')))

# D = bind_rows(
#     d_seq %>% filter(run == 1),
#     d_unseq %>% filter(run == 1)
# )
D = bind_rows(d_seq, d_unseq)
D = D %>% mutate(sequenced = ifelse(is.na(sequence), "sequenced", "unsequenced"))

linesize = 1.2