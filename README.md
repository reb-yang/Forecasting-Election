# Forecasting-Election

# Overview

In this repository is code and data created by me, Rebecca Yang, for forecasting the 2020 US election. 
The purpose is to create a report that about a model that I built to forecast these results. The data used in the model is from Nationscape survey conducted by UCLA and the Democracy Voter Study Group and the American Community Survey. This data is unable to be shared publicly, but is able to be freely accessed, and instructions to do so are detailed below. 

# tl;dr

Biden predicted to win 55% of popular vote with margin of error of 4% and between 284 and 444 electoral votes. In 4000 different ways the electoral college could swing, Biden won in 99% of them, Trump won in 1%, with <0.1% chance of a tie. 

# Inputs 

Inputs contain data that are unchanged from their original. 

- Nationscape survey data: To access the data, go to: https://www.voterstudygroup.org/publication/nationscape-data-set
Enter your email to submit a request for access, and it will be emailed to you in a folder. The data used is from Phase 2 (phase_2_v20200814), specifically the most recent one available (ns2020062). The folder also includes the data in .dta format as well as a bannerbook and codebook for the survey. 

- ACS data: To access the data, go to https://usa.ipums.org/usa-action/variables/group.
The variable I used are: sex, age, race, citizen, education, inctot. Stateicp, perwt are included by default.
The sample is the ACS 2018 sample. I used the whole sample, but smaller versions are available if required. It should be downloaded in .dta format. 

- electoral_vote_by_state.xlsx - I copied and pasted a table of state-by-state electoral vote counts from the Encyclopaedia Britannica.
 (https://www.britannica.com/topic/United-States-Electoral-College-Votes-by-State-1787124)

These should be saved in the "data" folder. 

# Outputs

Outputs contain data that are modified from the input data, the report and supporting material.

- vote_model2.rds - the final model used in the report 
- ElectionReport.Rmd - R Markdown file for the report
- ElectionReport.pdf - the report in pdf format 
- references.bib - citations for the report 

# Scripts 

Scripts contain R scripts that take inputs and outputs and produce outputs. These are:

- data_cleaning_survey.R - data cleaning script for the Nationscape survey - in here I create new variables, filter responses, etc. 
- data_cleaning_post_strat.R - data cleaning script for the ACS and to create cells for post-stratification
- auxiliary_data.R - some additional data used in the report - for state abbreviations, cleaning for electoral_vote_by_state.xlsx

# Notes 

- the code to install the fiftystater package I used to make the maps has been commented so you need to uncomment it before running the Rmd. This package is installed via devtools as it is no longer available to be installed locally for some reason, but I like it because you can get all 50 states, not just the 48 contiguous states.  
- I changed the font in the report using the Cairo graphics library which requires XQuartz to be installed on Macs. 
- The font used in the graphs is included in the default Font Book on Mac. 
