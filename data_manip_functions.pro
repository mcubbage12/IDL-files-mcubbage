
;function to determine size of 2D arrays
function array_size, dist2, depth2, xbinsize, ybinsize, x2, y2
  x2=round(max(dist2)/xbinsize)+1
  y2=round(max(depth2)/ybinsize)+1
end

;function to fill 2D arrays for TRiaxus environmental variables 
function fill_arrays, x_array, y_array, z_array, xbinsize, ybinsize,filled_array
length=size(y_array)
for i=0,(length[1]-1)do begin &$
  for j=0,(length[1]-1) do begin &$
  filled_array[(x_array[i]/xbinsize)-1,(y_array[i]/ybinsize)-1]=z_array[i]
  endfor
endfor
end 




;keep as example
;temp2=H_J_HB.field06
;length=size(temp2)
;x2=round(max(dist2)/0.2)+1
;y2=round(max(depth2)/0.25)+1
;temp_array2=fltarr(x2,y2)
;for i=0,(length[1]-1)do begin &$
; for j=0,(length[1]-1) do begin &$
; temp_array2[(dist2[i]/0.2)-1,(depth2[i]/0.25)-1]=temp2[i]
;temp_array2[where (temp_array2 eq 0, /NULL)]= "NAN"




function fill_zoop_array, x_array, y_array, z_array, xbinsize, ybinsize,dim_3, filled_array
  length=size(y_array)
  for i=0,(length[1]-1)do begin &$
    for j=0,(length[1]-1) do begin &$
    filled_array[(x_array[i]/xbinsize)-1,(y_array[i]/ybinsize)-1, dim_3]=z_array[i]
endfor
endfor
end


function splice_sections, var_array2, var_array
S=size(var_array2)
numrows=S[2]
numcols=S[1]
var_array_fill=var_array2
For i=5,(numcols-10) do begin &$
  for j=5,(numrows-10) do begin &$
  if finite(var_array2[i,j]) eq 0 then var_array_fill[i,j]=((var_array2[i-3,j]+var_array2[i+3,j])/2.0)
endfor
endfor
var_array=var_array_fill
end


