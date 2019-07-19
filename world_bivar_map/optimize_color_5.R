# Shape file downloaded from: 
# https://hub.arcgis.com/datasets/a21fdb46d23e4ef896f31475217cbb08_1/data
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
bivariate_color_scale_5 = tibble(
  group = paste(rep(1:5, 5), rep(5:1, each = 5), sep = " - "),
  fill = c("#AE3A4E", "#92364D", "#77324C", "#5B2D4A", "#3F2949", 
           "#BC7C8F", "#9E738D", "#806A8A", "#626088", "#445785",
           "#CABED0", "#AAB0CC", "#89A2C9", "#6993C5", "#4885C1", 
           "#E6E15F", "#B7C764", "#89AD6A", "#5A926F", "#2B7874",
           "#F1EE35", "#B5CC28", "#79A91B", "#3C870D", "#006400")
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

# 06. merge original data with color scheme
quantile_s = s  %>% 
  mutate(sdi_quantiles = cut(sdi, breaks = quantiles_sdi, 
                             include.lowest = TRUE),
         OOE_quantiles = cut(OOE, breaks = quantiles_OOE, 
                             include.lowest = TRUE),
         group = paste(as.numeric(sdi_quantiles), "-", 
                       as.numeric(OOE_quantiles))) %>%
  left_join(bivariate_color_scale_5, by = "group")

# 07. Bivariate map
biv_map_5 = quantile_s %>% 
  ggplot() +
  geom_sf(aes(fill = fill), color = "white", size = 0.1) +
  scale_fill_identity() +
  labs(x = NULL, y = NULL,
       title = "Global bivariate map of SDI and OOE",
       subtitle = paste0("This is an awesome subtitle"),
       caption = "This is a default caption") +
  theme_map()

# 08. Combine bivariate map and bivariate legend
biv_final_5 = ggdraw() +
  draw_plot(biv_map_5, 0, 0, 1, 1) +
  draw_plot(biv_legend_5, 0.05, 0.2, 0.2, 0.2)
biv_final_5

# 09. Save the combined plot
ggsave(plot = biv_final_5, filename = "biv_map_5_top.png", 
       dpi = 300, width = 10, height = 6.18)

