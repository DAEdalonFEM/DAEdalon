%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Steffen Eckert                            %
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

% meshx.m
% Ausgabe des deformierten Netzes,
% mit defo_scal = Skalierungsfaktor
% kann die Skalierung angepasst werden

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
global fid_dae;
figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

defo_flag=1.0;
initplot;
hold on;

% Schleife ueber alle Elemente
for aktele=1:numel
  elem_nr = elem_nr_matr(el2mat(aktele));
  meshnodes;
  switch ndm
    case {2}  % 2-D Elemente
      plot(x_plot,y_plot,'r-');
    case {3}  % 3-D Elemente
      plot3(x_plot,y_plot,z_plot,'r-');
  end % switch
end % aktele

if (defo_scal == 1)
  title(['Deformiertes Netz']);
else
  title([sprintf('Deformiertes Netz, defo\\_scal = %8.2f', defo_scal)]);
end

% Achsenbeschriftung
xlabel('x');
ylabel('y');
if (ndm==3)
  zlabel('z');
end
