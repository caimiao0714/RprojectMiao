load("sdat.Rdata")

require(tidyverse)
guess_encoding(charToRaw(sdat$p102[3]))

sdat = mutate_if(is.factor, as.character) %in%
	map(~parse_character(., locale = locale(encoding = "UTF-8"))) %>% 
	as_tibble()
