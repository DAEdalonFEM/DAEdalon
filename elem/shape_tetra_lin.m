%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002 Oliver Goy                                     %
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

function [shape,dshape,j] = shape_tetra_lin(x,coor)
%Formfunktion für 4Knoten-Tetraederelemente mit linearen Ansaetzen
%x = globale Koordinaten, coor = isoparam. Koor für akt. GP

% Knotenbezeichung siehe  und Integration mit 1 GP
r=coor(1);
s=coor(2);
t=coor(3);

% shapefunctions ausgewertet an der Stelle (xsi,eta,zeta):
shape(1) = 1.0-r-s-t;
shape(2) = r;
shape(3) = s;
shape(4) = t;

% berechnung dN/dr, dN/ds, dN/dt ...
% dN(u)/dx = dN(u)/du * du/dx
nshape(1,1)=-1.0;
nshape(1,2)=-1.0;
nshape(1,3)=-1.0;

nshape(2,1)= 1.0;
nshape(2,2)= 0.0;
nshape(2,3)= 0.0;

nshape(3,1)= 0.0;
nshape(3,2)= 1.0;
nshape(3,3)= 0.0;

nshape(4,1)= 0.0;
nshape(4,2)= 0.0;
nshape(4,3)= 1.0;

% Berechnung dx/dr = sum(dN/dr*x)
x_r=x'*nshape;
r_x = inv(x_r);

% Ableitungen der shapefunctions:
%dN/dx = dN/dr * dr/dx
%dshape(:,1) = nshape(:,1)*r_x(1,1) + nshape(:,2)*r_x(2,1) + nshape(:,3)*r_x(3,1);
%dshape(:,2) = nshape(:,1)*r_x(1,2) + nshape(:,2)*r_x(2,2) + nshape(:,3)*r_x(3,2);
%dshape(:,3) = nshape(:,1)*r_x(1,3) + nshape(:,2)*r_x(2,3) + nshape(:,3)*r_x(3,3);
dshape=nshape*r_x;
j = det(x_r);
if j <= 0
	disp('ACHTUNG J in Element negativ !')
end