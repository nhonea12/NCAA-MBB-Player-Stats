library(tidyverse)
library(gt)
library(gtExtras)
library(gtUtils)

# read in player stat totals
player_stats_total       <- readRDS("Data/player_stats_total.rds")

# get data just of players from NC
players_from_nc <- player_stats_total |> 
  filter(hometown |> str_ends("NC")) |> 
  arrange(desc(BPM_torvik)) |> 
  filter(
    MIN_pg >= 10,
    class2027 != "Grad/Done"
  )

# make into gt table
top_nc_players_gt <- players_from_nc |> 
  dplyr::mutate(
    BPM_torvik  = round(BPM_torvik, 2),
    OBPM_torvik = round(OBPM_torvik, 2),
    DBPM_torvik = round(DBPM_torvik, 2)
  ) |> 
  dplyr::select(
    athlete_headshot_href, 
    athlete_display_name, 
    role, 
    height, 
    team_logo,
    team_location,
    hometown,
    GP,
    MIN_pg,
    PTS_pg,
    BPM_torvik,
    OBPM_torvik, 
    DBPM_torvik
  ) |> 
  # make a gt object
  gt() |> 
  # add in logo images
  gt_img_rows(columns = "athlete_headshot_href", img_source = "web", height = 60) |> 
  gt_img_rows(columns = "team_logo", img_source = "web", height = 60) |> 
  # set column labels
  cols_label(
    athlete_headshot_href = "",
    athlete_display_name = "Player",
    role = "Role",
    height = "Height",
    team_logo = "",
    team_location = "Team",
    hometown = "Hometown",
    MIN_pg = "MIN",
    PTS_pg = "PTS",
    BPM_torvik = "BPM",
    OBPM_torvik = "OBPM",
    DBPM_torvik = "DBPM"
  ) |> 
  # add title and subtitle
  tab_header(title = "Best Players from North Carolina",
             subtitle = "According to Bart Torvik's Box Plus-Minus (At Least 10 Minutes Per Game and Not Seniors in 2025-26)") #|> 
  # add theme from the F5
  #gt_theme_f5_altered()
  
gtsave(top_nc_players_gt, filename = "top_nc_players.html")
