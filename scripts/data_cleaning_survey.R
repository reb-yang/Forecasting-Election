#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from Nationscape survey 
# Author: Rebecca Yang 
# Data: Nov 2 2020
# Contact: reb.yang@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the data from X and save the folder that you're 
# interested in to inputs/data 
# - Don't forget to gitignore it!

#### Workspace setup ####
library(haven)
library(tidyverse)
library(forcats)
library(dplyr)
# Read in the raw data 
raw_data <- read_dta("inputs/data/ns20200625/ns20200625.dta")

# Add the labels
raw_data <- labelled::to_factor(raw_data)

# Just keep some variables
reduced_data <- 
  raw_data %>% 
  select(vote_intention,
         vote_2020,
         vote_2020_lean,
         ideo5,
         employment,
         gender,
         race_ethnicity,
         household_income,
         education,
         state,
         age)


data <- reduced_data %>%     
  mutate(vote = ifelse(               # creating vote variable by combining likely and leaning votes
    vote_2020 == "I am not sure/don't know",       # coding Trump = 0 , Biden = 1
    levels(vote_2020_lean)[vote_2020_lean], 
    levels(vote_2020)[vote_2020]),
    vote = case_when(vote == "Donald Trump" ~ 0,
                     vote == "Joe Biden" ~ 1),
    age_group = as.character(cut(age,  # creating age groups
                      breaks = c(18, 30, 45, 60, Inf),
                      labels = c("18-29", "30-44", "45-59", "60+"), 
                      right = FALSE))
    ) %>% 
  filter(!is.na(vote))   # focusing on Trump and Biden

data$vote_intention <- fct_collapse(data$vote_intention,
                                    `Yes/Not sure` = levels(data$vote_intention)[1],
                                    No = levels(data$vote_intention)[2:4])

data <- data %>%
  mutate(vote_intention = case_when(vote_intention == "Yes/Not sure" ~ 1,
                   vote_intention == "No" ~ 0 )) 

# grouping education into less than BA, BA, higher than BA                               
data$education <- fct_collapse(data$education, 
             `<BA` = levels(data$education)[1:7],
             BA = levels(data$education)[8],
             `>BA` = levels(data$education)[9:11]
             )

data$race_ethnicity <- fct_collapse(data$race_ethnicity, 
                                    Black = levels(data$race_ethnicity)[2],
                                    `American Indian/Alaska Native` = levels(data$race_ethnicity)[3],
                                    `Asian/Pacific Islander` = levels(data$race_ethnicity)[4:14],
                                    Other = levels(data$race_ethnicity)[15])

data$income <- fct_collapse(data$household_income,
                            `<50K` = levels(data$household_income)[1:8],
                            `50-150K` = levels(data$household_income)[9:20],
                            `>150K` = levels(data$household_income)[21:24]
                            )



survey_data <-  data %>% rename(sex = gender, race = race_ethnicity) %>% 
  mutate(sex = tolower(sex)) %>%
  filter(!is.na(vote_intention)) %>% 
  filter(!is.na(income))

voter_data <-  survey_data  %>% filter(vote_intention == 1)
  # only want likely voters 


rm(raw_data)
rm(reduced_data)
rm(data)
