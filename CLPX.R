#---------------Load in Packages-------------
library(tidyverse)
library(tidymodels)
library(powerjoin)
library(glue)
library(vip)
library(baguette)
#---------Load in NASA CLPX dataset-------------
iop1 <- read.csv("data/pit_iop1_v2_density.csv")
iop2 <- read.csv("data/pit_iop2_v2_density.csv")
#---------Load in CAMELS dataset----------------
root  <- 'https://gdex.ucar.edu/dataset/camels/file'

download.file('https://gdex.ucar.edu/dataset/camels/file/camels_attributes_v2.0.pdf', 
              'data/camels_attributes_v2.0.pdf')

types <- c("clim", "geol", "soil", "topo", "vege", "hydro")
remote_files  <- glue('{root}/camels_{types}.txt')
local_files   <- glue('data/camels_{types}.txt')

walk2(remote_files, local_files, download.file, quiet = TRUE)

camels <- map(local_files, read_delim, show_col_types = FALSE) 

camels <- power_full_join(camels ,by = 'gauge_id')

camels <- map(remote_files, read_delim, show_col_types = FALSE) |> 
  power_full_join(by = 'gauge_id')

#Creating Visualizations of Data 
print(iop1)
print(iop2)

