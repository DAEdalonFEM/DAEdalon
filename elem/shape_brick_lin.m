%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002 Steffen Eckert/Daniel Hofer                    %
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

function [shape,dshape,j] = shape_brick_lin(x,coor)
%shape-funktion fuer 3d-8-Knotenelemente mit lin. Ansaetzen

xsi =coor(1);
eta =coor(2);
zeta=coor(3);

% shapefunctions ausgewertet an der Stelle (xsi,eta):

% quadratische Formfunktionen ausgewertet an der Stelle (xsi,eta):
% Eckknoten:
shape(1)= 0.125*(1.0-xsi)*(1.0-eta)*(1.0-zeta);
shape(2)= 0.125*(1.0+xsi)*(1.0-eta)*(1.0-zeta);
shape(3)= 0.125*(1.0+xsi)*(1.0+eta)*(1.0-zeta);
shape(4)= 0.125*(1.0-xsi)*(1.0+eta)*(1.0-zeta);
shape(5)= 0.125*(1.0-xsi)*(1.0-eta)*(1.0+zeta);
shape(6)= 0.125*(1.0+xsi)*(1.0-eta)*(1.0+zeta);
shape(7)= 0.125*(1.0+xsi)*(1.0+eta)*(1.0+zeta);
shape(8)= 0.125*(1.0-xsi)*(1.0+eta)*(1.0+zeta);

% Ableitungen der Formfunktionen
% nach xsi (:,1), eta (:,2) und zeta (:,3):

nshape(1,1)=-0.125*(1.0-eta)*(1.0-zeta);  %1
nshape(1,2)=-0.125*(1.0-xsi)*(1.0-zeta);
nshape(1,3)=-0.125*(1.0-xsi)*(1.0-eta);
nshape(2,1)=0.125*(1.0-eta)*(1.0-zeta);   %2
nshape(2,2)=-0.125*(1.0+xsi)*(1.0-zeta);
nshape(2,3)=-0.125*(1.0+xsi)*(1.0-eta);
nshape(3,1)=0.125*(1.0+eta)*(1.0-zeta);   %3
nshape(3,2)=0.125*(1.0+xsi)*(1.0-zeta);
nshape(3,3)=-0.125*(1.0+xsi)*(1.0+eta);
nshape(4,1)=-0.125*(1.0+eta)*(1.0-zeta);  %4
nshape(4,2)=0.125*(1.0-xsi)*(1.0-zeta);
nshape(4,3)=-0.125*(1.0-xsi)*(1.0+eta);
nshape(5,1)=-0.125*(1.0-eta)*(1.0+zeta);  %5
nshape(5,2)=-0.125*(1.0-xsi)*(1.0+zeta);
nshape(5,3)=0.125*(1.0-xsi)*(1.0-eta);
nshape(6,1)=0.125*(1.0-eta)*(1.0+zeta);   %6
nshape(6,2)=-0.125*(1.0+xsi)*(1.0+zeta);
nshape(6,3)=0.125*(1.0+xsi)*(1.0-eta);
nshape(7,1)=0.125*(1.0+eta)*(1.0+zeta);	  %7
nshape(7,2)=0.125*(1.0+xsi)*(1.0+zeta);
nshape(7,3)=0.125*(1.0+xsi)*(1.0+eta);
nshape(8,1)=-0.125*(1.0+eta)*(1.0+zeta);  %8
nshape(8,2)=0.125*(1.0-xsi)*(1.0+zeta);
nshape(8,3)=0.125*(1.0-xsi)*(1.0+eta);

%Berechung dx/dxsi = sum(N_xsi*x)

x_xsi=x'*nshape;
xsi_x = inv(x_xsi); % ohne ^T, getestet 26.02.2002 StE

% Ableitungen der shapefunctions:
%dshape(:,1) = nshape(:,1)*xsi_x(1,1) + nshape(:,2)*xsi_x(2,1);
%dshape(:,2) = nshape(:,1)*xsi_x(1,2) + nshape(:,2)*xsi_x(2,2);
dshape=nshape*xsi_x;
j= det(x_xsi);
if j <= 0
	disp('ACHTUNG: J in Element negativ!')
end
