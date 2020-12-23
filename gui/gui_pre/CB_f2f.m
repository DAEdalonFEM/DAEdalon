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
function CB_f2f

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global fid_pre;     % Figure ID PreProcess-Menu
global fid_prog;    % Figure ID ProgFlow-Menu
global fid_plot;    % Figure ID PlotControl-Menu
global fid_cont;    % Figure ID ContPlot-Menu
global fid_time;    % Figure ID time-Input
global fid_f2f;     % Figure ID FEAP-Input
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

global handles;
global ls;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check ob bereits ein Menu-Fenster offen, ggf. aktivieren
if not(isempty(findobj('Name','FEAP-Input')))
    figure(fid_f2f)
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y-Position Buttons
yB  = 0.5*Bh;

% y-Position Dateiliste
yls = yB+1.5*Bh;

% y-Position Ueberschrift
ytitle = yls + 5.1*Bh;

% Eingabe-Fenster initialisieren
fid_f2f = figure('NumberTitle','off',...
                 'Name','FEAP-Input',...
                 'menubar','none');

% PreProcess-Fenster: Aussenmass einlesen
p_pre  = get(fid_pre,'OuterPosition');

% FEAP-Input-Fenster: Innenmass einelsen
pi_f2f = get(fid_f2f,'pos');

% Groesse fuer Eingabe-Fenster initialisieren und zuweisen
pi_f2f(1) = pi_f2f(1);
pi_f2f(2) = pi_f2f(2);
pi_f2f(3) = 3*Bw+1.4*Bh;
pi_f2f(4) = 8.6*Bh;

set(fid_f2f,'pos',pi_f2f)

% FEAP-Input-Fenster: Aussenmass einelsen
po_f2f = get(fid_f2f,'OuterPosition');

% Position fuer Eingabe-Fenster ableiten und zuweisen
po_f2f(1) = p_pre(1);
po_f2f(2) = p_pre(2) - po_f2f(4);
po_f2f(3) = po_f2f(3);
po_f2f(4) = po_f2f(4);

set(fid_f2f,'OuterPosition',po_f2f)
set(fid_f2f,'Resize','off')
set(fid_f2f,'SelectionType','open')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = yB;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_f2f,'Style','pushbutton',...
                       'String','done',...
                       'pos',pB1,...
                       'Callback','CB_f2f_done');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = 0.7*Bh+Bw;
pB2(2) = yB;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_f2f,'Style','pushbutton',...
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

B3 = uicontrol(fid_f2f,'Style','pushbutton',...
                       'String','apply',...
                       'pos',pB3);

set(B3,'Callback','CB_f2f_apply');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Groesse und Position fuer Dateiliste ableiten
p_ls(1) = 0.5*Bh;
p_ls(2) = yls;
p_ls(3) = 3*Bw + 0.4*Bh;
p_ls(4) = 4.6*Bh;

% Dateiliste initialisieren
ls = uicontrol('style','listbox',...
               'pos',p_ls,...
               'Callback','DC_CB_f2f',...
               'BackgroundColor','w');


% Groesse und Position fuer Ueberschrift ableiten
p_title(1) = 0.5*Bh;
p_title(2) = ytitle;
p_title(3) = 3*Bw + 0.4*Bh;
p_title(4) = Bh;

% Hintergrundfarbe einlesen
bgc = get(fid_f2f,'Color');

% Ueberschrift fuer Liste
ls_title = uicontrol('style','text',...
                     'pos',p_title,...
                     'HorizontalAlignment','left');

% Aktuelles Verzeichnis einlesen
sys = computer;

if isunix
    path = [pwd,'/parser'];
end

if strncmp(sys, 'PC', 2)
    path = [pwd,'\parser'];
end

dir_struct = dir('./parser');

n          = length(dir_struct);
for i=1:1:n
    dummy = getfield(dir_struct,{i,1},'name');
    if length(dummy) == 6
        if dummy == 'f2f.pl'
            dir_struct(i) = [];
            break
        end
    end
end

n          = length(dir_struct);
for i=1:1:n
    dummy = getfield(dir_struct,{i,1},'name');
    if length(dummy) == 8
        if dummy == 'gid2d.pl'
            dir_struct(i) = [];
            break
        end
    end
end

n          = length(dir_struct);
for i=1:1:n
    dummy = getfield(dir_struct,{i,1},'name');
    if length(dummy) == 8
        if dummy == 'gid2f.pl'
            dir_struct(i) = [];
            break
        end
    end
end

% Sortieren nach Name
[dummy_names,dummy_index] = sortrows({dir_struct.name}');

% . und .. loeschen
n = length(dummy_names);
sorted_names = cell(n-2,1);
sorted_names(:,1) = dummy_names(3:n,1);
sorted_index(:,1) = dummy_index(1:n-2,1);

% handles dekarieren
handles.file_names   = sorted_names;
handles.is_dir       = [dir_struct.isdir];
handles.sorted_index = [sorted_index];

% handles dem Eingabefenster zuweisen
guidata(fid_f2f,handles)

set(ls,'String',handles.file_names,...
    'Value',1)
set(ls_title,'String',path,'BackGroundColor',bgc);
