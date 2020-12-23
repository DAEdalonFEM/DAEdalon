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

function [k_elem, r_elem, cont_zaehler, cont_nenner, ...
	  hist_new_elem, hist_user_elem] = ...
    elem34(isw, nel, ndf, contvar, mat_name, mat_par, x, u_elem, ...
	  hist_old_elem, hist_user_elem)

% Dreieckselement mit 6 Knoten und quadratischen Ansatzfuntionen
% grosse Defos, Refenzkonfiguration
% numerische Bestimmung der Tangente
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
k_mate=zeros(ndf*nel);
k_geom=zeros(ndf*nel);
k_elem_ana=zeros(ndf*nel);
r_elem=zeros(ndf*nel,1);
r_elem_var=zeros(ndf*nel);
cont_zaehler=zeros(nel,contvar);
cont_nenner=zeros(nel,1);


% Auslesen der Gausspunkte und der Gewichte
[gpcoor, gpweight] = gp_tri_quadr;
numgp=length(gpweight);


% Schleife ueber alle GP's
for aktgp=1:numgp

  %Auslesen der shape-functions und Ableitungen, sowie det(dx/dxi)
  [shape, dshape, det_X_xsi] = shape_tri_quadr(x,gpcoor(aktgp,:));

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
  [S, E, D_mat,hist_new_gp,hist_user_gp] ...
      = feval(mat_name,mat_par,F,hist_old_gp,hist_user_gp);

  %%%%%%%%%%%%%%%%%%%%%
  % Ende Materialaufruf
  %%%%%%%%%%%%%%%%%%%%%

  dv = gpweight(aktgp)*det_X_xsi;

  % GP-History-Felder zurueckspeichern
  hist_new_elem(:,aktgp) = hist_new_gp;
  hist_user_elem(:,aktgp) = hist_user_gp;

  % Aufbau von k_mate und r_elem
  % siehe Wriggers p.121-129

  % Aufstellen von b = [b_1, ...  ,b_nele]

  for i=1:nel
    pos = 2*i-1;
    b(1:3,pos:pos+1)=[ F(1,1)*dshape(i,1)   F(2,1)*dshape(i,1) ; ...
		       F(1,2)*dshape(i,2)   F(2,2)*dshape(i,2) ; ...
		       F(1,1)*dshape(i,2)+F(1,2)*dshape(i,1)     ...
		       F(2,1)*dshape(i,2)+F(2,2)*dshape(i,1)];
  end % i

  k_mate = k_mate + b' * D_mat * b * dv;
  r_elem = r_elem + b' * S * dv;


  % Zusammenbau von k_geom

  S_mat=[S(1) S(3); ...
	 S(3) S(2)];

  for i=1:nel
    for j=1:nel
      ii = 2*i-1;
      jj = 2*j-1;

      % Wriggers Gleichung (4.84)
      G_ij = (dshape(i,:)*S_mat*dshape(j,:)'*dv) * eye(2);
      k_geom(ii:ii+1,jj:jj+1) = k_geom(ii:ii+1,jj:jj+1)+ G_ij;

    end % j
  end % i


  % Contour-Plotausgabe
  % Aufbau der Matrix cont_mat_gp:
  % Spalte 1-3: eps_x,eps_y,eps_xy ; Spalte 4-6: sig_x,sig_y,sig_xy
  cont_mat_gp(1:6) = [E;S]';       % modifiziert von andreas

  cont_zaehler(:,1:6)=cont_zaehler(:,1:6) ...
      +shape'.*shape'*cont_mat_gp*dv;
  cont_nenner=cont_nenner+shape'.*shape'*dv;

  %  end %if

end  % Schleife aktgp

% Zusammenbau von k_elem_ana = k_geom + k_mate
k_elem_ana = k_mate+k_geom;



%%%%%%%%%%%%%%%%%%%%%%%%%%
%Berechnung der Tangente
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inkrement festlegen
delta_u = 1.E-8;

% Schleifen ueber alle Freiheitsgrade und Knoten
for ii=1:nel*ndf

  % Schleife ueber alle GP's
  for aktgp=1:numgp

    %Auslesen der shape-functions und Ableitungen, sowie det(dx/dxi)
    [shape, dshape, det_X_xsi] = shape_tri_quadr(x,gpcoor(aktgp,:));

    % Variation einer Verschiebung
    u_elem_var = u_elem';
    u_elem_var(ii) = u_elem_var(ii) + delta_u;
    u_elem_var=u_elem_var';

    % Bestimmung des Deformationsgradienten
    [F] = defgrad(u_elem_var,dshape);


    % GP-History-Felder zusmmenbauen:
    hist_old_gp = hist_old_elem(:,aktgp);
    hist_user_gp = hist_user_elem(:,aktgp);

    %%%%%%%%%%%%%%%%%%%%%%
    % Begin Materialaufruf
    %%%%%%%%%%%%%%%%%%%%%%

    [S,E,D_mat,hist_new_gp,hist_user_gp] ...
	= feval(mat_name,mat_par,F,hist_old_gp,hist_user_gp);

    %%%%%%%%%%%%%%%%%%%%%
    % Ende Materialaufruf
    %%%%%%%%%%%%%%%%%%%%%

    % GP-History-Felder nicht zurueckspeichern

    dv = gpweight(aktgp)*det_X_xsi;

    % Aufstellen von b = [b_1, ...  ,b_nele]
    for i=1:nel
      pos = 2*i-1;
      b(1:3,pos:pos+1)=[ F(1,1)*dshape(i,1)   F(2,1)*dshape(i,1) ; ...
			 F(1,2)*dshape(i,2)   F(2,2)*dshape(i,2) ; ...
			 F(1,1)*dshape(i,2)+F(1,2)*dshape(i,1)     ...
			 F(2,1)*dshape(i,2)+F(2,2)*dshape(i,1)];
    end % i


    % Matrix mit Residuumsvektoren anlegen
    r_elem_var(:,ii) = r_elem_var(:,ii) + b' * S * dv;

  end  % Schleife aktgp

end % ii

% Numerische Tangente bilden
k_elem =  r_elem_var - repmat(r_elem,1,ndf*nel);
k_elem = k_elem/delta_u;
