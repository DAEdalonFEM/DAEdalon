
list = {'Einzellast','Flaechenlast'};
Einzellast={'x-Koordinate','y-Koordinate','z-Koordinate','Betrag in N','Richtung (x=1,y=2,z=3)'};


singlforce=[];
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
                inp_singl=inputdlg(Einzellast,'Einzellast',[1 30],{'0','0','0','10','1'})';
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
                    data=[str2double(inp_singl{1}),str2double(inp_singl{2}),str2double(inp_singl{3}),str2double(inp_singl{4}),str2double(inp_singl{5})];
                    index=find(node(:,1)==data(1,1)& node(:,2)==data(1,2)& node(:,3)==data(1,3));
                    singlforce=[singlforce;index,data(1,5),data(1,4)];
                end
            end
        elseif indx==2

        end

    end
end
