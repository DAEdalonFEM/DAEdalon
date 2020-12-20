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

% boun.m
% Lager anzeigen, feste Lager in gruen, Verschiebungen in magenta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gui
global fid_dae;
figure(fid_dae);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xn=zeros(displ_len,1);
yn=zeros(displ_len,1);
zn=zeros(displ_len,1);
uu=zeros(displ_len,1);
vv=zeros(displ_len,1);
ww=zeros(displ_len,1);

displ_max=1.0E-8;

for i=1:displ_len
  xn(i)=node(displ_node(i),1)+ ...
	defo_flag*defo_scal*unode(displ_node(i),1);
  yn(i)=node(displ_node(i),2)+ ...
	defo_flag*defo_scal*unode(displ_node(i),2);
  zn(i)=0.0;

  if ndm==3
    zn(i)=node(displ_node(i),3)+ ...
	  defo_flag*defo_scal*unode(displ_node(i),3);
  end

  bl=diameter*0.02;

  if displ_u(i)==0
    % festes Lager in gruen malen

    switch displ_df(i)
     case 1
      plot3([xn(i)-bl,xn(i)+bl],[yn(i),yn(i)],[zn(i),zn(i)],'g-')
     case 2
      plot3([xn(i),xn(i)],[yn(i)-bl,yn(i)+bl],[zn(i),zn(i)],'g-')
     case 3
      plot3([xn(i),xn(i)],[yn(i),yn(i)],[zn(i)-bl,zn(i)+bl],'g-')
    end %switch

  else

    switch displ_df(i)
     case 1
      uu(i)=displ_u(i);

     case 2
      vv(i)=displ_u(i);

     case 3
      ww(i)=displ_u(i);
    end %switch

    if (displ_max < abs(displ_u(i)))
      displ_max=abs(displ_u(i));
    end

  end %if

end %i

% vorgegebene Verschiebung in magenta malen
% keine Skalierung der Vektoren in quiver3, funktioniert naemlich
% nicht richtig, sondern von Hand
max_abs = max([max(abs([uu,vv,ww])) 1.0E-6]);
uu = uu/max_abs*rand*0.8;
vv = vv/max_abs*rand*0.8;
ww = ww/max_abs*rand*0.8;
quiver3(xn,yn,zn,uu,vv,ww,0,'m-')

title(['Verschiebungsrandbedingungen']);