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
%    Public License along with DAEdalon; if not, write to the      %
%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,   %
%    Boston, MA  02111-1307  USA                                   %
%                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CB_cont_sm

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
if not(isempty(findobj('Name','cont_sm(X,Y)')))
    figure(fid_cont_sm)
    return
end

% Check ob ein anderes Eingabe-Fenster bereits offen
if not(isempty(findobj('Name','cont(X)')))
    delete(fid_cont)
end

if not(isempty(findobj('Name','ucont(X)')))
    delete(fid_ucont)
end

if not(isempty(findobj('Name','ucont_sm(X,Y)')))
    delete(fid_ucont_sm)
end

global X;
global Y;

X = 0;
Y = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cont_sm(X,Y)-Fenster initialisieren
fid_cont_sm = figure('NumberTitle','off',...
                     'Name','cont_sm(X,Y)',...
                     'MenuBar','none');

% PlotControl-Fenster: Aussenmass einlesen
p_plot  = get(fid_plot,'OuterPosition');

% cont_sm(X)-Fenster: Innenass einlesen
pi_cont_sm = get(fid_cont_sm,'pos');

% Greosse initialisieren und zuweisen
pi_cont_sm(1) = pi_cont_sm(1);
pi_cont_sm(2) = pi_cont_sm(2);
pi_cont_sm(3) = 3*Bw+1.4*Bh;
pi_cont_sm(4) = 6.8*Bh;

set(fid_cont_sm,'pos',pi_cont_sm)

% cont_sm(X)-Fenster: Aussenmass einlesen
po_cont_sm = get(fid_cont_sm,'OuterPosition');

% Position fuer Eingabe-Fenster ableiten und zuweisen
po_cont_sm(1) = p_plot(1);
po_cont_sm(2) = p_plot(2) - po_cont_sm(4);
po_cont_sm(3) = po_cont_sm(3);
po_cont_sm(4) = po_cont_sm(4);

set(fid_cont_sm,'OuterPosition',po_cont_sm)

set(fid_cont_sm,'Resize','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = 0.5*Bh;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_cont_sm,'Style','pushbutton',...
                           'String','done',...
                           'pos',pB1,...
                           'Callback','CB_cont_sm_done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = 0.5*Bh+ Bw + 0.2*Bh;
pB2(2) = 0.5*Bh;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_cont_sm,'Style','pushbutton',...
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

B3 = uicontrol(fid_cont_sm,'Style','pushbutton',...
                           'String','apply',...
                           'pos',pB3,...
                           'Callback','CB_cont_sm_apply');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Eingabefeld
global IX;

% Groesse deklarieren und zuweisen
pIX(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh;
pIX(2) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
pIX(3) = Bw;
pIX(4) = Bh;

IX = uicontrol(fid_cont_sm,'Style','edit',...
                           'String','1',...
                           'pos',pIX,...
                           'backgroundColor','w');

% Beschriftung
% Groesse deklarieren und zuweisen
pTX(1) = 0.5*Bh;
pTX(2) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
pTX(3) = Bw + 0.2*Bh + Bw;
pTX(4) = Bh;


cT = get(fid_cont_sm,'Color');
TX  = uicontrol(fid_cont_sm,'Style','text',...
                            'String','Gausspunkt-Groesse (X):',...
                            'HorizontalAlignment','left',...
                            'pos',pTX,...
                            'BackgroundColor',cT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vor und Zurueck Buttons

% Zurueck
% Groesse deklarieren und zuweisen
pBrewX(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh;
pBrewX(2) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
pBrewX(3) = Bw/2 - 0.1*Bh;
pBrewX(4) = Bh;

BrewX = uicontrol(fid_cont_sm,'Style','pushbutton',...
                              'String','<<',...
                              'pos',pBrewX,...
                              'Callback','CB_cont_sm_rewX');

% Vor
% Groesse deklarieren und zuweisen
pBffX(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh + Bw/2-0.1*Bh + 0.2*Bh;
pBffX(2) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
pBffX(3) = Bw/2 - 0.1*Bh;
pBffX(4) = Bh;

BffX = uicontrol(fid_cont_sm,'Style','pushbutton',...
                             'String','>>',...
                             'pos',pBffX,...
                             'Callback','CB_cont_sm_ffX');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Eingabefeld
global IY;

% Groesse deklarieren und zuweisen
pIY(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh;
pIY(2) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
pIY(3) = Bw;
pIY(4) = Bh;

IY = uicontrol(fid_cont_sm,'Style','edit',...
                           'String','1',...
                           'pos',pIY,...
                           'backgroundColor','w');

% Beschriftung
% Groesse deklarieren und zuweisen
pTY(1) = 0.5*Bh;
pTY(2) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
pTY(3) = Bw + 0.2*Bh + Bw;
pTY(4) = Bh;


%cT = get(fid_cont_sm,'Color');
TY  = uicontrol(fid_cont_sm,'Style','text',...
                            'String','Material-Datensatz (Y):',...
                            'HorizontalAlignment','left',...
                            'pos',pTY,...
                            'BackgroundColor',cT);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vor und Zurueck Buttons

% Zurueck
% Groesse deklarieren und zuweisen
pBrewY(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh;
pBrewY(2) = 0.5*Bh + Bh + 0.2*Bh;
pBrewY(3) = Bw/2 - 0.1*Bh;
pBrewY(4) = Bh;

BrewY = uicontrol(fid_cont_sm,'Style','pushbutton',...
                              'String','<<',...
                              'pos',pBrewY,...
                              'Callback','CB_cont_sm_rewY');

% Vor
% Groesse deklarieren und zuweisen
pBffY(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh + Bw/2-0.1*Bh + 0.2*Bh;
pBffY(2) = 0.5*Bh + Bh + 0.2*Bh;
pBffY(3) = Bw/2 - 0.1*Bh;
pBffY(4) = Bh;

BffY = uicontrol(fid_cont_sm,'Style','pushbutton',...
                             'String','>>',...
                             'pos',pBffY,...
                             'Callback','CB_cont_sm_ffY');
