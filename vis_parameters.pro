;Create Ke and Ei parameters (no units)

;function for ke larval fish visual parameter
;x is the PAR in uE m2-1 s-1 where light is not limiting fish vision
;varpe and fiksen 2010
function vis_ke, x,y
y=(x-(0.999*x))/0.999
return, y
end

;function for Ei larval fish visual parameter
;w is distance (m) fish can see when light is not limiting, x is contrast of prey (unitless), y is prey area (m^2)
function vis_Ei,num_types, max_rd, contrast, prey_area, prey_Ei
  prey_Ei=fltarr(num_types)
  for i=0,(num_types-1) do begin &$
    prey_Ei[i]=((max_rd)^2.0)/(contrast*prey_area[i])
  endfor
end 





