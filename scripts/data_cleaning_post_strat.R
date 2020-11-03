#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from IPUMS for the ACS 
# Author: Rebecca Yang
# Data: Nov 2 2020
# Contact: reb.yang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data


library(haven)
library(tidyverse)

# Read in the raw data 
raw_post <- read_dta("inputs/data/usa_00002.dta")
raw_post <- labelled::to_factor(raw_post)  # labeling columns 



# selecting desired variables 
post_strat_data <- 
  raw_post[,c(7, 11:15, 17, 21, 22, 24)] 

# First, we are only interested in potential voters - citizens 18+
# grouping citizens 
post_strat_data$citizen <- fct_collapse(post_strat_data$citizen, 
                                        yes = levels(post_strat_data$citizen)[1:3],
                                        no = levels(post_strat_data$citizen)[4:6]
)

post_strat_data <- post_strat_data %>% filter(citizen == "yes") 

# creating age groups
post_strat_data <- post_strat_data %>% 
  mutate(age = as.numeric(age), 
         age_group = as.character(cut(age,  
                                      breaks = c(-Inf, 18, 30, 45, 60, Inf),
                                      labels = c("Under 18", "18-29", "30-44", "45-59", "60+"), 
                                      right = FALSE)),
         income = case_when(
           inctot < 50000 ~ "<50K",
           inctot > 50000 & inctot <= 150000 ~ "50-150K",
           inctot > 150000 ~ ">150K"),
         income = as.factor(income)
         ) %>%
  filter(age_group != "Under 18") %>% 
  rename(education = educ,
         state_full = stateicp)  # renaming education
         

# adding state abbreviations
post_strat_data <- left_join(post_strat_data, state_names) 

# consider 4 years college ~ BA 
post_strat_data$education <- fct_collapse(post_strat_data$education, 
                               `<BA` = levels(post_strat_data$education)[1:10],
                               BA = levels(post_strat_data$education)[11],
                               `>BA` = levels(post_strat_data$education)[12]
)

# Grouping together races into broader categories 
post_strat_data$race <- fct_collapse(post_strat_data$race, 
                                     White = levels(post_strat_data$race)[1],
                                     Black = levels(post_strat_data$race)[2],
                                     `American Indian/Alaska Native` = levels(post_strat_data$race)[3],
                                     `Asian/Pacific Islander` = levels(post_strat_data$race)[4:6],
                                     Other = levels(post_strat_data$race)[6:9]
)

post_strat_data <- post_strat_data %>% mutate(education = fct_relevel(education, 
                                                  "<BA", "BA", ">BA"), 
                          income = fct_relevel(income, "<50K", "50-150K", ">150K"))

# creating post stratification cell counts 
post_strat_cell_counts <- post_strat_data %>% 
  group_by(age_group, state, education, race, sex, income) %>% 
  summarise(n = sum(perwt)) %>% # weighted cell counts 
  ungroup() %>% 
  mutate(total_prop = n/sum(n)) %>%
  group_by(state) %>% 
  mutate(state_prop = n/sum(n))  %>% # proportion of state
  ungroup() 


rm(raw_post) 
rm(post_strat_data)




