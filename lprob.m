%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Steffen Eckert                            %
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

% lprob.m

% ndm     Anzahl der Dimensionen
% numnp   Anzahl der Gesamtknoten
% numel   Anzahl der Elemente im Problem
% nel     Anzahl der Knoten pro Element
% ndf     Freiheitsgrade pro Knoten (nicht immer gleich ndm)
% gesdof  Anzahl der Gesamtfreiheitsgrade
% numgp_max   Max. Anzahl der verwendeten Gausspunkte pro Element
% nummat  Anzahl der unterschiedlichen verwendeten Materialgesetze

%clear all;

% datenschnittstelle zu bestimmten funktionen ueber globale variablen
%setGloVar;

% % Matlab Versionsnummer              // siehe "gui_setup.m"
%vers_nr = sscanf(version,'%f');

% einige (globale) Groessen initialisieren
dt = 1.0;        % Zeitinkrement
% tim  = dt;     % jetzt in loop.m durch Aufruf von time, sonst von Hand
tim = 0.0;       % aktuelle Zeit
defo_scal = 1;   % Faktor mit dem die Verschiebungen beim Plot
                 % skaliert werden
defo_flag = 0;   % siehe mesh0.m, meshx.m
resid_count= 0;
cont_flag = 0;
contvar = 16;    % Anzahl der Contourvariablen
cpu_total = 0.0;
flops_total = 0;
steps_total = 0; % Anzahl der insgesamt durchgefuehrten Zeitschritte
sparse_flag = 0; % Bei grossen Gleichungssystemen sollte man Sparse-
	             % Speichertenchnik verwenden -> sparse_flag=1
load_flag = 1;   % wenn load_flag=1, werden Randlasten und
                 % Randverschiebungen mit der in loadfunc(tim)
                 % vorgegebenen Funktion skaliert, sonst nicht
lam = 1;         % sollte immer auf 1 stehen, wird nur beim
                 % Bogenlaengenverfahren benoetigt
bounDisp_treat=0;% Art der Einarbeitung der Verschiebungsrandbed.
                 % in GlSyst, siehe syst.m
movie_flag = 0;  % wenn =1, wird nach jeden Zeitschritt ein Bild in
                 % movie_array gespeichert, siehe loop.

isw = 0;         % zur eingenen Verwendung
out_file_name = '';     % Defaultmaessig keine Ausgabefiles schreiben
histout_file_name = ''; % Defaultmaessig keine Ausgabefiles schreiben
rst_file_name = '';     % Defaultmaessig keine Restartfiles schreiben
out_incr = 1;    % alle wieviel Zeitschritte Ausgabe-file ...
rst_incr = 20;   % alle wieviel Zeitschritte Restart-file ...
                 % geschrieben wird
userSkript = ''; % mfile welches automatisch in time gestartet wird

%%%%%%%%%%%%%%%%%%%%
% Beginn
% Eingabefiles lesen
%%%%%%%%%%%%%%%%%%%%

if mat_oct_flag           % true --> octave         % HBaa - 17.12.2015
    warning('off', 'Octave:data-file-in-path')
end

% Eingabefile Geometriedaten:
% Format: [numnp; numel; nummat; ndm; ndf; nel]
% Ausser den Werten fuer nummat und ndf werden alle beim Einlesen
% von node.inp und el.inp ueberschrieben
load geom.inp
nummat=geom(3);
ndf=geom(5);
mat_set=1:nummat; % Anzahl an Materialdatensaetzen

% Schleife ueber alle Materialdateien
for i=1:nummat
  % Eingabefile Materialparameter: matX.inp
  % Format: [elem_nr; mat_nr; ...mat_par...]
  mat_file=strcat('mat',num2str(i),'.inp');
  load(mat_file);
  mat_par_length = length(eval(['mat',num2str(i)])) - 3;

  % in elem_nr_matr wird fuer jeden Materialdatensatz die Elementnr. abgelegt
  elem_nr_matr(i)=eval(['mat',num2str(i),'(1)']);

  % in elem_gp_matr wird fuer jeden Materialdatensatz die Anzahl der
  % Gausspunkte pro Element abgelegt
  elem_gp_matr(i)=eval(['mat',num2str(i),'(2)']);

  % in mat_nr_matr wird fuer jeden Materialdatensatz die Materialnr. abgelegt
  mat_nr_matr(i)=eval(['mat',num2str(i),'(3)']);

  % in mat_par_matr werden spaltenweise fuer jeden Materialdatensatz
  % die Materialparameter abgelegt
  % 1. Eintrag in mat_par_matr ist Anzahl der hist-Variablen pro GP
  mat_par_matr(1:mat_par_length,i)=eval(['mat',num2str(i),'(4:end)']);

end

% Eingabefile Knotenkoordinaten: node.inp
% Format: node(Knotennummer x Koordinate)
load node.inp
dummy = size(node);
numnp = dummy(1);   %Anzahl der Gesamtknoten
ndm = dummy(2);     %Anzahl der Dimensionen

% Falls bei 2D-Problem 3D-Koordinaten angegeben sind, die "Null-Richtung"
% rausschmeissen
if ndm==3                     % HBaa, 16.04.2009, wg. "Stab-Bsp. in Vorl.
  maxcoor = max(node);
  mincoor = min(node);
  dcoor = abs(maxcoor-mincoor);
  [value,pos] = min(dcoor);
  if (value<1.E-12)
    node(:,pos) = [];
    if (ndf==ndm)
      ndf=ndf-1;
    end
    ndm=ndm-1;
  end
end

% Eingabefile Elemente: el.inp
% Format: el(Anzahl Elemente x Materialnummer,Knotennummern)
load el.inp
dummy = size(el);
numel = dummy(1);    %Anzahl der Elemente im Problem
nel = dummy(2)-1;    %Anzahl der Knoten pro Element
el2mat = el(:,1);    %in der ersten Spalte steht die Materialnummer
el(:,1)=[];          %Rausschmeissen der Materialnummer aus el

% mat2el: pro Spalte stehen alle Elemente drin, die zu einem
% Materialdatensatz gehoeren, in der ersten Zeile steht wie viele
% Elemente es sind, Eckert 04.2003
mat2el = zeros(1,nummat);
for i=1:numel
  matsatz = el2mat(i);
  listlength = mat2el(1,matsatz) + 1;
  mat2el(1+listlength,matsatz) = i;
  mat2el(1,matsatz) = listlength;
end

% Aufbau von Vektoren mit Namen der Element- und Materialfunktionen
% neu Goy, Eckert 09.02, Fehler beseitigt, Eckert 10.02
elem_name = [repmat('elem',numel,1), ...
	     strjust(num2str(elem_nr_matr(el2mat')'),'left')]; %string-Vektor
mat_name  = [repmat('mat',numel,1), ...
	     strjust(num2str(mat_nr_matr(el2mat')'),'left')];  %string-Vektor

% Intitialisierung von u und du:
gesdof = ndf*numnp; %Anzahl der Gesamtfreiheitsgrade
u=zeros(gesdof,1);    %Spaltenvektor
du=zeros(gesdof,1);    %Spaltenvektor

% Eingabefile Verschiebungen: displ.inp
% Format:
% displ((Anzahl Knoten mit vorgeg. u) x (Knotennr.,Freiheitsgr.,Versch.))
load displ.inp
dummy=size(displ);
displ_len=dummy(1);
% Aufspalten von displ in 3 Vektoren damit int- und double-Variablen
% nicht im gleichen Feld
displ_node=displ(:,1);
displ_df=displ(:,2);
displ_u=displ(:,3);

% Initialisierung Lastvektor
p=zeros(gesdof,1);      %Spaltenvektor

% Eingabefile Knotenkraefte: force.inp
% Format:
% force(Anzahl belasteter Knoten x (Knotennr.,Freiheitsgr.,Knotenkraft))

% HBaa - 14.10.2016 fuer 'octave', wenn Datei leer
try
	load force.inp
catch err
	force = [];
end

dummy=size(force);
force_len=dummy(1);
if (force_len > 0)
  % Aufspalten von force in 3 Vektoren neu von Goy, 10.02
  force_node=force(:,1);
  force_df=force(:,2);
  force_val=force(:,3);

  % Einsortieren in Spaltenvektor p:
  for i=1:force_len
    %  p(ndf*(force(i,1)-1)+force(i,2))=force(i,3);
    p(ndf*(force_node(i)-1)+force_df(i))=force_val(i);
  end %i
end

%%%%%%%%%%%%%%%%%%%%
% Ende
% Eingabefiles lesen
%%%%%%%%%%%%%%%%%%%%

% History-Felder initialisieren

numgp_max=max(elem_gp_matr); % Max. Anzahl an GP's pro Element
gphist_max=max(mat_par_matr(1,:)); % Max. Anzahl an History-Variablen pro GP

% History-Matrizen:
% (Element-History-Variablen x Elementnummern)
% d.h. in jeder Spalte ist ein Satz Element-History-Variablen abgelegt
hist_old=zeros(numgp_max*gphist_max,numel);
hist_new=zeros(numgp_max*gphist_max,numel);
hist_user=zeros(numgp_max*gphist_max,numel);

% Initialisierung rechte Seite
rhs=zeros(gesdof,1);      %Spaltenvektor

disp(sprintf('\nInputfiles eingelesen'))
disp(sprintf('sparse_flag = %1.0f',sparse_flag))
disp(sprintf('load_flag = %1.0f',load_flag))
disp(sprintf('movie_flag = %1.0f',movie_flag))
disp(sprintf('Zeit: %8.4f',tim))

% Ende lprob.m

%fid_dae = 1;


