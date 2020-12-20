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

% file:     arcPredict.m
% author:   andreas trondl
% modified: steffen eckert

% ausfuehrung eines praediktorschrittes und initialisierung

%initP = 1;
%if exist( 'k', 'var' )
%  if norm( k, inf ) ~= 0
%    initP = 0;
%  end;
%end

% initialisierung bei aller ersten lastschritt
%if initP

if (tim ==0)

  sDs = 0;
  bounDisp_treat = 1; 
  load_flag = 0;
  
  stiffness;
  syst;
  dUp = repmat( du, [1,2] );            % init. fuer blockelimination
  dUp(poU,1) = k(poU,poU) \ p(poU);
  tmp = p' * dUp(:,1);
  csp0 = chk0( sign( tmp ) );
  csp = csp0;
  lam = 0;
  ds = dt;
else
  % vorzeichenbestimmung von inkrementellen lastfaktor (current stiffness par.)
  tmp = p' * dUp(:,1);
  csp = chk0( sign( tmp ) ) / csp0;
end

% charakteristische groesse zur vozeichenbestimmung im prediktorschritt
disp( sprintf( '\nP''*dUp (csp) : %f (%i)', tmp, csp ) );

% speichern des zustandes vom letzten ausiterierten gleichgewicht
lamK = lam;
uK = u;

% praediktorschritt: bestimmung des skalierungsfaktors für lastniveau
dLam = csp * ds / chk0( norm( dUp(:,1), 2 ) );
lam = lam + dLam;
lam0 = lam;
uP0 = uK + dLam * dUp(:,1);

% aktuelle verschiebung auf praediktorschritt setzen
u = uP0;

% update approximierter akumulierter bogenlaenge entlang gleichgewichtspfad
sDs = sDs + ds;
