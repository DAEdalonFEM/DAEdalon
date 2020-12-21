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

% meshnodes.m
% Speichern der Koordinaten in richtiger Reihenfolge zum Plotten
% eines Elements

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
%global fid_dae;
%figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Knoten fuer aktuelles Element in x_plot, y_plot speichern

% Zuordnung der Elementnummern (elemXY.m) zum jew. Elementtyp
truss_2 = {10};

triangle_3 = {2,102,333};
triangle_6 = {3,6,13,23,26,33,34,36,39,86,87,88,89,106};
quad_4 = {4,14,24,104,444};
quad_8 = {8};

tet_4 = {5};
tet_10 = {7};
brick_8 = {11};

switch elem_nr
    case triangle_3  % Dreieckselement (3 Knoten)
        x_plot(1:nel) = node(el(aktele,1:nel),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1:nel),1);
        x_plot(nel+1) = x_plot(1);

        y_plot(1:nel) = node(el(aktele,1:nel),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1:nel),2);
        y_plot(nel+1) = y_plot(1);

    case triangle_6  % Dreieckselement (6 Knoten)
        % Knotennummerierung im Dreieck nicht in Zeichenreihenfolge

        x_plot(1:2:nel) = node(el(aktele,1:nel/2),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1:nel/2),1);
        x_plot(2:2:nel) = node(el(aktele,nel/2+1:nel),1) + ...
            defo_flag*defo_scal*unode(el(aktele,nel/2+1:nel),1);
        x_plot(nel +1) = x_plot(1);

        y_plot(1:2:nel) = node(el(aktele,1:nel/2),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1:nel/2),2);
        y_plot(2:2:nel) = node(el(aktele,nel/2+1:nel),2) + ...
            defo_flag*defo_scal*unode(el(aktele,nel/2+1:nel),2);
        y_plot(nel +1) = y_plot(1);

    case quad_4  % Viereckselement (4 Knoten)
        x_plot(1:nel) = node(el(aktele,1:nel),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1:nel),1);
        x_plot(nel +1) = x_plot(1);

        y_plot(1:nel) = node(el(aktele,1:nel),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1:nel),2);
        y_plot(nel +1) = y_plot(1);

    case quad_8  % Viereckselement (8 Knoten)
        % genauso wie Sechsknoten-Dreieckselement
        x_plot(1:2:nel) = node(el(aktele,1:nel/2),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1:nel/2),1);
        x_plot(2:2:nel) = node(el(aktele,nel/2+1:nel),1) + ...
            defo_flag*defo_scal*unode(el(aktele,nel/2+1:nel),1);
        x_plot(nel +1) = x_plot(1);

        y_plot(1:2:nel) = node(el(aktele,1:nel/2),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1:nel/2),2);
        y_plot(2:2:nel) = node(el(aktele,nel/2+1:nel),2) + ...
            defo_flag*defo_scal*unode(el(aktele,nel/2+1:nel),2);
        y_plot(nel +1) = y_plot(1);

    case tet_4  % Tetraederelement (4 Knoten)
        x_plot(1:3) = node(el(aktele,1:3),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1:3),1);
        x_plot(4) = node(el(aktele,1),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1),1);
        x_plot(5) = node(el(aktele,4),1) + ...
            defo_flag*defo_scal*unode(el(aktele,4),1);
        x_plot(6) = node(el(aktele,3),1) + ...
            defo_flag*defo_scal*unode(el(aktele,3),1);
        x_plot(7) = node(el(aktele,2),1) + ...
            defo_flag*defo_scal*unode(el(aktele,2),1);
        x_plot(8) = node(el(aktele,4),1) + ...
            defo_flag*defo_scal*unode(el(aktele,4),1);

        y_plot(1:3) = node(el(aktele,1:3),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1:3),2);
        y_plot(4) = node(el(aktele,1),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1),2);
        y_plot(5) = node(el(aktele,4),2) + ...
            defo_flag*defo_scal*unode(el(aktele,4),2);
        y_plot(6) = node(el(aktele,3),2) + ...
            defo_flag*defo_scal*unode(el(aktele,3),2);
        y_plot(7) = node(el(aktele,2),2) + ...
            defo_flag*defo_scal*unode(el(aktele,2),2);
        y_plot(8) = node(el(aktele,4),2) + ...
            defo_flag*defo_scal*unode(el(aktele,4),2);

        z_plot(1:3) = node(el(aktele,1:3),3) + ...
            defo_flag*defo_scal*unode(el(aktele,1:3),3);
        z_plot(4) = node(el(aktele,1),3) + ...
            defo_flag*defo_scal*unode(el(aktele,1),3);
        z_plot(5) = node(el(aktele,4),3) + ...
            defo_flag*defo_scal*unode(el(aktele,4),3);
        z_plot(6) = node(el(aktele,3),3) + ...
            defo_flag*defo_scal*unode(el(aktele,3),3);
        z_plot(7) = node(el(aktele,2),3) + ...
            defo_flag*defo_scal*unode(el(aktele,2),3);
        z_plot(8) = node(el(aktele,4),3) + ...
            defo_flag*defo_scal*unode(el(aktele,4),3);

    case tet_10  % Tetraederelement (10 Knoten)
        x_plot(1:2:5) = node(el(aktele,1:3),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1:3),1);
        x_plot(2:2:10) = node(el(aktele,5:9),1) + ...
            defo_flag*defo_scal*unode(el(aktele,5:9),1);
        x_plot(7:2:9) = node(el(aktele,1:3:4),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1:3:4),1);
        x_plot(11:3:14) = node(el(aktele,2:8:10),1) + ...
            defo_flag*defo_scal*unode(el(aktele,2:8:10),1);
        x_plot(12) = node(el(aktele,6),1) + ...
            defo_flag*defo_scal*unode(el(aktele,6),1);
        x_plot(13:2:15) = node(el(aktele,3:4),1) + ...
            defo_flag*defo_scal*unode(el(aktele,3:4),1);

        y_plot(1:2:5) = node(el(aktele,1:3),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1:3),2);
        y_plot(2:2:10) = node(el(aktele,5:9),2) + ...
            defo_flag*defo_scal*unode(el(aktele,5:9),2);
        y_plot(7:2:9) = node(el(aktele,1:3:4),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1:3:4),2);
        y_plot(11:3:14) = node(el(aktele,2:8:10),2) + ...
            defo_flag*defo_scal*unode(el(aktele,2:8:10),2);
        y_plot(12) = node(el(aktele,6),2) + ...
            defo_flag*defo_scal*unode(el(aktele,6),2);
        y_plot(13:2:15) = node(el(aktele,3:4),2) + ...
            defo_flag*defo_scal*unode(el(aktele,3:4),2);

        z_plot(1:2:5) = node(el(aktele,1:3),3) + ...
            defo_flag*defo_scal*unode(el(aktele,1:3),3);
        z_plot(2:2:10) = node(el(aktele,5:9),3) + ...
            defo_flag*defo_scal*unode(el(aktele,5:9),3);
        z_plot(7:2:9) = node(el(aktele,1:3:4),3) + ...
            defo_flag*defo_scal*unode(el(aktele,1:3:4),3);
        z_plot(11:3:14) = node(el(aktele,2:8:10),3) + ...
            defo_flag*defo_scal*unode(el(aktele,2:8:10),3);
        z_plot(12) = node(el(aktele,6),3) + ...
            defo_flag*defo_scal*unode(el(aktele,6),3);
        z_plot(13:2:15) = node(el(aktele,3:4),3) + ...
            defo_flag*defo_scal*unode(el(aktele,3:4),3);

    case truss_2  % Stabelement (2 Knoten)
        x_plot(1:2) = node(el(aktele,1:2),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1:2),1);
        y_plot(1:2) = node(el(aktele,1:2),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1:2),2);
        if (ndm == 3)
            z_plot(1:2) = node(el(aktele,1:2),3) + ...
                defo_flag*defo_scal*unode(el(aktele,1:2),3);
        end %if

    case brick_8  % Quaderelement (8 Knoten)
        x_plot(1:4) = node(el(aktele,1:4),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1:4),1);
        x_plot(5) = node(el(aktele,1),1) + ...
            defo_flag*defo_scal*unode(el(aktele,1),1);
        x_plot(6:9) = node(el(aktele,5:8),1) + ...
            defo_flag*defo_scal*unode(el(aktele,5:8),1);
        x_plot(10:11) = node(el(aktele,5:6),1) + ...
            defo_flag*defo_scal*unode(el(aktele,5:6),1);
        x_plot(12:13) = node(el(aktele,2:3),1) + ...
            defo_flag*defo_scal*unode(el(aktele,2:3),1);
        x_plot(14:15) = node(el(aktele,7:8),1) + ...
            defo_flag*defo_scal*unode(el(aktele,7:8),1);
        x_plot(16) = node(el(aktele,4),1) + ...
            defo_flag*defo_scal*unode(el(aktele,4),1);

        y_plot(1:4) = node(el(aktele,1:4),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1:4),2);
        y_plot(5) = node(el(aktele,1),2) + ...
            defo_flag*defo_scal*unode(el(aktele,1),2);
        y_plot(6:9) = node(el(aktele,5:8),2) + ...
            defo_flag*defo_scal*unode(el(aktele,5:8),2);
        y_plot(10:11) = node(el(aktele,5:6),2) + ...
            defo_flag*defo_scal*unode(el(aktele,5:6),2);
        y_plot(12:13) = node(el(aktele,2:3),2) + ...
            defo_flag*defo_scal*unode(el(aktele,2:3),2);
        y_plot(14:15) = node(el(aktele,7:8),2) + ...
            defo_flag*defo_scal*unode(el(aktele,7:8),2);
        y_plot(16) = node(el(aktele,4),2) + ...
            defo_flag*defo_scal*unode(el(aktele,4),2);

        z_plot(1:4) = node(el(aktele,1:4),3) + ...
            defo_flag*defo_scal*unode(el(aktele,1:4),3);
        z_plot(5) = node(el(aktele,1),3) + ...
            defo_flag*defo_scal*unode(el(aktele,1),3);
        z_plot(6:9) = node(el(aktele,5:8),3) + ...
            defo_flag*defo_scal*unode(el(aktele,5:8),3);
        z_plot(10:11) = node(el(aktele,5:6),3) + ...
            defo_flag*defo_scal*unode(el(aktele,5:6),3);
        z_plot(12:13) = node(el(aktele,2:3),3) + ...
            defo_flag*defo_scal*unode(el(aktele,2:3),3);
        z_plot(14:15) = node(el(aktele,7:8),3) + ...
            defo_flag*defo_scal*unode(el(aktele,7:8),3);
        z_plot(16) = node(el(aktele,4),3) + ...
            defo_flag*defo_scal*unode(el(aktele,4),3);

    otherwise
        error('Element existiert nicht')
end  % switch
