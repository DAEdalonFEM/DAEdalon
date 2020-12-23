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

function histout(arg)
global numel tim numgp_max gphist_max hist_old hist_new

% hist_new in Datei schreiben
% Achtung geaendert 7.7.03 Eckert, vorher hist_old in Datei schreiben

% Name des Ausgabefiles zusammenbasteln
if (isempty(arg))
  % Defaultfilename
  arg='hist';
end

ti = sprintf('%.4f',tim);
file_name=strcat('./output/',arg,'_',num2str(ti),'.out');

% Zusammenbau der Ausgabematrix:
% (numel x history-variablen*GPs)

% Groesse der Matrix out_mat
num_zeilen = numel;
num_spalten = numgp_max*gphist_max + 1;

out_mat(:,1) = [1:num_zeilen]';
out_mat(:,2:num_spalten) = hist_new';

% Ausgabe der Matrix in ./output/file_name
fid = fopen(file_name,'w');

% Zeit in die erste Zeile
fprintf(fid,'time = %.4f \n',tim);

% Bedeutung der einzelnen Spalten
hhh=2;
fprintf(fid,'# Elementnr (Spalte 1)');

for iii = 1:numgp_max
  fprintf(fid,',      Hist.-Var. %d. GP (Spalte %1.0f-%1.0f)' ...
	  ,iii,hhh,hhh+gphist_max-1);
  hhh = hhh + gphist_max;
end

fprintf(fid,'\n');

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


