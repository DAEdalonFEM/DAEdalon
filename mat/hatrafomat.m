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

function [trafo_mat] = hatrafomat(a)

% Aufbau der Transformationsmatrix trafo_mat, mit der man einen Tensor
% 2-ter Stufe in Voigt-Notation im HA-System a zurueck ins
% urspruengliche System transformiert:
% Tensornotation:  A_neu = a * A_alt * a^T
% Vektornotation:  A_neu_voigt = trafo_mat * A_alt_voigt
% Trafo eines Tensors vierter Stufe D (6x6 Matrix in Voigt-Notation):
% D_neu_voigt = trafo_mat * D_alt_voigt * trafo_mat^(-1)
% Achtung es gilt NICHT trafomat^T = trafo_mat^(-1)
% Siehe Wriggers p.232,233, Reese 1994

trafo_mat = [a(1,1)^2 a(1,2)^2 a(1,3)^2 ...
	     2.0*a(1,1)*a(1,2) 2.0*a(1,3)*a(1,2) 2.0*a(1,1)*a(1,3); ...
%
	     a(2,1)^2 a(2,2)^2 a(2,3)^2 ...
	     2.0*a(2,1)*a(2,2) 2.0*a(2,3)*a(2,2) 2.0*a(2,1)*a(2,3); ...
%
	     a(3,1)^2 a(3,2)^2 a(3,3)^2 ...
	     2.0*a(3,1)*a(3,2) 2.0*a(3,3)*a(3,2) 2.0*a(3,1)*a(3,3); ...
%
	     a(1,1)*a(2,1) a(1,2)*a(2,2) a(1,3)*a(2,3) ...
	     a(1,2)*a(2,1)+a(1,1)*a(2,2) a(1,3)*a(2,2)+a(1,2)*a(2,3) ...
	     a(1,3)*a(2,1)+a(1,1)*a(2,3); ...
%
	     a(2,1)*a(3,1) a(2,2)*a(3,2) a(2,3)*a(3,3) ...
	     a(2,2)*a(3,1)+a(2,1)*a(3,2) a(2,3)*a(3,2)+a(2,2)*a(3,3) ...
	     a(2,3)*a(3,1)+a(2,1)*a(3,3); ...
%
	     a(1,1)*a(3,1) a(1,2)*a(3,2) a(1,3)*a(3,3) ...
	     a(1,2)*a(3,1)+a(1,1)*a(3,2) a(1,3)*a(3,2)+a(1,2)*a(3,3) ...
	     a(1,3)*a(3,1)+a(1,1)*a(3,3)];
