##################################################

# Reading in the SOEP data
##################################################


# Set the directory of your GitHub repository
setwd("C:/Users/choffmann/Desktop/R/today/SPL-Project/")

# Set "mypath" - 
# this is the folder with the datasets
mypath <- "C:/Users/choffmann/Desktop/R/data/" 

# Packages
if (!require("pacman")) 
  install.packages("pacman"); 
library("pacman") 

# Packages to load
p_load("magrittr", 
       "dplyr", 
       "haven")

if (!require("codebook")) 
  devtools::install_github("rubenarslan/codebook"); 
library("codebook") 

##################################################

#   1. Reading in the data
##################################################


#   Household Dataset
hgen <- read_dta(paste0(mypath,"hgen.dta"))%>%
  # select variables of interest
  dplyr::select(
    hid,    # Current Household Number
    syear,  # Survey Year
    hghinc  # Household Income
  ) %>%
  # recode negative values to missings
  detect_missings(learn_from_labels = T,   
                  only_labelled_missings = F,
                  negative_values_are_missing = T, 
                  ninety_nine_problems = F) 

#   Person Dataset
pgen <- read_dta(paste0(mypath,"pgen.dta"))%>%
  # select variables of interest
  dplyr::select(
    hid,       # Current Household Number
    pid,       # Person Identification NUmber
    syear,     # Survey Year
    pgtatzeit, # Real working hours per week
    pgvebzeit, # Agreed upon work time per week
    pgemplst,  # Employment status
    partenr = pgpartz, # Partner indicator
    school = pgpsbil, # schooling
    overtime = pguebstd, # Hours of overtime
    bruttoinc = pglabgro # Brutto income
  ) %>%
  # recode negative values to missings
  detect_missings(learn_from_labels = T, 
                  only_labelled_missings = F,
                  negative_values_are_missing = T, 
                  ninety_nine_problems = F)    


# Personal and household characteristics, survey weights
pequiv <- read_dta(paste0(mypath,"pequiv.dta")) %>%
  # keep only the individuals that participated 
  # in the survey in the particular year
  filter(x11105 == 1) %>% 
  # select variables of interest
  select(
    hid,    # Current Household Number
    pid,    # Person ID
    syear,  # Survey Year
    state = l11101, # Federal State
    age = d11101, # Age
    gender = d11102ll, # Gender
    pweight = w11105,  # Individual Weighing Factor
    hweight = w11102,  # Household Weighing Factor
    life.satisfaction = p11101, # Overall Life Satisfaction
    married = d11104, # marital status of individual
    hhsize = d11106, # number of people in household
    hhchild = d11107, # number of children in household
    yeduc = d11109, # number of years of education
    preinc = i11101, # hh pre-government income
    poinc = i11102, # hh post-government income
    laborinchh = i11103, # hh labor income
    assetinc = i11103, # hh income from asset flows
    rent = i11105, # hh imputed rent
    pritrans = i11106, # hh private transfers
    pubtrans = i11107, # hh public transfers
    soctrans = i11108, # hh social security pensions
    hhtax = i11109, # total hh taxes
    laborinci = i11110, # individual labor earnings
    windfall = i11118, # hh windfall income
    unempben = iunby, # unemployment benefit
    matben = imaty, # maternity benefit
    diabet = m11107, # have or had diabetes
    cancer = m11108, # have or had cancer
    psych = m11109, # psychatric problems
    heart = m11111, # angina or heart condition
    height = m11122, # body height
    weight = m11123, # body weight
    unemp2 = alg2, # unemployment benefit II
    cpi = y11101  # consumer price index
  )  %>%
  # recode negative values to missings
  detect_missings(learn_from_labels = T,
                  only_labelled_missings = F,
                  negative_values_are_missing = T, 
                  ninety_nine_problems = F) 


##################################################

#   2. Merging the data
##################################################

# merge data for all persons and households together 
data <- hgen %>%  
  left_join(pequiv, by = c("hid", "syear")) %>% 
  left_join(pgen, by = c("pid", "syear", "hid")) 

# save as rds file
saveRDS(data, paste0(mypath,"data.rds"))
