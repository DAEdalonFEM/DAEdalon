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

function [shape,dshape,j] = shape_tri_quadr(x,coor)
%shape-funktion für 6Knoten-Dreieckselemente mit quadratischen Ansaetzen
%x = globale Koordinaten, coor = isoparam. Koor für akt. GP 

% Knotenbezeichung wie in Hughes p.166-169 und Integration mit 3 GPs
r=coor(1);
s=coor(2);
t=1.0-r-s;

% shapefunctions ausgewertet an der Stelle (xsi,eta):
shape(1)=2.0*r*r - r;
shape(2)=2.0*s*s - s;
shape(3)=2.0*t*t - t;
shape(4)=4.0*r*s;
shape(5)=4.0*s*t;
shape(6)=4.0*r*t;

% berechnung dN/dr ...

nshape(1,1)=4.0*r-1.0;
nshape(1,2)=0.0;

nshape(2,1)=0.0;
nshape(2,2)=4.0*s-1.0;

%dN(t)/dr = dN(t)/dt * dt/r
nshape(3,1)=-4.0*t + 1.0;
nshape(3,2)=-4.0*t + 1.0;

nshape(4,1)=4.0*s;
nshape(4,2)=4.0*r;

nshape(5,1)=-4.0*s;
nshape(5,2)=4.0*(t-s);

nshape(6,1)=4.0*(t-r);
nshape(6,2)=-4.0*r;

%Berechung dx/dr = sum(dN/dr*x)

x_r=x'*nshape;
r_x = inv(x_r); % ohne ^T, getestet 26.02.2002 fuer shape_quad_lin, StE

% Ableitungen der shapefunctions:
%dN/dx = dN/dr * dr/dx
%dshape(:,1) = nshape(:,1)*r_x(1,1) + nshape(:,2)*r_x(2,1);
%dshape(:,2) = nshape(:,1)*r_x(1,2) + nshape(:,2)*r_x(2,2);
dshape=nshape*r_x;
j= det(x_r);
