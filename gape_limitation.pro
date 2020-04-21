;removes prey types that are not within larval gape height
;weight array (ug dry weight)
;watkins et al 2017
function wet_weight,num_types,prey_types, prey_L, prey_WW
  prey_WW=fltarr(num_types)
  for i=0,(num_types-1)do begin &$
    if prey_types[i] eq 'nauplii' then prey_WW[i]=(((!DPI/6.0)*(((sqrt(((prey_L[i]*1000.0)^2.0)/6.0))^3.0)*(10.0^(-6.0))))/(6.0^2.0))else $
    if prey_types[i] eq 'copepod' then prey_WW[i]=(((!DPI/6.0)*(((sqrt(((prey_L[i]*1000.0)^2.0)/6.0))^3.0)*(10.0^(-6.0))))/(6.0^2.0))else $
    if prey_types[i] eq 'cladoceran' then prey_WW[i]=(((!DPI/6.0)*(((sqrt(((prey_L[i]*1000.0)^2.0)/3.0))^3.0)*(10.0^(-6.0))))/(3.0^2.0))
  endfor
end


function gape_remove, num_types,gape,prey_ML, prey_RD, prey_SV, zoop_array, prey_CS, prey_HT, prey_ED, prey_DW, prey_WW
for i=0,(num_types-1) do begin &$
  if prey_ML[i] gt gape then prey_RD[*,*,i]='NaN'
  if prey_ML[i] gt gape then prey_SV[*,*,i]='NaN'
  if prey_ML[i] gt gape then zoop_array[*,*,i]='NaN'
  if prey_ML[i] gt gape then prey_CS[i]='NaN'
  if prey_ML[i] gt gape then prey_HT[i]='NaN'
  if prey_ML[i] gt gape then prey_ED[i]='NaN'
  if prey_ML[i] gt gape then prey_DW[i]='NaN'  
  if prey_ML[i] gt gape then prey_WW[i]='NaN'  
endfor
end


    
    