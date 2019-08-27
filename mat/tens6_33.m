%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2015 Herbert Baaser                                 %
%    Contact: http://www.daedalon.org                              %
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

% Umkopieren: [6x1]/VOIGT-Notation nach Matrix/Tensor [3x3] 

function [tens33] = tens6_33(tens6)

% voigt = [1 4 6; 4 2 5; 6 5 3];
 
tens33(1,1) = tens6(1);
tens33(2,2) = tens6(2);
tens33(3,3) = tens6(3);
tens33(1,2) = tens6(4);
tens33(2,3) = tens6(5);         % !! anders als ABAQ. !!
tens33(1,3) = tens6(6);
tens33(2,1) = tens6(4);
tens33(3,2) = tens6(5);
tens33(3,1) = tens6(6);

end
% *** END ***
