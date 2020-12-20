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
%    Public License along with Foobar; if not, write to the        %
%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,   %
%    Boston, MA  02111-1307  USA                                   %
%                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% elnum.m
% Elementnummern anzeigen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
global fid_dae;
figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:numel
  switch ndm

   case{2}
     xpos=0;
     ypos=0;
     % Elementnummer in die Mitte des Elements
     for j=1:nel
       xpos = xpos + node(el(i,j),1) + defo_flag*defo_scal*unode(el(i,j),1);
       ypos = ypos + node(el(i,j),2) + defo_flag*defo_scal*unode(el(i,j),2);
     end
     xpos=xpos/nel;
     ypos=ypos/nel;
     text(xpos,ypos,[num2str(i)]);

   case{3}
     xpos=0;
     ypos=0;
     zpos=0;
     % Elementnummer in die Mitte des Elements
     for j=1:nel
       xpos = xpos + node(el(i,j),1) + defo_flag*defo_scal*unode(el(i,j),1);
       ypos = ypos + node(el(i,j),2) + defo_flag*defo_scal*unode(el(i,j),2);
       zpos = zpos + node(el(i,j),3) + defo_flag*defo_scal*unode(el(i,j),3);
     end
     xpos=xpos/nel;
     ypos=ypos/nel;
     zpos=zpos/nel;
     text(xpos,ypos,zpos,[num2str(i)]);

  end %switch
end %i

title(['Elementnummern']);
