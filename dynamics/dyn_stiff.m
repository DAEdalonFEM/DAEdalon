%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2003 Steffen Eckert                                 %
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

% dyn_stiff.m
% Assemblierung von k, M_mass, C_damp zum dynamischen Rechnen

v_akt =  zeros(gesdof,1);
a_akt =  zeros(gesdof,1);

% Aufbau von M_mass und C_damp
% als Sparsematrix oder normal abspeichern
if (sparse_flag==0)
  k = zeros(gesdof);
  M_mass = zeros(gesdof);
  C_damp = zeros(gesdof);
else
  delta_el = 1;
  k_temp_size = 200; % Elemente

  k = spalloc(gesdof,gesdof,round(gesdof*gesdof/100));
  M_mass = spalloc(gesdof,gesdof,round(gesdof*gesdof/100));
  C_damp = spalloc(gesdof,gesdof,round(gesdof*gesdof/100));

  k_temp = spalloc(gesdof,gesdof,round(gesdof*gesdof/100));
  M_temp = spalloc(gesdof,gesdof,round(gesdof*gesdof/100));
  C_temp = spalloc(gesdof,gesdof,round(gesdof*gesdof/100));
end

r=zeros(gesdof,1);      %Spaltenvektor

cont_mat_node=zeros(numnp,contvar);
cont_norm=zeros(numnp,1);

% Schleife über alle Elemente

% Faktor bestimmen mit dem die Randverschiebungen skaliert werden
if (load_flag==1)
  loadfactor = loadfunc(tim);
else
  loadfactor = 1;
end


% vorgegebene Verschiebungsrandbed. in u einbauen
for i=1:displ_len                     % Schleife ueber alle Randverschiebungen
  pos=ndf*(displ_node(i)-1)+displ_df(i);% globale Position im GlSyst
  u(pos)=loadfactor*displ_u(i);           % vorgeg. Verschiebung eintragen
end  % i


% Berechung der rechten Seite:
unode=reshape(u,ndf,numnp)';


%if (sparse_flag~=0)
  % nur bei großen Problemen ausgeben
  disp(sprintf('Assemblierung der Steifigkeitsmatrix:      '))
%end

elem_count = 0;

% Schleife über alle Elemente für globale Iteration
% dabei wird erst über alle Elemente des gleichen
% Materialdatensatzes assembliert, dann naechster Datensatz,
% sinnvoll für Plots, Eckert 04/2003
% mat_set wird in dae und cont_sm gesetzt
for aktmat = mat_set
  listlength = mat2el(1,aktmat);
  elements = mat2el( 2:listlength+1,aktmat);
  for aktele = elements' % transponiert, damit die Elemente einzeln
                         % bei jedem Schleifendurchgang an aktele
                         % übergeben werden und nicht auf einmal
                         % als Vektor

  elem_count = elem_count + 1;

  % Knoten und Verschiebungen für aktuelles Element in x speichern
  %x(1:nel,1:ndf)=node(el(aktele,1:nel),1:ndf);
  x(:,:)=node(el(aktele,:),:);
  u_elem(:,:)=unode(el(aktele,:),:);

  % Element-History-Variablen aufbauen:
  hist_old_elem = reshape(hist_old(:,aktele),gphist_max,numgp_max);
  hist_user_elem = reshape(hist_user(:,aktele),gphist_max,numgp_max);

  %%%%%%%%%%%%%%%%%%%%%
  % Begin Elementaufruf
  %%%%%%%%%%%%%%%%%%%%%

  % zum aktuellen Element gehörende Größen (Elementnummer, Materialnummer,
  % Materialparameter) aus Material-Matrizen rausholen
  mat_par=mat_par_matr(:,el2mat(aktele));

  % Element anspringen
  % Hier wird jetzt elem_name zum Aufruf des Elements verwendet und
  % mat_name übergeben
    [k_elem, M_elem, C_elem, r_elem, ...
	  cont_zaehler, cont_nenner, hist_new_elem, hist_user_elem] = ...
      feval(deblank(elem_name(aktele,:)),isw, nel, ndf, contvar,...
	    deblank(mat_name(aktele,:)), mat_par, x, u_elem,...
	    hist_old_elem, hist_user_elem);


  %%%%%%%%%%%%%%%%%%%%
  % Ende Elementaufruf
  %%%%%%%%%%%%%%%%%%%%

  % lokale und globale Knotennummern für aktuelles Element
  node_loc = 1:nel;
  node_ges = (el(aktele,node_loc)-1)*ndf+1;

  % Positionen an denen in die Gesamt-STMA einsortiert wird
  for i=1:ndf
    pos_vec(i:ndf:nel*ndf) =  node_ges+i-1;
  end

  % Einsortieren in k und r

  % Sparse-Speichertechnik zeigt, dass das Einsortieren in k immer
  % langsamer dauert, je mehr Einträge schon drin sind
  % ->
  % es wird eine Sparse-Matrix zum Zwischenspeichern (k_temp)
  % eingeführt, die nach k_temp_size (z.B. 200 Elementen) in k
  % abgelegt wird und anschließend wieder neu initialisiert wird

  if  (sparse_flag~=0)
    k_temp(pos_vec,pos_vec) = k_temp(pos_vec,pos_vec) + k_elem;
    M_temp(pos_vec,pos_vec) = M_temp(pos_vec,pos_vec) + M_elem;
    C_temp(pos_vec,pos_vec) = C_temp(pos_vec,pos_vec) + C_elem;
    if (delta_el==k_temp_size)
      k = k + k_temp;
      M_mass = M_mass + M_temp;
      C_damp = C_damp + C_temp;

      k_temp = spalloc(gesdof,gesdof,round(gesdof*gesdof/100));
      M_temp = spalloc(gesdof,gesdof,round(gesdof*gesdof/100));
      C_temp = spalloc(gesdof,gesdof,round(gesdof*gesdof/100));
      delta_el = 0;
    end
    delta_el = delta_el + 1;

  else
    k(pos_vec,pos_vec) = k(pos_vec,pos_vec) + k_elem;
    M_mass(pos_vec,pos_vec) = M_mass(pos_vec,pos_vec) + M_elem;
    C_damp(pos_vec,pos_vec) = C_damp(pos_vec,pos_vec) + C_elem;
  end

  r(pos_vec) =  r(pos_vec) + r_elem;

  % Einsortieren von zaehler und nenner in cont_mat_node und cont_norm
  % Ausnahme für Stabelement ( elem10)
  if (strcmp(elem_name(aktele,:),'elem10'))
     cont_mat_node(aktele,:) = cont_zaehler;
     cont_norm(aktele) = cont_nenner;
  else
     for i=1:nel
       cont_mat_node(el(aktele,i),:) = ...
	   cont_mat_node(el(aktele,i),:)+cont_zaehler(i,:);
       cont_norm(el(aktele,i))=cont_norm(el(aktele,i))+cont_nenner(i);
     end %i
  end %if


% Fortschrittsanzeige auf Display
  percent=floor(100*elem_count/numel);
  disp(sprintf('\b\b\b\b\b%2.0f %%',percent))

end %aktele

end %nummat

% Normierung der Contour-Größen
for i = 1:contvar
  cont_mat_node(:,i)=cont_mat_node(:,i)./cont_norm(:);
end


if  (sparse_flag~=0);
  k = k + k_temp;
  M_mass = M_mass + M_temp;
  C_damp = C_damp + C_temp;
end

% Die an das Element zurückgegebene SteMa ist wird auf jeden Fall
% als Sparse-Matrix gespeichert, da dann Matlab auch Sparse-Solver
% verwendet, die sehr viel schneller sind, StE 02.03
k = sparse(k);
M_mass = sparse(M_mass);
C_damp = sparse(C_damp);


% Aufbau der modifizierten rechten Seite und Tangente mit
% zusätzlichen Anteilen aus Massenmatrix und Dämpungsmatrix

a_akt = alpha_1*(u-u_n) - alpha_2*v_n - alpha_3*a_n;
v_akt = alpha_4*(u-u_n) + alpha_5*v_n + alpha_6*a_n;

r = M_mass*a_akt + C_damp*v_akt + r;

k = alpha_1*M_mass + alpha_4*C_damp + k;

