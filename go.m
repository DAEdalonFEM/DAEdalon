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

% go.m
% Nacheinander ausfuehren der Befehle:
% stiffness
% syst
% solv
% residuum
cpu_start = cputime;
if vers_nr < 6 %&& mat_oct=0    % gilt fuer MATLAB - HBaa - 17.12.2015
  flops_start = flops;
end

stiffness
syst
solv
residuum

cpu_stop = cputime;
if vers_nr < 6 %&& mat_oct=0    % gilt fuer MATLAB - HBaa - 17.12.2015
  flops_stop = flops;
end

cpu_delta = cpu_stop - cpu_start;
cpu_total=cpu_total + cpu_delta;
if vers_nr < 6 %&& mat_oct=0    % gilt fuer MATLAB - HBaa - 17.12.2015
  flops_delta = flops_stop - flops_start;
  flops_total = flops_total + flops_delta;
end

if vers_nr < 6 %&& mat_oct=0    % gilt fuer MATLAB - HBaa - 17.12.2015
  disp(sprintf(['Flops (gesamt/letzte Iteration):' ...
	       '  %.6e    %.6e'],flops_total,flops_delta))
end
  disp(sprintf(['CPU-Zeit (gesamt/letzte Iteration):' ...
		'   %8.2f        %8.2f'],cpu_total,cpu_delta))

%
% Ende go.m