## Procuces an animation showing how weighted basis functions combine to produce a sline
##  - this version is for a cubic regression spline basis
pacman::p_load(ggplot2, tibble, tidyr, dplyr, mgcv, mvnfast,
               purrr, gganimate, gifski, transformr, png)
theme_set(theme_minimal())

##' wrapper around mvnfast::rmvn for coefs for basis functions
##'
##' @param n numeric, number of draws from MVN
##' @param k numeric, number of basis functions in basis
##' @param mu, sigma numeric vectors of means and **variances** for $\beta$
draw_beta <- function(n, k, mu = 1, sigma = 1) {
  mvnfast::rmvn(n = n, mu = rep(mu, k), sigma = diag(rep(sigma, k)))
}

##' Given a set of basis functions evaluated at `x`, weight them by coefs
##'
##' @param bf matrix od basis functions evaluated at `x`
##' @param x covariate values used to evaluated basis
##' @param n numeric, number of draws from MVN; probably should be 1
##' @param k, numeric; number of basis functions
##' @param ... additional arguments passed to `draw_beta`
weight_basis <- function(bf, x, n = 1, k, ...) {
  beta <- draw_beta(n = n, k = k, ...)
  out <- sweep(bf, 2L, beta, '*')
  colnames(out) <- paste0('f', seq_along(beta))
  out <- as_tibble(out)
  out <- add_column(out, x = x)
  out <- pivot_longer(out, -x, names_to = 'bf', values_to = 'y')
  out
}

##' Generate a set of draws from prior of a spline
##'
##' @param bf matrix of basis functions evaluated at `x`
##' @param x covariate values at which basis was evaluated
##' @param draws numeric; how many draws from the prior to make
##' @param k numeric; number of basis functions in basis
##' @param ... arguments passed to `weight_basis` and then on to `draw_beta`
random_bases <- function(bf, x, draws = 10, k, ...) {
  out <- rerun(draws, weight_basis(bf, x = x, k = k, ...))
  out <- bind_rows(out)
  out <- add_column(out, draw = rep(seq_len(draws), each = length(x) * k),
                    .before = 1L)
  class(out) <- c("random_bases", class(out))
  out
}

##' Plot method butchery for a set of draws
##'
##' Use `facet = FALSE` for animations
plot.random_bases <- function(x, facet = FALSE) {
  plt <- ggplot(x, aes(x = x, y = y, colour = bf)) +
    geom_line(lwd = 1) +
    guides(colour = FALSE)
  if (facet) {
    plt + facet_wrap(~ draw)
  }
  plt
}

## generate some data/covariate values to work with
set.seed(1)
N <- 500
data <- tibble(x = runif(N))

## Generate the basis
k <- 10 # number of basis functions
## CRS needs knot locations given `k`, arrange evenly over `x`
knots <- with(data, list(x = seq(min(x), max(x), length = k)))
## generate a CRS basis using *mgcv* evaluated at `x`
sm <- smoothCon(s(x, k = k, bs = "cr"), data = data, knots = knots)[[1]]$X
colnames(sm) <- levs <- paste0("f", seq_len(k))
## convert to tidy form
basis <- pivot_longer(cbind(sm, data), -x, names_to = 'bf')
basis

## generate draws from basis functions
set.seed(2)
bfuns <- random_bases(sm, data$x, draws = 20, k = k)

## given draws from basis functions & random betas, summarise
## to a spline for each draw
smooth <- bfuns %>%
  group_by(draw, x) %>%
  summarise(spline = sum(y)) %>%
  ungroup()

## base plot for animation
p <- plot(bfuns) + geom_line(data = smooth, aes(x = x, y = spline),
                             inherit.aes = FALSE, lwd = 1.5)

## animate
animate(
  p + transition_states(draw, transition_length = 4, state_length = 2) +
    ease_aes('cubic-in-out'),
  nframes = 200)

anim_save("animated_GAM.gif", animation = last_animation())