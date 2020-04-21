;data import (example for huron june harbor beach data)
;read in complete csv file for huron june harbor beach site
Huron_July_HB = DIALOG_PICKFILE(FILTER='*.csv')
H_J_HB=READ_CSV(Huron_July_HB, header=h)
print, h
help, H_J_HB




;renaming 1D arrays
length=size(dist2)
dist2=H_J_HB.field01
depth2=H_J_HB.field02
BAT2= H_J_HB.field11
temp2=H_J_HB.field06
DO2=H_J_HB.field08

zoop_12=H_J_HB.field14
zoop_22=H_J_HB.field15
zoop_32=H_J_HB.field16
zoop_42=H_J_HB.field17
zoop_52=H_J_HB.field18
zoop_62=H_J_HB.field19
zoop_72=H_J_HB.field20

;dimensions of 2D arrays
xbinsize=0.2
ybinsize=0.25
array_size(dist2, depth2, xbinsize, ybinsize, x2, y2)
;x2=round(max(dist2)/0.2)+1
;y2=round(max(depth2)/0.25)+1

;create empty 2D arrays for triaxus variables
temp_array2=fltarr(x2,y2)
depth_array2=findgen(x2,y2, start=500, increment=0)
dist_array2=findgen(x2,y2, start=500, increment=0)
BAT_array2=findgen(x2,y2, start=100, increment=0)
DO_array2=fltarr(x2,y2)
zoop_array2=findgen(x2,y2,7,start=100000, increment=0)


;fill 2D arrays with data
fill_arrays(dist2, depth2,depth2, xbinsize, ybinsize,depth_array2)
fill_arrays(dist2, depth2,dist2, xbinsize, ybinsize,dist_array2)
fill_arrays(dist2, depth2,temp2, xbinsize, ybinsize,temp_array2)
fill_arrays(dist2, depth2,BAT2, xbinsize, ybinsize,BAT_array2)
fill_arrays(dist2, depth2,DO2, xbinsize, ybinsize,DO_array2)

fill_zoop_array( dist2, depth2,zoop_12 , xbinsize, ybinsize,0, zoop_array2)
fill_zoop_array( dist2, depth2,zoop_22 , xbinsize, ybinsize,1, zoop_array2)
fill_zoop_array( dist2, depth2,zoop_32 , xbinsize, ybinsize,2, zoop_array2)
fill_zoop_array( dist2, depth2,zoop_42 , xbinsize, ybinsize,3, zoop_array2)
fill_zoop_array( dist2, depth2,zoop_52 , xbinsize, ybinsize,4, zoop_array2)
fill_zoop_array( dist2, depth2,zoop_62 , xbinsize, ybinsize,5, zoop_array2)
fill_zoop_array( dist2, depth2,zoop_72 , xbinsize, ybinsize,6, zoop_array2)


;replace placeholder values with NAN
depth_array2[where (depth_array2 eq 500, /NULL)]= "NAN"
temp_array2[where (temp_array2 eq 0, /NULL)]= "NAN"
dist_array2[where (dist_array2 eq 500, /Null)]="NAN"
BAT_array2[where (BAT_array2 eq 100, /Null)]="NAN"
DO_array2[where (DO_array2 eq 0, /Null)]="NAN"
zoop_array2[where (zoop_array2 eq 100000, /Null)]="NAN"


 ;set NAN values to mean of values next two it
 splice_sections(temp_array2, temp_array)
 splice_sections(BAT_array2, BAT_array)
 splice_sections(DO_array2, DO_array)
 splice_sections(depth_array2, depth_array)


;for zoop
SS=size(zoop_array2)
numrows=SS[2]
numcols=SS[1]
numtypes=SS[3]
zoop_array_fill=zoop_array2
;for stuff besides zoop
For i= 0,(numtypes-1) do begin&$
  For j=5,(numcols-10) do begin &$
    for k=5,(numrows-10) do begin &$
      if finite(zoop_array2[j,k,i]) eq 0 then zoop_array_fill[j,k,i]=((zoop_array2[j-3,k,i]+zoop_array2[j+3,k,i])/2.0)
endfor
zoop_array=zoop_array_fill



;graph 2D contour plots before splicing together sections
;good
device, decomposed=0
nlevels=8
LoadCT, 33, Ncolors=nlevels, Bottom=1
step=(Max(temp_array)-min(temp_array))/nlevels
levels=indgen(nlevels)*step+min(temp_array)
SetDecomposedState, 0, CurrentState=cuurentState
cgcontour,temp_array, dist_array2, depth_array2,color=255,Levels=levels,$
  c_labels=replicate(1,8), /cell_fill,yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)',C_COlors=indgen(nlevels)+1, /outline
 device, Decomposed=currentstate
cgColorbar, Range=[Min(temp_array), max(temp_array)], divisions=8,Xticklen=1, XMinor=0, Ncolors=8, Bottom=1, AnnotateColor='black', position=[0.125, 0.91, 0.855, 0.95], /top





;good
contour,temp_array, dist_array2, depth_array2, nlevels=5, color=255,$
  c_labels=replicate(1,5),c_colors=[255,255,255],yrange=[50,0], xstyle=1, ystyle=1, $
  xtitle='distance', ytitle='depth (m)', /overplot

  ;good zooplankton graphs
  contour,zoop_array[*,*,2], dist_array2, depth_array2,color=255, nlevels=5,$
    c_labels=replicate(1,5), /cell_fill,yrange=[50,0], xstyle=1, ystyle=1, $
    xtitle='distance', ytitle='depth (m)'

  ;good
  device, decomposed=0
  contour,zoop_array[*,*,2], dist_array2, depth_array2, nlevels=5, color=255,$
    c_labels=replicate(1,5),c_colors=[255,255,255],yrange=[50,0], xstyle=1, ystyle=1, $
    xtitle='distance', ytitle='depth (m)', /overplot
