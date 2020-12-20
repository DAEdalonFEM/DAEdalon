%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Steffen Eckert/Oliver Goy                 %
%              2015 Herbert Baaser                                 %
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

% cont_draw.m
% neue Struktur, cont_draw wird von cont.m, cont_sm.m und ucont.m
% aufgerufen und zeichnet die Elemente, Eckert 05.03
% die ganzen elvalin-Aufrufe sind jetzt nicht n�tig, da cont_draw.m
% keine Funktion ist, sollten aber auch nicht schaden


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
%global fid_dae;
%figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global numel aktele cont_value elem_nr cont_flag ndm;
global  surf_value surf_data elem_nr_matr el2mat;

% aufbereiten der Daten f�rs Element
evalin('base','surfnodes');

% Elementnummer bestimmen
elem_nr = elem_nr_matr(el2mat(aktele));

% Element zeichnen
switch elem_nr
 case {2,3,4,6,8,13,14,23,24,26,33,34,36,39,86,87,102,104,106,444}
  evalin('base','patch(x_surf,y_surf,surf_value)');

 case {10}   % Stabelement
	     % surf_value auf max. Strichst�rke von 8 normieren
	     surf_value = surf_value/max(abs(surf_data))*8.0;

	     if surf_value >= 0.0
	       pl_col = 'r';
	     else
	       pl_col = 'b';
	     end %if

	     string = ['plot3(x_surf,y_surf,z_surf,''',pl_col, ...
		       ''',''LineWidth'',',num2str(abs(surf_value)),')'];
	     evalin('base', string);

 case {5,7,9,11}                       % Volumenelemente
  if elem_nr == 5 | elem_nr == 7       % Tetraeder - 4 oder 10 Knoten
    anz_f = 4;
  elseif elem_nr == 9 | elem_nr == 11  % Brick-Element
    anz_f = 6;
  end

  for k=1:anz_f
    plotstring = ['patch(''Vertices'',[x_surf,y_surf,z_surf],',...
		  '''Faces'',face_surf(',num2str(k),',:),'...
		  '''FaceVertexCData'',surf_value,'...
		  '''FaceColor'',''interp'')'];
    evalin('base',plotstring);
  end %for

end %switch elem_nr