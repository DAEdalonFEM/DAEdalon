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
function CB_merge_apply

global fid_merge;
global I1_merge;
global I2_merge;
global I3_merge;
global I4_merge;

% Parameter einlesen

% 1.Eingabeparameter: Inputfiles
f_in = get(I1_merge,'String');
if isempty(f_in)
    disp('Inputfiles nicht eingegeben!')
end

% 2.Eingabeparameter: Knotenfile
f_k = get(I2_merge,'String');
if isempty(f_k)
    disp('Zeilennummer nicht eingegeben!')
end

% 3.Eingabeparameter: Spaltenfile
f_s = get(I3_merge,'String');
if isempty(f_s)
    disp('Spaltenfile nicht eingegeben!')
end

% 4.Eingabeparameter: Nach Spalte sortieren
s = get(I4_merge,'String');
if isempty(s)
    s = '1';
    disp('Spaltennummer zum Sortieren nicht eingegeben! Defaultwert = 1 gesetzt!')
else
    s = str2num(s);
    if isempty(s)
        s = '1';
        disp('Spaltennummer zum Sortieren ist keine Zahl! Defaultwert = 1 gesetzt!')
    else
        s = num2str(s);
    end
end

% Check ob alle Parameter eingegeben
check = 0;
if ~isempty(f_in)
    if ~isempty(f_k)
        if ~isempty(f_s)
            check = 1;
        end
    end
end

% Script ausfuehren falls check=1

if check == 1
    cd post

    sys = computer;
    if isunix
        unix(['perl merge.pl ',f_in,' ',f_k,' ',f_s,' ',s]);
    end

    if strncmp(sys, 'PC', 2)
        arg = ['perl merge.pl ',f_in,' ',f_k,' ',f_s,' ',s];
        merge = system(arg);
    end

    cd ..
else
    disp('Script nicht ausgefuehrt!')
    disp(' ')
end

global mod_string
mod_string = [f_in,f_k,f_s,s];

global X
X = 1;