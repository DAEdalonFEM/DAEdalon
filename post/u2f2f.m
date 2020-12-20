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

function u2f2f(arg)

% Rausschreiben des aktuellen Verschiebungsvektors in dem Format,
% in dem die Verschiebungen in FEAP-Eingabefiles unter disp
% gespeichert sind. arg ist der Name, der als Schlüsselword
% anstelle von disp rausgeschrieben wird.
% Sinn:
% Verschiebung des aktuellen GG-Zustandes können als
% Anfangsverschiebung für dynamische Rechnungen verwendet werden.

global u numnp ndf

% Name des Ausgabefiles zusammenbasteln
if (isempty(arg))
  % Defaultfilename
  arg='dis0';
end
keyword = arg;

% Filename
file_name=strcat('./parser/',arg,'.f2f');

% Aufbau der Ausgabematrix
u_0=[[1:numnp]', zeros(numnp,1), reshape(u,ndf,numnp)'];

% Ausgabe von Keyword und Matrix in ./output/file_name
fid = fopen(file_name,'w');

% Zeit in die erste Zeile
fprintf(fid,'\n%s\n',keyword);

[num_zeilen,num_spalten] = size(u_0);

% Werte schreiben
for i=1:num_zeilen
  fprintf(fid,'%d,%d',u_0(i,1),u_0(i,2));
  for j=3:num_spalten
    fprintf(fid,',%0.6e',u_0(i,j));
  end
  fprintf(fid,'\n');
end

fclose(fid);

disp(sprintf('%s geschrieben',file_name))


