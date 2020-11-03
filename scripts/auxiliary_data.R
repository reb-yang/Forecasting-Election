#### Preamble ####
# Purpose: Prepare and prepare the electoral college counts and state names 
# Author: Rebecca Yang
# Data: Nov 2 2020
# Contact: reb.yang@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the electoral college excel file saved inputs/data


library(tidyverse)
library(dplyr)
library(readxl)

# setting up auxiliary data 
state_names <- tibble(state_full = c(tolower(state.name), "district of columbia"), 
                      state = c(state.abb, "DC"))   
# adding dc to state names

electoral_college <- read_xlsx("../inputs/data/electoral_vote_by_state.xlsx")

# electoral college vote distribution by state
electoral_college <- electoral_college %>%
  mutate(splits = str_split(State, " - ")) %>%
  rowwise() %>%
  mutate(state_full = tolower(splits[1]),
         votes = as.numeric(substr(splits[2], 1, 2))) %>%
  select(-State, -splits) %>%
  left_join(state_names)

