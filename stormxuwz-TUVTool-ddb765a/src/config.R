require("leaflet")
config <- list()

#####
#install.packages(c("leaflet","ggplot2","sp","gstat","RColorBrewer","rgl","dplyr","ggmap","lubridate","dismo","rglwidget","shiny","reshape2","dygraphs","pracma"))
#####


###########################
### Data File settings ####
###########################

config$BBE_name <- c("total","green","bluegreen","diatom")
config$Seabird_name <- c("Seabird_temperature","DO","DOsat","conductivity","BAT","Spec.Cond")


config$varUnit <- c(Seabird_temperature="Temperature (C)",
	DO = "DO (mg/L)",
	Spec.Cond = "Spec Cond (uS/cm)",
	DOsat = "DO Sat (%)",
	total = "Chl (ug/L)",
	BAT = "Beam Attenuation Coeff (1/m)",
	density = "Density (kg/m^3)",
	Zdens = "Zooplankton Density (1/m^3)",
	Zug = "Zooplankton Biomass (ug/m^3)"
)

# define the zooplankton bin sizes

config$ZugBins = list(All=10:128, one=10:11, two=12:16, three=17:22,four=23:31, five=32:47, six=48:63, seven=63:125, test=10:100)

config$LOPC_name <- c(
	paste("Zdens", names(config$ZugBins) ,sep = "_"), 
	paste("Zug", names(config$ZugBins) ,sep = "_"))


for(zooplanktonBinName in names(config$ZugBins)){
	config$varUnit[[paste0("Zdens_",zooplanktonBinName)]] = paste(zooplanktonBinName, "Zooplankton Density (1/m^3)")
	config$varUnit[[paste0("Zug",zooplanktonBinName)]] = paste(zooplanktonBinName, "Zooplankton Biomass (ug/m^3)")
}

config$factorColor <- colorFactor(c("blue4","white","red","blue","yellow","green","aquamarine","darkorange3","darkorchid4","lightpink1"),c(-1:8))

######################
### User settings ####
######################
# the hotspot neighbor size
config$depth_distance_ratio <- 1
config$nbrange <- 0.75


# Interpolation 
config$maxdist <- 0.33
config$separate <- TRUE
config$tpsDf <- 10  # tps detrending results
config$K <- c(0.3,5)  # y axis scale factor range after scaled to [0,1]
config$model <- "Sph"
config$gridSize <- c(dx=0.2,dy=0.25) # grid size dx in KM unit and dy in m unit

config$interestVar <- c("Seabird_temperature","Spec.Cond","DO","DOsat","total","BAT","Zdens_All","Zug_All", "Zdens_one", "Zdens_two", "Zdens_three", "Zdens_four", "Zdens_five", "Zdens_six", "Zdens_seven") # config$interestVar <- c("Zdens") for test
# config$interestVar <- c("BAT") # for test only

# output folder
config$outputFolder <- "C:/Users/Marissa/Desktop/Ch1_laptop/tuv_files"

#plot meta 
config$meta <- FALSE
