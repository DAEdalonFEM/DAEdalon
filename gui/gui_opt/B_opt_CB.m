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
function B_opt_CB

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global fid_pre;     % Figure ID PreProcess-Menu
global fid_f2f;     % Figure ID FEAP-Input
global fid_prog;    % Figure ID ProgFlow-Menu
global fid_time;    % Figure ID time-Input
global fid_plot;    % Figure ID PlotControl-Menu
global fid_post;    % Figure ID PostProcess-Menu
global fid_opt;     % Figure ID DAEOptions
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

global contvar;
global movie_flag;
global load_flag;
global sparse_flag;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check ob bereits ein Menu-Fenster offen, ggf. aktivieren
if ishghandle('Name','DAEOptions')
    figure(fid_opt)
    return
end

if ishghandle('Name','PlotControl')
    close(fid_plot)
end

if ishghandle('Name','PreProcess')
    close(fid_pre)
end

if ishghandle('Name','ProgFlow')
    close(fid_prog)
end

if ishghandle('Name','PostProcess')
    close(fid_post)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAEControl-Fenster: Aussenmass einlesen
po_dc = get(fid_dc,'OuterPosition');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DAEControl-Fenster: Innenmass einlesen
pi_dc = get(fid_dc,'pos');

% DAEOptions-Fenster initialisieren
fid_opt = figure('NumberTitle','off',...
                 'Name','DAEOptions',...
                 'MenuBar','none');
             
set(fid_opt,'Resize','off')             

% DAEOptions-Fenster: Innenmass einlesen
pi_opt   = get(fid_opt,'Position');

% Größe des PlotControl-Fensters deklarieren und zuweisen
pi_opt(1) = pi_opt(1);
pi_opt(2) = pi_opt(2);
pi_opt(3) = 3*Bw+1.4*Bh;
pi_opt(4) = 18.8*Bh;

set(fid_opt,'Position',pi_opt);

% DAEOptions-Fenster: Aussenmass einlesen
po_opt   = get(fid_opt,'OuterPosition');

% Position des PlotControl-Fensters deklarieren und zuweisen
po_opt(1) = po_dc(1);
po_opt(2) = po_dc(2)-po_opt(4);
po_opt(3) = po_opt(3);
po_opt(4) = po_opt(4);

set(fid_opt,'OuterPosition',po_opt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Koordinaten und Masse
x1 = 0.5*Bh;
x2 = x1 + Bw + 0.2*Bh + Bw/2-0.1*Bh;

y1 = 0.5*Bh;

ya = y1 + Bh + 0.2*Bh + Bh + 0.2*Bh;
yb = ya + Bh + 0.2*Bh;

yc = yb + Bh + 0.2*Bh + Bh + 0.2*Bh;
y2 = yc + Bh + 0.2*Bh;
y3 = y2 + Bh + 0.2*Bh;

y4 = y3 + Bh + 0.2*Bh + Bh + 0.2*Bh;
y5 = y4 + Bh + 0.2*Bh;

y6 = y5 + Bh + 0.2*Bh + Bh + 0.2*Bh;
y7 = y6 + Bh + 0.2*Bh;
y8 = y7 + Bh + 0.2*Bh;

ww = Bw + 0.2*Bh + Bw/2 - 0.1*Bh;
w = ww/2 - 0.1*Bh;

% Background
cT = get(fid_opt,'Color');

% checkbox color
sys = computer;
if isunix
    cc = 'w';
end

if strncmp(sys, 'PC', 2)
    cc = cT;
end

% 8. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Textfeld 7: sparse_flag
pT_sf(1) = x1;
pT_sf(2) = y8;
pT_sf(3) = ww;

T_sf = uicontrol(fid_opt,'Style','text',...
                         'String','sparse_flag',...
                         'HorizontalAlignment','left',...
                         'BackgroundColor',cT);
                       
Th_sf = get(T_sf,'Extent');
pT_sf(4) = Th_sf(4);
set(T_sf,'pos',pT_sf)

% checkbox fuer sparse_flag

% Checkbox 3
pC_sf(1) = x2;
pC_sf(2) = y8;
pC_sf(3) = w;
pC_sf(4) = Bh;

% Auslesen!!!
global C_sf;

if (sparse_flag == 0)
    val_sf  = 0;
    stat_sf = 'off';
else
    val_sf  = 1;
    stat_sf = 'on';
end

C_sf = uicontrol(fid_opt,'Style','checkbox',...
                         'String',stat_sf,...
                         'Value',val_sf,...
                         'BackGroundColor',cc);
                      
set(C_sf,'pos',pC_sf)
set(C_sf,'Callback','CB_check_sf')

% 7. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Textfeld 6: load_flag
pT_lf(1) = x1;
pT_lf(2) = y7;
pT_lf(3) = ww;

T_lf = uicontrol(fid_opt,'Style','text',...
                         'String','load_flag',...
                         'HorizontalAlignment','left',...
                         'BackgroundColor',cT);
                       
Th_lf = get(T_lf,'Extent');
pT_lf(4) = Th_lf(4);
set(T_lf,'pos',pT_lf)

% checkbox fuer load_flag

% Checkbox 2
pC_lf(1) = x2;
pC_lf(2) = y7;
pC_lf(3) = w;
pC_lf(4) = Bh;

% Auslesen!!!
val = 0;

global C_lf;

if (load_flag == 0)
    val_lf  = 0;
    stat_lf = 'off';
else
    val_lf  = 1;
    stat_lf = 'on';
end

C_lf = uicontrol(fid_opt,'Style','checkbox',...
                         'String',stat_lf,...
                         'Value',val_lf,...
                         'BackGroundColor',cc);
                      
set(C_lf,'pos',pC_lf)
set(C_lf,'Callback','CB_check_lf')

% 6. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Textfeld 5: movie_flag
pT_mf(1) = x1;
pT_mf(2) = y6;
pT_mf(3) = ww;

T_mf = uicontrol(fid_opt,'Style','text',...
                         'String','movie_flag',...
                         'HorizontalAlignment','left',...
                         'BackgroundColor',cT);
                       
Th_mf = get(T_mf,'Extent');
pT_mf(4) = Th_mf(4);
set(T_mf,'pos',pT_mf)

% Checkbox fuer movie_flag

% Checkbox 1
pC_mf(1) = x2;
pC_mf(2) = y6;
pC_mf(3) = w;
pC_mf(4) = Bh;

% Auslesen!!!
global C_mf;

if (movie_flag == 0)
    val_mf  = 0;
    stat_mf = 'off';
else
    val_mf  = 1;
    stat_mf = 'on';
end

C_mf = uicontrol(fid_opt,'Style','checkbox',...
                         'String',stat_mf,...
                         'Value',val_mf,...
                         'BackGroundColor',cc);
                      
set(C_mf,'pos',pC_mf)
set(C_mf,'Callback','CB_check_mf')

% 5. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Textfeld 4: dt
pT_dt(1) = x1;
pT_dt(2) = y5;
pT_dt(3) = ww;

T_dt = uicontrol(fid_opt,'Style','text',...
                         'String','dt',...
                         'HorizontalAlignment','left',...
                         'BackgroundColor',cT);
                       
Th_dt = get(T_dt,'Extent');
pT_dt(4) = Th_dt(4);
set(T_dt,'pos',pT_dt)

% Eingabefeld fuer dt

% Eingabefeld 4
pE_dt(1) = x2;
pE_dt(2) = y5;
pE_dt(3) = w;
pE_dt(4) = Bh;

% Auslesen!!!
global dt;

global E_dt;
E_dt = uicontrol(fid_opt,'Style','edit',...
                         'String',dt,...
                         'BackgroundColor','w');
                       
set(E_dt,'pos',pE_dt)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Stufe


% Textfeld 3: defo_scal
pT_scal(1) = x1;
pT_scal(2) = y4;
pT_scal(3) = Bw + 0.2*Bh + Bw/2 - 0.1*Bh;

T_scal = uicontrol(fid_opt,'Style','text',...
                           'String','defo_scal',...
                           'HorizontalAlignment','left',...
                           'BackgroundColor',cT);
                       
Th_scal = get(T_scal,'Extent');
pT_scal(4) = Th_scal(4);
set(T_scal,'pos',pT_scal)

% Eingabefeld fuer defo_scal


% Eingabefeld 3
pE_scal(1) = x2;
pE_scal(2) = y4;
pE_scal(3) = w;
pE_scal(4) = Bh;

% Auslesen!!!
global defo_scal;

global E_scal;
E_scal = uicontrol(fid_opt,'Style','edit',...
                           'String',defo_scal,...
                           'BackgroundColor','w');
                       
set(E_scal,'pos',pE_scal)

% 3. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Textfeld 2: out_file_name
pT_out(1) = x1;
pT_out(2) = y3;
pT_out(3) = ww;

T_out = uicontrol(fid_opt,'Style','text',...
                          'String','out_file_name',...
                          'HorizontalAlignment','left',...
                          'BackgroundColor',cT);
                       
Th_out = get(T_out,'Extent');
pT_out(4) = Th_out(4);
set(T_out,'pos',pT_out)

% Eingabefeld fuer out_file_name

% Eingabefeld 2
pE_out(1) = x2;
pE_out(2) = y3;
pE_out(3) = ww;
pE_out(4) = Bh;

% Auslesen!!!
global out_file_name;

global E_out;
E_out = uicontrol(fid_opt,'Style','edit',...
                          'String',out_file_name,...
                          'HorizontalAlignment','left',...
                          'BackgroundColor','w');
                       
set(E_out,'pos',pE_out)

% 2. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    

% Textfeld 1: histout_file_name
pT_hist(1) = x1;
pT_hist(2) = y2;
pT_hist(3) = ww;

T_hist = uicontrol(fid_opt,'Style','text',...
                           'String','histout_file_name',...
                           'HorizontalAlignment','left',...
                           'BackgroundColor',cT);

Th_hist = get(T_hist,'Extent');
pT_hist(4) = Th_hist(4);                       
set(T_hist,'pos',pT_hist)

% Eingabefeld fuer histout_file_name


% Eingabefeld 1
pE_hist(1) = x2;
pE_hist(2) = y2;
pE_hist(3) = ww;
pE_hist(4) = Bh;

% Auslesen!!!
global histout_file_name;

global E_hist;
E_hist = uicontrol(fid_opt,'Style','edit',...
                           'String',histout_file_name,...
                           'HorizontalAlignment','left',...
                           'BackgroundColor','w');
                 
set(E_hist,'pos',pE_hist)

% c. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Textfeld c: out_incr
pT_oincr(1) = x1;
pT_oincr(2) = yc;
pT_oincr(3) = ww;

T_oincr = uicontrol(fid_opt,'Style','text',...
                            'String','out_incr',...
                            'HorizontalAlignment','left',...
                            'BackgroundColor',cT);

Th_oincr = get(T_oincr,'Extent');
pT_oincr(4) = Th_oincr(4);                       
set(T_oincr,'pos',pT_oincr)

% Eingabefeld fuer rst_incr

% Eingabefeld 1
pE_oincr(1) = x2;
pE_oincr(2) = yc;
pE_oincr(3) = w;
pE_oincr(4) = Bh;

% Auslesen!!!
global out_incr;

global E_oincr;
E_oincr = uicontrol(fid_opt,'Style','edit',...
                            'String',out_incr,...
                            'BackgroundColor','w');
                 
set(E_oincr,'pos',pE_oincr)

% b. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Textfeld b: rst_file_name
pT_rst(1) = x1;
pT_rst(2) = yb;
pT_rst(3) = ww;

T_rst = uicontrol(fid_opt,'Style','text',...
                          'String','rst_file_name',...
                          'HorizontalAlignment','left',...
                          'BackgroundColor',cT);

Th_rst = get(T_rst,'Extent');
pT_rst(4) = Th_rst(4);                       
set(T_rst,'pos',pT_rst)

% Eingabefeld fuer rst_file_name

% Eingabefeld 1
pE_rst(1) = x2;
pE_rst(2) = yb;
pE_rst(3) = ww;
pE_rst(4) = Bh;

% Auslesen!!!
global rst_file_name;

global E_rst;
E_rst = uicontrol(fid_opt,'Style','edit',...
                          'String',rst_file_name,...
                          'HorizontalAlignment','left',...
                          'BackgroundColor','w');
                 
set(E_rst,'pos',pE_rst)

% a. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Textfeld a: rst_incr
pT_rincr(1) = x1;
pT_rincr(2) = ya;
pT_rincr(3) = ww;

T_rincr = uicontrol(fid_opt,'Style','text',...
                            'String','rst_incr',...
                            'HorizontalAlignment','left',...
                            'BackgroundColor',cT);

Th_rincr = get(T_rincr,'Extent');
pT_rincr(4) = Th_rincr(4);                       
set(T_rincr,'pos',pT_rincr)

% Eingabefeld fuer rst_incr

% Eingabefeld 1
pE_rincr(1) = x2;
pE_rincr(2) = ya;
pE_rincr(3) = w;
pE_rincr(4) = Bh;

global rst_incr;

global E_rincr;
E_rincr = uicontrol(fid_opt,'Style','edit',...
                            'String',rst_incr,...
                            'BackgroundColor','w');
                 
set(E_rincr,'pos',pE_rincr)

% 1. Stufe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Button 1: done
% Groesse deklarieren und zuweisen
pB1(1) = x1;
pB1(2) = y1;
pB1(3) = Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_opt,'Style','pushbutton',...
                       'String','done',...
                       'pos',pB1,...
                       'Callback','CB_opt_done');

% Button 2: cancel
% Groesse deklarieren und zuweisen
pB2(1) = pB1(1) + Bw + 0.2*Bh;
pB2(2) = y1;
pB2(3) = Bw;
pB2(4) = Bh;

B2 = uicontrol(fid_opt,'Style','pushbutton',...
                       'String','cancel',...
                       'pos',pB2,...
                       'Callback','CB_cancel');
                   
% Button 3: apply
% Groesse deklarieren und zuweisen
pB3(1) = pB2(1) + Bw + 0.2*Bh;
pB3(2) = y1;
pB3(3) = Bw;
pB3(4) = Bh;

B3 = uicontrol(fid_opt,'Style','pushbutton',...
                       'String','apply',...
                       'pos',pB3,...
                       'Callback','CB_opt_apply');