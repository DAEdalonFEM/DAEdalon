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

% setGloVar.m
% wird von verschiedenen funtionen benutzt, die auf unten stehende
% variablen aus der aktuellen matlab-sitzung zugreifen muessen

% gesamtproblembezogene skalare groessen
global elem_nr ndf ndm nel numnp numel nummat mat2el;

% elementbezogene felder
global shape dshape detvol gpcoor gpweight k_elem r_elem cont_mat_gp aktele;

% gesamtproblembezogene felder und vektoren
global node el u;

% gesamtproblembezogene parameter zur beschreibung des materialverhaltens
global mat_nr mat_par;

% zur komunikation zwischen einer funktion und einem skript (bspw. elem4)
% daten von/zu funktion zu/von skript (fnc<->scr) ; speziell für skripts
% von elemente
global x u_elem unode shapeGp;

global cont_mat_node cont_value
global cont_flag
global resid res_norm tim
global cont_mat_node
global dt dt_new
global r
global vers_nr
global out_file_name histout_file_name
global elem_nr_matr el2mat surf_value surf_data
global numgp_max gphist_max hist_old hist_new % fuer histout
global mat_set
global contvar
global sparse_flag;
global load_flag;
global movie_flag
global defo_scal;
global steps_total
global rst_file_name
global out_incr rst_incr;
global userSkript;
global lam;
global bounDisp_treat;
global mat_oct_flag;                      % Projekt WiSe2015 - HBaa
global pc_environ;                        % HBaa - 14.10.2016
global dir_trenn;
%
%