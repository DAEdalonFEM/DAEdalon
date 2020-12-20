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
function CB_sig_u_done

global fid_su;
global I1_su;
global I2_su;

% Parameter einlesen

% 1.Eingabeparameter: Inputfile
f_in = get(I1_su,'String');

% 2.Eingabeparameter: Outputfile
f_out = get(I2_su,'String');

global mod_string
global X

vgl_string = [f_in,f_out];
if strcmp(vgl_string,mod_string)
    delete(fid_su)
    if X == 0
        disp('Inputfiles nicht eingegeben!')
        disp('Knotenfile nicht eingegeben!')
        disp('Script nicht ausgefuehrt!')
        disp(' ')
    end
    mod_string = '';
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(f_in)
    disp('Inputfiles nicht eingegeben!')
end

if isempty(f_out)
    disp('Knotenfile nicht eingegeben!')
end

% Check ob alle Parameter eingegeben
check = 0;
if ~isempty(f_in)
    if ~isempty(f_out)
        check = 1;
    end
end

% Script ausfuehren falls check=1
if check == 1
    cd post
    
    sys = computer;
    if isunix
        unix(['perl sig_u.pl ',f_in,' ',f_out]);
    end

    if strncmp(sys, 'PC', 2)
        arg = ['perl sig_u.pl ',f_in,' ',f_out];
        sig_u = system(arg);
    end
    
    cd ..
else
    disp('Script nicht ausgefuehrt!')
    disp(' ')
end

mod_string = '';
delete(fid_su)