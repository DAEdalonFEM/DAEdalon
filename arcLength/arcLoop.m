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

% file:     arcLoop.m
% author:   andreas trondl
% modified: steffen eckert

function [] = arcLoop( lEnd, nMax )

% mehrmaliges bestimmen von gleichgewichtszustaenden mittels schleife.
%
% input-parameter:
% ================
% lEnd ... maximal zugelassener lastparameter l=p/p*; abbruch wenn l >= lEnd
% nMax ... maximalanzahl der zu berechnenden gleichgewichtsszustaende 

co = 1;                      % indikator zur schleifenfortsetzung
iterMax = 17;                % max. iterationen zur auffindung von gleichgewicht
errMax = 1e-8;               % max. fehler bezueglich gleichgewichtszustand
i = 1;                       % zaehler fuer berechnete gleichgewichtszustaende
rep = 1;                     % ignoriere lastfaktorabfrage beim 1. durchlauf !!!

% aufstellen des abbruchkriteriums bezueglich des vorzeichens von lEnd
%rel = '>><';
%rel = [ 'evalin( ''base'', ''lam'' ) ', rel(sign(lEnd)+2), ' lEnd'];

vorzeich = sign(lEnd);
if (vorzeich<0)
  rel = [ 'evalin( ''base'', ''lam'' ) >  lEnd']; 
else
 rel = [ 'evalin( ''base'', ''lam'' ) <  lEnd']; 
end

% schleife ueber aufzufindende gleichgewichtszustaende
while rep & i <= nMax & co

  % fuehre praediktor- und 'zeitschritt' aus
  evalin( 'base', 'arcPredict' );
  evalin( 'base', 'time' );
  
  j = 0;                 % iterationszaehler zur auffindung von gleichgewicht
 
  %while evalin( 'base', 'resid' ) >= errMax & j < iterMax
  while evalin( 'base', 'resid*res_norm' ) >= errMax & j < iterMax

    % fuehre iterationsschritt aus
    disp( sprintf( 'dLam(%i): %f\n', j, evalin( 'base', 'dLam' ) ) );
    j = j + 1;
    evalin( 'base', 'arcGo' );

  end                        % schleifenende zur auffindung von gleichgewicht

  if j > iterMax             % wurde gleichgewicht gefunden ?
    co = 0;                  % nein
  end

  disp( sprintf( '\nlam(%i): %f', i, evalin( 'base', 'lam' ) ) );
  i = i + 1;                 % zaehler fuer gefundene gleichgewichtszustaende

  % falls vorhanden fuehre benutzerskript aus
%  if evalin( 'base', 'exist( ''userSkript'', ''var'' )' )
%    evalin( 'base', evalin( 'base', 'userSkript' ) );
%  end

  rep = eval( rel );         % ist grenzwert des lastfaktors erreicht?

end                          % schleifenende fuer alle gleichgewichte
