library(tidyverse)

#importing data
wages <- read_csv("raw_data/Wages.csv")
otwages <- read_csv("raw_data/Wages_ot.csv")
racegender <- read_csv("raw_data/Wages_race.csv")

#combining the data in 'otwages' so it totals all overtime for each employee
otwages <- otwages %>% 
  group_by(`Emp #`) %>% 
  summarize(total_ot=sum(`Employee Gross`))

#renaming the employee number column in all three datasets to facilitate joining
wages <- wages %>% 
  rename(employee_id=`Emp #`)
otwages <- otwages %>% 
  rename(employee_id=`Emp #`)
racegender <- racegender %>% 
  select(employee_id=Employee, gender=Gender, race=`EEO Race`)

#joining the datasets and cleaning things up
wages <- left_join(wages, otwages)
wages <- left_join(wages, racegender)

rm(otwages)
rm(racegender)

wages <- wages %>% 
  select(employee_id, last_name=`Last Name`, first_name=`First Name`, 
         base_pay=`Employee Gross`, department=Loc, total_ot, gender, race)

write_csv(wages, "output_data/2017wages_all.csv")
