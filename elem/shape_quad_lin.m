%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002 Steffen Eckert                                 %
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

function [shape,dshape,j] = shape_quad_lin(x,coor)
%shape-funktion fuer Vierknotenelemente mit lin. Ansaetzen

xsi=coor(1);
eta=coor(2);

% shapefunctions ausgewertet an der Stelle (xsi,eta):

shape(1) = 0.25*(1.0-xsi)*(1.0-eta);
shape(2) = 0.25*(1.0+xsi)*(1.0-eta);
shape(3) = 0.25*(1.0+xsi)*(1.0+eta);
shape(4) = 0.25*(1.0-xsi)*(1.0+eta);

% Berechnung dN/dxsi ...
nshape(1,1) = -0.25*(1.0-eta);
nshape(1,2) = -0.25*(1.0-xsi);

nshape(2,1) =  0.25*(1.0-eta);
nshape(2,2) = -0.25*(1.0+xsi);

nshape(3,1) =  0.25*(1.0+eta);
nshape(3,2) =  0.25*(1.0+xsi);

nshape(4,1) = -0.25*(1.0+eta);
nshape(4,2) =  0.25*(1.0-xsi);

%Berechnung dx/dxsi = sum(N_xsi*x)
x_xsi=x'*nshape;
xsi_x = inv(x_xsi); % ohne ^T, getestet 26.02.2002 StE

% Ableitungen der shapefunctions:
%dshape(:,1) = nshape(:,1)*xsi_x(1,1) + nshape(:,2)*xsi_x(2,1);
%dshape(:,2) = nshape(:,1)*xsi_x(1,2) + nshape(:,2)*xsi_x(2,2);
dshape=nshape*xsi_x;
j= det(x_xsi);