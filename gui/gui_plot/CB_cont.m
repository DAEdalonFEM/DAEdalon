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
function CB_cont

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global fid_pre;     % Figure ID PreProcess-Menu
global fid_prog;    % Figure ID ProgFlow-Menu
global fid_plot;    % Figure ID PlotControl-Menu
global fid_cont;    % Figure ID cont(X)-Menu
global fid_ucont;   % Figure ID ucont(X)-Menu
global fid_cont_sm; % Figure ID cont_sm(X,Y) Plot-Menu
global fid_ucont_sm;% Figure ID ucont_sm(X,Y) Plot-Menu
global fid_time;    % Figure ID time-Input
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check ob Fenster bereits offen
if findobj('Name','cont(X)')
    figure(fid_cont)
    return
end

% Check ob anderes Eingabe-Fenster bereits offen
if findobj('Name','ucont(X)')
    delete(fid_ucont)
end

if findobj('Name','cont_sm(X,Y)')
    delete(fid_cont_sm)
end

if findobj('Name','ucont_sm(X,Y)')
    delete(fid_ucont_sm)
end

global X;
X = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cont(X)-Fenster initialisieren
fid_cont = figure('NumberTitle','off',...
                  'Name','cont(X)',...
                  'MenuBar','none');
              
% PlotControl-Fenster: Aussenmass einlesen
p_plot  = get(fid_plot,'OuterPosition');

% cont(X)-Fenster: Innenass einlesen
pi_cont = get(fid_cont,'pos');

% Greosse initialisieren und zuweisen
pi_cont(1) = pi_cont(1);
pi_cont(2) = pi_cont(2);
pi_cont(3) = 3*Bw+1.4*Bh;
pi_cont(4) = 4.4*Bh;

set(fid_cont,'pos',pi_cont)

% cont(X)-Fenster: Aussenmass einlesen
po_cont = get(fid_cont,'OuterPosition');
              
% Position für Eingabe-Fenster ableiten und zuweisen
po_cont(1) = p_plot(1);
po_cont(2) = p_plot(2) - po_cont(4);
po_cont(3) = po_cont(3);
po_cont(4) = po_cont(4);

set(fid_cont,'OuterPosition',po_cont)

set(fid_cont,'Resize','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = 0.5*Bh;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_cont,'Style','pushbutton',...
                        'String','done',...
                        'pos',pB1,...
                        'Callback','CB_cont_done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = 0.5*Bh+ Bw + 0.2*Bh;
pB2(2) = 0.5*Bh;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_cont,'Style','pushbutton',...
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

B3 = uicontrol(fid_cont,'Style','pushbutton',...
                        'String','apply',...
                        'pos',pB3,...
                        'Callback','CB_cont_apply');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Eingabefeld
global I;

% Groesse deklarieren und zuweisen
pI(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh;
pI(2) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
pI(3) = Bw;
pI(4) = Bh;

global I; % Fuer Vor und Zurueck Buttons

I = uicontrol(fid_cont,'Style','edit',...
                       'String','1',...
                       'pos',pI,...
                       'backgroundColor','w');

% Beschriftung
% Groesse deklarieren und zuweisen
pT(1) = 0.5*Bh;
pT(2) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
pT(3) = Bw + 0.2*Bh + Bw;
pT(4) = Bh;


cT = get(fid_cont,'Color');
T  = uicontrol(fid_cont,'Style','text',...
                        'String','Gaußpunkt-Größe (X):',...
                        'HorizontalAlignment','left',...
                        'pos',pT,...
                        'BackgroundColor',cT);
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vor und Zurueck Buttons

% Zurueck
% Groesse deklarieren und zuweisen
pBrew(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh;
pBrew(2) = 0.5*Bh + Bh + 0.2*Bh;
pBrew(3) = Bw/2 - 0.1*Bh;
pBrew(4) = Bh;

Brew = uicontrol(fid_cont,'Style','pushbutton',...
                          'String','<<',...
                          'pos',pBrew,...
                          'Callback','CB_cont_rew');

% Vor
% Groesse deklarieren und zuweisen
pBff(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh + Bw/2-0.1*Bh + 0.2*Bh;
pBff(2) = 0.5*Bh + Bh + 0.2*Bh;
pBff(3) = Bw/2 - 0.1*Bh;
pBff(4) = Bh;

Brew = uicontrol(fid_cont,'Style','pushbutton',...
                          'String','>>',...
                          'pos',pBff,...
                          'Callback','CB_cont_ff');