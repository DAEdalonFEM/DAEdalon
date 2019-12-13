%Funktion zum Erstellen der displ.inp fuer Knoten in einer Koordinatenebene
function edis()

    % Zunaechst wird das Aussehen des Eingabe Dialogfensters festgelegt, dabei
    % wird der Text ueberhalb der Eingabe Edit-Fields in der Variablen
    % Knotenpunkt gespeichert

    Knotenpunkt={'Koordinatenrichtung(x=1,y=2,z=3)',...
        'Koordinatenwert in mm',...
        'Freiheitsgradrichtung(x=1,y=2,z=3) / Mehrfacheingabe moeglich',...
        'Freiheitsgradwert/Verschiebung in mm',...
        'Toleranz fuer obigen Koordinatenwert in mm'};
    Titel='Edis';                         % Titel legt den Titel des Dialogfensters fest
    lines=1;                              % lines bestimmt die Größe eines Edit-Fields
    default={'1','0','1,2,3','0','0.1'};  % Dies sind Default-Werte, welche im Edit-Feld angezeigt werden

    xyz=['x' 'y' 'z'];                    % Dient in spaeterer Print-Ausgabe zum besseren Verstaendnis als '1,2,3'

    disp=[]; % Die Variable disp, welche zum Schluss ausgegeben werden soll
             % wird als neue leere Variable deklariert

    load(['input',filesep,'node.inp']); % Einlesen der Knotendatei
    % load() ermöglicht das sofortige Erstellen einer gleichnamigen Variable


    fprintf('Die Datei input/displ.inp wird neu angelegt.\n');

    % Alle folgenden button* Variablen dienen als Schleifenabbruchbedingungen
    % dabei aendert sich der Wert dieser Variablen falls man im Abfrage-Fenster
    % 'Wollen sie wirklich beenden?' mit 'Ja' antwortet und die Schleife wird
    % beendet

    button=0;
    while button==0
        Eingaben=inputdlg(Knotenpunkt,Titel,lines,default)'; % Aufruf des Dialogfensters zur Eingabe
        temp=isempty(Eingaben);                              % Im Fall des Abbruchs wird die Variable 'Eingaben' empty und die temp Variable zu 1
        if temp == 1                                         % Es soll abgefragt werden ob man tatsaechlich beenden moechte
            button=questdlg('Wollen Sie wirklich beenden?','Abfrage','Ja','Nein','Nein');
            switch button
                case 'Ja'
                    button=1;
                    fprintf('Es wurden keine/keine weiteren Veraenderungen an der displ.inp Datei vorgenommen.\n');
                case 'Nein'
                    button=0;
            end
        else
            % Verarbeitung der Eingaben

            tol=str2double(Eingaben{5}); % hier wird die Toleranz gespeichert
            v=str2double(Eingaben{3}(1));

            % Da eine Mehrfacheingabe zu sperrender oder zu verschiebender
            % Richtungen moeglich ist, muss zunaechst ueberprueft werden ob diese
            % Mehrfacheingabe auch vorgenommen wurde

            if length(Eingaben{3})==3
                v=[str2double(Eingaben{3}(1)),str2double(Eingaben{3}(3))];
            elseif length(Eingaben{3})==5
                v=[str2double(Eingaben{3}(1)),str2double(Eingaben{3}(3)),str2double(Eingaben{3}(5))];
            end

            % Nun werden die restlichen Eingaben unter data zwischengespeichert
            % und in der node Variablen nach den Indizes gesucht, welche den
            % Eingaben entsprechen. Folgender Aufbau ist fuer data vorgesehen
            % [Ebene(x, y oder z), Koord.wert, Verschiebung]

            data=[str2double(Eingaben{1}),str2double(Eingaben{2}),str2double(Eingaben{4})];
            index=find(node(:,data(1,1))<=data(1,2)+tol & node(:,data(1,1))>=data(1,2)-tol);

            % Gefundene Knoten werden mit der entsprechenden Verschiebung
            % korrekt formatiert in der Variablen disp gespeichert

            for i=1:length(v)
                disp=[disp;index,ones(length(index),1)*v(1,i),data(1,3)*ones(length(index),1)];
            end
            fprintf('Verschiebungsrandbedingung: %u Knoten',length(index));
            fprintf(' bei %s = %s (+- %s)mm',xyz(data(1)),num2str(data(2)),num2str(tol));
            fprintf(' in Richtung');
            fprintf(' %i',v);
            fprintf(' um %smm verschieben.\n',num2str(data(3)));
        end
    end

    % Abschließend wird die vollendete Variable disp in eine Datei mit dem
    % Namen disp.inp geschrieben und abgespeichert

    pfad_disp=fopen(['input',filesep,'displ.inp'],'w');
    fprintf(pfad_disp,'%i %i %f\n',disp');
    fclose(pfad_disp);
end
