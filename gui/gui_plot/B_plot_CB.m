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
function B_plot_CB

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global fid_pre;     % Figure ID PreProcess-Menu
global fid_f2f;     % Figure ID FEAP-Input
global fid_prog;    % Figure ID ProgFlow-Menu
global fid_time;    % Figure ID time-Input
global fid_plot;    % Figure ID PlotControl-Menu
global fid_opt;     % Figure ID DAEOptions-Menu
global fid_cont;
global fid_cont_sm;
global fid_ucont;
global fid_ucont_sm;
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

global contvar;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check ob bereits ein Menu-Fenster offen, ggf. schliessen
if not(isempty(findobj('Name','PlotControl')))
    figure(fid_plot)
    if not(isempty(findobj('Name','cont(X)')))
        figure(fid_cont)
    end
    if not(isempty(findobj('Name','cont_sm(X,Y)')))
        figure(fid_cont_sm)
    end
    if not(isempty(findobj('Name','ucont(X)')))
        figure(fid_ucont)
    end
    if not(isempty(findobj('Name','ucont_sm(X,Y)')))
        figure(fid_ucont_sm)
    end
    return
end

if not(isempty(findobj('Name','PreProcess')))
    close(fid_pre)
end

if not(isempty(findobj('Name','ProgFlow')))
    close(fid_prog)
end

if not(isempty(findobj('Name','DAEOptions')))
    close(fid_opt)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAEControl-Fenster: Aussenmass einlesen
po_dc = get(fid_dc,'OuterPosition');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAEControl-Fenster: Innenmass einlesen
pi_dc = get(fid_dc,'pos');

% PlotControl-Fenster initialisieren
fid_plot = figure('NumberTitle','off',...
                  'Name','PlotControl',...
                  'MenuBar','none',...
                  'CloseRequestFcn','CRF_PlotControl');

set(fid_plot,'Resize','off')

% PlotControl-Fenster: Innenmass einlesen
pi_plot   = get(fid_plot,'Position');

% Groesse des PlotControl-Fensters deklarieren und zuweisen
pi_plot(1) = pi_plot(1);
pi_plot(2) = pi_plot(2);
pi_plot(3) = pi_dc(3);
pi_plot(4) = 11*Bh;

set(fid_plot,'Position',pi_plot);

% PlotControl-Fenster: Aussenmass einlesen
po_plot   = get(fid_plot,'OuterPosition');

% Position des PlotControl-Fensters deklarieren und zuweisen
po_plot(1) = po_dc(1);
po_plot(2) = po_dc(2)-po_plot(4);
po_plot(3) = Fw;
po_plot(4) = po_plot(4);

set(fid_plot,'OuterPosition',po_plot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen
% 1. Stufe
y1 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.5*Bh + Bh + 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
y2 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.5*Bh + Bh + 0.5*Bh + Bh + 0.2*Bh;
y3 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.5*Bh + Bh + 0.5*Bh;
y4 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.5*Bh;
y5 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
y6 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
y7 = 0.5*Bh + Bh + 0.2*Bh;
y8 = 0.5*Bh;

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = y1;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_plot,'Style','pushbutton',...
                        'String','mesh0',...
                        'pos',pB1,...
                        'Callback','mesh0');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 2
% Groessen deklarieren und zuweisen
pB2(1) = 0.5*Bh + Bw + 0.2*Bh;
pB2(2) = y1;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_plot,'Style','pushbutton',...
                        'String','nodenum',...
                        'pos',pB2,...
                        'Callback','nodenum');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 3
% Groesse deklarieren und zuweisen
pB3(1) = 0.5*Bh;
pB3(2) = y2;
pB3(3) = Bw;
pB3(4) = Bh;

B3 = uicontrol(fid_plot,'Style','pushbutton',...
                        'String','boun',...
                        'pos',pB3,...
                        'Callback','boun');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 4
% Groesse deklarieren und zuweisen
pB4(1) = 0.5*Bh + Bw + 0.2*Bh;
pB4(2) = y2;
pB4(3) = Bw;
pB4(4) = Bh;

B4 = uicontrol(fid_plot,'Style','pushbutton',...
                        'String','elnum',...
                        'pos',pB4,...
                        'Callback','elnum');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 5
% Groesse deklarieren und zuweisen
pB5(1) = 0.5*Bh;
pB5(2) = y3;
pB5(3) = Bw;
pB5(4) = Bh;

B5 = uicontrol(fid_plot,'Style','pushbutton',...
                        'String','forc',...
                        'pos',pB5,...
                        'Callback','forc');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 6
% Groesse deklarieren und zuweisen
pB6(1) = 0.5*Bh + Bw +0.2*Bh;
pB6(2) = y3;
pB6(3) = Bw;
pB6(4) = Bh;

B6 = uicontrol(fid_plot,'Style','pushbutton',...
                        'String','mats',...
                        'pos',pB6,...
                        'Callback','mats');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button 7
% Groesse deklarieren und zuweisen
pB7(1) = 0.5*Bh + Bw + 0.1*Bh - 0.5*Bw;
pB7(2) = y4;
pB7(3) = Bw;
pB7(4) = Bh;

B7 = uicontrol(fid_plot,'Style','pushbutton',...
                        'String','clp',...
                        'pos',pB7,...
                        'Callback','clp');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button 8
% Groesse deklarieren und zuweisen
pB8(1) = 0.5*Bh;
pB8(2) = y5;
pB8(3) = Bw;
pB8(4) = Bh;

B8 = uicontrol(fid_plot,'Style','pushbutton',...
                        'String','meshx',...
                        'pos',pB8,...
                        'Callback','meshx');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 10
% Groesse deklarieren und zuweisen
pB10(1) = 0.5*Bh;
pB10(2) = y6;
pB10(3) = Bw;
pB10(4) = Bh;

B10 = uicontrol(fid_plot,'Style','pushbutton',...
                         'String','cont',...
                         'pos',pB10,...
                         'Callback','CB_cont');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 12
% Groesse deklarieren und zuweisen
pB12(1) = 0.5*Bh + Bw + 0.2*Bh;
pB12(2) = y6;
pB12(3) = Bw;
pB12(4) = Bh;

B12 = uicontrol(fid_plot,'Style','pushbutton',...
                         'String','ucont',...
                         'pos',pB12,...
                         'Callback','CB_ucont');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 13
% Groesse deklarieren und zuweisen
pB13(1) = 0.5*Bh;
pB13(2) = y7;
pB13(3) = Bw;
pB13(4) = Bh;

B13 = uicontrol(fid_plot,'Style','pushbutton',...
                         'String','cont_sm',...
                         'pos',pB13,...
                         'Callback','CB_cont_sm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 14
% Groesse deklarieren und zuweisen
pB14(1) = 0.5*Bh + Bw + 0.2*Bh;
pB14(2) = y7;
pB14(3) = Bw;
pB14(4) = Bh;

B14 = uicontrol(fid_plot,'Style','pushbutton',...
                         'String','ucont_sm',...
                         'pos',pB14,...
                         'Callback','CB_ucont_sm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 9
% Groesse deklarieren und zuweisen
pB9(1) = 0.5*Bh;
pB9(2) = y8;
pB9(3) = Bw;
pB9(4) = Bh;

B9 = uicontrol(fid_plot,'Style','pushbutton',...
                        'String','disvec',...
                        'pos',pB9,...
                        'Callback','disvec');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 11
% Groesse deklarieren und zuweisen
pB11(1) = 0.5*Bh + Bw + 0.2*Bh;
pB11(2) = y8;
pB11(3) = Bw;
pB11(4) = Bh;

B11 = uicontrol(fid_plot,'Style','pushbutton',...
                         'String','reac',...
                         'pos',pB11,...
                         'Callback','reac');



