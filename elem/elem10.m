%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Oliver Goy                                %
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
    elem10(isw, nel, ndf, contvar, mat_name, mat_par, x, u_elem, ...
	  hist_old_elem, hist_user_elem)

% Stabelement 
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
% hist_user_elem = wie hist_old_elem, jedoch kein Überschreiben bei
%                  neuem Zeitschritt
%
% raus:
% k_elem = Elementsteifigkeitsmatrix
% r_elem = Elementresiduumsvektor (für Newton-Iteration)
% cont_zaehler = Matrix in der Größen für Contour-Plot drinstehen
% cont_nenner = Vektor zum Normieren vom globalen cont_zähler
%               siehe projection.m
% hist_new_elem = aktualisierte Werte (sind im nächsten Zeitschritt
%                 in hist_old_elem gespeichert
% hist_user_elem = s.o. 


%Initialisierung
k_elem=zeros(ndf*nel);
r_elem=zeros(ndf*nel,1);
cont_zaehler=zeros(1,contvar);
cont_nenner=zeros(nel,1);


  % Einlesen der Materialwerte
  E_mod = mat_par(2);
  A = mat_par(3);
  
  % Berechnung des Einheitsvektors in Axialrichtung 
  % der Elementlänge
  t = x(2,:)' - x(1,:)';
  L = norm(t);
  t = t/L;
  
  % Berechnung der lokalen Verschiebung
  u_axial = (u_elem(2,:) - u_elem(1,:))*t;
  
  % Berechnung der Dehnung
  epsilon = u_axial/L;
  
  % Berechnung der Spannung
  sig = E_mod*epsilon;
  
   
  % GP-History-Felder zurückspeichern
  hist_new_elem = hist_old_elem;
  hist_user_elem = hist_user_elem;
  
%  if isw ~= 8   % Aufbau von k_elem und r_elem
    
    % Aufstellen von B
    B = [-t',t']/L;

    % Zusammenbau von k_elem 
    k_elem = B' * E_mod*A * B * L; 
    
    % und Residuumsvektor r 
    r_elem = B' * sig*A*L;

%  elseif isw == 8  
    % Aufbau von zaehler und nenner für contourplot
    % Contour-Plotausgabe
    % Aufbau der Matrix cont_mat_gp:
    % cont_mat_gp(1): eps_xx; cont_mat_gp(2): sig_xx
   
    cont_mat_gp(1:2) = [epsilon;sig]';
    cont_zaehler(1:2)= cont_mat_gp;
    cont_nenner=1.0;
%  end %if

  %end  % Schleife aktgp
