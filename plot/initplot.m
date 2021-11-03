%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Steffen Eckert                            %
%              2015 Herbert Baaser                                 %
%                                                                  %
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

% initplot.m
% vor dem ersten Plotten muss 'initplot' aufgerufen werden
% 'mesh0': Undeformiertes Netz
% 'meshx': Deformiertes Netz, skaliert mit defo_scal (default = 1)
% 'nodenum': Knotennummern dranschreiben
% 'clearplot': Plotfenster loeschen
% 'dispx': x-Verschiebungen als Kontourplot ausgeben
% 'dispy': y-Verschiebungen als Kontourplot ausgeben
% 'boun': Lager einzeichnen: gruen festgehaltene Verschiebungen
%         gelb vorgebene Randverschiebungen
% 'cont(x)': Contourplot der Groesse x, die auf Elementebene in
%            cont_mat_gp in Spalte x abgelegt ist

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
global fid_dae;
figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(gcf,'NumberTitle','off');                  % HBaa - 2015/11/17
set(gcf,'Name','DAEdalon Plot-Fenster')

% Verschiebungen in Matrixnotation wie node
unode=reshape(u,ndf,numnp)';

for i=1:numnp

     x_test = node(i,1) + defo_flag*defo_scal*unode(i,1);
     y_test = node(i,2) + defo_flag*defo_scal*unode(i,2);

     if x_max < x_test;
       x_max=x_test;
     end
     if x_min > x_test;
       x_min=x_test;
     end
     if y_max < y_test;
       y_max=y_test;
     end
     if y_min > y_test;
       y_min=y_test;
     end

     if ndm==3
       z_test = node(i,3) + defo_flag*defo_scal*unode(i,3);
       if z_max < z_test;
         z_max=z_test;
       end
       if z_min > z_test;
         z_min=z_test;
       end
     end
end %numnp

if ndm==2
  diameter=max([x_max-x_min,y_max-y_min]);
  rand=0.15*diameter;
  lala=(diameter+2.0*rand)/2.0;
  xm = (x_min + x_max)/2.0;
  ym = (y_min + y_max)/2.0;

  axis([xm-lala,xm+lala,ym-lala,ym+lala])
%  axis([x_min-rand,x_min+diameter+rand,y_min-rand,y_min+diameter+rand])
%  axis image
  axis square

elseif ndm==3
  diameter=max([x_max-x_min,y_max-y_min,z_max-z_min]);
  rand=0.1*diameter;
  lala=(diameter+2.0*rand)/2.0;
  xm = (x_min + x_max)/2.0;
  ym = (y_min + y_max)/2.0;
  zm = (z_min + z_max)/2.0;

  axis([xm-lala,xm+lala,ym-lala,ym+lala,zm-lala,zm+lala])

%  axis([x_min-rand,x_min+diameter+rand,y_min-rand,y_min+diameter+rand, ...
%	 z_min-rand,z_min+diameter+rand])

  view(135,45);
%   axis image
  axis square
end
