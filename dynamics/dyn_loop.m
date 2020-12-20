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

function dyn_loop(arg)
global resid res_norm tim out_file_name histout_file_name;
%
iter_max=15;
break_flag=0;
for j = 1:arg
  evalin('base','dyn_time');
  count=0;
  while resid*res_norm > 1.E-8
    if count > iter_max
      disp(sprintf(['Nach %2.0f globalen Iterationen keine '...
		    'Konvergenz'] ,count))
      disp(sprintf('Abbruch zum Zeitpunkt %8.4f',tim))
      break_flag=1;
      break;
    end
    evalin('base','dyn_go');
    count=count+1;
  end
  if break_flag==1
    break
  end

  % Outputfiles schreiben
  if (~isempty(out_file_name))
    out(out_file_name);     
  end
   
  if (~isempty(histout_file_name))
    histout(histout_file_name);     
  end

  % movie files speichern
%  cla;
%  evalin('base','meshx;');
%  evalin('base','movie_array(round(tim/dt)) = getframe;'); 
  
end