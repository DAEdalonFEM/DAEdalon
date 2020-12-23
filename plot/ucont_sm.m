%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2003 Steffen Eckert                                 %
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

function ucont_sm(arg1,arg2)
global numel cont_value ndm ndf numnp aktele;
global surf_data el2mat ;
global nummat mat2el mat_set;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
global fid_dae;
figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cont_value = arg1;
mat_set = arg2;

evalin('base','surf_data=u(cont_value:ndf:numnp*ndf);');

% Schleife ueber alle Elemente EINES Datensatzes
listlength = mat2el(1,arg2);
elements = mat2el( 2:listlength+1,arg2);
for aktele = elements'


  % zeichnen der Elemente, ab jetzt durch Aufruf von cont_draw.m
  evalin('base','cont_draw');

end


ucont_max = max(surf_data);
ucont_min = min(surf_data);

set(findobj('Type','patch'),'EdgeColor','none')

colorbar;
colormap(jet); % jet,bone,hsv

title(['ucont\_sm(',num2str(cont_value),',',num2str(mat_set),'):   ',...
       'max-Wert: ',num2str(ucont_max),',   min-Wert: ', ...
       num2str(ucont_min)]);

% Achsenbeschriftung
xlabel('x');
ylabel('y');
if (ndm==3)
  zlabel('z');
end
