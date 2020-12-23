%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002 Steffen Eckert                                 %
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

function [k_elem, r_elem, cont_zaehler, cont_nenner, ...
	  hist_new_elem, hist_user_elem] = ...
    elem3(isw, nel, ndf, contvar, mat_name, mat_par, x, u_elem, ...
	  hist_old_elem, hist_user_elem)

% Dreieckselement mit 6 Knoten und quadratischen Ansatzfuntionen
% kleine Defos
%
% rein:
% isw = switch, if isw==8 dann Aufbau der Contourmatrix, sonst
%       Aufbau von k_elem, r_elem
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

% Auslesen der Gausspunkte und der Gewichte
[gpcoor, gpweight] = gp_tri_quadr;
numgp=length(gpweight);

% Schleife ueber alle GP's
for aktgp=1:numgp

  %Auslesen der shape-functions und Ableitungen, sowie det(dx/dxi)
  [shape, dshape, detvol] = shape_tri_quadr(x,gpcoor(aktgp,:));

  % Bestimmung des Deformationsgradienten
  [F] = defgrad(u_elem,dshape);


  % GP-History-Felder zusmmenbauen:
  hist_old_gp = hist_old_elem(:,aktgp);
  hist_user_gp = hist_user_elem(:,aktgp);


  %%%%%%%%%%%%%%%%%%%%%%
  % Begin Materialaufruf
  %%%%%%%%%%%%%%%%%%%%%%

  % Materialname zusammenbasteln
  %mat_name=strcat('mat',num2str(mat_nr));

  % Anspringen von mat_name
  [sig,vareps,D_mat,hist_new_gp,hist_user_gp] ...
      = feval(mat_name,mat_par,F,hist_old_gp,hist_user_gp);

  %%%%%%%%%%%%%%%%%%%%%
  % Ende Materialaufruf
  %%%%%%%%%%%%%%%%%%%%%

  dv = gpweight(aktgp)*detvol;

  % GP-History-Felder zurueckspeichern
  hist_new_elem(:,aktgp) = hist_new_gp;
  hist_user_elem(:,aktgp) = hist_user_gp;

%  if isw ~= 8   % Aufbau von k_elem und r_elem

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

%  elseif isw == 8
    % Aufbau von zaehler und nenner fuer contourplot
    % Contour-Plotausgabe
    % Aufbau der Matrix cont_mat_gp:
    % Spalte 1-3: eps_x,eps_y,eps_xy ; Spalte 4-6: sig_x,sig_y,sig_xy

    cont_mat_gp(1:6) = [vareps;sig]';
    cont_zaehler(:,1:6)=cont_zaehler(:,1:6) ...
	+shape'.*shape'*cont_mat_gp*dv;
    cont_nenner=cont_nenner+shape'.*shape'*dv;
%  end %if

end  % Schleife aktgp
