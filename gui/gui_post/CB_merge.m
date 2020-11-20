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
function CB_merge

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
global fid_gv;      % Figure ID get_value.pl
global fid_gv2;     % Figure ID get_val2.pl
global fid_merge;   % Figure ID merge.pl
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

global handles;
global ls;

global mod_string;
mod_string = '1';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check ob bereits ein merge.pl-Fenster offen, ggf. aktivieren
if ishghandle('Name','merge.pl')
    figure(fid_merge)
    return
end

% Check ob bereits ein anderes script-Fenster offen
if ishghandle('Name','sel_nodes.pl')
    delete(fid_sn)
end

if ishghandle('Name','Info: sel_nodes.pl')
    delete(fid_sn_info)
end

if ishghandle('Name','sig_u.pl')
    delete(fid_su)
end

if ishghandle('Name','get_value.pl')
    delete(fid_gv)
end

if ishghandle('Name','get_val2.pl')
    delete(fid_gv2)
end

global mod_string;
global X

X = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y-Position Buttons
yB  = 0.5*Bh;

% y-Position Dateiliste
yls = yB+1.5*Bh;

% y-Position Ueberschrift
ytitle = yls + 5.1*Bh;

% Eingabe-Fenster initialisieren
fid_merge = figure('NumberTitle','off',...
                   'Name','merge.pl',...
                   'menubar','none');

% Check ob Info Fenster offen
if ishghandle('Name','Info: merge.pl')
    p = get(fid_merge_info,'OuterPosition');
else
    p = get(fid_post,'OuterPosition');
end

% merge.pl-Fenster: Innenmass einelsen
pi_merge = get(fid_merge,'pos');

% Groesse fuer Eingabe-Fenster initialisieren und zuweisen
pi_merge(1) = pi_merge(1);
pi_merge(2) = pi_merge(2);
pi_merge(3) = 3*Bw+1.4*Bh;
pi_merge(4) = 10.4*Bh;

set(fid_merge,'pos',pi_merge)

% merge.pl-Fenster: Aussenmass einelsen
po_merge = get(fid_merge,'OuterPosition');

% Position fuer Eingabe-Fenster ableiten und zuweisen
po_merge(1) = p(1);
po_merge(2) = p(2) - po_merge(4);
po_merge(3) = po_merge(3);
po_merge(4) = po_merge(4);

set(fid_merge,'OuterPosition',po_merge)
set(fid_merge,'Resize','off')
set(fid_merge,'SelectionType','open')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eingabeparameter

cBG = get(fid_merge,'Color');

% 1. Parameter: Inputfiles
pT1(1) = 0.5*Bh;
pT1(2) = pi_merge(4) - 0.5*Bh - Bh;
pT1(3) = Bw;
pT1(4) = Bh;

T1 = uicontrol(fid_merge,'Style','text',...
                       'String','Inputfiles',...
                       'HorizontalAlignment','left',...
                       'BackGroundColor',cBG,...
                       'pos',pT1);

pI1(1) = 0.5*Bh + pT1(3) + 0.2*Bh;
pI1(2) = pT1(2);
pI1(3) = 2*Bw + 0.2*Bh;
pI1(4) = Bh;

global I1_merge;
I1_merge = uicontrol(fid_merge,'Style','edit',...
                           'HorizontalAlignment','left',...
                           'String','',...
                           'BackGroundColor','w',...
                           'pos',pI1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Parameter: Knotenfile
pT2(1) = 0.5*Bh;
pT2(2) = pT1(2) - 0.2*Bh - Bh - 0.2*Bh - Bh;
pT2(3) = Bw + 0.2*Bh + Bw;
pT2(4) = Bh;

T2 = uicontrol(fid_merge,'Style','text',...
                         'String','Knotenfile',...
                         'HorizontalAlignment','left',...
                         'BackGroundColor',cBG,...
                         'pos',pT2);

pI2(1) = pI1(1);
pI2(2) = pT2(2);
pI2(3) = pI1(3);
pI2(4) = Bh;

global I2_merge;
I2_merge = uicontrol(fid_merge,'Style','edit',...
                           'String','',...
                           'HorizontalAlignment','left',...
                           'BackGroundColor','w',...
                           'pos',pI2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Parameter: Spaltenfile
pT3(1) = 0.5*Bh;
pT3(2) = pT2(2) - 0.2*Bh - Bh;
pT3(3) = Bw + 0.2*Bh;
pT3(4) = Bh;

T3 = uicontrol(fid_merge,'Style','text',...
                       'String','Spaltenfile',...
                       'HorizontalAlignment','left',...
                       'BackGroundColor',cBG,...
                       'pos',pT3);

pI3(1) = pI1(1);
pI3(2) = pT3(2);
pI3(3) = pI1(3);
pI3(4) = Bh;

global I3_merge;
I3_merge = uicontrol(fid_merge,'Style','edit',...
                           'String','',...
                           'HorizontalAlignment','left',...
                           'BackGroundColor','w',...
                           'pos',pI3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Parameter: Sortieren nach Spalte
pT4(1) = 0.5*Bh;
pT4(2) = pT3(2) - 0.2*Bh - Bh - 0.2*Bh - Bh;
pT4(3) = Bw + 0.2*Bh + Bw + 0.2*Bh;
pT4(4) = Bh;

T4 = uicontrol(fid_merge,'Style','text',...
                         'String','Sortieren nach Spalte',...
                         'HorizontalAlignment','left',...
                         'BackGroundColor',cBG,...
                         'pos',pT4);

pI4(1) = pT4(1) + pT4(3);
pI4(2) = pT4(2);
pI4(3) = Bw;
pI4(4) = Bh;

global I4_merge;
I4_merge = uicontrol(fid_merge,'Style','edit',...
                               'String','1',...
                               'BackGroundColor','w',...
                               'pos',pI4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = yB;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_merge,'Style','pushbutton',...
                       'String','done',...
                       'pos',pB1,...
                       'Callback','CB_merge_done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = 0.7*Bh+Bw;
pB2(2) = yB;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_merge,'Style','pushbutton',...
                         'String','cancel',...
                         'pos',pB2,...
                         'Callback','CB_cancel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 3
% Groesse deklarieren und zuweisen
pB3(1) = 0.5*Bh + Bw + 0.2*Bh + Bw + 0.2*Bh;
pB3(2) = yB;
pB3(3) = Bw;
pB3(4) = Bh;

B3 = uicontrol(fid_merge,'Style','pushbutton',...
                         'String','apply',...
                         'pos',pB3);

set(B3,'Callback','CB_merge_apply');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
