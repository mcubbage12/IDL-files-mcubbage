;script to create kd values

function kd, bat_array, kd_ave
;Light in water
;scattering coefficient derived from beam attenuation based on 580 nm
;source, Helgi Arst et all 2002
;clear lakes had values 0.3-0.65 in calculation of b, chose 0.3 becasue our beam attentuation is at the lower end of the range included in this paper
;b=scattering coefficient, c=beam attentuation coefficient
b=0.3*(BAT_array)

;array of angle of photons just directly below the water, AP= angle of photons
AP=findgen(5)
AP[0]=0.0
AP[1]=30
AP[2]=45
AP[3]=60
AP[4]=75

;Kd (diffuse atennuation coefficient)for clear sky conditions (overcast conditions equation also available
;scatt is the scattering coefficient
scatt=BAT_array-b
Kd_array=(1.0/cos(AP[0]))*(((scatt^2.0)+(0.0425*cos(AP[0])-0.19)*scatt*b)^0.5)

;for loop to calculate average k values
; total_array is all non-averaged K values
; kd_ave is all averaged K values
S=size(bat_array)
numrows=S[2]
numcols=S[1]
kd_ave=fltarr(numcols, numrows)
For i=0,(numcols-1) do begin &$
  for j=0,(numrows-1) do begin &$
 kd_ave[i,j]= mean(Kd_array[i,0:j],/NAN)
  endfor
endfor 
end

function PAR, kd_ave, depth_array, surface_par, par_val
;PAR_val = photosythetically active radiation values in uE/m2/s
;PAR_val are PAR values in uE/m2/s
;
PAR_val=surface_PAR* exp((-kd_ave)*depth_array)
end 


