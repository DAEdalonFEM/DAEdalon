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
function CB_sel_nodes

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

global X

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check ob bereits ein Menu-Fenster offen, ggf. aktivieren
if not(isempty(findobj('Name','sel_nodes.pl')))
    figure(fid_sn)
    return
end

% Check ob bereits ein anderes script-Fenster offen
if not(isempty(findobj('Name','sig_u.pl')))
    delete(fid_su)
end

if not(isempty(findobj('Name','get_value.pl')))
    delete(fid_gv)
end

if not(isempty(findobj('Name','get_val2.pl')))
    delete(fid_gv2)
end

if not(isempty(findobj('Name','merge.pl')))
    delete(fid_merge)
end

X = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y-Position Buttons
yB  = 0.5*Bh;

% y-Position Dateiliste
yls = yB+1.5*Bh;

% y-Position Ueberschrift
ytitle = yls + 5.1*Bh;

% Eingabe-Fenster initialisieren
fid_sn = figure('NumberTitle','off',...
                'Name','sel_nodes.pl',...
                'menubar','none');

% Check ob Info Fenster offen
if not(isempty(findobj('Name','Info: sel_nodes.pl')))
    p = get(fid_sn_info,'OuterPosition');
else
    p = get(fid_post,'OuterPosition');
end

% selnodes-Fenster: Innenmass einelsen
pi_sn = get(fid_sn,'pos');

% Groesse fuer Eingabe-Fenster initialisieren und zuweisen
pi_sn(1) = pi_sn(1);
pi_sn(2) = pi_sn(2);
pi_sn(3) = 3*Bw+1.4*Bh;
pi_sn(4) = 11.6*Bh;

set(fid_sn,'pos',pi_sn)

% selnodes-Fenster: Aussenmass einelsen
po_sn = get(fid_sn,'OuterPosition');

% Position fuer Eingabe-Fenster ableiten und zuweisen
po_sn(1) = p(1);
po_sn(2) = p(2) - po_sn(4);
po_sn(3) = po_sn(3);
po_sn(4) = po_sn(4);

set(fid_sn,'OuterPosition',po_sn)
set(fid_sn,'Resize','off')
set(fid_sn,'SelectionType','open')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eingabeparameter

cBG = get(fid_sn,'Color');

% 1. Parameter: Inputfile
pT1(1) = 0.5*Bh;
pT1(2) = pi_sn(4) - 0.5*Bh - Bh;
pT1(3) = Bw;
pT1(4) = Bh;

T1 = uicontrol(fid_sn,'Style','text',...
                      'String','Inputfile',...
                      'HorizontalAlignment','left',...
                      'BackGroundColor',cBG,...
                      'pos',pT1);

% ouput Verzeichnis einlesen
sys = computer;

if isunix
    path = [pwd,'/output'];
end

if strncmp(sys, 'PC', 2)
    path = [pwd,'\output'];
end

dir_struct = dir('./output');

n          = length(dir_struct);
j = 1;
for i=1:1:n
    dummy = getfield(dir_struct,{i,1},'name');
    if strfind(dummy,'.out')
        dir_struct_clean(j) = dir_struct(i);
        j = j+1;
    end
end

dir_struct = dir_struct_clean;

% Sortieren nach Name
[dummy_names,dummy_index] = sortrows({dir_struct.name}');

% . und .. loeschen
n = length(dummy_names);
sorted_names = cell(n-2,1);
sorted_names(:,1) = dummy_names(3:n,1);
sorted_index(:,1) = dummy_index(1:n-2,1);

% PopUpMenu anlegen
pI1(1) = 0.5*Bh + pT1(3) + 0.2*Bh;
pI1(2) = pT1(2);
pI1(3) = 2*Bw + 0.2*Bh;
pI1(4) = Bh;

global I1_sn;
I1_sn = uicontrol(fid_sn,'Style','popupmenu',...
                         'HorizontalAlignment','left',...
                         'String',dummy_names,...
                         'BackGroundColor','w',...
                         'pos',pI1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Parameter: Outputfile
pT2(1) = 0.5*Bh;
pT2(2) = pT1(2) - 0.2*Bh - Bh;
pT2(3) = Bw;
pT2(4) = Bh;

T2 = uicontrol(fid_sn,'Style','text',...
                      'String','Outputfile',...
                      'HorizontalAlignment','left',...
                      'BackGroundColor',cBG,...
                      'pos',pT2);

pI2(1) = pI1(1);
pI2(2) = pT2(2);
pI2(3) = 2*Bw + 0.2*Bh;
pI2(4) = Bh;

global I2_sn;
I2_sn = uicontrol(fid_sn,'Style','edit',...
                         'HorizontalAlignment','left',...
                         'String','',...
                         'BackGroundColor','w',...
                         'pos',pI2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Parameter: x-Koordinate
pT3(1) = 0.5*Bh;
pT3(2) = pT2(2) - 0.2*Bh - Bh - 0.2*Bh - Bh;
pT3(3) = Bw;
pT3(4) = Bh;

T3 = uicontrol(fid_sn,'Style','text',...
                      'String','x-coor',...
                      'HorizontalAlignment','left',...
                      'BackGroundColor',cBG,...
                      'pos',pT3);

pI3(1) = pI1(1);
pI3(2) = pT3(2);
pI3(3) = Bw;
pI3(4) = Bh;

global I3_sn;
I3_sn = uicontrol(fid_sn,'Style','edit',...
                         'String','',...
                         'BackGroundColor','w',...
                         'pos',pI3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Parameter: y-Koordinate
pT4(1) = 0.5*Bh;
pT4(2) = pT3(2) - 0.2*Bh - Bh;
pT4(3) = Bw;
pT4(4) = Bh;

T4 = uicontrol(fid_sn,'Style','text',...
                      'String','y-coor',...
                      'HorizontalAlignment','left',...
                      'BackGroundColor',cBG,...
                      'pos',pT4);

pI4(1) = pI1(1);
pI4(2) = pT4(2);
pI4(3) = Bw;
pI4(4) = Bh;

global I4_sn;
I4_sn = uicontrol(fid_sn,'Style','edit',...
                         'String','',...
                         'BackGroundColor','w',...
                         'pos',pI4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Parameter: Toleranz
pT5(1) = 0.5*Bh;
pT5(2) = pT4(2) - 0.2*Bh - Bh - 0.2*Bh - Bh;
pT5(3) = Bw;
pT5(4) = Bh;

T5 = uicontrol(fid_sn,'Style','text',...
                      'String','tol',...
                      'HorizontalAlignment','left',...
                      'BackGroundColor',cBG,...
                      'pos',pT5);

pI5(1) = pI1(1);
pI5(2) = pT5(2);
pI5(3) = Bw;
pI5(4) = Bh;

global I5_sn;
I5_sn = uicontrol(fid_sn,'Style','edit',...
                         'String','0.001',...
                         'BackGroundColor','w',...
                         'pos',pI5);

% Buttons anlegen

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = yB;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_sn,'Style','pushbutton',...
                       'String','done',...
                       'pos',pB1,...
                       'Callback','CB_sel_nodes_done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = 0.7*Bh+Bw;
pB2(2) = yB;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_sn,'Style','pushbutton',...
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

B3 = uicontrol(fid_sn,'Style','pushbutton',...
                       'String','apply',...
                       'pos',pB3);

set(B3,'Callback','CB_sel_nodes_apply');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
