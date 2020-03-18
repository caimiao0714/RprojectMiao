pacman::p_load(icd, dplyr, tableone)
Sys.setlocale("Chinese")
Sys.setlocale(category="LC_ALL",locale="chinese")

add_comma <- function(pt1) {
  require(stringr)
  pt1_out <- pt1
  for(i in 1:ncol(pt1)) {
    cur_column <- pt1[, i]
    num_after <- str_extract(cur_column, '[0-9.]+\\b') %>% 
      as.numeric %>% comma %>% str_replace('(\\.00|NA)', '') %>% trimws
    pt1_out[, i] <- str_replace(string=pt1_out[, i], pattern='[0-9.]+\\b', replacement=num_after)
  }
  return(pt1_out)
}


#*************************#
#*** stratify table 1  ***#
#*************************#
# CHF
CreateTableOne(var = c("female", "age", "marriage", "occupation",
                       "los_quart", "hlevel", "cci_quan", "Walraven", "Moore"),
               data = cbind(CHF0, CHF_cciquan, CHF_Walraven, CHF_Moore),
               strata = "outcome") %>% 
  print(printToggle = FALSE) %>% 
  as.data.frame() %>% 
  rownames_to_column("variable") %>% 
  write_csv("Clinical Epidemiology/First review/tables/tab1_CHF.csv")

# CRF
CreateTableOne(var = c("female", "age", "marriage", "occupation",
                       "los_quart", "hlevel", "cci_quan", "Walraven", "Moore"),
               data = cbind(CRF0, CRF_cciquan, CRF_Walraven, CRF_Moore),
               strata = "outcome") %>% 
  print(printToggle = FALSE) %>% 
  as.data.frame() %>% 
  rownames_to_column("variable") %>% 
  write_csv("Clinical Epidemiology/First review/tables/tab1_CRF.csv")

# Diabetes
CreateTableOne(var = c("female", "age", "marriage", "occupation",
                       "los_quart", "hlevel", "cci_quan", "Walraven", "Moore"),
               data = cbind(DIA0, DIA_cciquan, DIA_Walraven, DIA_Moore),
               strata = "outcome") %>% 
  print(printToggle = FALSE) %>% 
  as.data.frame() %>% 
  rownames_to_column("variable") %>% 
  write_csv("Clinical Epidemiology/First review/tables/tab1_DIA.csv")

# PCI
CreateTableOne(var = c("female", "age", "marriage", "occupation",
                       "los_quart", "hlevel", "cci_quan", "Walraven", "Moore"),
               data = cbind(PCI0, PCI_cciquan, PCI_Walraven, PCI_Moore),
               strata = "outcome") %>% 
  print(printToggle = FALSE) %>% 
  as.data.frame() %>% 
  rownames_to_column("variable") %>% 
  write_csv("Clinical Epidemiology/First review/tables/tab1_PCI.csv")