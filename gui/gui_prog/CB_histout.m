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
function CB_histout

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global fid_pre;     % Figure ID PreProcess-Menu
global fid_prog;    % Figure ID ProgFlow-Menu
global fid_plot;    % Figure ID PlotControl-Menu
global fid_cont;    % Figure ID ContPlot-Menu
global fid_time;    % Figure ID time-Input
global fid_out;     % Figure ID out-Eingabe
global fid_histout  % Figure ID histout-Eingabe
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

global X_check_hist;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check ob Fenster bereits offen
if ishghandle('Name','histout(NAME)')
    figure(fid_histout)
    return
end

X_check_hist = '';

% Check ob loop Fenster bereits offen
if ishghandle('Name','Zeitschritte')
    close(fid_time)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Zeitschritte-Fenster initialisieren
fid_histout = figure('NumberTitle','off',...
                     'Name','histout(NAME)',...
                     'menubar','none');

% ProgFlow-Fenster: Aussenmass einlesen              
p_prog = get(fid_prog,'OuterPosition');

% histout-Fenster: Innenmass einlesen
pi_histout = get(fid_histout,'OuterPosition');

% Groesse initialisieren und zuweisen
pi_histout(1) = pi_histout(1);
pi_histout(2) = pi_histout(2);
pi_histout(3) = 3*Bw+1.4*Bh;
pi_histout(4) = 4.4*Bh;

set(fid_histout,'pos',pi_histout)

% histout-Fenster: Aussenmass einlesen
po_histout = get(fid_histout,'OuterPosition');

% Position für Eingabe-Fenster ableiten und zuweisen
if ishghandle('Name','out(NAME)')
    po_out = get(fid_out,'OuterPosition');
    
    po_histout(1) = po_out(1);
    po_histout(2) = po_out(2) - po_histout(4);
    po_histout(3) = po_histout(3);
    po_histout(4) = po_histout(4);
else
    po_histout(1) = p_prog(1);
    po_histout(2) = p_prog(2) - po_histout(4);
    po_histout(3) = po_histout(3);
    po_histout(4) = po_histout(4);             
end

set(fid_histout,'OuterPosition',po_histout)
set(fid_histout,'Resize','off')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = 0.5*Bh;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_histout,'Style','pushbutton',...
                       'String','done',...
                       'pos',pB1,...
                       'Callback','CB_histout_done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = 0.5*Bh+ Bw + 0.2*Bh;
pB2(2) = 0.5*Bh;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_histout,'Style','pushbutton',...
                       'String','cancel',...
                       'pos',pB2,...
                       'Callback','CB_cancel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 3
% Groesse deklarieren und zuweisen
pB3(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh;
pB3(2) = 0.5*Bh;
pB3(3) = Bw;
pB3(4) = Bh;

B3 = uicontrol(fid_histout,'Style','pushbutton',...
                       'String','apply',...
                       'pos',pB3,...
                       'Callback','CB_histout_apply');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Eingabefeld
global I_hist;

% Groesse deklarieren und zuweisen
pI(1) = 0.5*Bh;
pI(2) = 0.5*Bh + Bh + 0.2*Bh;
pI(3) = Bw + 0.2*Bh + Bw + 0.2*Bh + Bw;
pI(4) = Bh;

I_hist = uicontrol(fid_histout,'Style','edit',...
                       'String','',...
                       'pos',pI,...
                       'HorizontalAlignment','left',...
                       'backgroundColor','w');

% Beschriftung
% Groesse deklarieren und zuweisen
pT(1) = 0.5*Bh;
pT(2) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
pT(3) = Bw + 0.2*Bh + Bw + 0.2*Bh + Bw;
pT(4) = Bh;

cT = get(fid_histout,'Color');
T  = uicontrol(fid_histout,'Style','text',...
                        'String','Ausgabefile Knotengroessen:',...
                        'HorizontalAlignment','left',...
                        'pos',pT,...
                        'BackgroundColor',cT);