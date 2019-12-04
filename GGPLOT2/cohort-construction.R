pacman::p_load(dplyr, ggplot2, lubridate, pBrackets, grid)

bracketsGrob <- function(...){
  l <- list(...)
  e <- new.env()
  e$l <- l
  grid:::recordGrob(  {
    do.call(grid.brackets, l)
  }, e)
}

b1 <- bracketsGrob(0.33, 0.7, 0.05, 0.7, h=0.05, lwd=2, col="#018571")
b2 <- bracketsGrob(0.9, 0.7, 0.34, 0.7, h=0.05,  lwd=2, col="#a6611a")

ggplot() +
  geom_segment(data = data.frame(start_time = 2003, end_time = 2008),
               aes(x = start_time, xend = end_time, y = 0, yend = 0),
               size = 0.8, color = "#018571", linetype = "dashed") +
  geom_segment(data = data.frame(start_time = 2008, end_time = 2018),
               aes(x = start_time, xend = end_time, y = 0, yend = 0),
               arrow = arrow(length = unit(0.2, "cm")),
               lineend = 'butt', size = 1, color = "black") +
  geom_point(aes(x = 2003, y = 0)) +
  geom_point(aes(x = 2008, y = 0)) +
  geom_point(aes(x = 2013, y =0), shape = 4, color = 'red', size = 5) +
  annotate("text", x = 2003, y = -0.05, family = "Times",
           label = latex2exp::TeX("2003", output="character"),
           hjust = 0.5, size = 4, parse = TRUE)+
  annotate("text", x = 2008, y = -0.05, family = "Times",
           label = latex2exp::TeX("T_0 = 2008", output="character"),
           hjust = 0.5, size = 4, parse = TRUE) +
  annotate("text", x = 2013, y = -0.05, color = "red", family = "Times",
           label = latex2exp::TeX("Amputation", output="character"),
           hjust = 0.5, size = 4, parse = TRUE) +
  annotate("text", x = 2018, y = -0.05, family = "Times",
           label = latex2exp::TeX("T_{end} = 2018", output="character"),
           hjust = 0.5, size = 4, parse = TRUE) +
  annotate("text", x = 2005.5, y = -0.18, family = "Times", color = "#018571",
           label = latex2exp::TeX("Baseline", output="character"),
           hjust = 0.5, size = 4, parse = TRUE) +
  annotate("text", x = 2013, y = -0.18, family = "Times", color = "#a6611a",
           label = latex2exp::TeX("Follow-up (N = 6,227,383)", output="character"),
           hjust = 0.5, size = 4, parse = TRUE) +
  annotate("text", x = 2003, y = -0.28, family = "Times", #color = "#018571",
           label = latex2exp::TeX("Inclusion and exclusion criteria:",
                                  output="character"),
           hjust = 0, size = 4, parse = TRUE) +
  annotate("text", x = 2003, y = -0.4, family = "Times", #color = "#018571",
           label = latex2exp::TeX("- At least one encounter at VHA one year before T_0,",  output="character"),
           hjust = 0, size = 4, parse = TRUE) +
  annotate("text", x = 2003, y = -0.47, family = "Times", #color = "#018571",
           label = latex2exp::TeX("- Interaction with VHA for at least 1 year,",  output="character"),
           hjust = 0, size = 4, parse = TRUE) +
  annotate("text", x = 2003, y = -0.54, family = "Times", #color = "#018571",
           label = latex2exp::TeX("- No amputation or death before T_0.",
                                  output = "character"),
           hjust = 0, size = 4, parse = TRUE) +
  ylim(c(-0.8, 0.2)) + xlim(c(2003, 2019)) +
  annotation_custom(b1)+
  annotation_custom(b2) +
  theme_void() +
  theme(legend.justification = c(1, 1), legend.position = "none", #c(0.75, 0.99),
        legend.direction="horizontal", text=element_text(family="Times"),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank())

ggsave("Plot - ggplot2/cohort_construction.png", width = 8, height = 3.2, dpi = 300)
