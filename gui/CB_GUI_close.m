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

function CB_GUI_close

% schliesst alle GUI-Fenster

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% globale GUI-Variablen

% Figure IDs
global fid_pre     % Figure ID PreProcess-Menu
global fid_prog    % Figure ID ProgFlow-Menu
global fid_plot    % Figure ID PlotControl-Menu
global fid_post    % Figure ID PostProcess-Menu
global fid_opt     % Figure ID DAEOptions-Menu

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fenster schliessen
if not(isempty(findobj('Name','PreProcess')))
    close(fid_pre)              % schliesst PreProcess-Menu und dessen Untermenus
    set_gui_status              % aktiviert GUI-Schalter
    return
end

if not(isempty(findobj('Name','ProgFlow')))
    close(fid_prog)             % schliesst ProgFlow-Menu und dessen Untermenus
    set_gui_status              % schliesst DAEControl-Menu und aktiviert GUI-Schalter
    return
end

if not(isempty(findobj('Name','PlotControl')))
    close(fid_plot)             % schliesst PlotControl-Menu und dessen Untermenus
    set_gui_status              % schliesst DAEControl-Menu und aktiviert GUI-Schalter
    return
end

if not(isempty(findobj('Name','PostProcess')))
    close(fid_post)             % schliesst PostProcess-Menu und dessen Untermenus
    set_gui_status              % schliesst DAEControl-Menu und aktiviert GUI-Schalter
    return
end

if not(isempty(findobj('Name','DAEOptions')))
    close(fid_opt)             % schliesst DAEOptions-Menu
    set_gui_status             % schliesst DAEControl-Menu und aktiviert GUI-Schalter
    return
end

% Wenn nur DAEControl-Menu aktiv
set_gui_status                 % schliesst DAEControl-Menu und aktiviert GUI-Schalter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function set_gui_status

% UnterFunktion: schliesst DAEControl-Menu und aktiviert GUI-Schalter

% globale GUI-Variablen
global fid_dc		% Figure ID DAEControl-Menu
global gui_close	% 'Close GUI' ID (DAEControl Untermenu)
global gui_start	% 'Start GUI' ID (DAEControl Untermenu)

% DAEControl schliessen
delete(fid_dc)

% DAEControl-Menu umschalten
set(gui_close,'Enable','off')
set(gui_start,'Enable','on')

% Schalter fuer GUI beim Starten setzen
z = 0;
dlmwrite('./gui/gui_check.txt',z,' ');