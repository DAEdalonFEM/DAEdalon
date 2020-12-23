%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Steffen Eckert, Andreas Trondl            %
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

% file:     uf.m
% author:   andreas trondl
% modified:

function [] = uf()

% umschalten des indikators 'bounDisp_treat' der festlegt ob beim loesen
% des globalen gleichungssystems die freiheitsgrade welche aus den bekannten
% verschiebungsrandbedingungen stammen, entfernt werden.

evalin( 'base', 'bounDisp_treat = ~bounDisp_treat;' );
if evalin( 'base', 'bounDisp_treat' )
  tmp='';
else
  tmp=' nicht(!)';
end
disp( [ 'Verschiebungsrandbedingungen werden aus globaler Stefikeitsmatrix' ...
     , tmp, ' eliminiert !' ] );