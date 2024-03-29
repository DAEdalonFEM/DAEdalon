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

function [sig,vareps,D_mat,hist_new_gp,hist_user_gp] ...
    = mat1(mat_par,F,hist_old_gp,hist_user_gp)


fall = 'esz';
%fall = 'evz';


% lin. elast Matarialverhalten ESZ oder EVZ 2D
% Berechnung des E-tensors (elast. Anteil der Materialtangente)
%
% rein:
% mat_par = Materialparameter (z.B. E, nu)
% F = Deformationsgradient dx/dX
% hist_old_gp = GP-Historyfeld, wie im Element (gphist_max x 1)
% hist_user_gp = GP-Historyfeld, wie im Element (gphist_max x 1)
%
% raus:
% sig = Spannungsgroesse
% vareps = zu sig konjugierte Verzerrungsgroesse
% D_mat = linearisierte Materialtangente am GP
% hist_new_gp = GP-Historyfeld, wie im Element (gphist_max x 1)
% hist_user_gp = s.o.


% Damit hist_new_gp belegt ist, auch wenn sich an den
% hist.-Variablen nichts aendert:
hist_new_gp=hist_old_gp;

nhv=mat_par(1); % Anzahl der History-Variablen pro GP
Emod=mat_par(2);
nu=mat_par(3);
C_el = etensor(Emod,nu,fall);

vareps=zeros(3,1);
D_mat = C_el;

% du/dX = (F + F^T)/2 - 1

vareps(1)=F(1,1)-1.0;
vareps(2)=F(2,2)-1.0;
vareps(3)=F(1,2)+F(2,1);

sig = D_mat * vareps;
