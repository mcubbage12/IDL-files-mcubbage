;Consumption of fish 

;c_max_r=max consumption in ug g-1 day-1 (Huuskonen et al 1998), c_max is joules/day
 function cmax,start,num_types,prey_profit,cmax_eq,CTM,CTO, cA,mass, cB, cQ, temp_array, prey_DW, prey_WW,prey_ED, c_max
   start= where(~finite(prey_profit[*,1]),/NULL)
   ;Y=alog(CQ)*(CTM-CTO+2)
   ;Z=alog(CQ)*(CTM-CTO)
   ;X=((Z^2.0)*(1+(1+(40/Y))^0.5)^2.0)/400
   ;V=(CTM-temp_array)/(CTM-CTO)
   ;F=(V^X)*exp(x*(1-V))
   if cmax_eq eq 2 then begin &$
   Y=alog(CQ)*(CTM-CTO+2)
    Z=alog(CQ)*(CTM-CTO)
    X=((Z^2.0)*(1+(1+(40/Y))^0.5)^2.0)/400
    V=(CTM-temp_array)/(CTM-CTO)
    F=(V^X)*exp(x*(1-V))
    c_max_r=cA*(mass^cB)*F 
    c_max_dw=c_max_r*mass*.1 
    c_max=c_max_dw*1000000*mean(prey_ED[0:num_types-(max(start)+2)])
    endif
  if cmax_eq eq 1 then begin &$ 
   c_max_r=cA*(mass^cB)*exp(cQ*temp_array) 
   c_max_dw=c_max_r*mass*.1 
   c_max=c_max_dw*1000000*mean(prey_ED[0:num_types-(max(start)+2)])
   endif
 end 
 
;actual consumption before dissolved oxygen component (Varpe and fiksen 2010)
;swim_rate=swimming speed of larvae (m/s) (Dabrowski 1989)
function swim_rate, length,SS
SS=6.932*exp(1.282*(length/10))/3600
end

;search_rate= clearance rate of the fish (m3/s) (varpe and fiksen 2010)
function search_vol, prey_RD, SS, prey_SV
  prey_SV=(0.5)*3.14*(prey_RD^2.0)*SS
end

;function search_vol, RD_x, SS, search_vol_x
;search_vol_x=(1/2)*3.14*(RD_x^2)*SS
;end 

;CS= capture success (%)
; letcher et al 1996
function CS, num_types,prey_types, mass, prey_CS
  prey_CS=fltarr(num_types)
  for i=0,(num_types-1) do begin &$
    if prey_types[i] eq 'nauplii' then prey_CS[i]=1.0 else $
    if prey_types[i] eq 'copepod' then prey_CS[i]=(0.8*(mass^2.0))/(0.0002+(mass^2.0)) else $
    if prey_types[i] eq 'cladoceran' then prey_CS[i]=(0.8*(mass^2))/(0.0006+(mass^2.0))
  endfor
end


;HT= handling time (seconds per prey item)
;Walton et al 1992
;Mitchelbach 1981
function HT,num_types, length, prey_L, prey_HT
  prey_HT=fltarr(num_types)
  for i=0,(num_types-1) do begin &$
  if length le 19 then prey_HT[i]=exp(0.26410^(7.0151*(prey_L[i]/length)))
  if length gt 19 then prey_HT[i]=0.536*exp(18.488*(prey_L[i]/length))
  endfor
end


;daily number of items larvae eats in each prey type that is included   
function items,num_types, prey_profit, pro_acc, prey_CS, prey_SV, zoop_array, prey_HT, prey_ER
start= where(~finite(prey_profit[*,1]),/NULL) 
S=size(zoop_array)
numrows=S[2]
numcols=S[1]
prey_ER=fltarr(numcols, numrows, num_types)
 for i=(max(start)+1),(num_types-1) do begin &$
    for j=0,(numcols-1) do begin &$
      for k=0,(numrows-1) do begin &$
         if pro_acc[j,k,i] gt pro_acc[j,k,i-1] then $
          prey_ER[j,k,i]= 3600.0*12.0*prey_CS[prey_profit[i,0]]*((prey_SV[j,k,prey_profit[i,0]]*zoop_array[j,k,prey_profit[i,0]])/(1+(prey_HT[prey_profit[i,0]]*prey_SV[j,k,prey_profit[i,0]]*zoop_array[j,k,prey_profit[i,0]])))
      endfor
    endfor
  endfor
end
  
;daily number of items larvae eats in each prey type that is included
function capture,num_types, prey_profit, pro_acc, prey_SV, zoop_array, prey_HT, prey_ER
  start= where(~finite(prey_profit[*,1]),/NULL)
  S=size(zoop_array)
  numrows=S[2]
  numcols=S[1]
  prey_ER=fltarr(numcols, numrows, num_types)
  for i=(max(start)+1),(num_types-1) do begin &$
    for j=0,(numcols-1) do begin &$
    for k=0,(numrows-1) do begin &$
    if pro_acc[j,k,i] gt pro_acc[j,k,i-1] then $
    prey_ER[j,k,i]= 12.0*3600*((prey_SV[j,k,prey_profit[i,0]]*zoop_array[j,k,prey_profit[i,0]])/(1+(prey_HT[prey_profit[i,0]]*prey_SV[j,k,prey_profit[i,0]]*zoop_array[j,k,prey_profit[i,0]])))
endfor
endfor
endfor
end

function items_total, num_types, prey_er, daily_items
;create 2D of total items ingested
S=size(prey_ER)
numrows=S[2]
numcols=S[1]
prey_sum=fltarr(numcols, numrows, num_types)
for i= 0,(num_types-1) do begin &$
  for j=0,(numcols-1) do begin &$
  for k=0,(numrows-1) do begin &$
  prey_sum[j,k,i]=prey_er[j,k,i]+prey_sum[j,k,i-1]
endfor
endfor
endfor


daily_items=prey_sum[*,*,(num_types-1)]
end 

;creates 2D of daily joules consumed
function daily_joules, num_types,prey_profit, prey_ER, prey_DW, prey_ED, prey_J
  S=size(prey_ER)
  numrows=S[2]
  numcols=S[1]
  start= where(~finite(prey_profit[*,1]),/NULL)
  prey_J=fltarr(numcols, numrows, num_types)
  for i= max(start+1),(num_types-1) do begin &$
    for j=0,(numcols-1) do begin &$
      for k=0,(numrows-1) do begin &$
        prey_j[j,k,i]=prey_ER[j,k,i]*prey_DW[prey_profit[i,0]]*prey_ED[prey_profit[i,0]]
endfor
endfor
endfor
end

function J_total, num_types,prey_ER, prey_J, daily_J
  S=size(prey_ER)
  numrows=S[2]
  numcols=S[1]
;total number of joules per day before DO and cmax,
prey_Jsum=fltarr(numcols, numrows, num_types)
for i= 0,(num_types-1) do begin &$
  for j=0,(numcols-1) do begin &$
    for k=0,(numrows-1) do begin &$
      prey_Jsum[j,k,i]=prey_j[j,k,i]+prey_Jsum[j,k,i-1]
    endfor
  endfor
endfor

daily_J=prey_jsum[*,*,(num_types-1)]
  
end 
  
function cons_DO, temp_array, DO_array, daily_J, daily_J_DO
;set oxygen multiplier (Arend et al 2010)
S=size(temp_array)
numrows=S[2]
numcols=S[1]
DOcrit=fltarr(numcols, numrows)
fDO=fltarr(numcols,numrows)
  For i=0,(numcols-1) do begin &$
    for j=0,(numrows-1) do begin &$
      DOcrit[i,j]=0.168333*temp_array[i,j]+0.358333
      if (DO_array[i,j] ge DOcrit[i,j]) then fDO[i,j]=1.0 else $
      if(DO_array[i,j] lt DOcrit[i,j]) then fDO[i,j]=(1/DOcrit[i,j])*DO_array[i,j]
    endfor 
  endfor 
  

;daily_J_DO= consumption that is dependent on dissolved oxygen (units in number of prey items)
daily_J_DO=daily_J*fDO
end 

;set any consunsumption per day that exceeds cmax equal to cmax
Function set_cmax,c_max,daily_J_DO, daily_J_DO_MAX
  S=size(c_max)
  numrows=S[2]
  numcols=S[1]
  daily_J_DO_MAX=daily_J_DO
For i=0,(numcols-1) do begin &$
  for j=0,(numrows-1) do begin &$
     if daily_J_DO[i,j] gt c_max[i,j] then daily_J_DO_MAX[i,j]=c_max[i,j]
  endfor
endfor
end