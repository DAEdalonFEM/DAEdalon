%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002 Steffen Eckert/Oliver Goy                      %
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

% surfnodes.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
%global fid_dae;
%figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch elem_nr
    case triangle_3  % Dreieckselement (3 Knoten)
        x_surf=node(el(aktele,1:nel),1)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nel),1);

        y_surf=node(el(aktele,1:nel),2)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nel),2);

        surf_value = surf_data(el(aktele,1:nel));

    case [triangle_6, quad_8]  % Dreieckselement (6 Kn.) / Viereckselement (8 Kn.)
        % Knotennummerierung: nur Eckknoten
        x_surf=node(el(aktele,1:nel/2),1)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nel/2),1);

        y_surf=node(el(aktele,1:nel/2),2)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nel/2),2);

        surf_value = surf_data(el(aktele,1:nel/2));

    case quad_4  % Viereckselement (4 Knoten)
        x_surf(1:nel)=node(el(aktele,1:nel),1)+ ...
            defo_flag*defo_scal*unode(el(aktele,1:nel),1);

        y_surf(1:nel)=node(el(aktele,1:nel),2)+ ...
            defo_flag*defo_scal*unode(el(aktele,1:nel),2);

        surf_value = surf_data(el(aktele,1:nel));

    case [tet_4, tet_10]  % Tetraederelemente (4 & 10 Knoten)
        nr_vert = 4;

        x_surf=node(el(aktele,1:nr_vert),1)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nr_vert),1);

        y_surf=node(el(aktele,1:nr_vert),2)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nr_vert),2);

        z_surf=node(el(aktele,1:nr_vert),3)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nr_vert),3);

        surf_value = surf_data(el(aktele,1:nr_vert));

        face_surf=[1 2 3; 2 1 4; 3 4 1; 4 3 2];

    case pyramid_5  % Pyramidenelement (5 Knoten)
        nr_vert = 5;

        x_surf=node(el(aktele,1:nr_vert),1)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nr_vert),1);

        y_surf=node(el(aktele,1:nr_vert),2)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nr_vert),2);

        z_surf=node(el(aktele,1:nr_vert),3)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nr_vert),3);

        surf_value = surf_data(el(aktele,1:nr_vert));

        % Da es Flaechen mit 3 und 4 Knoten gibt, brauchen die Flaechen mit 3 Knoten
        % im Array noch einen vierten Eintrag. Hier wird einfach der erste Eintrag am Ende wiederholt.
        face_surf=[1 2 3 4; 2 1 5 2; 3 2 5 3; 4 3 5 4; 1 4 5 1];

    case brick_8  % Quaderelement (8 Knoten)
        x_surf=node(el(aktele,1:nel),1)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nel),1);

        y_surf=node(el(aktele,1:nel),2)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nel),2);

        z_surf=node(el(aktele,1:nel),3)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nel),3);

        surf_value = surf_data(el(aktele,1:nel));

        face_surf=[4 3 2 1; 2 3 7 6; 5 6 7 8; 1 5 8 4; 1 2 6 5; 3 4 8 7];

    case truss_2  % Stabelement (2 Knoten)
        x_surf=node(el(aktele,1:nel),1)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nel),1);

        y_surf=node(el(aktele,1:nel),2)+ ...
               defo_flag*defo_scal*unode(el(aktele,1:nel),2);

        if (ndm == 3)
            z_surf=node(el(aktele,1:nel),3)+ ...
                 defo_flag*defo_scal*unode(el(aktele,1:nel),3);
        else
            z_surf(1:nel)=0.0;
        end %if

        surf_value = surf_data(aktele);

    otherwise
        error('Element existiert nicht')
end  % switch
