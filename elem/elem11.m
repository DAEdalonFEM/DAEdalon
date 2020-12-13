%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Steffen Eckert/Oliver Goy                 %
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
%    Public License along with Foobar; if not, write to the        %
%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,   %
%    Boston, MA  02111-1307  USA                                   %
%                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [k_elem, r_elem, cont_zaehler, cont_nenner, ...
	  hist_new_elem, hist_user_elem] = ...
    elem11(isw, nel, ndf, contvar, mat_name, mat_par, X, u_elem, ...
	  hist_old_elem, hist_user_elem)

% 8-Knotenelement mit tri-linearen Ansatzfuntionen
% % kleine Defos ---> grosse Defos / Mom.konfig. // HBaa - 24.08.2017 / 20.10.2020
%
% rein:
% isw = switch, if isw==8 dann Aufbau der Contourmatrix, sonst
%       Aufbau von k_elem, r_elem
% nel = Anzahl der Knoten pro Element
% ndf = Freiheitsgrade pro Knoten (nicht immer gleich ndm)
% contvar = Anzahl der Contourvariablen -> femlab.m, projection.m
% mat_nr = Materialnummer XX zum Aufruf von matXX.m
% mat_par = Materialparameter (z.B. E, nu)
% X = Elementkoordinaten (nel x ndm)
% u_elem = Elementfeiheitsgrade (nel x ndf)
% hist_old_elem = Elementhistory-Variablen aus letztem Zeitschritt
%                 (gphist_max x numgp_max) -> femlab.m
%                 Bei neuem Zeitschritt (time-Komando) wird hist_old_elem
%                 durch hist_new_elem ersetzt
% hist_user_elem = wie hist_old_elem, jedoch kein Ueberschreiben bei
%                  neuem Zeitschritt
%
% raus:
% k_elem = Elementsteifigkeitsmatrix
% r_elem = Elementresiduumsvektor (fuer Newton-Iteration)
% cont_zaehler = Matrix in der Groessen fuer Contour-Plot drinstehen
% cont_nenner = Vektor zum Normieren vom globalen cont_zaehler
%               siehe projection.m
% hist_new_elem = aktualisierte Werte (sind im naechsten Zeitschritt
%                 in hist_old_elem gespeichert
% hist_user_elem = s.o.


%Initialisierung
k_elem=zeros(ndf*nel);
r_elem=zeros(ndf*nel,1);
cont_zaehler=zeros(nel,contvar);
cont_nenner=zeros(nel,1);
k_mate=zeros(ndf*nel);
k_geom=zeros(ndf*nel);

% Koordinaten in R_x
x = X + u_elem;

% Auslesen der Gausspunkte und der Gewichte
[gpcoor, gpweight] = gp_quad3d_lin;
numgp=length(gpweight);

% Schleife ueber alle GPs
for aktgp=1:numgp

  %Auslesen der shape-functions und Ableitungen, sowie det(dx/dxi)
  [shape, dshape, detvol] = shape_brick_lin(x,gpcoor(aktgp,:));

  % Bestimmung des Deformationsgradienten  --> hier bzgl. "akt. Konfig" !!
  F = defgrad_x(u_elem,dshape);

  % GP-History-Felder zusmmenbauen:
  hist_old_gp = hist_old_elem(:,aktgp);
  hist_user_gp = hist_user_elem(:,aktgp);

  %%%%%%%%%%%%%%%%%%%%%%
  % Begin Materialaufruf
  %%%%%%%%%%%%%%%%%%%%%%

          vol_flag = 1;    % auch Vol.anteile in Mat.routine berechnen
  [sig, vareps, D_mat,hist_new_gp,hist_user_gp] ...    % "CAUCHY-Spg."
      = feval(mat_name,mat_par,F,hist_old_gp,hist_user_gp,vol_flag);

  %%%%%%%%%%%%%%%%%%%%%
  % Ende Materialaufruf
  %%%%%%%%%%%%%%%%%%%%%

  dv = gpweight(aktgp)*detvol;

  % GP-History-Felder zurueckspeichern
  hist_new_elem(:,aktgp) = hist_new_gp;
  hist_user_elem(:,aktgp) = hist_user_gp;

  % Aufstellen von b = [b_1, ...  ,b_nel] siehe Hughes p.152
  for i=1:nel
    pos = (i-1)*3 + 1;  % 1, 4, 7, ...
    b(1:6,pos:pos+2)=[dshape(i,1)  0            0          ;  ...
                      0            dshape(i,2)  0          ;  ...
                      0            0            dshape(i,3);  ...
                      dshape(i,2)  dshape(i,1)  0          ;  ...
                      0            dshape(i,3)  dshape(i,2);  ...
                      dshape(i,3)  0            dshape(i,1)];
  end %i

  % Zusammenbau von k_elem = b^t*D_mat*b*dv --> neue / grosse Defos !
  % und Residuumsvektor r = b^T * sigma
  k_mate = k_mate + b' * D_mat * b * dv;
  r_elem = r_elem + b' * sig * dv;

  % Zusammenbau von k_geom
  % HBaa - 25.11.2015 / 08.12.2020
  S_mat = tens6_33(sig);
  for i=1:nel
    ii = (i-1)*3 + 1;
    for j=1:nel
      jj = (j-1)*3 + 1;
      % Wriggers Gleichung (4.106)
                         g_ij = dshape(i,:)*S_mat*dshape(j,:)';
      k_geom(ii:ii+2,jj:jj+2) = k_geom(ii:ii+2,jj:jj+2) + g_ij*eye(3)*dv;
    end % j
  end % i

  % Aufbau von zaehler und nenner fuer contourplot
  % Contour-Plotausgabe
  % Aufbau der Matrix cont_mat_gp:
  % Spalte 1-5: eps_x,eps_y,eps_z,eps_xy,... ;
  % Spalte 7-12: sig_x,sig_y,sig_z,sig_xy,...
  cont_mat_gp(1:12) = [vareps;sig]';
  cont_zaehler(:,1:12)=cont_zaehler(:,1:12)+shape'.*shape'*cont_mat_gp*dv;
  cont_nenner=cont_nenner+shape'.*shape'*dv;

end  % Schleife aktgp

% Zusammenbau von k_elem = k_geom + k_mate
k_elem = k_mate + k_geom;
