%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2002/2003 Steffen Eckert, Oliver Goy,               %
%                        Andreas Trondl                            %
%              2022      T. Brambier                               %
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

% stiffness_func.m

% Achtung, 'u' wird transponiert zurueckgegeben
function [k,r,u,hist_new,hist_user,cont_mat_node] = ...
    stiffness_func(nel,ndf,u,displ_u,displ_df,displ_node,...
    displ_len,elem_name,mat_name,el,el2mat,mat2el,mat_set,...
    mat_par_matr,node,contvar,gesdof,numgp_max,...
    numel,numnp,sparse_flag,load_flag,tim,...
    hist_old,hist_user,gphist_max);

global loadfactor

% Aufbau der Systemsteifigkeitsmatrix k durch Assemblierung
% ueber alle Knoten und Berechnung des Residuums (Fehlkraftvektor)

%Steifigkeitsmatrix und Fehlkraftvektor nullen

r=zeros(gesdof, 1);      %Spaltenvektor
isw=1;

%Initialisierung Contourmatrix
% geaendert, StE 20.03.03
%numnpel = max(numnp, numel);
%cont_mat_node = zeros(numnpel, contvar);
%cont_norm = zeros(numnpel, 1);

% vorgegebene Verschiebungsrandbed. in u einbauen
%for i=1:displ_len                     % Schleife ueber alle Randverschiebungen
%  pos = ndf*(displ_node(i)-1)+displ_df(i);% globale Position im GlSyst
%  u(pos) = loadfactor*displ_u(i);           % vorgeg. Verschiebung eintragen
%end  % i
pos = ndf * ( displ_node - 1 ) + displ_df;
u(pos) = loadfactor*displ_u;


% unode in gleicher Form wie x
unode=reshape(u,ndf,numnp)';

% Schleife ueber alle Elemente fuer globale Iteration
% dabei wird erst ueber alle Elemente des gleichen
% Materialdatensatzes assembliert, dann naechster Datensatz,
% sinnvoll fuer Plots, Eckert 04/2003
% mat_set wird in lprob und cont_sm gesetzt

for aktmat = mat_set

    % Einige benoetigte Vorabzuweisungen um zu verhindern, dass bei jedem
    % Schritt das entsprechende Array im Arbeitsspeicher vergroessert werden muss.
    listlength      = mat2el(1, aktmat);
    elements        = mat2el(2:listlength+1, aktmat);
    node_temp       = zeros(nel, ndf, listlength);
    unode_temp      = zeros(nel, ndf, listlength);
    k_matrix        = repmat([gesdof,gesdof,0], nel*nel*ndf*ndf, 1, listlength);
    r_matrix        = repmat([gesdof,1,0], nel*ndf, 1, listlength);
    cont_mat_node_m = repmat([numnp,contvar,0], nel*contvar, 1, listlength);
    cont_norm_m     = repmat([listlength,1,0], nel, 1, listlength);
    pos_vec         = zeros(nel*ndf, 1, listlength);

    % Matrizen, welche als Indizierung verwendet werden, als Seiten einer
    % 3-Dimensionalen Matrix speichern. Hiermit wird verhindert, dass jedem
    % Worker die gesamte Variable zur Verfuegung gestellt werden muss.
    % Stattdessen muessen immer nur die entsprechenden Seiten uebergeben
    % werden.
    for aktele = elements'
        node_temp(:,:,aktele)  =  node(el(aktele,:),:);
        unode_temp(:,:,aktele) = unode(el(aktele,:),:);
        node_loc = 1:nel;
        node_ges = (el(aktele,node_loc)-1)*ndf+1;
        for i=1:ndf
            pos_vec(i:ndf:nel*ndf, 1, aktele) = (node_ges+i-1)';
        end
    end

    % for -> parfor, falls Parallel Toolbox verfuegbar
    for aktele = elements' % transponiert, damit die Elemente einzeln
        % bei jedem Schleifendurchgang an aktele
        % uebergeben werden und nicht auf einmal
        % als Vektor

        % Knoten und Verschiebungen fuer aktuelles Element in x speichern
        x = node_temp(:,:,aktele);
        u_elem = unode_temp(:,:,aktele);

        % Element-History-Variablen aufbauen:
        hist_old_elem = reshape(hist_old(:,aktele),gphist_max,numgp_max);
        hist_user_elem = reshape(hist_user(:,aktele),gphist_max,numgp_max);

        %%%%%%%%%%%%%%%%%%%%%
        % Begin Elementaufruf
        %%%%%%%%%%%%%%%%%%%%%

        % Zusammenbauen der Element- und Materialnamen nicht mehr noetig, da dies
        % schon in dae.m geschieht und fuer jedes Element in den Vektoren
        % elem_name und mat_name abgelegt ist
        % -> sehr viel schneller
        % Goy, Eckert 09.02

        % zum aktuellen Element gehoerende Groessen (Elementnummer, Materialnummer,
        % Materialparameter) aus Material-Matrizen rausholen
        mat_par = mat_par_matr(:,el2mat(aktele));

        % Element anspringen
        % Hier wird jetzt elem_name zum Aufruf des Elements verwendet und
        % mat_name uebergeben
        [k_elem, r_elem, cont_zaehler, cont_nenner, ...
            hist_new_elem, hist_user_elem] = ...
            feval(deblank(elem_name(aktele,:)),isw, nel, ndf, contvar,...
            deblank(mat_name(aktele,:)), mat_par, x, u_elem,...
            hist_old_elem, hist_user_elem);


        %%%%%%%%%%%%%%%%%%%%
        % Ende Elementaufruf
        %%%%%%%%%%%%%%%%%%%%

        % Element-History-Felder zurueckspeichern
        hist_new(:,aktele) = reshape(hist_new_elem, gphist_max*numgp_max, 1);
        hist_user(:,aktele) = reshape(hist_user_elem, gphist_max*numgp_max, 1);

        % Ablauf zur Erstellung der Einzellisten:
        % Jede Einzelliste besteht aus den Informationen:
        % i: Spaltenvektor der Zeilennummern des Eintrags in der
        %    letztendlichen Matrix
        % j: Spaltenvektor der Spaltennummern des Eintrags in der
        %    letztendlichen Matrix
        % v: Spaltenvektor der Werte
        % Mit diesen Informationen wird jede Elementsteifigkeitsmatrix zu
        % einer Einzelliste konvertiert und in die 3-Dimensionale Matrix,
        % welche alle weiteren Einzellisten beinhaltet, aufgenommen.
        i = repmat(pos_vec(:,:,aktele), nel*ndf, 1);
        j = reshape(repmat(pos_vec(:,:,aktele)', nel*ndf, 1), [], 1);
        v = reshape(k_elem, [], 1);
        r_matrix(:,:,aktele) = [pos_vec(:,:,aktele), ones(nel*ndf,1), r_elem];
        k_matrix(:,:,aktele) = [i, j, v];


        % Herausschreiben der Contour-Variablen funktioniert auf die
        % gleiche Weise wie die der Elementsteifigkeitsmatrizen.
        if (strcmp(elem_name(aktele,:),'elem10'))
            i = [repmat(aktele,contvar,1); repmat(listlength,contvar,1)];
            j = [(1:contvar)'; repmat(contvar,contvar,1)];
            v = [reshape(cont_zaehler,[],1); zeros(contvar,1)];
            ii = [aktele; 1];
            jj = [1; 1];
            vv = [cont_nenner; 0];
        else
            i = repmat(el(aktele,:)', contvar, 1);
            j = reshape(repmat((1:contvar), nel, 1), [], 1);
            v = reshape(cont_zaehler, [], 1);
            ii = el(aktele,:)';
            jj = ones(nel, 1);
            vv = cont_nenner;
        end
        cont_mat_node_m(:,:,aktele) = [i, j, v];
        cont_norm_m(:,:,aktele) = [ii, jj, vv];
    end %aktele parfor

    % So wie es jetzt ist erlaubt die Funktion nur den Durchlauf eines
    % einzigen Materials!

    % Ablauf der Umformungen der 3-Dimensionalen Matrix:
    % 1. Mit 'permute' und 'reshape' wird erreicht, dass die als
    %    Seiten einer 3-Dimensionalen Matrix gespeicherten Einzellisten zu
    %    einer 2-Dimensionalen Gesamtliste aneinander gehaengt werden.
    % 2. An das so entstandene Ende der Liste wird ein Nulleintrag
    %    angehaengt um im nächsten Schritt die gewünschte Größe der Matrix
    %    zu gewaehrleisten.
    % 3. Mit 'spconvert' wird die entstandene Liste zu einer spaerlich
    %    besetzten Matrix umgewandelt.
    %    - Alle Eintraege derselben Indizes werden automatisch addiert.
    %    - Alle Eintraege beeinflussen die letztendliche Groesse der Matrix.
    %    - Alle Nulleintraege werden anschliessend automatisch herausgekuerzt.

    k_matrix = reshape(permute(k_matrix,[1,3,2]), [], 3);
    k_matrix(end+1,:) = [gesdof, gesdof, 0];
    k = spconvert(k_matrix);

    r_matrix = reshape(permute(r_matrix,[1,3,2]), [], 3);
    r_matrix(end+1,:) = [gesdof,1,0];
    r = spconvert(r_matrix);

    cont_mat_node_m = reshape(permute(cont_mat_node_m, [1,3,2]), [], 3);
    cont_mat_node_m(end+1,:) = [numnp, contvar, 0];
    cont_mat_node = spconvert(cont_mat_node_m);

    cont_norm_m = reshape(permute(cont_norm_m,[1,3,2]),[],3);
    cont_norm_m(end+1,:) = [numnp, 1, 0];
    cont_norm = spconvert(cont_norm_m);
    cont_norm = full(cont_norm);
    cont_norm(find(cont_norm==0)) = 1.0E-12;

end %aktmat

% Normierung der Contour-Groessen
for i = 1:contvar
    cont_mat_node(:,i) = cont_mat_node(:,i)./cont_norm(:);
end
cont_mat_node = full(cont_mat_node);

disp('Invertieren der Steifigkeitsmatrix')

% Ende stiffness_func.m
