%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2003 Amin Mozaffarin                                %
%              2015 Herbert Baaser                                 %
%                                                                  %
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
function gui_setup

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% globale GUIVariablen
global fid_dae;

global mat_oct_flag;                      % Projekt WiSe2015 - HBaa
global pc_environ;                        % HBaa - 14.10.2016
global dir_trenn

% Matlab Versionsnummer
vers_nr = sscanf(version,'%f');

% Infos ausgeben und Logo im Grafikfenster plotten

% Aktuelle Versionsnummer
versnum = '3.2';

disp(sprintf('\nDAEdalon Finite-Element-Project'))
disp(sprintf(['Version ',versnum]))
disp(sprintf(['This Project is placed under the GNU General ', ...
	      'Public License\n(for Details read file COPYING.TXT).']))
disp(sprintf('Contact: http://www.daedalon.org'))
if not(mat_oct_flag)                                 % 17.12.2015 - HBaa
    disp(sprintf('actual MATLAB-Version: %1.1f',vers_nr(1)))
elseif mat_oct_flag
    disp(sprintf('actual OCTAVE-Version: %1.1f',vers_nr(1)))
else
    disp(sprintf('SYSTEM UNBEKANNT'))
    pause
end
if not(pc_environ)                                 % 14.10.2016 - HBaa
    disp(sprintf('on LINUX or MAC environment'))
elseif pc_environ
    disp(sprintf('on WIN environment'))
else
    disp(sprintf('environment unknown'))
    pause
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logo anzeigen - HBaa 2015/11/17

if mat_oct_flag          % --> octave            % HBaa - 17.12.2015
    warning('off', 'Octave:GraphicsMagic-Quantum-Depth')
end

if ~isempty(findobj('Name','DAEControl'))
    return
end

if ~isempty(findobj('Name','DAEdalon'))
    delete(fid_dae)
end

fid_dae = figure;
clf reset;       % HBaa - 2015/11/17
set(fid_dae,'NumberTitle','off','Name','DAEdalon','CloseRequestFcn','crf')

logo = imread(['logo',dir_trenn,'logo_bunt_kl.jpg'],'jpg');
image(logo);
axis image;

set(gca,'XTick',[])
set(gca,'YTick',[])
text(20,620,['Version ',versnum],'fontsize',16,'color','b')
xlabel('www.DAEdalon.org','fontsize',16)
% Ende dae.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aminem
% Menu zum Starten/Ausschalten der GUI
dae_menu = uimenu(fid_dae,'Label','&DAEControl');

% Untermenu
global gui_start;
gui_start = uimenu(dae_menu,'Label','&Start GUI','Enable','off','Callback','DAEGui_dummy');

global gui_close;
gui_close = uimenu(dae_menu,'Label','&Close GUI','Callback','CB_GUI_close');

% Help Menu
dae_web   = uimenu(fid_dae,'Label','DAE&Online','Callback','dae_link');

% GUI aufrufen
try
    z = dlmread('./gui/gui_check.txt');
catch
    dlmwrite('./gui/gui_check.txt', '0');
    z = dlmread('./gui/gui_check.txt');
end

if z == 1
    DAEGui_dummy
else
    set(gui_start,'Enable','on')
    set(gui_close,'Enable','off')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
