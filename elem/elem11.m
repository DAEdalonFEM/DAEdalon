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
% % kleine Defos ---> gro�e Defos / Mom.konfig. // HBaa - 24.08.2017 / 20.10.2020
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
% hist_user_elem = wie hist_old_elem, jedoch kein �berschreiben bei
%                  neuem Zeitschritt
%
% raus:
% k_elem = Elementsteifigkeitsmatrix
% r_elem = Elementresiduumsvektor (f�r Newton-Iteration)
% cont_zaehler = Matrix in der Gr��en f�r Contour-Plot drinstehen
% cont_nenner = Vektor zum Normieren vom globalen cont_z�hler
%               siehe projection.m
% hist_new_elem = aktualisierte Werte (sind im n�chsten Zeitschritt
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
  %[F] = defgrad_x_3d(u_elem,dshape);
  [F] = defgrad_x(u_elem,dshape);
  detF_J = det(F);

  % GP-History-Felder zusmmenbauen:
  hist_old_gp = hist_old_elem(:,aktgp);
  hist_user_gp = hist_user_elem(:,aktgp);

  %%%%%%%%%%%%%%%%%%%%%%
  % Begin Materialaufruf (direkt eingetragen)
  %%%%%%%%%%%%%%%%%%%%%%

  % Materialname zusammenbasteln
  %mat_name=strcat('mat',num2str(mat_nr));

  % Anspringen von mat_name

  [sig, vareps, D_mat,hist_new_gp,hist_user_gp] ...    % "CAUCHY-Spg."
      = feval(mat_name,mat_par,F,hist_old_gp,hist_user_gp);

  %%%%%%%%%%%%%%%%%%%%%
  % Ende Materialaufruf 
  %%%%%%%%%%%%%%%%%%%%%

  dv = gpweight(aktgp)*detvol;

  % GP-History-Felder zur�ckspeichern
  hist_new_elem(:,aktgp) = hist_new_gp;
  hist_user_elem(:,aktgp) = hist_user_gp;

%  if isw ~= 8   % Aufbau von k_elem und r_elem

    % Aufstellen von b = [b_1, ...  ,b_nele] siehe Hughes p.152
    for i=1:nel
      pos = 3*i-2;      
      b(1:6,pos:pos+2)=[dshape(i,1)  0            0          ;  ...
                        0            dshape(i,2)  0          ;  ...
                        0            0            dshape(i,3);  ...
                        dshape(i,2)  dshape(i,1)  0          ;  ...
                        0            dshape(i,3)  dshape(i,2);  ...
                        dshape(i,3)  0            dshape(i,1)];
    end %i
    
    % Zusammenbau von k_elem = b^t*D_mat*b*dv --> neue / gro�e Defos !
    % und Residuumsvektor r = b^T * sigma
    k_mate = k_mate + b' * D_mat * b * dv;
    r_elem = r_elem + b' * sig * dv;

    % Zusammenbau von k_geom

    % Positionen f�r GG
    node_loc = 1:nel;
    for i=1:ndf
      pos_vec(i:3:nel*ndf) =  node_loc;   % geht sch�ner --> 'reshape' !
    end
    S_mat = tens6_33(sig);
    GG = dshape(pos_vec,:)*S_mat*dshape(pos_vec,:)'*dv;    % HBaa - 24.08.2017
    % GG nur auf den einzelnen Diagonalen belegt
    %GG(1:2:2*nel,2:2:2*nel) = 0.0;
    %GG(2:2:2*nel,1:2:2*nel) = 0.0;

    GG(1:3:3*nel,2:3:3*nel) = 0.0;            % sch�ner machen !
      GG(1:3:3*nel,3:3:3*nel) = 0.0;
        GG(2:3:3*nel,3:3:3*nel) = 0.0;
    GG(2:3:3*nel,1:3:3*nel) = 0.0;
      GG(3:3:3*nel,1:3:3*nel) = 0.0;
        GG(3:3:3*nel,2:3:3*nel) = 0.0;
    
    k_geom = k_geom + GG;
    
%  elseif isw == 8  
    % Aufbau von zaehler und nenner f�r contourplot
    % Contour-Plotausgabe
    % Aufbau der Matrix cont_mat_gp:
    % Spalte 1-5: eps_x,eps_y,eps_z,eps_xy,... ; Spalte 7-12:
    % sig_x,sig_y,sig_z,sig_xy,...
    cont_mat_gp(1:12) = [vareps;sig]';
    cont_zaehler(:,1:12)=cont_zaehler(:,1:12) ...
	+shape'.*shape'*cont_mat_gp*dv;
    cont_nenner=cont_nenner+shape'.*shape'*dv;
    
%  end %if
  
end  % Schleife aktgp

% Zusammenbau von k_elem = k_geom + k_mate
k_elem = k_mate + k_geom;
