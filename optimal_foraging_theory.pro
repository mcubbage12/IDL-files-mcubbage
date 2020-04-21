;optimal foraging theory
;determies which prey types to include in model


;individual prey type profitability in order greatest to least
;for loop that fils second row of profit_array which is the profitabiliy of each prey item
;first row in profit_array is the prey type
;Hook et al 2008
function Profit, num_types, prey_DW, prey_ED, prey_CS, prey_HT, prey_profit
  prey_profit=findgen(num_types,2,start=0)
  ;for i=0,(num_types-1) do begin &$
      ;if prey_l[i] gt gape then prey_profit[i,0]='NaN' 
 ; endfor
  for i=0,(num_types-1) do begin &$
      prey_profit[i,1]=(prey_DW[i]*prey_ED[i]*prey_CS[i])/prey_HT[i]
  endfor
  
;sort profit_array
  index=reverse(sort(prey_profit[*,1]))
  for i=0,1 do begin &$
    prey_profit[*,i]=prey_profit[index,i]
  endfor
  ;prey_profit[where (prey_profit[*,1] eq 'NaN')]=!Values.F_NAN
end


;accumulated profitability

function profit_acc,num_types, prey_profit,prey_ED, prey_DW, prey_CS, zoop_array, prey_SV, prey_HT, pro_acc
;numerator
start= where(~finite(prey_profit[*,1]),/NULL)
num=fltarr(num_types)
num[max(start)+1]=(prey_ED[prey_profit[max(start)+1,0]] * prey_DW[prey_profit[max(start)+1,0]] * prey_CS[prey_profit[max(start)+1,0]])
for i= (max(start)+2), (num_types-1) do begin &$
  num[i]=num[i-1]+(prey_ED[prey_profit[i,0]] * prey_DW[prey_profit[i,0]] * prey_CS[prey_profit[i,0]])
endfor

;denominator 3 parts 
S=size(zoop_array)
numrows=S[2]
numcols=S[1]
den=fltarr(numcols, numrows, num_types)      
for k=(max(start)+1),(num_types-1) do begin &$
  den[*,*,k]=zoop_array[*,*,prey_profit[k,0]]*prey_SV[*,*,prey_profit[k,0]]*prey_HT[prey_profit[k,0]]
endfor
den_final=fltarr(numcols, numrows, num_types) 
for k=(0), (num_types-1) do begin &$
  den_final[*,*,k]=den[*,*,k]+den[*,*,k-1]
endfor  
  
;together
pro_acc=fltarr(numcols, numrows, num_types)
for i=(max(start)+1), (num_types-1) do begin &$
  pro_acc[*,*,i]=num[i]/(1+den_final[*,*,i])
endfor  

end

;prey included
;prey type included 'true' or 'false' 
;prey_inc=fltarr(numcols, numrows, num_types)
;for i=0, (num_types-1) do begin &$
 ; for j=0,(numcols-1) do begin &$
    ;for k=0,(numrows-1) do begin &$
       ; if pro_acc[j,k,i] eq 0 then prey_inc[j,k,i]='NaN'
    ;endfor
  ;;endfor
;endfor






















