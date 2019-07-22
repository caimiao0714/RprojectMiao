pacman::p_load(sf, dplyr, tidyr, ggplot2, viridis, cowplot)
source("functions/theme_map.R")

# 01. Read in and merge data
s = read_sf("Countries_WGS84/Countries_WGS84.shp") %>% 
  left_join(
    readxl::read_excel("data/OOE_excel.xlsx"),
    by = c("CNTRY_NAME" = "country")
  ) %>% 
  select("CNTRY_NAME", "sdi", "OOE")

# 02. Default parameters for fonts, background, and family
default_font_color <- "#4e4d47"
default_background_color <- "#f5f5f2"
default_font_family <- "Arial"

# 03. Cut two main variables into quantiles
quantiles_sdi <- s %>%
  pull(sdi) %>%
  quantile(probs = seq(0, 1, length.out = 6), na.rm = TRUE)

quantiles_OOE <- s %>%
  pull(OOE) %>%
  quantile(probs = seq(0, 1, length.out = 6), na.rm = TRUE)

# 04. Color scheme 5*5
# Color adjusted from: 
# https://meyerweb.com/eric/tools/color-blend/#C39DB0:466EA3:3:hex
bivariate_color_scale_5 <- tibble(
  "5 - 5" = "#3F2949",
  "5 - 4" = "#414067",
  "5 - 3" = "#445785", # high sdi, high OOE
  "5 - 2" = "#466EA3",
  "5 - 1" = "#4885C1", # high sdi, low OOE
  "4 - 5" = "#5B2D4A",
  "4 - 4" = "#5E4769",
  "4 - 3" = "#626088",
  "4 - 2" = "#657AA6", # medium sdi, medium OOE
  "4 - 1" = "#6993C5",
  "3 - 5" = "#77324C",
  "3 - 4" = "#7B4E6B",
  "3 - 3" = "#806A8A",
  "3 - 2" = "#8586AA", # medium sdi, medium OOE
  "3 - 1" = "#89A2C9",
  "2 - 5" = "#92364D",
  "2 - 4" = "#98546D",
  "2 - 3" = "#9E738D",
  "2 - 2" = "#A491AD", # medium sdi, medium OOE
  "2 - 1" = "#AAB0CC",
  "1 - 5" = "#AE3A4E",
  "1 - 4" = "#B55B6F",
  "1 - 3" = "#BC7C8F", # low sdi, high OOE
  "1 - 2" = "#C39DB0",
  "1 - 1" = "#CABED0" # low sdi, low OOE
) %>%
  gather("group", "fill")

# 05. Bivariate legend - 5*5
biv_legend_5 = bivariate_color_scale_5 %>% 
  separate(group, into = c("sdi", "OOE"), sep = " - ") %>%
  mutate(sdi = as.integer(sdi),
         OOE = as.integer(OOE)) %>% 
  ggplot() +
  geom_tile(
    mapping = aes(x = sdi, y = OOE, fill = fill)) +
  scale_fill_identity() +
  labs(x = "Higher sdi →", y = "Higher OOE →") +
  theme_map() +
  theme(axis.title = element_text(size = 6)) +
  coord_fixed()

# Customize the legend
update_biv_legend = biv_legend_5 +
  geom_segment(aes(x=0.5, xend = 5.5, y=2.5, yend = 2.5), 
               linetype = "dashed") + 
  geom_segment(aes(x=0.5, xend = 5.5, y=0.5, yend = 0.5), size=1,
               arrow = arrow(length = unit(0.2,"cm"))) + 
  geom_segment(aes(x=0.5, xend = 0.5, y=0.5, yend = 4.5), size=1,
               arrow = arrow(length = unit(0.2,"cm"))) + 
  annotate("text", label = "1", x = 0.3, y = 2.5)

ggsave(plot = biv_final_5, filename = "biv_map_5.png", 
       dpi = 300, width = 10, height = 6.18)