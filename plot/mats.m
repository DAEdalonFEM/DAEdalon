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

% Zuordnung der Elementnummern (elemXY.m) zum jew. Elementtyp
truss_2 = {10};

triangle_3 = {2,102,333};
triangle_6 = {3,6,13,23,26,33,34,36,39,86,87,88,89,106};
quad_4 = {4,14,24,104,444};
quad_8 = {8};

tet_4 = {5};
tet_10 = {7};
brick_8 = {9, 11};  % 9 aus cont_draw.m uebernommen ?!

surf_elem = [triangle_3, triangle_6, quad_4, quad_8];
vol_elem = [tet_4, tet_10, brick_8];

surf_data = spalloc(numnp,1,1);

% Schleife ueber alle Elemente
for aktele=1:numel

    % Materialnummer fuer aktuelles Element raussuchen
    %mat_nr = mat_nr_matr(el2mat(aktele));
    mat_nr = el2mat(aktele);

    % Elementnummer bestimmen
    elem_nr = elem_nr_matr(el2mat(aktele));

    % Aufbereiten der Daten fuers Element
    evalin('base','surfnodes');

    len = size(x_surf);
    surf_value = repmat(mat_nr,len,1);

    % Element zeichnen
    switch elem_nr
        case surf_elem  % Surface-Elemente
            evalin('base','patch(x_surf,y_surf,surf_value)');

        case truss_2  % Stabelement
            % surf_value auf max. Strichstaerke von 8 normieren
            %surf_value = surf_value/max(abs(surf_data))*8.0;

            %if surf_value >= 0.0
            %   pl_col = 'r';
            %else
            %   pl_col = 'b';
            %end %if

           string = ['plot3(x_surf,y_surf,z_surf,''',pl_col, ...
                     ''',''LineWidth'',',num2str(5),')'];
           evalin('base', string);


        case vol_elem  % Volumenelemente
            if not(isempty(find([[tet_4, tet_10]{:}] == elem_nr)))  % Tetraederelement (4 oder 10 Knoten)
                anz_f = 4;
            elseif not(isempty(find([brick_8{:}] == elem_nr)))  % Quaderelement
                anz_f = 6;
            end %if

           for k=1:anz_f
               string = ['patch(''Vertices'',[x_surf,y_surf,z_surf],',...
              	         '''Faces'',face_surf(',num2str(k),',:),'...
              	         '''FaceVertexCData'',surf_value,'...
              	         '''FaceColor'',''interp'')'];
               evalin('base', string);
           end %for

    end %switch elem_nr
end %aktele

set(findobj('Type','patch'),'EdgeColor','none')

colorbar;
colormap(jet); % jet,bone,hsv

title('Materialdatensaetze');

% Achsenbeschriftung
xlabel('x');
ylabel('y');
if (ndm==3)
  zlabel('z');
end
