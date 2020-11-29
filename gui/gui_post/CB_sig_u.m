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
function CB_sig_u

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check ob bereits ein Menu-Fenster offen, ggf. aktivieren
if not(isempty(findobj('Name','sig_u.pl')))
    figure(fid_su)
    return
end

% Check ob bereits ein anderes script-Fenster offen
if not(isempty(findobj('Name','sel_nodes.pl')))
    delete(fid_sn)
end

if not(isempty(findobj('Name','Info: sel_nodes.pl')))
    delete(fid_sn_info)
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

global mod_string;
global X

%mod_string = '';
X = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y-Position Buttons
yB  = 0.5*Bh;

% y-Position Dateiliste
yls = yB+1.5*Bh;

% y-Position Ueberschrift
ytitle = yls + 5.1*Bh;

% Eingabe-Fenster initialisieren
fid_su = figure('NumberTitle','off',...
                'Name','sig_u.pl',...
                'menubar','none');

% Check ob Info Fenster offen
if not(isempty(findobj('Name','Info: sig_u.pl')))
    p = get(fid_su_info,'OuterPosition');
else
    p = get(fid_post,'OuterPosition');
end

% selnodes-Fenster: Innenmass einelsen
pi_su = get(fid_su,'pos');

% Groesse fuer Eingabe-Fenster initialisieren und zuweisen
pi_su(1) = pi_su(1);
pi_su(2) = pi_su(2);
pi_su(3) = 3*Bw+1.4*Bh;
pi_su(4) = 5.6*Bh;

set(fid_su,'pos',pi_su)

% selnodes-Fenster: Aussenmass einelsen
po_su = get(fid_su,'OuterPosition');

% Position fuer Eingabe-Fenster ableiten und zuweisen
po_su(1) = p(1);
po_su(2) = p(2) - po_su(4);
po_su(3) = po_su(3);
po_su(4) = po_su(4);

set(fid_su,'OuterPosition',po_su)
set(fid_su,'Resize','off')
set(fid_su,'SelectionType','open')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eingabeparameter

cBG = get(fid_su,'Color');

% 1. Parameter: Inputfile
pT1(1) = 0.5*Bh;
pT1(2) = pi_su(4) - 0.5*Bh - Bh;
pT1(3) = Bw;
pT1(4) = Bh;

T1 = uicontrol(fid_su,'Style','text',...
                      'String','Inputfiles',...
                      'HorizontalAlignment','left',...
                      'BackGroundColor',cBG,...
                      'pos',pT1);

pI1(1) = 0.5*Bh + pT1(3) + 0.2*Bh;
pI1(2) = pT1(2);
pI1(3) = 2*Bw + 0.2*Bh;
pI1(4) = Bh;

global I1_su;
I1_su = uicontrol(fid_su,'Style','edit',...
                         'HorizontalAlignment','left',...
                         'String','',...
                         'BackGroundColor','w',...
                         'pos',pI1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Parameter: Outputfile
pT2(1) = 0.5*Bh;
pT2(2) = pT1(2) - 0.2*Bh - Bh;
pT2(3) = Bw;
pT2(4) = Bh;

T2 = uicontrol(fid_su,'Style','text',...
                      'String','Knotenfile',...
                      'HorizontalAlignment','left',...
                      'BackGroundColor',cBG,...
                      'pos',pT2);

pI2(1) = pI1(1);
pI2(2) = pT2(2);
pI2(3) = 2*Bw + 0.2*Bh;
pI2(4) = Bh;

global I2_su;
I2_su = uicontrol(fid_su,'Style','edit',...
                         'HorizontalAlignment','left',...
                         'String','',...
                         'BackGroundColor','w',...
                         'pos',pI2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = yB;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_su,'Style','pushbutton',...
                       'String','done',...
                       'pos',pB1,...
                       'Callback','CB_sig_u_done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = 0.7*Bh+Bw;
pB2(2) = yB;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_su,'Style','pushbutton',...
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

B3 = uicontrol(fid_su,'Style','pushbutton',...
                       'String','apply',...
                       'pos',pB3);

set(B3,'Callback','CB_sig_u_apply');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
