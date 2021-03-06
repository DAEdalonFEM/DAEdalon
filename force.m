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


% Skript zum Erstellen einer Force-Inputdatei
function force()

    load(['input',filesep,'node.inp']);
    load(['input',filesep,'el.inp']);
    el(:,1)=[];

    list = {'Einzellast','Flaechenlast','keine Last'};
    Einzellast={'x-Koordinate','y-Koordinate','z-Koordinate','Toleranz des Koordinatenwertes',...
                '(Bei entgegengesetzt wirkenden Kraeften diese mit negativem Vorzeichen eingeben)                    Kraft in x-Richtung ',...
                'Kraft in y-Richtung','Kraft in z-Richtung'};
    Flaechenlast={'Ebenenrichtung auf der die Flaechenlast angreift','Koordinatenwert der Ebene','Toleranz','Flaechenlast in N/mm^2'};

    fprintf('\nDie Datei input/force.inp wird neu angelegt.\n');

    singleforce=[];
    nodeforce=[];
    button1=0;
    flag=[];
    while button1==0
        [indx,tf] = listdlg('ListString',list,'Name','Force','SelectionMode','single','ListSize',[200 75]);
        temp=isempty(indx);
        if temp == 1
            button1=questdlg('Wollen Sie wirklich beenden?','Abfrage','Ja','Nein','Nein');
            switch button1
                case 'Ja'
                    button1=1;
                    fprintf('Es wurden keine/keine weiteren Veraenderungen an der force.inp Datei vorgenommen.\n');
                case 'Nein'
                    button1=0;
            end
        else
            if indx==1
                flag=1;
                button2=0;
                while button2==0  % Einzellasteingabe
                    inp_singl=inputdlg(Einzellast,'Einzellast',[1 50],{'0','0','0','0.1','0','0','0'});

                    v=[inp_singl{1:length(inp_singl)}];
                    if ~isempty(find(v==','))
                        uiwait(warndlg('Bitte geben Sie Dezimalzahlen mit Punkttrennung ein.','Warnung'));
                        continue
                    end

                    temp=isempty(inp_singl);
                    if temp == 1
                        button2=questdlg('Sind alle Einzellasten bestimmt?','Abfrage','Ja','Nein','Nein');
                        switch button2
                            case 'Ja'
                                button2=1;
                            case 'Nein'
                                button2=0;
                        end
                    else
                        tol=str2double(inp_singl{4});
                        coord=[str2double(inp_singl{1}),str2double(inp_singl{2}),str2double(inp_singl{3})];
                        forces=[str2double(inp_singl{5}),str2double(inp_singl{6}),str2double(inp_singl{7})];
                        index=find(node(:,1)<=coord(1,1)+tol & node(:,1)>=coord(1,1)-tol &...
                                   node(:,2)<=coord(1,2)+tol & node(:,2)>=coord(1,2)-tol &...
                                   node(:,3)<=coord(1,3)+tol & node(:,3)>=coord(1,3)-tol);

                        if isempty(index)
                            uiwait(warndlg('ACHTUNG! Es wurde kein Knoten mit den angegebenen Koordinaten gefunden!','Warnung'));
                            continue
                        elseif size(index,1)>1
                            uiwait(warndlg('ACHTUNG! Es wurden mehrere Knoten innerhalb der Toleranz gefunden! Toleranz verringern.','Warnung'));
                            continue
                        end

                        for i=1:3
                            if forces(i)~=0
                                singleforce=[singleforce;index,i,forces(i)];
                            end
                        end
                        fprintf('Kraftrandbedingung: Einzellast an Knoten %i',index);
                        fprintf(' an Position (%s, %s, %s)',num2str(coord(1)),num2str(coord(2)),num2str(coord(3)));
                        fprintf(' von (%s, %s, %s) N aufgebracht.\n',num2str(forces(1)),num2str(forces(2)),num2str(forces(3)));
                    end
                end
            elseif indx==2
                flag=1;
                button3=0;
                while button3==0  %Flaechenlasteingabe
                    inp_area=inputdlg(Flaechenlast,'Flaechenlast',[1 50],{'1','0','0.1','0'});
                    xyz1 = ["x", "y", "z"];
                    xyz2 = ["yz", "xz", "xy"];

%                     v=[inp_area{1:length(inp_area)}];
%                     if ~isempty(find(v==','))
%                         uiwait(warndlg('Bitte geben Sie Dezimalzahlen mit Punkttrennung ein.','Warnung'));
%                         continue
%                     end

                    temp=isempty(inp_area);
                    if temp == 1
                        button3=questdlg('Sind alle Flaechenlasten bestimmt?','Abfrage','Ja','Nein','Nein');
                        switch button3
                            case 'Ja'
                                button3=1;
                            case 'Nein'
                                button3=0;
                        end
                    else
                        tol=str2double(inp_area{3});
                        data=[str2double(inp_area{1}),str2double(inp_area{2}),str2double(inp_area{4})];
                        nodeforce=connectbuild(data(1),data(2),tol,data(3),node,el);

                        if isempty(nodeforce)
                           continue
                        end

                        fprintf('Kraftrandbedingung: %u Knoten',size(nodeforce,1));
                        fprintf(' auf %s-Ebene bei %s = %s (+- %s)',xyz2(data(1)),xyz1(data(1)),inp_area{2},inp_area{3});
                        fprintf(' mit Flaechenlast von %sN/mm^2 beaufschlagt.\n',inp_area{4});
                    end
                end
            elseif indx==3
                if flag==1
                    button4=questdlg('Es wurden bereits Lasten bestimmt. Bestehende Lasten loeschen?','Warning','Ja','Nein','Nein');
                    switch button4
                        case 'Ja'
                            singleforce=[];
                            nodeforce=[];
                            fprintf('Alle aufgebrachten Lasten wurden geloescht!\n\n');
                            continue
                        case 'Nein'
                            continue
                    end
                else
                    break
                end
            end
        end
    end

    if isempty(singleforce)
        gesforce=nodeforce;
    elseif isempty(nodeforce)
        gesforce=singleforce;
    else
        if size(nodeforce,1)>size(singleforce,1)
            for i=1:size(singleforce,1)
                row=find(nodeforce(:,1)==singleforce(i,1)&nodeforce(:,2)==singleforce(i,2));
                if ~isempty(row)
                    nodeforce(row,3)=nodeforce(row,3)+singleforce(i,3);
                    singlforce(i,:)=0;
                end
            end
            delete=find(singlforce(:,1)==0&singlforce(:,2)==0&singlforce(:,3)==0);
            singlforce(delete,:)=[];
            gesforce=[nodeforce;singlforce];
        else
            for i=1:size(nodeforce,1)
                row=find(singleforce(:,1)==nodeforce(i,1)&singleforce(:,2)==nodeforce(i,2));
                if ~isempty(row)
                    singleforce(row,3)=singleforce(row,3)+nodeforce(i,3);
                    nodeforce(i,:)=0;
                end
            end
            delete=find(nodeforce(:,1)==0&nodeforce(:,2)==0&nodeforce(:,3)==0);
            nodeforce(delete,:)=[];
            gesforce=[singlforce;nodeforce];
        end
    end

    pfad_force=fopen(['input',filesep,'force.inp'],'w');
    fprintf(pfad_force,'%i %i %f\n',gesforce');
    fclose(pfad_force);

end % function
