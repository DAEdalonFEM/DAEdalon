%Skript zum Herausschreiben der Loesung als vtu-Datei

%FileID zur Erstellung der Datei mit Schreib- und Leseberechtigung
name=inputdlg('Ihr gewuenschter Dateiname:','Output',1,{'default_out'})';
if isempty(name)
    name={'default_output'};
end
name=[name{1} '.vtu'];
fid=fopen(name,'w+');

%Erstellung des Standard Header des .vtu Dateiformats
fprintf(fid,'%s\n','<VTKFile type="UnstructuredGrid" version="0.1" byte_order="LittleEndian" header_type="UInt32" compressor="vtkZLibDataCompressor">');
fprintf(fid,'%s\n','<!--This file was created by DAEdalon/write_out.m-->');
fprintf(fid,'%s\n','<UnstructuredGrid>');
fprintf(fid,'%s%s%s%s%s\n','<Piece NumberOfPoints="',num2str(size(node,1)),'" NumberOfCells="',num2str(size(el,1)),'">');

%Schreiben der Knotenkoordinaten
fprintf(fid,'%s\n','<Points>');
fprintf(fid,'%s%s%s\n','<DataArray type="Float64" Name="Points" NumberOfComponents="',num2str(size(node,2)),'" format="ascii">');
fprintf(fid,'%f\n',node');
fprintf(fid,'%s\n','</DataArray>');
fprintf(fid,'%s\n','</Points>');

%Innerhalb des PointData Feldes stehen alle Informationen zu den einzelnen
%Punkten wie zB. (Verschiebungen, Dehnungen, Spannungen)
fprintf(fid,'%s\n','<PointData>');

%Schreiben der Verschiebungen
fprintf(fid,'%s%s%s\n','<DataArray type="Float64" Name="Disp" NumberOfComponents="',num2str(size(node,2)),'" format="ascii">');
fprintf(fid,'%f\n',u);
fprintf(fid,'%s\n','</DataArray>');

%Schreiben der Dehnungen
fprintf(fid,'%s%s%s\n','<DataArray type="Float64" Name="Dehnungen" NumberOfComponents="6" format="ascii">');
fprintf(fid,'%f\n',cont_mat_node(:,1:6)');
fprintf(fid,'%s\n','</DataArray>');

%Schreiben der Spannungen
fprintf(fid,'%s%s%s\n','<DataArray type="Float64" Name="Spannungen" NumberOfComponents="6" format="ascii">');
fprintf(fid,'%f\n',cont_mat_node(:,7:12)');
fprintf(fid,'%s\n','</DataArray>');

fprintf(fid,'%s\n','</PointData>');

%Innerhalb des Cell Felds stehen Informationen über Konnektivität der
%Elemente, offsets und Typ der Elemente
fprintf(fid,'%s\n','<Cells>');

%Konnektivität
% el2=el;
% el2(:,[2,3])=el2(:,[3,2]);
fprintf(fid,'%s\n','<DataArray type="Int64" Name="connectivity" format="ascii">');
fprintf(fid,'%i\n',(el-1)');
fprintf(fid,'%s\n','</DataArray>');

%offsets
offsets=4:4:4*size(el,1);
fprintf(fid,'%s\n','<DataArray type="Int64" Name="offsets" format="ascii">');
fprintf(fid,'%i\n',offsets');
fprintf(fid,'%s\n','</DataArray>');

%Typ der Elemente
type=10*ones(size(el,1),1);
fprintf(fid,'%s\n','<DataArray type="Int64" Name="types" format="ascii">');
fprintf(fid,'%i\n',type);
fprintf(fid,'%s\n','</DataArray>');

fprintf(fid,'%s\n','</Cells>');
fprintf(fid,'%s\n','</Piece>');
fprintf(fid,'%s\n','</UnstructuredGrid>');
fprintf(fid,'%s\n','</VTKFile>');

fclose(fid);
