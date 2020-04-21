;User parameters
;when imputing user parameters, be sure to include at  least 1 decimal point
;current parameters are for larval lake whitefish, and sources are for this species 

;what species are you running the model for? 
species='YP'
;length=larvae length (mm) (Auer 1982)
length=15.0

;foraging

;Par just below the surface of the water column (uE/m2/sec)
;source varies based on site (most from NOAA plankton survey system data)
surface_par=2000

;PAR value where reactive distance when light is not limiting (no units)
;Ke currently based on the fact that at 20 uE m2-1 s-1, light is not limiting
PAR_min=20

;maximum reactive distance when light is not limiting set to one body length (m)
max_rd=length/1000.0

;contrast of prey vs. water (Utne-Palm 1999)
Contrast=0.3

;bioenergetics (Huuskonen et al 1998)
;;consumption in units in g g-1 day-1 (relative weight)(Huuskonen et al 1998)
;cA=intercept for C max,cB=coefficient,Cmax vs fresh mass,cQ= coefficient for temperature
cmax_eq=2
cA=0.51
cB=(-0.42)
cQ=2.3
;CTM and CTO only needed is cmax_eq=2
CTM=32
CTO=29
;metabolism in units gO2 g-1 day-1
;Ra=intercept for routine rate of R, Rb=coefficient for routine rate of R vs. fresh mass, Rq= Coefficient for R vs. temperature
met_eq=2
Ra=0.0065
Rb=(-0.2)
Rq=2.1
;RTM and RTO only needed is met_eq=2
RTM=35
RTO=32
;A= coefficient for activity,SDA=coefficient for specific dynamic action
A=1.0
SDA=0.17
;egestion (F) and excretion (U)
F=0.19
U=0.07

;number of prey types included in model
num_types=7
;zoop taxanomic designation (rotifer, nauplii, copepod or cladoceran)
prey_tax_1="nauplii"
prey_tax_2="copepod"
prey_tax_3="cladoceran"
prey_tax_4="copepod"
prey_tax_5="cladoceran"
prey_tax_6="cladoceran"
prey_tax_7="cladoceran"

prey_types=[prey_tax_1, prey_tax_2, prey_tax_3,prey_tax_4, prey_tax_5, prey_tax_6, prey_tax_7]

;zoop length (mm) for each prey type
prey_L=fltarr(num_types)
prey_L[0]=0.25
prey_L[1]=0.4
prey_L[2]=0.6
prey_L[3]=0.85
prey_L[4]=1.25
prey_L[5]=1.75
prey_L[6]=3.0

;zooplankton amx length for gape limitation
prey_ML=fltarr(num_types)
prey_ML[0]=0.3
prey_ML[1]=0.5
prey_ML[2]=0.7
prey_ML[3]=1.0
prey_ML[4]=1.5
prey_ML[5]=2.0
prey_ML[6]=4.0

;zoop energy densities for each size bin (J/ug dry weight)
prey_ED=fltarr(num_types)
prey_ED[0]=0.02461
prey_ED[1]=0.02331
prey_ED[2]=0.02418
prey_ED[3]=0.02214
prey_ED[4]=0.02555
prey_ED[5]=0.02555
prey_ED[6]=0.02555




;Energetic contents for fish larvae (J g-1)
larvae_E=2806
end