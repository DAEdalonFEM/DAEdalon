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

function out(arg)
global elem_nr ndm ndf cont_flag cont_mat_node u node
global tim r numel numnp
% Ausgabe aller berechneten Groessen zum aktuellen Zeitpunkt

out_value = arg;

% Aufbau von cont_mat_node durch aufruf von projection

% evalin ruft mfiles auf, wobei alle Variablen gueltig sind, die auch
% im workspace verfuegbar sind

% nicht mehr noetig, da alles in stiffness aufgebaut wird, StE
% 14.03.03
%if cont_flag ~=1
%  evalin('base','projection');
%  cont_flag=1;
%end %if

% Name des Ausgabefiles zusammenbasteln
if (isempty(arg))
  % Defaultfilename
  arg='data';
end
ti = sprintf('%.4f',tim);
file_name=strcat('./output/',arg,'_',num2str(ti),'.out');

% Zusammenbau der Ausgabematrix:
% (numnp x (Elementnummer,x,y,ux,uy,epsx,epsy,2.0*epsxy,sigx,sigy,sigxy,,,))

unode=reshape(u,ndf,numnp)';
u_size  = size(unode); %= [numnp,ndf];
rnode = reshape(r,ndf,numnp)';
r_size = size(rnode); %= [numnp,ndf];

cont_size = size(cont_mat_node);

% Groesse der Matrix out_mat
num_zeilen = u_size(1,1);
num_spalten =1 + ndm + u_size(1,2) + r_size(1,2) + cont_size(1,2);

out_mat(:,1) =[1:num_zeilen]';
out_mat(:,2:num_spalten)=[node unode rnode cont_mat_node];

% Ausgabe der Matrix in ./output/file_name
fid = fopen(file_name,'w');

% Zeit in die erste Zeile
fprintf(fid,'time = %.4f \n',tim);

% Bedeutung der einzelnen Spalten
hhh=2;
fprintf(fid,'# Knotennr (Spalte 1),  Koordinaten (Spalte %1.0f-%1.0f),   ' ...
	,hhh,hhh+ndm-1);
hhh = hhh + ndm;
fprintf(fid,'u (Spalte %1.0f-%1.0f),  ' ...
	,hhh,hhh+u_size(1,2)-1);
hhh = hhh + u_size(1,2);
fprintf(fid,'reac (Spalte %1.0f-%1.0f),  ' ...
	, hhh,hhh+r_size(1,2)-1);
hhh = hhh + r_size(1,2);
fprintf(fid,'epsilon,  sigma,  int.Var (Spalte %1.0f-%1.0f)\n' ...
	, hhh,hhh+cont_size(1,2)-1);

% Werte schreiben
for i=1:num_zeilen
  fprintf(fid,'%d  ',out_mat(i,1));
  for j=2:num_spalten
    fprintf(fid,'%0.6e  ',out_mat(i,j));
  end
  fprintf(fid,'\n');
end

fclose(fid);

disp(sprintf('%s geschrieben',file_name))


