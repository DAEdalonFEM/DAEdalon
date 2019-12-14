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
                button2=0;
                while button2==0
                    inp_singl=inputdlg(Einzellast,'Einzellast',[1 50],{'0','0','0','0.1','0','0','0'});
                    v=[inp_singl{1:length(inp_singl)}];
                    if ~isempty(find(v==','))
                        uiwait(warndlg('Bitte geben Sie Dezimalzahlen mit Punkttrennung ein.','Warnung'));
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
                button3=0;
                while button3==0
                    inp_area=inputdlg(Flaechenlast,'Flaechenlast',[1 50],{'1','0','0.1','0'});
                    xyz1 = ["x", "y", "z"];
                    xyz2 = ["yz", "xz", "xy"];
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
                        fprintf('Kraftrandbedingung: %u Knoten',size(nodeforce,1));
                        fprintf(' auf %s-Ebene bei %s = %s (+- %s)',xyz2(data(1)),xyz1(data(1)),inp_area{2},inp_area{3});
                        fprintf(' mit Flaechenlast von %sN/mm^2 beaufschlagt.\n',inp_area{4});
                    end
                end
            elseif indx==3
                gesforce=[];
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
                end
            end
            gesforce=nodeforce;
        else
            for i=1:size(nodeforce,1)
                row=find(singleforce(:,1)==nodeforce(i,1)&singleforce(:,2)==nodeforce(i,2));
                if ~isempty(row)
                    singleforce(row,3)=singleforce(row,3)+nodeforce(i,3);
                end
            end
            gesforce=singleforce;
        end
    end

    pfad_force=fopen(['input',filesep,'force.inp'],'w');
    fprintf(pfad_force,'%i %i %f\n',gesforce');
    fclose(pfad_force);

end % function
