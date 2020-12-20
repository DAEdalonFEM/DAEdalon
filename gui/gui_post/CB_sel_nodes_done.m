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
function CB_sel_nodes_done

global fid_sn;
global I1_sn;
global I2_sn;
global I3_sn;
global I4_sn;
global I5_sn;

global X

% Parameter einlesen

% 1.Eingabeparameter: Inputfile
i      = get(I1_sn,'Value');
if i == X
    delete(fid_sn)
    return
end

f_list = get(I1_sn,'String');
f_in   = f_list(i);
f_in   = f_in{1,1};

if isempty(f_in)
    disp('Inputfile nicht vorhanden!')
    return
end

% 2.Eingabeparameter: Outputfile
f_out = get(I2_sn,'String');

% 3.Eingabeparameter: x-Koordinate
x = get(I3_sn,'String');

% 4.Eingabeparameter: y-Koordinate
y = get(I4_sn,'String');

% 5.Eingabeparameter: Toleranz
tol = get(I5_sn,'String');

global mod_string
vgl_string = [f_out,x,y,tol];
if strcmp(vgl_string,mod_string)
    delete(fid_sn)
    return
end


if isempty(f_out)
    disp('Outputfile nicht eingeben!')
end
if isempty(x)
    disp('x-coor nicht eingegeben!')
end
if isempty(y)
    disp('y-coor nicht eingegeben!')
end





% Check ob alle Parameter eingegeben
check = 0;
if ~isempty(f_in)
    if ~isempty(f_out)
        if ~ isempty(x)
            if ~isempty(y)
                if ~isempty(tol)
                    tol = str2double(tol);
                    check = 1;
                end
            end
        end
    end
end

% Script ausfuehren falls check=1
if check == 1
    cd post

    sys = computer;
    if isunix
        unix(['perl sel_nodes.pl ',f_in,' ',f_out,' ',x,' ',y,' ',tol]);
    end

    if strncmp(sys, 'PC', 2)
        arg = ['perl sel_nodes.pl ',f_in,' ',f_out,' ',x,' ',y,' ',tol];
        sel_nodes = system(arg);
    end

    cd ..
else
    disp('Script nicht ausgefuehrt!')
    disp(' ')
end

X = 0;
delete(fid_sn)