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
function B_prog_CB

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global fid_pre;     % Figure ID PreProcess-Menu
global fid_prog;    % Figure ID ProgFlow-Menu
global fid_plot;    % Figure ID PlotControl-Menu
global fid_opt;     % Figure ID DAEOptions-Menu
global fid_time;    % Figure ID Zeitschritte
global fid_cont;    % Figure ID ContPlot-Menu
global fid_f2f;     % Figure ID FEAP-Input
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check ob bereits ein Menu-Fenster offen, ggf. schliessen
if ishghandle('Name','ProgFlow')
    figure(fid_prog)
    if ishghandle('Name','Zeitschritte')
        figure(fid_time)
    end
    return
end

if ishghandle('Name','PreProcess')
    close(fid_pre)
end

if ishghandle('Name','PlotControl')
    close(fid_plot)
end

if ishghandle('Name','DAEOptions')
    close(fid_opt)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAEControl-Fenster: Aussenmass einlesen
po_dc = get(fid_dc,'OuterPosition');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAEControl-Fenster: Innenmass einlesen
pi_dc = get(fid_dc,'pos');

% ProgFlow-Fenster initialisieren
fid_prog = figure('NumberTitle','off',...
                  'Name','ProgFlow',...
                  'MenuBar','none',...
                  'CloseRequestFcn','CRF_ProgFlow');

set(fid_prog,'Resize','off');

% ProgFlow-Fenster: Innenmass einlesen
pi_prog   = get(fid_prog,'Position');

% Größe des ProgFlow-Fensters deklarieren und zuweisen
pi_prog(1) = pi_prog(1);
pi_prog(2) = pi_prog(2);
pi_prog(3) = pi_dc(3);
pi_prog(4) = 8*Bh;

set(fid_prog,'pos',pi_prog);

% ProgFlow-Fenster: Aussenmass einlesen
po_prog   = get(fid_prog,'OuterPosition');

% Position des ProgFlow-Fensters deklarieren und zuweisen
po_prog(1) = po_dc(1);
po_prog(2) = po_dc(2)-po_prog(4);
po_prog(3) = Fw;
po_prog(4) = po_prog(4);

set(fid_prog,'OuterPosition',po_prog);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen
Bx = 0.5*Bh + Bw + 0.1*Bh - Bw/2;

y1 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
y2 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
y3 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
y4 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
y5 = 0.5*Bh + Bh + 0.2*Bh;
y6 = 0.5*Bh;

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = Bx;
pB1(2) = y1;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_prog,'Style','pushbutton',...
                        'String','time',...
                        'pos',pB1,...
                        'Callback','CB_time');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = Bx;
pB2(2) = y2;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_prog,'Style','pushbutton',...
                        'String','go',...
                        'pos',pB2,...
                        'Callback','go');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 3
% Groesse deklarieren und zuweisen
pB3(1) = Bx;
pB3(2) = y3;
pB3(3) = Bw;
pB3(4) = Bh;

B3 = uicontrol(fid_prog,'Style','pushbutton',...
                        'String','loop',...
                        'pos',pB3,...
                        'Callback','CB_loop');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 4
% Groesse deklarieren und zuweisen
pB4(1) = Bx;
pB4(2) = y4;
pB4(3) = Bw;
pB4(4) = Bh;

B4 = uicontrol(fid_prog,'Style','pushbutton',...
                        'String','vtu_out',...
                        'pos',pB4,...
                        'Callback','vtu_out');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 5
% Groesse deklarieren und zuweisen
pB5(1) = Bx;
pB5(2) = y5;
pB5(3) = Bw;
pB5(4) = Bh;

B5 = uicontrol(fid_prog,'Style','pushbutton',...
                        'String','out',...
                        'pos',pB5,...
                        'Callback','CB_out');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 6
% Groesse deklarieren und zuweisen
pB6(1) = Bx;
pB6(2) = y6;
pB6(3) = Bw;
pB6(4) = Bh;

B6 = uicontrol(fid_prog,'Style','pushbutton',...
                        'String','histout',...
                        'pos',pB6,...
                        'Callback','CB_histout');
