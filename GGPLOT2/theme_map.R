# copied and pasted from
# https://timogrossenbacher.ch/2019/04/bivariate-maps-with-ggplot2-and-sf/

default_font_color <- "#4e4d47"
default_background_color <- "#f5f5f2"
#default_font_family <- "Arial"

theme_map <- function(...) {
  theme_minimal() +
    theme(
      text = element_text(family = default_font_family,
                          color = default_font_color),
      # remove all axes
      axis.line = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks = element_blank(),
      # add a subtle grid
      panel.grid.major = element_blank(),
      #element_line(color = "#dbdbd9", size = 0.2),
      panel.grid.minor = element_blank(),
      # background colors
      plot.background = element_rect(fill = default_background_color,
                                     color = NA),
      panel.background = element_rect(fill = default_background_color,
                                      color = NA),
      legend.background = element_rect(fill = default_background_color,
                                       color = NA),
      # borders and margins
      #plot.margin = unit(c(.5, .5, .2, .5), "cm"),
      panel.border = element_blank(),
      #panel.spacing = unit(c(-.1, 0.2, .2, 0.2), "cm"),
      # titles
      legend.title = element_text(size = 16),
      legend.text = element_text(size = 14, hjust = 0,
                                 color = default_font_color),
      plot.title = element_text(size = 20, hjust = 0.5,
                                margin = margin(t = 0.1, b = 0., unit = "cm"),
                                color = default_font_color),
      plot.subtitle = element_text(size = 14, hjust = 0.5,
                                   color = default_font_color,
                                   margin = margin(b = 0,
                                                   t = 0.2,
                                                   l = 2,
                                                   unit = "cm"),
                                   debug = F),
      # captions
      plot.caption = element_text(size = 14,
                                  hjust = .5,
                                  margin = margin(t = 0.2,
                                                  b = 0,
                                                  unit = "cm"),
                                  color = default_font_color),
      ...
    )
}
