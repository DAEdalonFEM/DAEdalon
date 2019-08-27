%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2005 / 2012 / 2015 Herbert Baaser                   %
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

%function [sig_cauchy,D_mat] = mat_3d_neo_hooke(mat_par,b)

function [sigKH,vareps,D_mat,hist_new_gp,hist_user_gp] ...
         = mat8(mat_par,F,hist_old_gp,hist_user_gp)  
%
% hyperelst. Materialverhalten 3D - "neo HOOKE"
%
% HBaa, 15./16.03.2012 ** neu **
%       24.11.2015 @ FH Bingen
%
% rein:
% mat_par = Materialparameter (c10 = G/2, K) 
% F --> b=F*F' -  linker CAUCHY-GREEN-Verzerr.tensor
%
% raus:
% sigKH = KIRCHHOFF-Spannung
% D_mat = linearisierte Materialtangente am GP
%

% Damit hist_new_gp belegt ist, auch wenn sich an den
% hist.-Variablen nichts ändert:
hist_new_gp = hist_old_gp;

%nhv=mat_par(1); % Anzahl der History-Variablen pro GP

 c10 = mat_par(2);  % = G / 2
   K = mat_par(3);  % = 2 / D1

   b = F*F';
detF = sqrt(det(b));
bbar = b * detF^(-2.0/3.0);
trbbar3 = trace(bbar)/3.0;

% KIRCHHOFF-Spannungen (isochorer Anteil)
   sigKH = zeros(6,1);
           EG = 2.0*c10;
sigKH(1) = EG * (bbar(1,1)-trbbar3);
sigKH(2) = EG * (bbar(2,2)-trbbar3);
sigKH(3) = EG * (bbar(3,3)-trbbar3);
sigKH(4) = EG *  bbar(1,2);
sigKH(5) = EG *  bbar(2,3);            % !! anders als ABAQ. !!
sigKH(6) = EG *  bbar(1,3);            %

% Tangentenmodul
% neu - 24.11.2015 - siehe "Das gilt immer"
   i4 = [1;1;1;0;0;0];
eins4 = eye(6);
D_mat = 2*EG*trbbar3*(3*eins4-i4*i4') - 2/3*(i4*sigKH'+sigKH*i4') ...
      + K*detF*( (2*detF-1)*(i4*i4') - 2*(detF-1)*eins4 );

  
% neu - 30.11.'15 - siehe "solidmechanics.org" #8
% noch "unschön" codiert !
 voigt = [1 4 6; 4 2 5; 6 5 3];
delKRO = eye(3);
 D_mat = zeros(6,6);

for i=1:3
    for j=1:3
        for k=1:3
            for l=1:3
                D_mat(voigt(i,j),voigt(k,l)) = EG*( delKRO(i,k)*bbar(j,l)+bbar(i,l)*delKRO(j,k)...
                                                    -2/3*(bbar(i,j)*delKRO(k,l)+bbar(k,l)*delKRO(i,j)) ...
                                                    +2/3*trbbar3*delKRO(i,j)*delKRO(k,l) ) ...
                                             + K*detF*(2*detF-1)*delKRO(i,j)*delKRO(k,l);
            end
        end
    end
end

% + volumetr. Anteil
                      EK = K*(detF-1)*detF;
sigKH(1) = sigKH(1) + EK;
sigKH(2) = sigKH(2) + EK;
sigKH(3) = sigKH(3) + EK;

% Dehnungsausgabe
vareps33 = ( eye(3) - inv(b) )/2;      % "ALMANSI"-Tensor
  vareps = tens33_6(vareps33);

end
%
% *** ENDE ***