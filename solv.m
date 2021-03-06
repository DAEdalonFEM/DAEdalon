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

% solv.m
% Loesung des globales GlSyst (1 Newton-Iteration)
% k * du = rhs

%Vorkonditionierung
%inv_c=inv(diag(diag(k)));
%k_cond=inv_c*k;
%rhs_cond =inv_c*rhs;

% Loesen des GlSyst

if (bounDisp_treat == 0)
  du=k\rhs;
  %du=k_cond\rhs_cond;
else
  % aT: reduziertes system loesen
  du(poU) = k(poU,poU) \ rhs(poU);
end

% Update des Verschiebungsvektors
%sprintf('Loesung / Verschiebungsvektor:')
u=u+du;



cont_flag=0;

% Ende solv.m
