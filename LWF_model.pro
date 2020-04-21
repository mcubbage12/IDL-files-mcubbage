;larval lake whitefish GRP model based on zooplankton size and density, temperature, and water clarity
;functions and sources within this model are defined elsewhere in the downloaded folder
;this GRP model can be used with bioenergietic consumption models following Ktichell et al 1977 or Stewart et al 1983. However, this model can only be used with excretion and egestion models  by kitchell et al 1977. 
;determining number or rows and colomns in 2d arrays: use bat_array as example but will apply to all 2D arrays
S=size(bat_array)
numrows=S[2]
numcols=S[1]


;mass=fresh mass (g) based on length(mm) (davis and todd 1997)
if species  eq 'LWF' then mass=exp((-5.68)+3.17*alog(length))/1000 else $
if species eq 'YP' then mass=exp((alog(length/45.9))/3.3)
;gape= mouth gape in mm based on length (mm) (Arts and Evans 1987)if species 
if species eq 'LWF' then gape=(1.18*(length/10))-0.75 else $
if species eq 'YP' then gape=0.159*length-0.597

;zooplankton area (m^2) for each prey type
prey_area=fltarr(num_types)
for i=0,(num_types-1) do begin &$
  if prey_types[i] eq 'nauplii' then prey_area[i]=(prey_L[i]*(prey_L[i]/6.0))/1000000.0 else $
  if prey_types[i] eq 'copepod' then prey_area[i]=(prey_L[i]*(prey_L[i]/6.0))/1000000.0 else $
  if prey_types[i] eq 'cladoceran' then prey_area[i]=(prey_L[i]*(prey_L[i]/3.0))/1000000.0
endif
endfor   


;visual parameters of fish ke and Ei for each prey type
vis_ke(par_min,Ke)
vis_ei(num_types, max_rd, contrast, prey_area, prey_Ei)


;convert beam attenuation values to PAR
kd(bat_array, kd_ave)
PAR(kd_ave, depth_array,surface_par, par_val)
device, decomposed=0
contour,kd_ave, dist_array, depth_array, nlevels=5, color=255,$
  c_labels=replicate(1,5),c_colors=[255,255,255],yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)';, /overplot
 
  device, decomposed=0
  contour,par_val, dist_array, depth_array, nlevels=5, color=255,$
    c_labels=replicate(1,5),c_colors=[255,255,255],yrange=[50,0], xstyle=1, ystyle=1, $
    xtitle='distance', ytitle='depth (m)';, /overplot

;reactive distance of larval fish for each prey type (m) (Aknes and Utne 1997)
RD(num_types,contrast, prey_area, prey_Ei, Ke, PAR_val, prey_rd)
device, decomposed=0
contour,prey_rd[*,*,2], dist_array2, depth_array2, nlevels=8, color=255,$
  c_labels=replicate(1,8),c_colors=[255,255,255],yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)';, /overplot


;swim rate of larval fish (Dabrowkski 1989)
swim_rate(length,SS)

;search volume (m/s) for each prey type (Varpe and fiksen 2010)
search_vol(prey_RD, SS, prey_SV)
device, decomposed=0
contour,p[*,*,2], dist_array2, depth_array2, nlevels=7, color=255,$
  c_labels=replicate(1,7),c_colors=[255,255,255],yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)';, /overplot


;define capture success (%) for each prey type (Letcher et al 1996)
c


;wet weight of prey types (ug)
;watkins et al 2017
wet_weight(num_types,prey_types, prey_L, prey_WW)
;dry weight of prey types (ug)
;watkins et al 2017
prey_DW=prey_WW*0.1

;gape limitation
gape_remove(num_types,gape,prey_ML, prey_RD, prey_SV, zoop_array, prey_CS, prey_HT, prey_ED, prey_DW, prey_WW)

;Optimal Foraging Theory (what prey types to include in the model)
;Hook et al 2008 

;prey types ranked
Profit(num_types, prey_DW, prey_ED, prey_CS, prey_HT, prey_profit)
;accumulated profitability based on environmental conditions
profit_acc(num_types, prey_profit,prey_ED, prey_DW, prey_CS, zoop_array, prey_SV, prey_HT, pro_acc)

;;daily number of prey items eaten by larval fish for each prey type based on encounter rate
items(num_types,prey_profit, pro_acc, prey_CS, prey_SV, zoop_array, prey_HT, prey_ER)
;capture(num_types,prey_profit, pro_acc, prey_SV, zoop_array, prey_HT, prey_ER)
items_total(num_types, prey_er, daily_items)

device, decomposed=0
contour,prey_er[*,*,6], dist_array2, depth_array2,color=255, nlevels=4,$
  c_labels=replicate(1,4), /cell_fill,yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)'
  
  
  device, decomposed=0
  nlevels=9
  LoadCT, 33, Ncolors=nlevels, Bottom=1
  step=(Max(daily_items)-min(daily_items))/nlevels
  levels=indgen(nlevels)*step+min(daily_items)
  SetDecomposedState, 0, CurrentState=cuurentState
  cgcontour,daily_items, dist_array2, depth_array2,color=255,Levels=levels, $
   yrange=[50,0], xstyle=1, ystyle=1, $
    xtitle='distance', ytitle='depth (m)',C_COlors=indgen(nlevels)+1, /outline
  device, Decomposed=currentstate
  cgColorbar, Range=[Min(daily_items), max(daily_items)], divisions=nlevels,Xticklen=1, XMinor=0, Ncolors=nlevels, Bottom=1, AnnotateColor='black', position=[0.125, 0.91, 0.855, 0.95], /top


 
  

;convert consumed prey item number into joules for each prey type per day
;sum joules from all prey types to get total joules consumed per day
daily_joules(num_types,prey_profit, prey_ER, prey_DW, prey_ED, prey_J)
J_total(num_types,prey_ER, prey_J, daily_J)

;DO multipier for consumption
cons_DO(temp_array, DO_array, daily_J, daily_J_DO)


;define maximum consumption for larvae (J/day)
cmax(start,num_types,prey_profit,cmax_eq,CTM,CTO,cA,mass, cB, cQ, temp_array, prey_DW, prey_WW,prey_ED, c_max)
device, decomposed=0
contour,c_max, dist_array, depth_array, nlevels=5, color=255,$
  c_labels=replicate(1,5),c_colors=[255,255,255],yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)';, /overplot

;don't let daily consumption be greater than maximum consumption
set_cmax(c_max,daily_J_DO, daily_J_DO_MAX)

device, decomposed=0
nlevels=9
LoadCT, 33, Ncolors=nlevels, Bottom=1
step=(Max(daily_j_do_max)-min(daily_J_DO_Max))/nlevels
levels=indgen(nlevels)*step+min(daily_j_do_max)
SetDecomposedState, 0, CurrentState=cuurentState
cgcontour,daily_J_DO_max, dist_array2, depth_array2,color=255,Levels=levels, $
  yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)',C_COlors=indgen(nlevels)+1, /outline
device, Decomposed=currentstate
cgColorbar, Range=[Min(daily_J_DO_MAX), max(daily_J_DO_MAx)], divisions=nlevels,Xticklen=1, XMinor=0, Ncolors=nlevels, Bottom=1, AnnotateColor='black', position=[0.125, 0.91, 0.855, 0.95], /top, charsize=0.65



;calculate daily metabolism for larvae in joules/day
met_joules(Ra,Rb,Rq,met_eq,RTM,RTO,temp_array,mass,A, met_J)



device, decomposed=0
nlevels=9
LoadCT, 33, Ncolors=nlevels, Bottom=1
step=(Max(met_j)-min(met_j))/nlevels
levels=indgen(nlevels)*step+min(met_j)
SetDecomposedState, 0, CurrentState=cuurentState
cgcontour,met_j, dist_array2, depth_array2,color=255,Levels=levels, $
  yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)',C_COlors=indgen(nlevels)+1, /outline, /cell_fill
device, Decomposed=currentstate
cgColorbar, Range=[Min(met_j), max(met_j)], divisions=nlevels,Xticklen=1, XMinor=0, Ncolors=nlevels, Bottom=1, AnnotateColor='black', position=[0.125, 0.91, 0.855, 0.95], /top




;calculate daily GRP in g g-1 day-1
daily_grp(daily_J_DO_MAX,met_J,A,F,SDA,U,GRP_relative)


device, decomposed=0
nlevels=9
LoadCT, 33, Ncolors=nlevels, Bottom=1
step=(Max(grp_relative)-min(grp_relative))/nlevels
levels=indgen(nlevels)*step+min(grp_relative)
SetDecomposedState, 0, CurrentState=cuurentState
cgcontour,grp_relative, dist_array2, depth_array2,color=255,Levels=levels, $
  yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)',C_COlors=indgen(nlevels)+1, /outline, /cell_fill
device, Decomposed=currentstate
cgColorbar, Range=[Min(grp_relative), max(grp_relative)], divisions=nlevels,Xticklen=1, XMinor=0, Ncolors=nlevels, Bottom=1, AnnotateColor='black', position=[0.125, 0.91, 0.855, 0.95], /top, charsize=0.6




 