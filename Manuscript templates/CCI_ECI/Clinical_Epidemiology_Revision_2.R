pacman::p_load(boot)

boot_c = function(dt, ind){
  boot_fit = glm(outcome ~ ., data = dt[ind,], family = "binomial")
  DescTools::Cstat(boot_fit)
}


# --------- 1. CHF --------- 
load(".\\Data\\CHF20171204.Rdata")

CHF0 = cleandat(CHF20171204)
CHF_cci = fun_com(CHF20171204, "cci")
CHF_eci = fun_com(CHF20171204, "eci")
CHF_cciquan = fun_com(CHF20171204, "cci_quan")
CHF_Walraven = fun_com(CHF20171204, "Walraven")
CHF_Moore = fun_com(CHF20171204, "Moore")

set.seed(123)
CHF_baseline = CHF0 %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CHF_cci = cbind(CHF0, CHF_cci) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CHF_eci = cbind(CHF0, CHF_eci) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CHF_cciquan = cbind(CHF0, CHF_cciquan) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CHF_Walraven = cbind(CHF0, CHF_Walraven) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CHF_Moore = cbind(CHF0, CHF_Moore) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())



saveRDS(list(CHF_baseline = CHF_baseline, 
             CHF_cciquan = CHF_cciquan,
             CHF_Walraven = CHF_Walraven,
             CHF_Moore = CHF_Moore,
             CHF_cci = CHF_cci,
             CHF_eci = CHF_eci), 
        "Clinical Epidemiology/2nd review/fit/1_CHF_c_bootstrap.rds")



# --------- 2. CRF --------- 
load(".\\Data\\CRF20171204.Rdata")

CRF0 = cleandat(CRF20171204)

CRF_cci = fun_com(CRF20171204, "cci")
CRF_eci = fun_com(CRF20171204, "eci")
CRF_cciquan = fun_com(CRF20171204, "cci_quan")
CRF_Walraven = fun_com(CRF20171204, "Walraven")
CRF_Moore = fun_com(CRF20171204, "Moore")

set.seed(123)
CRF_baseline = CRF0 %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CRF_cci = cbind(CRF0, CRF_cci) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CRF_eci = cbind(CRF0, CRF_eci) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CRF_cciquan = cbind(CRF0, CRF_cciquan) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CRF_Walraven = cbind(CRF0, CRF_Walraven) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

CRF_Moore = cbind(CRF0, CRF_Moore) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

saveRDS(list(CRF_baseline = CRF_baseline, 
             CRF_cciquan = CRF_cciquan,
             CRF_Walraven = CRF_Walraven,
             CRF_Moore = CRF_Moore,
             CRF_cci = CRF_cci,
             CRF_eci = CRF_eci), 
        "Clinical Epidemiology/2nd review/fit/2_CRF_c_bootstrap.rds")




# --------- 3. DIA --------- 
load(".\\Data\\DIA20171204.Rdata")

DIA0 = cleandat(DIA20171204)

DIA_cci = fun_com(DIA20171204, "cci")
DIA_eci = fun_com(DIA20171204, "eci")
DIA_cciquan = fun_com(DIA20171204, "cci_quan")
DIA_Walraven = fun_com(DIA20171204, "Walraven")
DIA_Moore = fun_com(DIA20171204, "Moore")

set.seed(123)
DIA_baseline = DIA0 %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

DIA_cci = cbind(DIA0, DIA_cci) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

DIA_eci = cbind(DIA0, DIA_eci) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

DIA_cciquan = cbind(DIA0, DIA_cciquan) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

DIA_Walraven = cbind(DIA0, DIA_Walraven) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

DIA_Moore = cbind(DIA0, DIA_Moore) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

saveRDS(list(DIA_baseline = DIA_baseline, 
             DIA_cciquan = DIA_cciquan,
             DIA_Walraven = DIA_Walraven,
             DIA_Moore = DIA_Moore,
             DIA_cci = DIA_cci,
             DIA_eci = DIA_eci), 
        "Clinical Epidemiology/2nd review/fit/3_DIA_c_bootstrap.rds")





# --------- 4. PCI --------- 
load(".\\Data\\PCI20171204.Rdata")

PCI0 = cleandat(PCI20171204)

PCI_cci = fun_com(PCI20171204, "cci")
PCI_eci = fun_com(PCI20171204, "eci")
PCI_cciquan = fun_com(PCI20171204, "cci_quan")
PCI_Walraven = fun_com(PCI20171204, "Walraven")
PCI_Moore = fun_com(PCI20171204, "Moore")

set.seed(123)
PCI_baseline = PCI0 %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

PCI_cci = cbind(PCI0, PCI_cci) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

PCI_eci = cbind(PCI0, PCI_eci) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

PCI_cciquan = cbind(PCI0, PCI_cciquan) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

PCI_Walraven = cbind(PCI0, PCI_Walraven) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

PCI_Moore = cbind(PCI0, PCI_Moore) %>% 
  select(-visit_name) %>%
  boot(data = ., boot_c, R = 1000, parallel = "multicore", ncpus = parallel::detectCores())

saveRDS(list(PCI_baseline = PCI_baseline, 
             PCI_cciquan = PCI_cciquan,
             PCI_Walraven = PCI_Walraven,
             PCI_Moore = PCI_Moore,
             PCI_cci = PCI_cci,
             PCI_eci = PCI_eci), 
        "Clinical Epidemiology/2nd review/fit/4_PCI_c_bootstrap.rds")



# ------------ Get CIs -------------
pacman::p_load(dplyr, ggplot2, ggthemes)
CHF = readRDS("Clinical Epidemiology/2nd review/fit/1_CHF_c_bootstrap.rds")
CRF = readRDS("Clinical Epidemiology/2nd review/fit/2_CRF_c_bootstrap.rds")
DIA = readRDS("Clinical Epidemiology/2nd review/fit/3_DIA_c_bootstrap.rds")
PCI = readRDS("Clinical Epidemiology/2nd review/fit/4_PCI_c_bootstrap.rds")

getbot = function(dt, cohort_name){
  d = dplyr::bind_rows(quantile(dt[[1]]$t, c(0.5, 0.025, 0.975)),
                       quantile(dt[[2]]$t, c(0.5, 0.025, 0.975)),
                       quantile(dt[[3]]$t, c(0.5, 0.025, 0.975)),
                       quantile(dt[[4]]$t, c(0.5, 0.025, 0.975)),
                       quantile(dt[[5]]$t, c(0.5, 0.025, 0.975)),
                       quantile(dt[[6]]$t, c(0.5, 0.025, 0.975))) %>% 
    mutate(`Disease cohorts` = cohort_name,
           `Variable sets` = c("sociodemographic (baseline)", "socio + Quan (2011)", "socio + van Walraven (2009)",
                   "socio + Moore (2017)", "socio + 17 Charlson", "socio + 30 Elixhauser")) %>% 
    mutate(`Variable sets` = factor(`Variable sets`,
            levels = c("sociodemographic (baseline)", "socio + Quan (2011)", "socio + van Walraven (2009)",
                       "socio + Moore (2017)", "socio + 17 Charlson", "socio + 30 Elixhauser")))
    
  return(d)
}

boot_c = bind_rows(getbot(CHF, "CHF"),
                   getbot(CRF, "CRF"),
                   getbot(DIA, "Diabetes"),
                   getbot(PCI, "PCI")) %>% 
  mutate(`Disease cohorts` = factor(`Disease cohorts`))

boot_c %>% 
  ggplot(aes(x = `Disease cohorts`, 
             y = `50%`, 
             fill = `Variable sets`)) + 
  geom_bar(stat = "identity", 
           width = 0.75, 
           position=position_dodge())  + 
  scale_fill_manual(values = c('#D6D6D6','#DAA520', '#1e656d', 
                               '#228B22', '#FF8247', '#FF0000')) +
  geom_errorbar(aes(ymin = `2.5%`, 
                    ymax = `97.5%`),
                position = position_dodge(width = 0.75), 
                colour="black", width = 0.3, alpha = 0.3)+
  scale_y_continuous(expand = c(0, 0)) +
  coord_cartesian(ylim = c(0.5, 1)) +
  labs(y = "C-statistics", 
       caption = "The error bars are 95% confidence intervals calculated by 1,000 bootstrap replications") +
  theme_few() + 
  theme()

set_width = 8
ggsave("Clinical Epidemiology/2nd review/fig1.eps", width = set_width, height = set_width*0.618)
ggsave("Clinical Epidemiology/2nd review/fig1.pdf", width = set_width, height = set_width*0.618)
ggsave("Clinical Epidemiology/2nd review/fig1.png", width = set_width, height = set_width*0.618, dpi = 600)



# reporting C-statistics
pad_num = function(x) return(stringr::str_pad(round(x, 3), 5, "right", "0"))

bind_cols(
  getbot(CHF, "CHF") %>% 
    select(`Variable sets`),
  getbot(CHF, "CHF") %>%
    mutate(CHF = paste0(pad_num(`50%`), " (", 
                        pad_num(`2.5%`), ", ", 
                        pad_num(`97.5%`), ")")) %>% 
    select(CHF),
  getbot(CRF, "CRF") %>%
    mutate(CRF = paste0(pad_num(`50%`), " (", 
                        pad_num(`2.5%`), ", ", 
                        pad_num(`97.5%`), ")")) %>% 
    select(CRF),
  getbot(DIA, "Diabetes") %>%
    mutate(DIA = paste0(pad_num(`50%`), " (", 
                        pad_num(`2.5%`), ", ", 
                        pad_num(`97.5%`), ")")) %>% 
    select(DIA),
  getbot(PCI, "PCI") %>%
    mutate(PCI = paste0(pad_num(`50%`), " (", 
                        pad_num(`2.5%`), ", ", 
                        pad_num(`97.5%`), ")")) %>% 
    select(PCI)
) %>% 
  readr::write_csv("Clinical Epidemiology/2nd review/report_c_statistics.csv")
