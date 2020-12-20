%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Steffen Eckert, Andreas Trondl            %
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

% syst.m
% Einbau der Verschiebungsrandbedingungen in k
% und Aufbau der rechten Seite aus Lastvektor und Residuum

% Schleife über alle vorgegebenen Randverschiebungen (in displ abgelegt)
% Zeile komplett ausnullen nur an der Stelle pos eine 1


% Faktor bestimmen mit dem die Randverschiebungen skaliert werden
if (load_flag==1)
  loadfactor = loadfunc(tim);
else
  loadfactor = 1;
end

% rechte Seite, zusammengesetzt aus Randlasten p und Residuum r
rhs = -r + loadfactor * lam * p;

% aT globale Position im globalen gleichungsystem
pos = ndf * ( displ_node - 1 ) + displ_df;
poU = [1:gesdof]';

if bounDisp_treat                       % aT behandlung der verschieb.-randbed.
  poU(pos) = [];                        % aT pos. der zu berechnenden verschieb.
else
% Die Verschiebungsrandbed werden in stiffness in u( ) eingetragen,
% sodass die Inkremente delta_u immer = 0 sind
  i = size( k, 1 ) + 1;                 % aT konst. fuer indextrafo
  k(pos,:) = 0.0;                       % Zeile nullen
  k(:,pos) = 0.0;                       % Spalte nullen
  k(i*pos-i+1) = 1.0;                   % aT 1 auf hauptdiagonal-positionen
end
rhs(pos) = 0.0;                         % Verschiebungsinkrement=0 eintragen

% Ende syst.m
