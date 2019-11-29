%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2001 Herbert Baaser                                 %
%              2002/2003 Steffen Eckert                            %
%              2015 Herbert Baaser                                 %
%              2016 Herbert Baaser                                 %
%                                                                  %
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

% dae.m

% ndm     Anzahl der Dimensionen
% numnp   Anzahl der Gesamtknoten
% numel   Anzahl der Elemente im Problem
% nel     Anzahl der Knoten pro Element
% ndf     Freiheitsgrade pro Knoten (nicht immer gleich ndm)
% gesdof  Anzahl der Gesamtfreiheitsgrade 
% numgp_max   Max. Anzahl der verwendeten Gausspunkte pro Element
% nummat  Anzahl der unterschiedlichen verwendeten Materialgesetze

clear all

setGloVar;

% Auf welchem System laeuft's ?  -  HBaa, 15.10.2016
%
% Projekt WiSe 2015 - HBaa
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;   % 11.01.2016
if isOctave == 1
    mat_oct_flag = true;       % jetzt "octave"
elseif isOctave == 0
    mat_oct_flag = false;
end
%
% HBaa - 14.10.2016: "ispc", "isunix", "ismac"           --- Geht das schoener ?
if isOctave == 1
	pc_environ = ispc;
elseif isOctave == 0
	if ispc==1
		pc_environ = true;
	elseif ispc==0
		pc_environ = false;
	end
end

% Pfade absolut setzen
if pc_environ
	dir_trenn = '\';      % WIN-PC              - HBaa, 14.10.2016
else
	dir_trenn = '/';      % LINUX / MAC
end
aP = [pwd,dir_trenn];

% Pfade hinzufuegen
addpath([aP,'plot'])
addpath([aP,'input'])
addpath([aP,'elem'])
addpath([aP,'mat'])
addpath([aP,'dynamics'])
addpath([aP,'post'])
addpath([aP,'output'])
addpath([aP,'logo'])
addpath([aP,'rst_files'])
addpath([aP,'..',dir_trenn,'ownstuff'])

% AMINEM: Pfade fuer GUI
addpath([aP,'gui'])
addpath([aP,'gui',dir_trenn,'gui_pre'])
addpath([aP,'gui',dir_trenn,'gui_prog'])
addpath([aP,'gui',dir_trenn,'gui_plot'])
addpath([aP,'gui',dir_trenn,'gui_post'])
addpath([aP,'gui',dir_trenn,'gui_opt'])

% aT: Bogenlaengenverfahren
addpath([aP,'arcLength'])

% Paraview-Macros in Paraview-Konfig-Ordner kopieren, falls Ordner vorhanden
paraview_check

% gui initialisieren
crf
gui_setup

%
% *** END ***
