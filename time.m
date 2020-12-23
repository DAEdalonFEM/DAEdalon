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

% time.m
% hier wird die Systemzeit tim um dt erhoeht

if(tim==0)
  clp;

else
  steps_total = steps_total + 1;

  % Output-files schreiben
  if (~isempty(out_file_name) & mod(steps_total,out_incr)==0)
    out(out_file_name);
  end

  if (~isempty(histout_file_name) & mod(steps_total,out_incr)==0)
    histout(histout_file_name);
  end

  % Restart-file schreiben
  if (~isempty(rst_file_name) & mod(steps_total,rst_incr)==0)
  rst_write(rst_file_name);
  end

   % falls vorhanden fuehre benutzerskript aus
  %if evalin( 'base', 'exist( ''userSkript'', ''var'' )' )
  if (~isempty(userSkript))
  evalin( 'base', userSkript )
  end

  % movie array speichern
  % ansehen der moviez mit dem Befehl movie(movie_array)
  if (movie_flag==1)
    cla;
    evalin('base','meshx;');
    evalin('base','movie_array(round(tim/dt)) = getframe(gca);');
  end



end

tim = tim + dt;
disp(sprintf('Zeit: %8.4f',tim))

% Residuum-Counter auf null:
resid_count = 0;
resid = 1.0;
res_norm = 1.0;

% History-Felder umspeichern:
hist_old = hist_new;

% Ende time.m
