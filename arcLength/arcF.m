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

% file:     arcF.m
% author:   andreas trondl
% modified:

function [ fArc, dFdU, dFdL ] = arcF( u_, u0, u, l_, l0, l, ds )

% lineare zwangsbedingung nach riks
% auswertung der zwangsbedingung und deren ableitungen
% zur bestimmung des lastparameters
%
% input-parameter:
% ================
% u_, l_ ... letzter gleichgewichtszustand
% u0, l0 ... zustand aus praediktorschritt
% u, l   ... aktueller belastungszustand
% ds     ... bogenlaengeninkrement

dFdL = ( l0 - l_ );                           % ableitung nach lastparameter
dFdU = ( u0 - u_ )';                          % ableitung nach verschiebungen
fArc = dFdU * ( u - u0 ) + dFdL * ( l - l0 ); % zwangsbedingung