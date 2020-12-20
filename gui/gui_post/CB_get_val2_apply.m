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
function CB_get_val2_apply

global fid_gv2;
global I1_gv2;
global I2_gv2;
global I3_gv2;

% Parameter einlesen

% 1.Eingabeparameter: Inputfiles
f_in = get(I1_gv2,'String');
if isempty(f_in)
    disp('Inputfiles nicht eingegeben!')
end

% 2.Eingabeparameter: Zeilennummer
z_num = get(I2_gv2,'String');
if isempty(z_num)
    disp('Zeilennummer nicht eingegeben!')
else
    z_num = str2num(z_num);
    if isempty(z_num)
        disp('Zeilennummer ist keine Zahl!')
    end
end

% 3.Eingabeparameter: Spaltenfile
f_s = get(I3_gv2,'String');
if isempty(f_s)
    disp('Spaltenfile nicht eingegeben!')
end

% Check ob alle Parameter eingegeben
check = 0;
if ~isempty(f_in)
    if ~isempty(z_num)
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
        unix(['perl get_val2.pl ',f_in,' ',z_num,' ',f_s]);
    end

    if strncmp(sys, 'PC', 2)
        arg = ['perl get_val2.pl ',f_in,' ',z_num,' ',f_s];
        get_val2 = system(arg);
    end

    cd ..
else
    disp('Script nicht ausgefuehrt!')
    disp(' ')
end

global mod_string
mod_string = [f_in,num2str(z_num),f_s];

global X
X = 1;