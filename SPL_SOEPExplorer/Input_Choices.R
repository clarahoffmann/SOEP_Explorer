# convert to data frame -> important for NA variables
data <-as.data.frame(data)

color.choices <-  c("gender"= "gender2", 
                    "employment status" = "pgemplst2",
                    "number of people in household" = "hhsize2",
                    "Number of children in household" = "hhchild2",
                    "Years of education" = "yeduc2")

var.choices <- c("household income" = "hghinc",
                 "age of individual" = "age",
                 "real weekly working hours" = "pgtatzeit", 
                 "agreed upon weekly working hours" = "pgvebzeit",
                 "Hours of overtime" = "overtime",
                 "Brutto income" = "bruttoinc",
                 "Life satisfaction: Scale of 1-10" = "life.satisfaction",
                 "Pre-tax hh income" = "preinc",
                 "Post-tax hh income" = "poinc",
                 "HH income from assets" = "assetinc",
                 "Rent" = "rent",
                 "Private hh transfers" = "pritrans",
                 "Public hh transfers" = "pubtrans",
                 "Social transfers" = "soctrans",
                 "Taxes paid on hh level" = "hhtax",
                 "Individual labor income" = "inclabori",
                 "Windfall hh income" = "windfall",
                 "Unemployment benefits" = "unempben",
                 "Maternity benefits" = "matben",
                 "ALG2 benefits" = "unemp2")

state.choices <- c("All federal states" = "All", "Berlin" = 11, 
                   "Baden-Wuerttemberg" = 8, 
                   "Bayern" = 9, "Brandenburg" = 12, 
                   "Bremen" = 4, "Hamburg" = 2, 
                   "Hessen" = 6, "Mecklenburg-Vorpommern" = 13, 
                   "Niedersachsen" = 3, "Nordrhein-Westfalen" = 5, 
                   "Rheinland-Pfalz" = 7, "Saarland" = 10,
                   "Sachsen" = 14, "Sachsen-Anhalt" = 15,
                   "Schleswig-Holstein" = 1, "Thueringen" = 16)


# drop levels of categorical variables
# that do not appear
# and convert to factors
data$gender2 <- as_factor(data$gender) %>% 
  droplevels()
data$gender2 <- gsub("[0-9]","", data$gender2)
data$gender2 <- gsub("\\[]","", data$gender2) 


data$pgemplst2 <- as_factor(data$pgemplst) %>% 
  droplevels() 
data$pgemplst2 <- gsub("[0-9]", "", data$pgemplst2) 
data$pgemplst2 <- gsub("\\[]","", data$pgemplst2) 


data$hhsize2 <- as_factor(
  cut(data$hhsize, 
      seq(0:6), 
      right=FALSE, 
      labels=c("1", "2", "3", 
               "4", "5", "6+")
  )
)

data$hhchild2 <- as_factor(
  cut(data$hhchild, 
      seq(0:6), 
      right=FALSE, 
      labels=c("1", "2", "3", 
               "4", "5", "6+")
  )
)
data$yeduc2 <- as_factor(
  cut(data$yeduc, 
      seq(0,18, 3), 
      right=FALSE,
      labels=c("0-3 years", 
               "4-6 years", 
               "7-9 years", 
               "10-12 years",
               "13-15 years", 
               "15+ years"
      )
  )
)


