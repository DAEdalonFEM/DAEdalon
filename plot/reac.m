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

% reac.m
% Reaktionskraefte mit Pfeilen anzeigen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
global fid_dae;
figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rnode = reshape(r,ndf,numnp)';
xcoor=zeros(numnp,1);
ycoor=zeros(numnp,1);
zcoor=zeros(numnp,1);

for i=1:numnp
  xcoor(i)=node(i,1)+ defo_flag*defo_scal*unode(i,1);
  ycoor(i)=node(i,2) + defo_flag*defo_scal*unode(i,2);

  if ndm == 2
    zcoor(i)=0.0;
    rnode(i,3) = 0.0;
  elseif ndm==3
    zcoor(i)=node(i,3) + defo_flag*defo_scal*unode(i,3);
  end

end %i

% keine Skalierung der Vektoren in quiver3, funktioniert naemlich
% nicht richtig, sondern von Hand
max_abs = max([max(abs(rnode)) 1.0E-6]);
rnode_plt = rnode/max_abs*rand*0.8;               % HBaa - 11.01.2016
title(['Reaktionskraefte']);
quiver3(xcoor,ycoor,zcoor,rnode_plt(:,1),rnode_plt(:,2),rnode_plt(:,3),0,'r')
