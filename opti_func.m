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


function [elem_out,node_out,displ_node_out,force_node_out]...
    = opti_func(elem_in,node_in,displ_node_in,force_node_in)

global numel nel numnp ndm
% opti_func.m
% Optimierung der Bandbreite durch Verwendung des Cuthill-McKee-Algorithmus.

delta_el = 1;
kk_temp_size = 200; % Elemente
kk = spalloc(numnp,numnp,round(numnp*numnp/100));
kk_temp = spalloc(numnp,numnp,round(numnp*numnp/100));

node_out = zeros(numnp,ndm);
displ_node_out = zeros(length(displ_node_in),1);
force_node_out = zeros(length(force_node_in),1);

disp(['Knoten werden neu durchnumeriert (Bandbreitenoptimierung):', ...
      '     '])

% Matrix aufbauen
for i=1:numel
  kk_temp(elem_in(i,:),elem_in(i,:)) = 1;
    if (delta_el==kk_temp_size)
      kk = kk + kk_temp;
      kk_temp = spalloc(numnp,numnp,round(numnp*numnp/100));
      delta_el = 0;
    end
    delta_el = delta_el + 1;

    percent=floor(50*i/numel);
%    disp(sprintf('\b\b\b\b\b%2.0f %%',percent))
end

kk = kk + kk_temp;


subplot(1,2,1)
spy(kk);
title(['Knotenkonektivität'])
xlabel('Elemente');
ylabel('Elemente');

% symrcm gibt einen Permutationsvektor zurück, dabei ist der Wert
% die alte Knotennummer und der Index die neue Knotennummer.
% Bsp.: permt_vec(4)=12 -> alte Knotennr:12, neue Knotennr:4
permut_vec = symrcm(kk);

subplot(1,2,2)
spy(kk(permut_vec,permut_vec));
title(['Optimierte Knotenkonektivität'])
xlabel('Elemente');
ylabel('Elemente');

% neue Elementmatrix erzeugen
for i=1:numel
  for j=1:nel
    elem_out(i,j) = find(permut_vec==elem_in(i,j));
  end
  percent=floor(50+50*i/numel);
  disp(sprintf('\b\b\b\b\b%2.0f %%',percent))
end


% neue Knotenmatrix erzeugen
for i=1:numnp
  node_out(i,:) = node_in(permut_vec(i),:);
end

% neuen Randverschiebungsvektor erzeugen
for i=1:length(displ_node_in)
  displ_node_out(i) =  find(permut_vec==displ_node_in(i));
end

% neuen Lastvektor erzeugen (wenn nötig)
if (length(force_node_in)>0)
  for i=1:length(force_node_in)
    force_node_out(i) =  find(permut_vec==force_node_in(i));
  end
end