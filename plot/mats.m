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
%    Public License along with DAEdalon; if not, write to the      %
%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,   %
%    Boston, MA  02111-1307  USA                                   %
%                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% mats.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
global fid_dae;
figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

surf_data = spalloc(numnp,1,1);

% Schleife �ber alle Elemente
for aktele=1:numel

  % Materialnummer f�r aktuelles Element raussuchen
  %mat_nr= mat_nr_matr(el2mat(aktele));
  mat_nr= el2mat(aktele);

  % aufbereiten der Daten f�rs Element
  evalin('base','surfnodes');

  len = size(x_surf);
  surf_value = repmat(mat_nr,len,1);

  % Elementnummer bestimmen
  elem_nr=elem_nr_matr(el2mat(aktele));

  % Element zeichnen
  switch elem_nr
   case {2,3,4,6,8,13,14,23,24,26,33,36,39,86,87,333}

    evalin('base','patch(x_surf,y_surf,surf_value)');

  case {10}   % Stabelement
      % surf_value auf max. Strichst�rke von 8 normieren
      %surf_value = surf_value/max(abs(surf_data))*8.0;

      %if surf_value >= 0.0
      %   pl_col = 'r';
      %else
      %   pl_col = 'b';
      %end %if

     string = ['plot3(x_surf,y_surf,z_surf,''',pl_col, ...
             ''',''LineWidth'',',num2str(5),')'];
     evalin('base', string);


  case {7,11}    % Volumenelemente
      if elem_nr == 7   % Tetraederelement
        anz_f = 4;
      elseif elem_nr == 11   % Quaderelement
        anz_f = 6;
      end %if

     for k=1:anz_f
        fuckstring = ['patch(''Vertices'',[x_surf,y_surf,z_surf],',...
		    '''Faces'',face_surf(',num2str(k),',:),'...
		    '''FaceVertexCData'',surf_value,'...
		    '''FaceColor'',''interp'')'];
        evalin('base',fuckstring);
     end %for

  end %switch elem_nr
end %aktele

set(findobj('Type','patch'),'EdgeColor','none')

colorbar;
colormap(jet); % jet,bone,hsv

title('Materialdatens�tze');

% Achsenbeschriftung
xlabel('x');
ylabel('y');
if (ndm==3)
  zlabel('z');
end