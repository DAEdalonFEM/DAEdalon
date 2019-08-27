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
function B_post_CB

% globale GUI-Variablen
global fid_dae;     % Figure ID DAE-Hauptfenster
global fid_dc;      % Figure ID DAEControl-Fenster
global fid_pre;     % Figure ID PreProcess-Menu
global fid_prog;    % Figure ID ProgFlow-Menu
global fid_plot;    % Figure ID PlotControl-Menu
global fid_post;    % Figure ID PostProcess-Menu
global fid_opt;     % Figure ID DAEOptions-Menu
global fid_f2f;     % Figure ID FEAP-Input
global fid_cont;    % Figure ID ContPlot-Menu
global fid_time;    % Figure ID time-Input
global fid_sn;      % Figure ID sel_nodes.pl-Menu
global Fw;          % Breite Andock-Fenster
global Bh;          % Hoehe Mini-Buttons
global Bw;          % Breite Mini-Buttons

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check ob bereits ein Menu-Fenster offen, ggf. schliessen
if ishghandle('Name','PostProcess')
    figure(fid_post)
    if ishghandle('Name','sel_nodes.pl')
        figure(fid_sn)
    end
    
    
    return
end

if ishghandle('Name','PreProcess')
    close(fid_pre)
end

if ishghandle('Name','ProgFlow')
    close(fid_prog)
end

if ishghandle('Name','PlotControl')
    close(fid_plot)
end

if ishghandle('Name','DAEOptions')
    close(fid_opt)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Position des DAEControl-Fensters einlesen
po_dc = get(fid_dc,'OuterPosition');
pi_dc = get(fid_dc,'pos');

% PostProcess-Fenster initialisieren
fid_post = figure('NumberTitle','off',...
                  'Name','PostProcess',...
                  'MenuBar','none',...
                  'CloseRequestFcn','CRF_PostProcess');
             
set(fid_post,'Resize','off');
             
% PostProcess-Fenster: Innenmass einlesen
pi_post   = get(fid_post,'pos');
     
% Größe des PostProcess-Fensters deklarieren und zuweisen
pi_post(1) = pi_post(1);
pi_post(2) = pi_post(2);
pi_post(3) = pi_dc(3);
pi_post(4) = 0.5*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.2*Bh + Bh + 0.5*Bh;

set(fid_post,'Position',pi_post);

% PostProcess-Fenster: Aussenmass einlesen
po_post   = get(fid_post,'OuterPosition');

% Position des PostProcess-Fensters deklarieren und zuweisen
po_post(1) = po_dc(1);
po_post(2) = po_dc(2)-po_post(4);
po_post(3) = Fw;
po_post(4) = po_post(4);

set(fid_post,'OuterPosition',po_post);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buttons anlegen

% Button 1
% Groesse deklarieren und zuweisen
pB1(1) = 0.5*Bh;
pB1(2) = pi_post(4) - 0.5*Bh - Bh;
pB1(3) = Bw + 0.2*Bh + Bw;
pB1(4) = Bh;

B1 = uicontrol(fid_post,'Style','pushbutton',...
                        'String','sel_nodes.pl',...
                        'pos',pB1,...
                        'Callback','CB_sel_nodes');

% Button 1 Info
% Groesse deklarieren und zuweisen
pB1_help(1) = pB1(1) + pB1(3) + 0.2*Bh;
pB1_help(2) = pB1(2);
pB1_help(3) = 0.5*Bw;
pB1_help(4) = Bh;

% B1_help = uicontrol(fid_post,'Style','pushbutton',...
%                              'String','?',...
%                              'pos',pB1_help,...
%                              'Callback','CB_sel_nodes_info');
                         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Button 2
% Groesse deklarieren und zuweisen
pB2(1) = pB1(1);
pB2(2) = pB1(2) - 0.2*Bh - Bh;
pB2(3) = pB1(3);
pB2(4) = Bh;

B2 = uicontrol(fid_post,'Style','pushbutton',...
                        'String','sig_u.pl',...
                        'pos',pB2,...
                        'Callback','CB_sig_u');
                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
% Button 3
% Groesse deklarieren und zuweisen
pB3(1) = pB1(1);
pB3(2) = pB2(2) - 0.2*Bh - Bh;
pB3(3) = pB1(3);
pB3(4) = Bh;

B3 = uicontrol(fid_post,'Style','pushbutton',...
                        'String','get_value.pl',...
                        'pos',pB3,...
                        'Callback','CB_get_value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
% Button 4
% Groesse deklarieren und zuweisen
pB4(1) = pB1(1);
pB4(2) = pB3(2) - 0.2*Bh - Bh;
pB4(3) = pB1(3);
pB4(4) = Bh;

B4 = uicontrol(fid_post,'Style','pushbutton',...
                        'String','get_val2.pl',...
                        'pos',pB4,...
                        'Callback','CB_get_val2');
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
% Button 5
% Groesse deklarieren und zuweisen
pB5(1) = pB1(1);
pB5(2) = pB4(2) - 0.2*Bh - Bh;
pB5(3) = pB1(3);
pB5(4) = Bh;

B5 = uicontrol(fid_post,'Style','pushbutton',...
                        'String','merge.pl',...
                        'pos',pB5,...
                        'Callback','CB_merge');