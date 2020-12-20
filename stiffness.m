%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002 Steffen Eckert, Oliver Goy                     %
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

% stiffness.m
% Ab Version 1.5 kann stiffness.m als Funktion durch
% stiffness_func.m aufgerufen werden, damit stiffness auch
% kompiliert werden kann. 

[k,r,u,hist_new,hist_user,cont_mat_node] = ...
    stiffness_func(nel,ndf,u,displ_u,displ_df,displ_node,displ_len, ...
		   elem_name,mat_name,el,el2mat,mat2el,mat_set,mat_par_matr,...
		   node,contvar,gesdof,numgp_max,numel,numnp,sparse_flag,...
		   load_flag,tim,hist_old,hist_user,gphist_max);

% Ende stiffness.m


