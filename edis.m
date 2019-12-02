%Funktion zum Erstellen einer Displacement-Datei
function edis()

    Knotenpunkt={'Koordinatenrichtung(x=1,y=2,z=3)',...
        'Koordinatenwert in mm',...
        'Freiheitsgradrichtung(x=1,y=2,z=3) / Mehrfachauswahl moeglich',...
        'Freiheitsgradwert/Verschiebung in mm',...
        'Toleranz fuer obigen Koordinatenwert in mm'};
    Titel='Edis';
    lines=1;
    default={'1','0','1,2,3','0','0.1'};

    disp=[];
    fid=fopen(['input',filesep,'node.inp']);
    temp=textscan(fid,'%f%f%f');
    node=[temp{1,1},temp{1,2},temp{1,3}];

    button=0;
    while button==0
        Eingaben=inputdlg(Knotenpunkt,Titel,lines,default)';
        temp=isempty(Eingaben);
        if temp == 1
            button=questdlg('Wollen Sie wirklich beenden?','Abfrage','Ja','Nein','Nein');
            switch button
                case 'Ja'
                    button=1;
                    fprintf('Es wurden keine/keine weiteren Veraenderungen an der displ.inp Datei vorgenommen.\n');
                case 'Nein'
                    button=0;
            end
        else
            tol=str2double(Eingaben{5});
            v=str2double(Eingaben{3}(1));
            if length(Eingaben{3})==3
                v=[str2double(Eingaben{3}(1)),str2double(Eingaben{3}(3))];
            elseif length(Eingaben{3})==5
                v=[str2double(Eingaben{3}(1)),str2double(Eingaben{3}(3)),str2double(Eingaben{3}(5))];
            end

            data=[str2double(Eingaben{1}),str2double(Eingaben{2}),str2double(Eingaben{4})];
            index=find(node(:,data(1,1))<=data(1,2)+tol & node(:,data(1,1))>=data(1,2)-tol);
            for i=1:length(v)
            disp=[disp;index,ones(length(index),1)*v(1,i),data(1,3)*ones(length(index),1)];
            end
        end
    end

    pfad_disp=fopen(['input',filesep,'displ.inp'],'w');
    fprintf(pfad_disp,'%i %i %f\n',disp');
    fclose(pfad_disp);
    fclose(fid);
end
