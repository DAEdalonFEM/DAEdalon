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
function B_pre_CB

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global fid_pre;     % Figure ID PreProcess-Menu
global fid_prog;    % Figure ID ProgFlow-Menu
global fid_plot;    % Figure ID PlotControl-Menu
global fid_opt;     % Figure ID DAEOptions-Menu
global fid_f2f;     % Figure ID FEAP-Input
global fid_cont;    % Figure ID ContPlot-Menu
global fid_time;    % Figure ID time-Input
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check ob bereits ein Menu-Fenster offen, ggf. schliessen
if not(isempty(findobj('Name','PreProcess')))
    figure(fid_pre)
    if not(isempty(findobj('Name','FEAP-Input')))
        figure(fid_f2f)
    end
    return
end

if not(isempty(findobj('Name','ProgFlow')))
    close(fid_prog)
end

if not(isempty(findobj('Name','PlotControl')))
    close(fid_plot)
end

if not(isempty(findobj('Name','DAEOptions')))
    close(fid_opt)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Position des DAEControl-Fensters einlesen
po_dc = get(fid_dc,'OuterPosition');
pi_dc = get(fid_dc,'pos');

% PreProcess-Fenster initialisieren
fid_pre = figure('NumberTitle','off',...
                 'Name','PreProcess',...
                 'MenuBar','none',...
                 'CloseRequestFcn','CRF_PreProcess');

set(fid_pre,'Resize','off');

% PreProcess-Fenster: Innenmass einlesen
pi_pre   = get(fid_pre,'pos');

% Groesse des PreProcess-Fensters deklarieren und zuweisen
pi_pre(1) = pi_pre(1);
pi_pre(2) = pi_pre(2);
pi_pre(3) = pi_dc(3);
pi_pre(4) = 4*Bh;

set(fid_pre,'Position',pi_pre);

% PreProcess-Fenster: Aussenmass einlesen
po_pre   = get(fid_pre,'OuterPosition');

% Position des PreProcess-Fensters deklarieren und zuweisen
po_pre(1) = po_dc(1);
po_pre(2) = po_dc(2)-po_pre(4);
po_pre(3) = Fw;
po_pre(4) = po_pre(4);

set(fid_pre,'OuterPosition',po_pre);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen
% 1. Stufe
y1 = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh;
y2 = 0.5*Bh + Bh + 0.2*Bh;
y3 = 0.5*Bh;

%Button 0
%Groesse deklarieren und zuweisen
pB0(1) = 0.5*Bh + Bw + 0.1*Bh - 0.5*Bw;
pB0(2) = y1;
pB0(3) = Bw;
pB0(4) = Bh;
B0 = uicontrol(fid_pre,'Style','pushbutton',...
                       'String','inp_convert',...
                       'pos',pB0,...
                       'Callback','inp_convert');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Button 0.1
%Groesse deklarieren und zuweisen
pB01(1) = 0.5*Bh;
pB01(2) = y2;
pB01(3) = Bw;
pB01(4) = Bh;
B01 = uicontrol(fid_pre,'Style','pushbutton',...
                       'String','edis',...
                       'pos',pB01,...
                       'Callback','edis');

%Button 0.2
%Groesse deklarieren und zuweisen
pB02(1) = 0.5*Bh + Bw + 0.2*Bh;
pB02(2) = y2;
pB02(3) = Bw;
pB02(4) = Bh;
B02 = uicontrol(fid_pre,'Style','pushbutton',...
                       'String','force',...
                       'pos',pB02,...
                       'Callback','force');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = y3;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_pre,'Style','pushbutton',...
                       'String','lprob',...
                       'pos',pB1,...
                       'Callback','lprob');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = 0.5*Bh + Bw + 0.2*Bh;
pB2(2) = y3;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_pre,'Style','pushbutton',...
                       'String','f2f.pl',...
                       'pos',pB2,...
                       'Callback','CB_f2f');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
