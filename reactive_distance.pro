;reactive distance function

;prey_rd=reactive distance of larvae (m)

function RD, num_types,contrast, prey_area, prey_Ei, Ke, PAR_val, prey_rd
  S=size(PAR_val)
  numrows=S[2]
  numcols=S[1]
  prey_rd=fltarr(numcols, numrows, num_types)
  for i=0,(num_types-1) do begin &$
    prey_rd[*,*,i]=(sqrt((PAR_val/(ke+PAR_val))*prey_ei[i]*prey_area[i]*contrast))
  endfor
end





  
  


