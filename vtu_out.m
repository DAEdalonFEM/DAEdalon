%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2019 P. Werner                                      %
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

%Skript zum Herausschreiben der Loesung als vtu-Datei

%FileID zur Erstellung der Datei mit Schreib- und Leseberechtigung
name=inputdlg('Ihr gewuenschter Dateiname:','Output',1,{'default_out'})';
if isempty(name)
  % Falls leerer Dateiname oder Cancel gedrueckt wurde, keine vtu-Datei herausschreiben
  fprintf('Es wurde keine vtu-Datei herausgeschrieben!\n');
  return
end
name=['output',filesep,name{1},'.vtu'];
fid=fopen(name,'w+');

%Erstellung des Standard Header des .vtu Dateiformats
fprintf(fid,'%s\n','<VTKFile type="UnstructuredGrid" version="0.1">');
fprintf(fid,'%s%s%s\n','<!--This file was created by DAEdalon/',mfilename,'.m-->');
fprintf(fid,'%s\n','<UnstructuredGrid>');
fprintf(fid,'%s%s%s%s%s\n','<Piece NumberOfPoints="',num2str(size(node,1)),'" NumberOfCells="',num2str(size(el,1)),'">');

%Paraview benoetigt auch fuer ebenes Problem drei Knotenkoordinaten, daher ggf. Variable 'node' erweitern um dritte Spalte
if size(node,2)==2
    node(:,3) = 0;
end

%Schreiben der Knotenkoordinaten
fprintf(fid,'%s\n','<Points>');
fprintf(fid,'%s%s%s\n','<DataArray type="Float64" Name="Points" NumberOfComponents="',num2str(size(node,2)),'" format="ascii">');
fprintf(fid,'%f ',node');
fprintf(fid,'\n%s\n','</DataArray>');
fprintf(fid,'%s\n','</Points>');

%Innerhalb des PointData-Feldes stehen alle Informationen zu den einzelnen
%Punkten wie zB. (Verschiebungen, Dehnungen, Spannungen).
%Anfang des PointData-Feldes
fprintf(fid,'%s\n','<PointData>');

%Schreiben der Verschiebungen
fprintf(fid,'%s%s%s\n','<DataArray type="Float64" Name="Verschiebungen" NumberOfComponents="',num2str(ndf),'" format="ascii">');
fprintf(fid,'%f ',u);
fprintf(fid,'\n%s\n','</DataArray>');

%Schreiben der Dehnungen und Spannungen
%Ermittlung, ob es sich um Kontinuumselemente handelt
%(Abfrage klappt nur, solange das Beispiel ausschliesslich durch eine Art von Element aufgebaut ist)
if ismember(elem_nr_matr, cell2mat([surf_elem, vol_elem]))
  if ndf==2
    fprintf(fid,'%s\n','<DataArray type="Float64" Name="Dehnungen" NumberOfComponents="3" format="ascii">');
    fprintf(fid,'%f ',cont_mat_node(:,1:3)');
    fprintf(fid,'\n%s\n','</DataArray>');

    fprintf(fid,'%s\n','<DataArray type="Float64" Name="Spannungen" NumberOfComponents="3" format="ascii">');
    fprintf(fid,'%f ',cont_mat_node(:,4:6)');
    fprintf(fid,'\n%s\n','</DataArray>');
  elseif ndf==3
    fprintf(fid,'%s\n','<DataArray type="Float64" Name="Dehnungen" NumberOfComponents="6" format="ascii">');
    fprintf(fid,'%f ',cont_mat_node(:,1:6)');
    fprintf(fid,'\n%s\n','</DataArray>');

    fprintf(fid,'%s\n','<DataArray type="Float64" Name="Spannungen" NumberOfComponents="6" format="ascii">');
    fprintf(fid,'%f ',cont_mat_node(:,7:12)');
    fprintf(fid,'\n%s\n','</DataArray>');
  end
end

%Schreiben der Kraftrandbedingungen
% Kraft_RB initialisieren
Kraft_RB = zeros(numnp,3);
% force ist gespeichert als (Knoten, FHG, Kraftwert).
% Kraft_RB mit diesen Werten fuellen
for i=1:force_len
  Kraft_RB(force(i,1),force(i,2)) = force(i,3);
end
% Eintraege von Kraft_RB hintereiander als Vektor darstellen.
% Dazu muss Kraft_RB transponiert werden
Kraft_RB = reshape(Kraft_RB',[],1);
fprintf(fid,'%s\n','<DataArray type="Float64" Name="Kraft_RB" NumberOfComponents="3" format="ascii">');
fprintf(fid,'%f ',Kraft_RB);
fprintf(fid,'\n%s\n','</DataArray>');

%Schreiben der Reaktionskraft (wird immer mit drei Komponenten ausgegeben!)
%(r abzueglich der Kraftrandbedingungen entspricht den Reaktionskraeften an den Lagerstellen)
if ndf==2
  % Das Array r enthaelt nur Eintraege fuer die x- und die y-Komponente,
  % daher wird r um die fehlende 3. Vektorkomponente erweitert.
  r_tmp = reshape(r,ndf,numnp);           % r in die Form (ndf x numnp) bringen und als r_tmp abspeichern
  r_tmp = cat(1, r_tmp, zeros(1,numnp));  % Die fehlende dritte Dimension an r_tmp anhaengen, d.h. eine dritte Zeile ans Ende von r_tmp anhaengen, die numnp Spalten hat
  r_tmp = reshape(r_tmp, [], 1);          % r_tmp in die Form eines Vektors mit 3*numnp Eintraegen bringen

  fprintf(fid,'%s\n','<DataArray type="Float64" Name="Reaktionskraft" NumberOfComponents="3" format="ascii">');
  fprintf(fid,'%f ',r_tmp-Kraft_RB);
  fprintf(fid,'\n%s\n','</DataArray>');
elseif ndf==3
  fprintf(fid,'%s\n','<DataArray type="Float64" Name="Reaktionskraft" NumberOfComponents="3" format="ascii">');
  fprintf(fid,'%f ',r-Kraft_RB);
  fprintf(fid,'\n%s\n','</DataArray>');
end

% Schreiben der Verschiebungsrandbedingungen
Verschiebung_RB=zeros(numnp,3);
for i=1:length(displ)
  % displ(i,1) entspricht der Knotennummer
  % displ(i,2) entspricht dem Freiheitsgrad
  % displ(i,3) entspricht dem Verschiebungswert
  % Null-Verschiebungen mit "1" markieren
  if displ(i,3)==0
    Verschiebung_RB(displ(i,1),displ(i,2))=1;
  % Nicht-Null-Verschiebungen mit "2" markieren
  else
    Verschiebung_RB(displ(i,1),displ(i,2))=2;
  end
end
% Eintraege von Verschiebung_RB hintereinander als Vektor darstellen.
% Dazu muss Verschiebung_RB transponiert werden.
Verschiebung_RB=reshape(Verschiebung_RB',[],1);
fprintf(fid,'%s\n','<DataArray type="Float64" Name="Verschiebung_RB" NumberOfComponents="3" format="ascii">');
fprintf(fid,'%f ',Verschiebung_RB);
fprintf(fid,'\n%s\n','</DataArray>');

%Ende des PointData-Feldes
fprintf(fid,'%s\n','</PointData>');

%Innerhalb des Cell Felds stehen Informationen ueber Konnektivitaet der
%Elemente, offsets und Typ der Elemente
fprintf(fid,'%s\n','<Cells>');

%Konnektivitaet
fprintf(fid,'%s\n','<DataArray type="Int32" Name="connectivity" format="ascii">');
fprintf(fid,'%i ',(el-1)');
fprintf(fid,'\n%s\n','</DataArray>');

%offsets
offsets=nel:nel:nel*size(el,1);
fprintf(fid,'%s\n','<DataArray type="Int32" Name="offsets" format="ascii">');
fprintf(fid,'%i ',offsets');
fprintf(fid,'\n%s\n','</DataArray>');

%vtk-spezifische Elementnummern definieren (bei "quadratischen" Elementen nur zus. Kantenknoten beruecksichtigt)
if ndm==2
    % lin. Linie
    if nel==2
        vtktype=3;
    % lin. Tri
    elseif nel==3
        vtktype=5;
    % lin. Quad
    elseif nel==4
        vtktype=9;
    % quad. Tri
    elseif nel==6
        vtktype=22;
    % quad. Quad
    elseif nel==8
        vtktype=23;
    end
elseif ndm==3
    % lin. Linie
    if nel==2
        vtktype=3;
    % lin. Tet
    elseif nel==4
        vtktype=10;
    % lin. Pyramide
    elseif nel==5
        vtktype=14;
    % lin. Hex
    elseif nel==8
        vtktype=12;
    % quad. Tet
    elseif nel==10
        vtktype=24;
    % quad. Quad
    elseif nel==20
        vtktype=25;
    end
end

%Typ der Elemente
type=vtktype*ones(size(el,1),1);
fprintf(fid,'%s\n','<DataArray type="UInt8" Name="types" format="ascii">');
fprintf(fid,'%i ',type);
fprintf(fid,'\n%s\n','</DataArray>');

fprintf(fid,'%s\n','</Cells>');

%Stabdehnungen und -spannungen als (diskrete) elementbezogene Groessen herausschreiben, statt (kontinuierlich) knotenbezogen.
%Ermittlung, ob es sich um ein Stabbeispiel handelt
%(Abfrage klappt nur, solange das Beispiel ausschliesslich durch eine Art von Element aufgebaut ist)
if ismember(elem_nr_matr, cell2mat(truss_2))
  %CellData oeffnen
  fprintf(fid,'%s\n','<CellData>');
  %DataArray Dehnungen
  fprintf(fid,'%s\n','<DataArray type="Float64" Name="Dehnungen" NumberOfComponents="1" format="ascii">');
  fprintf(fid,'%f ',cont_mat_node(:,1)');
  fprintf(fid,'\n%s\n','</DataArray>');
  %DataArray Dehnungen
  fprintf(fid,'%s\n','<DataArray type="Float64" Name="Spannungen" NumberOfComponents="1" format="ascii">');
  fprintf(fid,'%f ',cont_mat_node(:,2)');
  fprintf(fid,'\n%s\n','</DataArray>');
  %CellData schliessen
  fprintf(fid,'%s\n','</CellData>');
end

fprintf(fid,'%s\n','</Piece>');
fprintf(fid,'%s\n','</UnstructuredGrid>');
fprintf(fid,'%s\n','</VTKFile>');

fclose(fid);
fprintf('Datei herausgeschrieben: %s\n',name);
