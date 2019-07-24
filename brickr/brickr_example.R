devtools::install_github("ryantimpe/brickr")
pacman::p_load(brickr, jpeg, dplyr)

mosaic1 <- jpeg::readJPEG("brickr/pics/Miao IMG_20180517_170540_947.jpg") %>%
  image_to_bricks(img_size = 100)

mosaic1 %>% display_set()


# Ziqi
mosaic1 <- png::readPNG("brickr/pics/Ziqi.PNG") %>%
  image_to_bricks(img_size = 70)
mosaic1 %>% display_set()
ggplot2::ggsave("brickr/Ziqi.jpg", width = 10, height = 10, dpi = 300)

mosaic1 <- jpeg::readJPEG("brickr/pics/mmexport1503618215460.jpg") %>%
  image_to_bricks(img_size = 100)
mosaic1 %>% display_set()
ggplot2::ggsave("brickr/img0.jpg", width = 10, height = 10, dpi = 300)



# SF
mosaic1 <- jpeg::readJPEG("brickr/pics/IMG_20190308_170034.jpg") %>%
  image_to_bricks(img_size = 70)
mosaic1 %>% display_set()
ggplot2::ggsave("brickr/SF_spiderman.jpg", width = 10, height = 10, dpi = 300)

# s
mosaic1 <- jpeg::readJPEG("brickr/pics/mmexport1556124875967.jpg") %>%
  image_to_bricks(img_size = 70)
mosaic1 %>% display_set()
ggplot2::ggsave("brickr/s.jpg", width = 10, height = 10, dpi = 300)

# caomeixiong
mosaic1 <- jpeg::readJPEG("brickr/pics/IMG_20190512_230132.jpg") %>%
  image_to_bricks(img_size = 70)
mosaic1 %>% display_set()
ggplot2::ggsave("brickr/caomeixiong.jpg", width = 10, height = 10, dpi = 300)

# 5bbs
mosaic1 <- jpeg::readJPEG("brickr/pics/WeChat Image_20190723212249.jpg") %>%
  image_to_bricks(img_size = 70)
mosaic1 %>% display_set()
ggplot2::ggsave("brickr/5bbs.jpg", width = 10, height = 10, dpi = 300)



