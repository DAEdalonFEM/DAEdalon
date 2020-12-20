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

% dyn_init.m
% Initialisierung aller benötigten Größen zur Berechnug dynamischer
% Probleme

% Parameter für Newmark-Algorithmus
% folgender Parametersatz ist unbedingt stabil:
%n_beta = 0.25;
%n_gamma = 0.5;

n_beta = 0.25;
n_gamma = 0.5;


alpha_1 = 1.0/(n_beta*dt^2);
alpha_2 = 1.0/(n_beta*dt);
alpha_3 = (1.0-2.0*n_beta)/(2.0*n_beta);
alpha_4 = n_gamma/(n_beta*dt);
alpha_5 = 1-n_gamma/n_beta;
alpha_6 = (1.0 - n_gamma/(2.0*n_beta))*dt;

% History-Felder für Zeitintegration
u_n = zeros(gesdof,1); 
v_n = zeros(gesdof,1);
a_n = zeros(gesdof,1);

% Skalierung der Randlasten, -verschiebungen defaultmäßig ausschalten
lf

% Eingabefile  disp0.inp mit Anfangsverschiebungen lesen
% Format:
% disp0((Anzahl Knoten mit vorgeg. u_0 x (Knotennr.,Freiheitsgr.,Versch.))
load disp0.inp
dummy=size(disp0);
disp0_len=dummy(1);

if (disp0_len>0)
  % Aufspalten von displ in 3 Vektoren damit int- und double-Variablen
  % nicht im gleichen Feld
  disp0_node=disp0(:,1);
  disp0_df=disp0(:,2);
  disp0_u=disp0(:,3);
  
  % Einbau in u_n: 
  for i=1:disp0_len
    pos=ndf*(disp0_node(i)-1)+disp0_df(i);
    u_n(pos)=disp0_u(i);
  end  % i
end % if

% Eingabefile  veloc0.inp mit Anfangsgeschwindigkeiten lesen
% Format:
% veloc0((Anzahl Knoten mit vorgeg. v_0 x (Knotennr.,Freiheitsgr.,Versch.))
load veloc0.inp
dummy=size(veloc0);
veloc0_len=dummy(1);

if (veloc0_len>0)
  % Aufspalten von displ in 3 Vektoren damit int- und double-Variablen
  % nicht im gleichen Feld
  veloc0_node=veloc0(:,1);
  veloc0_df=veloc0(:,2);
  veloc0_v=veloc0(:,3);

  % Einbau in v_n: 
  for i=1:veloc0_len
    pos=ndf*(veloc0_node(i)-1)+veloc0_df(i);
    v_n(pos)=veloc0_v(i);
  end  % i
end % if

% Schleife über alle Elemente muss zum Initialisieren einmal mit u_0
% durchlaufen werden um a_0 zu bestimmen
u = u_n;

% Aufruf von dyn_stiff.m
dyn_stiff;


% Bestimmung von a_0:
syst;
a_n = M_mass\(rhs - C_damp*v_n);

% aktuelle Werte mit den Startwerten initialisieren, da beim
% Aufruf von time die Größen umgespeichert werden.
u = u_n;
v_akt = v_n;
a_akt = a_n;