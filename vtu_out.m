%Skript zum Herausschreiben der Loesung als vtu-Datei

%FileID zur Erstellung der Datei mit Schreib- und Leseberechtigung
name=inputdlg('Ihr gewuenschter Dateiname:','Output',1,{'default_out'})';
if isempty(name)
    name={'default_output'};
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

%Innerhalb des PointData Feldes stehen alle Informationen zu den einzelnen
%Punkten wie zB. (Verschiebungen, Dehnungen, Spannungen)
fprintf(fid,'%s\n','<PointData>');

%Schreiben der Verschiebungen
fprintf(fid,'%s%s%s\n','<DataArray type="Float64" Name="Verschiebungen" NumberOfComponents="',num2str(ndf),'" format="ascii">');
fprintf(fid,'%f ',u);
fprintf(fid,'\n%s\n','</DataArray>');

%Schreiben der Dehnungen und Spannungen
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

fprintf(fid,'%s\n','</PointData>');

%Innerhalb des Cell Felds stehen Informationen über Konnektivität der
%Elemente, offsets und Typ der Elemente
fprintf(fid,'%s\n','<Cells>');

%Konnektivität
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
    % lin. Tri
    if nel==3
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
    % lin. Tet
    if nel==4
        vtktype=10;
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
fprintf(fid,'%s\n','</Piece>');
fprintf(fid,'%s\n','</UnstructuredGrid>');
fprintf(fid,'%s\n','</VTKFile>');

fclose(fid);
fprintf('Datei herausgeschrieben: %s\n',name);
