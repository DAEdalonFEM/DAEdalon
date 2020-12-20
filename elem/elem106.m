%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2003 Steffen Eckert                                 %
%    Contact: http://www.daedalon.org                              %
%                                                                  %
%                                                                  %
%    This file is part of DAEdalon.                                %
%                                                                  %
%    DAEdalon is free software; you can redistribute it            %
%    and/or modify it under the terms of the GNU General           %
%    Public License as published by the Free Software Foundation;  %
%    either version 2 of the License, or (at your option)          %
%    any later version.                                            %
%                                                                  %
%    DAEdalon is distributed in the hope that it will be           %
%    useful, but WITHOUT ANY WARRANTY; without even the            %
%    implied warranty of MERCHANTABILITY or FITNESS FOR A          %
%    PARTICULAR PURPOSE.  See the GNU General Public License       %
%    for more details.                                             %
%                                                                  %
%    You should have received a copy of the GNU General            %
%    Public License along with DAEdalon; if not, write to the      %
%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,   %
%    Boston, MA  02111-1307  USA                                   %
%                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [k_elem, M_elem, C_elem, r_elem, ...
	  cont_zaehler, cont_nenner, hist_new_elem, hist_user_elem] = ...
    elem106(isw, nel, ndf, contvar, mat_name, mat_par, x, u_elem, ...
	  hist_old_elem, hist_user_elem)

% DYNAMISCHES
% Dreieckselement mit 6 Knoten und quadratischen Ansatzfuntionen
% kleine Defos
% Aufruf von 3-D Materialgesetz, durch Streichen der notwendigen
% Spalten und Zeilen ergibt sich EVZ
%
% rein:
% isw = unbelegt
% nel = Anzahl der Knoten pro Element
% ndf = Freiheitsgrade pro Knoten (nicht immer gleich ndm)
% contvar = Anzahl der Contourvariablen -> femlab.m, projection.m
% mat_nr = Materialnummer XX zum Aufruf von matXX.m
% mat_par = Materialparameter (z.B. E, nu)
% x = Elementkoordinaten (nel x ndm)
% u_elem = Elementfeiheitsgrade (nel x ndf)
% hist_old_elem = Elementhistory-Variablen aus letztem Zeitschritt
%                 (gphist_max x numgp_max) -> femlab.m
%                 Bei neuem Zeitschritt (time-Komando) wird hist_old_elem
%                 durch hist_new_elem ersetzt
% hist_user_elem = wie hist_old_elem, jedoch kein Überschreiben bei
%                  neuem Zeitschritt
%
% raus:
% k_elem = Elementsteifigkeitsmatrix
% M_elem = Elementmassenmatrix
% C_elem = Elementdämpfungsmatrix

% r_elem = Elementresiduumsvektor (für Newton-Iteration)
% cont_zaehler = Matrix in der Größen für Contour-Plot drinstehen
% cont_nenner = Vektor zum Normieren vom globalen cont_zähler
%               siehe projection.m
% hist_new_elem = aktualisierte Werte (sind im nächsten Zeitschritt
%                 in hist_old_elem gespeichert
% hist_user_elem = s.o.


%Initialisierung
k_elem = zeros(ndf*nel);
M_elem = zeros(ndf*nel);
C_elem = zeros(ndf*nel);
r_elem=zeros(ndf*nel,1);
cont_zaehler=zeros(nel,contvar);
cont_nenner=zeros(nel,1);

% Auslesen der Gausspunkte und der Gewichte
[gpcoor, gpweight] = gp_tri_quadr;
numgp=length(gpweight);

% Rausholen von rho_mass sowie damp1 und damp2 (Rayleigh-Damping)
% aus mat_par, die Werte müssen an den letzten drei Stellen von
% mat_par eingetragen werden
rho_mass = mat_par(end-2);
damp1 = mat_par(end-1);
damp2 = mat_par(end);


% Schleife ueber alle GPs
for aktgp=1:numgp

  %Auslesen der shape-functions und Ableitungen, sowie det(dx/dxi)
  [shape, dshape, detvol] = shape_tri_quadr(x,gpcoor(aktgp,:));

  % Bestimmung des Deformationsgradienten
  F = zeros(3,3);
  F(3,3) = 1.0;
  [F(1:2,1:2)] = defgrad(u_elem,dshape);

  % GP-History-Felder zusmmenbauen:
  hist_old_gp = hist_old_elem(:,aktgp);
  hist_user_gp = hist_user_elem(:,aktgp);

  %%%%%%%%%%%%%%%%%%%%%%
  % Begin Materialaufruf
  %%%%%%%%%%%%%%%%%%%%%%

  % Materialname zusammenbasteln
  %mat_name=strcat('mat',num2str(mat_nr));

  % Anspringen von mat_name
  [sig, vareps, D_mat, hist_new_gp, hist_user_gp] ...
      = feval(mat_name, mat_par, F, hist_old_gp, hist_user_gp);

  % Zurücktransformieren von sig, vareps, D_mat in EVZ

  sig(5:6)=[];
  sig(3) = [];

  vareps(5:6)=[];
  vareps(3)=[];

  D_mat(5:6,:)=[];
  D_mat(3,:)=[];

  D_mat(:,5:6)=[];
  D_mat(:,3)=[];


  %%%%%%%%%%%%%%%%%%%%%
  % Ende Materialaufruf
  %%%%%%%%%%%%%%%%%%%%%

  dv = gpweight(aktgp)*detvol;

  % GP-History-Felder zurückspeichern
  hist_new_elem(:,aktgp) = hist_new_gp;
  hist_user_elem(:,aktgp) = hist_user_gp;


  % Aufstellen von b = [b_1, ...  ,b_nele] siehe Hughes p.152
  for i=1:nel
    pos = 2*i-1;
    b(1:3,pos:pos+1)=[dshape(i,1)     0      ;      ...
		      0      dshape(i,2);      ...
		      dshape(i,2) dshape(i,1)];
  end % i

  % Zusammenbau von k_elem = b^t*D_mat*b*dv
  % und Residuumsvektor r = b^T * sigma
  k_elem = k_elem + b' * D_mat * b * dv;
  r_elem = r_elem + b' * sig * dv;

  % Aufbau von
  % M_elem = rho*G*dv
  % G = (N_i*N_k)*eins

  for i=1:nel
    for j=1:nel
      ii = 2*i-1;
      jj = 2*j-1;
      G_ij = (shape(i)*shape(j)*dv)*eye(2);
      M_elem(ii:ii+1,jj:jj+1) = M_elem(ii:ii+1,jj:jj+1) + rho_mass*G_ij*dv;
    end % j
  end % i


  % Aufbau von zaehler und nenner für contourplot
  % Contour-Plotausgabe
  % Aufbau der Matrix cont_mat_gp:
  % Spalte 1-3: eps_x,eps_y,eps_xy ; Spalte 4-6: sig_x,sig_y,sig_xy

  % StE-Konstruktion, alle internen Variablen (falls vorhanden)
  % im Bereich hist_new_gp(7-9) werden in cont(7-9) geschrieben,
  % ansonsten = 0

  ll = length(hist_new_gp)- 6;
  if (ll > 0)
    for ii=1:ll
      intvar(ii)=hist_new_gp(6+ii);
    end
    cont_mat_gp(1:(6+ll)) = [vareps;sig;intvar']';
  else
    cont_mat_gp(1:6) = [vareps;sig]';
    ll = 0;
  end

  cont_zaehler(:,1:6+ll)=cont_zaehler(:,1:6+ll) ...
      +shape'.*shape'*cont_mat_gp*dv;
  cont_nenner=cont_nenner+shape'.*shape'*dv;

end  % Schleife aktgp

% Massen zeilenweise zusammenfassen und auf Diagonale setzen (Lumped masses):
% Dreieckselement mit 6 Knoten laeuft nur mit dieser Technik anstaendig
for i=1:nel*ndf
  lump_i=sum(M_elem(i,:));
  M_elem(i,:)=zeros(1,nel*ndf);
  M_elem(i,i)=lump_i;
end


% Einbau von Rayleigh-Damping
C_elem = damp1*M_elem + damp2*k_elem;