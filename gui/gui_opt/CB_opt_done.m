%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2003 Amin Mozaffarin                                %
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
function CB_opt_done

global fid_opt;
global E_hist;
global E_out;
global E_rst;
global E_dt;
global E_scal;
global E_oincr;
global E_rincr;
global out_file_name;
global histout_file_name;
global out_incr;
global rst_file_name;
global rst_incr;
global dt;
global defo_scal;
global X_dt;
global X_scal;
global X_out;
global X_hist;
global X_rst;
global X_oincr;
global X_rincr;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X_dt einlesen
X_dt = str2num(get(E_dt,'String'));

% Check ob neuer Wert
if (X_dt ~= dt)
    dt = X_dt;
    disp(['dt = ',num2str(dt)])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X_scal einlesen
X_scal = str2double(get(E_scal,'String'));

% Check ob neuer Wert
if (X_scal ~= defo_scal)
    defo_scal = X_scal;
    disp(['defo_scal = ',num2str(defo_scal)])
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X_out einlesen
X_out = get(E_out,'String');

% Check ob neuer Wert
if ~strcmp(X_out,out_file_name)
    out_file_name = X_out;
    disp(['out_file_name = ',out_file_name])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X_hist einlesen
X_hist = get(E_hist,'String');

% Check ob neuer Wert
if ~strcmp(X_hist,histout_file_name)
    histout_file_name = X_hist;
    disp(['histout_file_name = ',histout_file_name])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X_oincr einlesen
X_oincr = str2num(get(E_oincr,'String'));

if ~isempty(X_oincr)
    % Check ob neuer Wert
    if (X_oincr ~= out_incr)
        out_incr = X_oincr;
        disp(['out_incr = ',num2str(out_incr)])
    end
else
    disp(['out_incr ist keine Zahl! Defaultwert = ',num2str(out_incr)])
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X_rst einlesen
X_rst = get(E_rst,'String');

% Check ob neuer Wert
if ~strcmp(X_rst,rst_file_name)
    rst_file_name = X_rst;
    disp(['rst_file_name = ',rst_file_name])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% X_rincr einlesen
X_rincr = str2num(get(E_rincr,'String'));

if ~isempty(X_rincr)
    % Check ob neuer Wert
    if (X_rincr ~= rst_incr)
        rst_incr = X_rincr;
        disp(['rst_incr = ',num2str(rst_incr)])
    end
else
    disp(['rst_incr ist keine Zahl! Defaultwert = ',num2str(rst_incr)])
end

close(fid_opt)