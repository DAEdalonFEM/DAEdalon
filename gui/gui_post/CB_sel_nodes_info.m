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
function CB_sel_nodes_info

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global fid_pre;     % Figure ID PreProcess-Menu
global fid_prog;    % Figure ID ProgFlow-Menu
global fid_plot;    % Figure ID PlotControl-Menu
global fid_post;    % Figure ID PostProcess-Menu
global fid_cont;    % Figure ID ContPlot-Menu
global fid_time;    % Figure ID time-Input
global fid_f2f;     % Figure ID FEAP-Input
global fid_sn;      % Figure ID sel_nodes.pl
global fid_sn_info; % Figure ID Info: sel_nodes.pl
global fid_su;      % Figure ID sig_u.pl
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

global handles;
global ls;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check ob bereits ein Menu-Fenster offen, ggf. aktivieren
if ishghandle('Name','Info: sel_nodes.pl')
    figure(fid_sn_info)
    return
end

% Check ob bereits ein anderes script-Fenster offen
if ishghandle('Name','sig_u.pl')
    delete(fid_su)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y-Position Buttons
yB  = 0.5*Bh;

% y-Position Dateiliste
yls = yB+1.5*Bh;

% y-Position Ueberschrift
ytitle = yls + 5.1*Bh;

% Eingabe-Fenster initialisieren
fid_sn_info = figure('NumberTitle','off',...
                     'Name','Info: sel_nodes.pl',...
                     'menubar','none',...
                     'CloseRequestFcn','crf_sn_info');

% Check ob sel_nodes.pl Fenster offen
if ishghandle('Name','sel_nodes.pl')
    p = get(fid_sn,'OuterPosition');
else
    p = get(fid_post,'OuterPosition');
end

% selnodes-Fenster: Innenmass einelsen
pi_sn_info = get(fid_sn_info,'pos');

% Groesse fuer Eingabe-Fenster initialisieren und zuweisen
pi_sn_info(1) = pi_sn_info(1);
pi_sn_info(2) = pi_sn_info(2);
pi_sn_info(3) = 3*Bw+1.4*Bh;
pi_sn_info(4) = 8.6*Bh;

set(fid_sn_info,'pos',pi_sn_info)

% selnodes-Fenster: Aussenmass einelsen
po_sn_info = get(fid_sn_info,'OuterPosition');

% Position fuer Eingabe-Fenster ableiten und zuweisen
po_sn_info(1) = p(1);
po_sn_info(2) = p(2) - po_sn_info(4);
po_sn_info(3) = po_sn_info(3);
po_sn_info(4) = po_sn_info(4);

set(fid_sn_info,'OuterPosition',po_sn_info)
set(fid_sn_info,'Resize','off')
set(fid_sn_info,'SelectionType','open')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Textfeld

pT_frame(1) = 0.5*Bh;
pT_frame(2) = 0.5*Bh + Bh + 0.5*Bh;
pT_frame(3) = pi_sn_info(3) - Bh;
pT_frame(4) = pi_sn_info(4) - 0.5*Bh - 2*Bh;

T_frame = uicontrol(fid_sn_info,'Style','frame',...
                                'BackGroundColor','w',...
                                'pos',pT_frame);

% Text
pT = pT_frame;

T = uicontrol(fid_sn_info,'Style','text',...
                          'BackGroundColor','w',...
                          'pos',pT,...
                          'HorizontalAlignment','left',...
                          'String',['Mit sel_nodes.pl kann man die Knotennummern aus einem unter DAEdalon ',...
                                    'mit out(NAME) erzeugten Ausgabefile NAME_time.out heraussuchen, ',...
                                    'die vorgegebene Koordinaten (in der Referenzkonfiguration) besitzen.',...
                                    'Wenn die Koordinate in einer Richtung beliebig ist, macht man das mit dem Schluesselwort all deutlich.']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen

% Button 3
% Groesse deklarieren und zuweisen
pB3(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh;
pB3(2) = yB;
pB3(3) = Bw;
pB3(4) = Bh;

B3 = uicontrol(fid_sn_info,'Style','pushbutton',...
                       'String','close',...
                       'pos',pB3);

set(B3,'Callback','crf_sn_info');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
