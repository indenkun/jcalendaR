library(tidyverse)
library(jsonlite)

gregorian_kyureki_calender <- read_tsv("https://raw.githubusercontent.com/manakai/data-locale/master/data/calendar/kyuureki-map.txt",
                                       col_names = c("gregorian_calender", "kyureki_calender"))
gregorian_jdn_calender <- read_tsv("https://raw.githubusercontent.com/manakai/data-locale/master/data/calendar/map-jd-gregorian.txt",
                                   col_names = c("JDN", "gregorian_calender"))
gregorian_kyureki_JDN <- full_join(gregorian_kyureki_calender, gregorian_jdn_calender) %>%
  na.omit() %>%
  filter(JDN >= JDN[kyureki_calender == "0001-01-01"])

era.jsondata <- fromJSON("https://raw.githubusercontent.com/manakai/data-locale/master/data/calendar/era-systems.json")

# era_default <- data.frame(era.jsondata[["systems"]][["jp"]]) %>%
#   rename(JDN = 2, era_name = 3) %>%
#   mutate(JDN = as.numeric(JDN) + 0.5) %>%
#   select(JDN, era_name) %>%
#   left_join(gregorian_kyureki_JDN) %>%
#   na.omit() %>%
#   mutate(gregorian_year = as.numeric(str_split(gregorian_calender, pattern = "-", simplify = TRUE)[,1]),
#          kyureki_year = as.numeric(str_split(kyureki_calender, pattern = "-", simplify = TRUE)[,1])) %>%
#   select(JDN, era_name, gregorian_year, kyureki_year)

era_east <- data.frame(era.jsondata[["systems"]][["jp-east"]])%>%
  rename(JDN = 2, era_name = 3) %>%
  mutate(JDN = as.numeric(JDN) + 0.5) %>%
  select(JDN, era_name) %>%
  left_join(gregorian_kyureki_JDN) %>%
  na.omit() %>%
  mutate(gregorian_year = as.numeric(str_split(gregorian_calender, pattern = "-", simplify = TRUE)[,1]),
         kyureki_year = as.numeric(str_split(kyureki_calender, pattern = "-", simplify = TRUE)[,1])) %>%
  select(JDN, era_name, gregorian_year, kyureki_year)

era_heishi <- data.frame(era.jsondata[["systems"]][["jp-heishi"]])%>%
  rename(JDN = 2, era_name = 3) %>%
  mutate(JDN = as.numeric(JDN) + 0.5) %>%
  select(JDN, era_name) %>%
  left_join(gregorian_kyureki_JDN) %>%
  na.omit() %>%
  mutate(gregorian_year = as.numeric(str_split(gregorian_calender, pattern = "-", simplify = TRUE)[,1]),
         kyureki_year = as.numeric(str_split(kyureki_calender, pattern = "-", simplify = TRUE)[,1])) %>%
  select(JDN, era_name, gregorian_year, kyureki_year)

era_kyoto <- data.frame(era.jsondata[["systems"]][["jp-kyoto"]])%>%
  rename(JDN = 2, era_name = 3) %>%
  mutate(JDN = as.numeric(JDN) + 0.5) %>%
  select(JDN, era_name) %>%
  left_join(gregorian_kyureki_JDN) %>%
  na.omit() %>%
  mutate(gregorian_year = as.numeric(str_split(gregorian_calender, pattern = "-", simplify = TRUE)[,1]),
         kyureki_year = as.numeric(str_split(kyureki_calender, pattern = "-", simplify = TRUE)[,1])) %>%
  select(JDN, era_name, gregorian_year, kyureki_year)

era_north <- data.frame(era.jsondata[["systems"]][["jp-north"]])%>%
  rename(JDN = 2, era_name = 3) %>%
  mutate(JDN = as.numeric(JDN) + 0.5) %>%
  select(JDN, era_name) %>%
  left_join(gregorian_kyureki_JDN) %>%
  na.omit() %>%
  mutate(gregorian_year = as.numeric(str_split(gregorian_calender, pattern = "-", simplify = TRUE)[,1]),
         kyureki_year = as.numeric(str_split(kyureki_calender, pattern = "-", simplify = TRUE)[,1])) %>%
  select(JDN, era_name, gregorian_year, kyureki_year)

era_south <- data.frame(era.jsondata[["systems"]][["jp-south"]])%>%
  rename(JDN = 2, era_name = 3) %>%
  mutate(JDN = as.numeric(JDN) + 0.5) %>%
  select(JDN, era_name) %>%
  left_join(gregorian_kyureki_JDN) %>%
  na.omit() %>%
  mutate(gregorian_year = as.numeric(str_split(gregorian_calender, pattern = "-", simplify = TRUE)[,1]),
         kyureki_year = as.numeric(str_split(kyureki_calender, pattern = "-", simplify = TRUE)[,1])) %>%
  select(JDN, era_name, gregorian_year, kyureki_year)

# era_ryukyu <- data.frame(era.jsondata[["systems"]][["ryuukyuu"]])%>%
#   rename(JDN = 2, era_name = 3) %>%
#   mutate(JDN = as.numeric(JDN) + 0.5) %>%
#   select(JDN, era_name) %>%
#   left_join(gregorian_kyureki_JDN)

kyureki_JDN <- gregorian_kyureki_JDN %>%
  # filter(JDN <= JDN[gregorian_calender == "1872-12-31"]) %>%
  mutate(kyureki_year = as.numeric(str_split(kyureki_calender, pattern = "-", simplify = T)[,1]),
         kyureki_month = str_split(kyureki_calender, pattern = "-", simplify = T)[,2],
         kyureki_day = as.numeric(str_split(kyureki_calender, pattern = "-", simplify = T)[,3])) %>%
  filter(kyureki_day == 1) %>%
  mutate(leap_month = if_else(str_detect(kyureki_month, pattern = "'"), as.numeric(str_remove(kyureki_month, pattern = "'")), 0)) %>%
  mutate(kyureki_month = if_else(str_detect(kyureki_month, pattern = "'"), "month_13", paste0("month_", kyureki_month)),
         leap_month = na_if(leap_month, 0)) %>%
  select(-c(gregorian_calender, kyureki_calender, kyureki_day))

kyureki_JDN_1 <- kyureki_JDN %>%
  pivot_wider(id_cols = kyureki_year, names_from = kyureki_month, values_from = JDN)

kyureki_JDN <- kyureki_JDN %>%
  na.omit() %>%
  select(kyureki_year, leap_month) %>%
  right_join(kyureki_JDN_1) %>%
  arrange(kyureki_year)

# for(i in 1:nrow(kyureki_JDN)) kyureki_JDN[i,] <- c(kyureki_JDN[i,][1:2], arrange(kyureki_JDN[i,][3:15]))

for(i in 1:nrow(kyureki_JDN)) kyureki_JDN[i,] <- c(kyureki_JDN[i,][1:2],kyureki_JDN[i,][3:15][order(kyureki_JDN[i,][3:15])])

kyureki_JDN <- kyureki_JDN[order(kyureki_JDN$kyureki_year),]

rm(i, era.jsondata,kyureki_JDN_1,gregorian_jdn_calender,gregorian_kyureki_calender,gregorian_kyureki_JDN)

usethis::use_data(era_east, era_heishi, era_kyoto, era_north, era_south, kyureki_JDN, internal = TRUE, overwrite = TRUE)
