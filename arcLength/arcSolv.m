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
%    Public License along with Foobar; if not, write to the        %
%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,   %
%    Boston, MA  02111-1307  USA                                   %
%                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% file:     arcSolve.m
% author:   andreas trondl
% modified: steffen eckert

% loesen des durch zwangsbedingung erweiterten gleichungssystems durch
% blockelimination (partitionierungstechnik)

% loesen des linearen gleichungssystems mit unterschiedlichen lasten
% dUp(:,1) = du_P
% dUp(:,2) = du_G
dUp(poU,:) = k(poU,poU) \ [ p(poU), rhs(poU) ];

% auswerten der zwangsbedingung und deren ableitungen
[ fArc, dFdU, dFdL ] = arcF( uK, uP0, u, lamK, lam0, lam, ds );
% berechnung der inkremente aus groessen von zwangsbedingung
tmp = dFdU * dUp;
dLam = - ( fArc + tmp(2) ) / ( dFdL + tmp(1) );
du = dLam * dUp(:,1) + dUp(:,2);

% update der unbekannten (feld)groessen
lam = lam + dLam;
u = u + du;

% update approximierter akumulierter bogenlaenge entlang gleichgewichtspfad
% (andere approximation die eine groessere abschaetzung des weges liefert)
% sDs = sDs + abs( dLam ) * norm( du, 2 );