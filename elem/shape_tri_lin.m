%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002 Steffen Eckert, Andreas Trondl                 %
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

function [ shape, dshape, j ] = shape_tri_lin( x, coor )
% shape-funktion fuer 3-Knoten-Dreieckselemente mit linearen Ansaetzen
% Knotenbezeichung wie in Hughes p.167 und Integration mit 3 GPs

% shapefunctions ausgewertet an der Stelle (xsi,eta)
shape = [ coor, 1. - sum(coor) ];

% berechnung von ableitungen der shapefunctions nach lokalen variablen
nshape = [ +1.,  0. ; ...
            0., +1. ; ...
           -1., -1. ];

%Berechung dx/dr = sum(dN/dr*x)
x_r = x' * nshape;
% ohne ^t(=') da durch mult. mit x von links bereits transposition impliziert ist
r_x = inv(x_r);

% Ableitungen der shapefunctions nach globalen Variablen:
% dN/dx = dN/dr * dr/dx
dshape = nshape * r_x;
j = det(x_r);
