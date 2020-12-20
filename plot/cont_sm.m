%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Steffen Eckert/Oliver Goy                 %
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

function cont_sm(arg1,arg2)
global numel aktele cont_value elem_nr cont_flag ndm;
global  surf_value surf_data elem_nr_matr el2mat;
global nummat mat2el mat_set;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
global fid_dae;
figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cont_value = arg1;
mat_set = arg2;

% evalin ruft mfiles auf, wobei alle Variablen gültig sind, die auch
% im workspace verfügbar sind

% Aufruf von stiffness, durch setzen von mat_set = arg2 werden aber
% nur die Elemente mit Materialdatensatz mat_set assembliert
evalin('base','stiffness;');

% Vektor mit Contour-Variable aufbauen:
% eine zeile aus der Matrix cont_mat_node:
%    2-D:   (numnp x (epsx,epsy,2.0*epsxy,sigx,sigy,sigxy,,,))
%    3-D:   (numnp x (epsx,epsy,epsz,2.0*epsxy,2.0*epsyz,2.0*epsxz,
%                     sigx,sigy,sigz,sigxy,sigyz,sigxz,,,))

evalin('base','surf_data=cont_mat_node(:,[cont_value]);');

% Schleife über alle Elemente EINES Datensatzes
listlength = mat2el(1,arg2);
elements = mat2el( 2:listlength+1,arg2);
for aktele = elements'

  % zeichnen der Elemente, ab jetzt durch Aufruf von cont_draw.m
  evalin('base','cont_draw');

end


cont_max = max(surf_data);
cont_min = min(surf_data);

set(findobj('Type','patch'),'EdgeColor','none')

colorbar;
colormap(jet); % jet,bone,hsv

title(['cont\_sm(',num2str(cont_value),',',num2str(mat_set),'):   ',...
       'max-Wert: ',num2str(cont_max),',   min-Wert: ', ...
       num2str(cont_min)]);

% Achsenbeschriftung
xlabel('x');
ylabel('y');
if (ndm==3)
  zlabel('z');
end

% nochmal aufrufen mit Schleife über alle Materialdatensätze, damit
% alles wieder beim alten ist.
mat_set=1:nummat;
evalin('base','stiffness;');