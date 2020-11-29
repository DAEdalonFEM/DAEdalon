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
function CRF_PostProcess

global fid_post

global fid_sn
global fid_sn_info
global fid_su
global fid_gv
global fid_gv2
global fid_merge

if not(isempty(findobj('Name','sel_nodes.pl')))
    delete(fid_sn)
end

if not(isempty(findobj('Name','Info: sel_nodes.pl')))
    delete(fid_sn_info)
end

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

delete(fid_post)