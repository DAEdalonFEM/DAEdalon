*# Template-Datei für DAEdalon
*set var ndm=GenData(NDM,int)
*set var ndf=GenData(NDF,int)
*set var i=0
*intformat "%1i"
geom
0
0
*nmats
*ndm
*ndf
*nnode

node
*set elems(all)
*loop nodes
*realformat "%8.6e"
*NodesCoord(1,real) *NodesCoord(2,real)*\
*if(ndm==3)
 *NodesCoord(3,real)*\
*endif

*end nodes

el
*set elems(all)
*loop elems
*intformat "%1i"
*elemsmat*\
*intformat "%4i "
 *elemsConec
*end elems

force
*Set Cond Surface-Load *nodes
*Add Cond Face-Load *nodes
*Add Cond Point-Load *nodes
*if(CondNumEntities(int)>0)
*loop nodes *OnlyInCond
*intformat "%1i"
*realformat "%8.6e"
*for(i=1;i<=ndf;i=i+1)
*if(cond(*i,real)!=0.0)
*NodesNum *i *cond(*i,real)
*endif
*endfor
*end nodes
*endif

displ
*Set Cond Surface-Constraints *nodes *or(1,int) *or(3,int) *or(5,int)
*Add Cond Line-Constraints *nodes *or(1,int) *or(3,int) *or(5,int)
*Add Cond Point-Constraints *nodes *or(1,int) *or(3,int) *or(5,int)
*if(CondNumEntities(int)>0)
*loop nodes *OnlyInCond
*intformat "%1i"
*realformat "%8.6e"
*set var j=1
*for(i=1;i<=ndf*2;i=i+2)
*if(*cond(*i,int)!=0)
*NodesNum *j *cond(*operation(i+1),real)
*endif
*set var j=j+1
*endfor
*end nodes
*endif

*loop materials
mat*matnum()
*format "%1i"
*MatProp(Element-Nr.:)
*MatProp(Anz.Gausspunkte)
*MatProp(Mat.-Nummer:)
*MatProp(Anz.History-Variablen)
*MatProp(E-Modul)
*MatProp(Nu)
*if(MatProp(sig_0,real)||MatProp(N,real))
*MatProp(sig_0)
*MatProp(N)
*endif

*end materials