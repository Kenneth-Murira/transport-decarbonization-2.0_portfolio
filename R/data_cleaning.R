#load data
library(tidyverse)
hh <- read_csv("data-raw/hhv2pub.csv")
veh <- read_csv("data-raw/vehv2pub.csv")

#Clean Household Demographics
hh_clean <- hh %>%
  mutate(
    HHFAMINC_num = as.numeric(HHFAMINC)
  ) %>%
  filter(HHFAMINC_num > 0) %>%
  mutate(
    Income_Bracket = case_when(
      HHFAMINC_num %in% 1:3 ~ "1. Low (<$25k)",
      HHFAMINC_num %in% 4:5 ~ "2. Lower Mid ($25k-$50k)",
      HHFAMINC_num %in% 6:7 ~ "3. Middle ($50k-$100k)",
      HHFAMINC_num %in% 8:9 ~ "4. Upper Mid ($100k-$150k)",
      HHFAMINC_num %in% 10:11 ~ "5. High (>$150k)"
    ),

    Region = case_when(
      CENSUS_R == "01" ~ "Northeast",
      CENSUS_R == "02" ~ "Midwest",
      CENSUS_R == "03" ~ "South",
      CENSUS_R == "04" ~ "West"
    ),

    HH_Size = case_when(
      HHSIZE == 1 ~ "1 Person",
      HHSIZE == 2 ~ "2 People",
      HHSIZE >= 3 ~ "3+ People"
    )
  ) %>%
  select(HOUSEID, Income_Bracket, Region, HH_Size, WTHHFIN)


# Clean Vehicles and Aggregate to Household level
veh_clean <- veh %>%
  group_by(HOUSEID) %>%
  summarize(
    Has_EV = case_when(
      any(VEHFUEL %in% c("04", "05")) ~ "Yes",
      all(VEHFUEL == "-9") ~ "Unknown",
      TRUE ~ "No"
    ),
    .groups = "drop"
  )


# Final Join
df_analysis <- hh_clean %>%
  left_join(veh_clean, by = "HOUSEID") %>%
  mutate(
    Has_EV = case_when(
      !is.na(Has_EV) ~ Has_EV,
      TRUE ~ "No"
    )
  )

# Save final analytical dataset
write_rds(df_analysis, "data/nhts_analysis.rds")


