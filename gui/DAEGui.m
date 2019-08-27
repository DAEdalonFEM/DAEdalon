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
function DAEGui

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

global gui_start;
global gui_close;

% Schalter fuer GUI beim Start
z = 1;
dlmwrite('./gui/gui_check.txt',z,' ');

set(gui_start,'Enable','off')
set(gui_close,'Enable','on')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Masse und Position des DAEPlot-Fensters einlesen
po_dae = get(fid_dae,'OuterPosition');

% DAEControl-Fenster: Masse festlegen
Fw   = floor(po_dae(3)/3);
dc_h = floor(po_dae(4)/3) * 4/3;

% DAEControl-Fenster: Masse zuweisen
po_dc(1) = po_dae(1)+po_dae(3);
po_dc(2) = po_dae(2)+po_dae(4)-dc_h;
po_dc(3) = Fw;
po_dc(4) = dc_h;

% DAEControl-Fenster initialisieren und Attribute zuweisen
fid_dc   = figure('NumberTitle','off',...
                  'Name','DAEControl',...                  
                  'MenuBar','none',...
                  'CloseRequestFcn','CB_GUI_close');

set(fid_dc,'OuterPosition',po_dc)
set(fid_dc,'Resize','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAEControl-Fenster: Innen-Masse einlesen
pi_dc    = get(fid_dc,'pos');
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons: Masse zur Übergabe in globale Variablen schreiben

% Hauptmenu-Buttons: Breite Bw_dc
Bw_dc = pi_dc(3);

% Hauptmenu-Buttons: Hoehe Bh_dc
Bh_dc     = floor(pi_dc(4)/4)*4/5;
Bh_dc_mod = floor(pi_dc(4)/4);

% Mini-Buttons: Hoehe Bh (global)
Bh = floor(Bh_dc_mod/2);

% Mini-Buttons: Breite Bw (global)
Bw = floor((Bw_dc-1.2*Bh)/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen

% Button "PreProcess"

% Button-Nr.
BN = 5;

% Position
pB_pre(1) = 0;
pB_pre(2) = (BN-1)*Bh_dc;
pB_pre(3) = Bw_dc;
pB_pre(4) = Bh_dc;

B_pre = uicontrol(fid_dc,'Style','pushbutton',...
                         'String','PreProcess',...
                         'Callback','B_pre_CB');

set(B_pre,'pos',pB_pre)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button "ProgFlow"

% Button-Nr.
BN = 4;

% Position
pB_prog(1) = 0;
pB_prog(2) = (BN-1)*Bh_dc;
pB_prog(3) = Bw_dc;
pB_prog(4) = Bh_dc;

B_prog = uicontrol(fid_dc,'Style','pushbutton',...
                          'String','ProgFlow',...
                          'Callback','B_prog_CB');

set(B_prog,'pos',pB_prog)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button "PlotControl"

% Button-Nr.
BN = 3;

% Position
pB_plot(1) = 0;
pB_plot(2) = (BN-1)*Bh_dc;
pB_plot(3) = Bw_dc;
pB_plot(4) = Bh_dc;

B_plot = uicontrol(fid_dc,'Style','pushbutton',...
                          'String','PlotControl',...
                          'Callback','B_plot_CB');

set(B_plot,'pos',pB_plot)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button "PostProcess"

% Button-Nr.
BN = 2;

% Position
pB_post(1) = 0;
pB_post(2) = (BN-1)*Bh_dc;
pB_post(3) = Bw_dc;
pB_post(4) = Bh_dc;

B_post = uicontrol(fid_dc,'Style','pushbutton',...
                          'String','PostProcess',...
                          'Callback','B_post_CB');

set(B_post,'pos',pB_post)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button "Options"

% Button-Nr.
BN = 1;

% Position
pB_opt(1) = 0;
pB_opt(2) = (BN-1)*Bh_dc;
pB_opt(3) = Bw_dc;
pB_opt(4) = Bh_dc;

B_opt = uicontrol(fid_dc,'Style','pushbutton',...
                         'String','DAEOptions',...
                         'Callback','B_opt_CB');

set(B_opt,'pos',pB_opt)