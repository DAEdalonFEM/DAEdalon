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

function [S,E,D_mat,hist_new_gp,hist_user_gp] ...
    = mat2(mat_par,F,hist_old_gp,hist_user_gp)
%
% St. Venant - Material (2D) Wriggers p.127
%
% rein:
% mat_par = Materialparameter (z.B. E, nu)
% F = Deformationsgradient dx/dX
% hist_old_gp = GP-Historyfeld, wie im Element (gphist_max x 1)
% hist_user_gp = GP-Historyfeld, wie im Element (gphist_max x 1)
%
% raus:
% S = Spannungsgröße
% E = zu S konjugierte Verzerrungsgröße
% D_mat = linearisierte Materialtangente am GP
% hist_new_gp = GP-Historyfeld, wie im Element (gphist_max x 1)
% hist_user_gp = s.o.


% Damit hist_new_gp belegt ist, auch wenn sich an den
% hist.-Variablen nichts ändert:
hist_new_gp=hist_old_gp;

E=zeros(3,1);
% Berechnung des E-tensors (elast. Anteil der Materialtangente)
Emod=mat_par(2);
nu=mat_par(3);
C_el = etensor(Emod,nu);
D_mat = C_el;

% Green-Lagrange-VT: E = 0.5 * ( F^T*F - 1)
E_mat=0.5*(F'*F -eye(2));

E(1)=E_mat(1,1);
E(2)=E_mat(2,2);
E(3)=2.0*E_mat(1,2);

S = D_mat * E;

