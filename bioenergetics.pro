;larval lake whitefish bioenergetics

Function met_joules, Ra,Rb,Rq,met_eq,RTM, RTO, temp_array,mass,A, met_J
  if met_eq eq 2 then begin  &$
    Y=alog(RQ)*(RTM-RTO+2)
    Z=alog(RQ)*(RTM-RTO)
    X=((Z^2.0)*(1+(1+(40/Y))^0.5)^2.0)/400
    V=(RTM-temp_array)/(RTM-RTO)
    F=(V^X)*exp(x*(1-V))
    met=Ra*(mass^Rb)*F*A
    met_J=met*13560*mass
  endif

 if met_eq eq 1 then begin &$
  met= Ra*(mass^Rb)*exp(rQ*temp_array)*A
  met_J=met*13560*mass
 endif
end
;GRP in g g-1 day
;energy density of larval fish from pothoven et al 2013
Function daily_grp,daily_J_DO_MAX,met_J,A,F,SDA,U,GRP_relative
GRP_joules=daily_J_DO_MAX-(met_j*A)-((daily_J_DO_MAx-f)*SDA)-U
GRP_relative=GRP_joules/2806
end 
