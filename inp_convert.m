function inp_convert()
%START
fprintf('P R AE P R O Z E S S O R   S C H N I T T S T E L L E\n\n');
clearvars;

%Material
material=1;

%VARIABLEN
empt=[];

i=1;
count=0;
Emodmin=0;                %Es gibt keinen negativen E-Modul
numax=0.5;                %Maximalwert 0.5
numin=-1;                 %Minimalwert -1 https://www.chemie.de/lexikon/Poissonzahl.html

begin=true;
start=false;
start2=false;

eline=inf;
e2line=inf;
Emod=-inf;                  
nu=inf;                      

%INPUT-/OUTPUT-ORNDER

%DATEI IM INPUTDATEI FESTLEGEN
%Dateiname und Ordnerpfad speichern
[Inputdatei,inpOrdner]=uigetfile('*.inp','Inputdatei im Abaqus-Format fuer DAEDALON festlegen');

%OUTPUT ORDNER FESTLEGE
%Ordnerpfad speichern
outOrdner=uigetdir('','Outputordner fuer DAEdalon-*.inp festlegen');

%Abfrage, ob schon Dateien vorhanden sind
if (isfile([outOrdner,filesep,'node.inp']) ==1 )
    answer1 = questdlg('Im Ordner wurden schon Dateien gefunden. Diese überschreiben?', ...
	'WARNUNG', ...
	'JA','NEIN','NEIN');

     switch answer1
        case 'JA'
            disp("UEberschreiben der Dateien");
            
        case 'NEIN'
            disp("Alte Dateien werden behalten");
            %Abbruch des Codes, wenn NEIN gewaehlt wird
            return;
     end
     
     %Falls Eingabefenster geschlossen wird, Dateien überschreiben
     if (isempty(answer1)==1)
         uiwait(msgbox('Fenster wurde geschlossen. Alte Dateien werden ueberschrieben','WARNUNG')); %warten bis aktion an Fenster durchgeführt wird
         
     end
     
end

%ABFRAGE EMODUL & NÜ : Solange bis Werte für Emodul & Poissonszahl i.O (z.B:Poissonzahl max. 0.5)
while Emod<=Emodmin || nu>numax || nu<numin
  
  if Emod==-inf  && nu==inf
    prompt = {'Gebe den E-Modul ein (Einheiten beachten Bsp.: mm -> MPa, m -> Pa)[Wertebereich >0]','Gebe die Querkontraktionszahl (Poissonzahl) ein [Wertebereich -1 bis 0.5]'};
    dlgtitle = 'INPUT';
    definput = {'210000','0.3'};
  else
   if Emod<=Emodmin && nu<numax && nu>numin
    prompt = {'E-Modul außerhalb des Wertebereichs: Gebe den E-Modul erneut ein (Einheiten beachten Bsp.: mm -> MPa, m -> Pa) [Wertebereich >0]','Gebe die Querkontraktionszahl (Poissonzahl) ein [Wertebereich -1 bis 0.5]'};
    dlgtitle = 'INPUT';
    definput = {'210000',num2str(nu)};
   else
    if Emod>Emodmin && nu>numax || Emod>Emodmin && nu<numin
     prompt = {'Gebe den E-Modul ein (Einheiten beachten Bsp.: mm -> MPa, m -> Pa) [Wertebereich >0]','Querkontraktionszahl außerhalb des Wertebereichs: Gebe die Querkontraktionszahl (Poissonzahl) erneut ein [Wertebereich -1 bis 0.5]'};
     dlgtitle = 'INPUT';
     definput = {num2str(Emod),'0.3'};
    else
     prompt = {'E-Modul außerhalb des Wertebereichs: Gebe den E-Modul erneut ein (Einheiten beachten Bsp.: mm -> MPa, m -> Pa) [Wertebereich >0]','Querkontraktionszahl außerhalb des Wertebereichs: Gebe die Querkontraktionszahl (Poissonzahl) erneut ein [Wertebereich -1 bis 0.5]'};
     dlgtitle = 'INPUT';
     definput = {'210000','0.3'};
    end
   end
  end
  dlgtitle = 'INPUT';
  answer2 = inputdlg(prompt,dlgtitle,[1 40],definput);
  Emod = str2num(answer2{1});
  nu = str2num(answer2{2});

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%EXTRAHIEREN DER 'node' UND 'el' DATEI

%Pfad festlegen
pfad=[inpOrdner,Inputdatei];
pfad_node=[outOrdner,filesep,'node.inp'];
pfad_el=[outOrdner,filesep,'el.inp'];
pfad_geom=[outOrdner,filesep,'geom.inp'];
pfad_mat=[outOrdner,filesep,'mat1.inp'];

%Oeffnen der Dateien
fid_el = fopen(pfad_el,'w');
fid_node = fopen(pfad_node,'w');
fid_geom = fopen( pfad_geom, 'w' );
fid_mat = fopen( pfad_mat, 'w' );

fid = fopen(pfad);

%EXTRAHIEREN START
a = {};  
tline = fgetl(fid); 

while ischar(tline) 
    
    %Zeilenweise auslesen
    tline = fgetl(fid); 
    a{length(a)+1,1} = tline;
    
    %Extrahieren der 'node'
    
    %Suchen nach dem Start-Schlagwort 
    if(isempty(strfind(tline,'*Node'))==0)  
        sline=length(a)+1;
        start=true;
    end
    
    
    
    %Umschreiben des CellArrays 'a' in ein neues gekuerztes Cellarray 'node'
    if (start==true)
        %Suchen nach dem Pause-Schlagwort (Leere Zeile)
        if((isempty(tline)==1)) 
         eline=length(a)-4;   
        end
        
        %Extrahierungsvorgang von Start-Zeile (sline) 
        %bis Pause-Zeile (eline)
        if((length(a)>=sline)&&(length(a)<=(eline)))
            count=count+1;
            %Umschreiben in gekuertztes Array und Kommata löschen
            m_node{count,1}=strrep(a{length(a),1},',','');
            %Voranngestellte Durchnummerierung in erster Spalte des Strings im Array löschen (z.B 45,46,47,48...)
            empt=strfind(m_node{count,1},' ');
            %Engueltige Nodes rausschreiben in Cell-Array
            node{count,1}=m_node{count,1}((empt(1)+1):end) ;         
        end
    end
    
    %Exrahieren der 'el'
    
    %Suchen nach dem Start-Schlagwort 
    if(isempty(strfind(tline,'*Element'))==0)  
        s2line=length(a)+1;
        start2=true;
        set=true;
        count=0;
    end
    
    
    
    %Umschreiben des CellArrays in eine Matrix 'm_node'
    if (start2==true)
        
            %Suchen nach einer leeren Zeile
            if((isempty(tline)==1))
                e2line=length(a)-2;
            end
        
        
        if((length(a)>=s2line)&&length(a)<=(e2line))
            count=count+1;
            %Kuerzen des Cell-Arrays a und Kommata loeschen
            m_el{count,1}=strrep(a{length(a),1},',','');
            %Voranngestellte Durchnummerierung in erster Spalte des Strings im Array löschen (z.B 45,46,47,48...)
            empt=strfind( m_el{count,1},' ');
            %Engueltige Nodes rausschreiben in Cell-Array
            el{count,1}=[num2str(material),' ',m_el{count,1}((empt(1)+1):end)];   
            
        end
    end
    
end

zn=length(node);
ze=length(el);

sn=length(strfind(node{1,1},' '))+1;
se1=length(strfind(el{1,1},' '));

fclose(fid);

%Export der 'node' als string um Datenverust zu vermeiden
fprintf(fid_node,'%s \n',node{1:end,1});
fclose(fid_node);
fprintf('Erzeugt: %s\n',pfad_node);

%Export der 'el' ebenfalls als string
fprintf(fid_el,'%s \n',el{1:end,1}); %1:end: Alle Zeilen schreiben
fclose(fid_el);
fprintf('Erzeugt: %s\n',pfad_el);

%geom.inp

fprintf(fid_geom, '%g\t', [zn]); %Zeile 1: Anzahl Zeilen aus node.inp
fprintf(fid_geom, '\n'); %Zeilenumbruch
fprintf(fid_geom, '%g\t', [ze]); %Zeile 2: Anzahl Zeilen aus el.inp
fprintf(fid_geom, '\n');
fprintf(fid_geom, '%g\t', [1]); %Zeile 3: Fester Wert (Materialanzahl)
fprintf(fid_geom, '\n');
fprintf(fid_geom, '%g\t', [sn]); %Zeile 4: Anzahl der Dimensionen (Anzahl Spalten aus node.inp)
fprintf(fid_geom, '\n');
fprintf(fid_geom, '%g\t', [sn]); %Zeile 5: Anzahl der Freiehitsgrade pro Knoten (Zeile 4 aus geom inp.)
fprintf(fid_geom, '\n');
fprintf(fid_geom, '%g\t', [se1]); %Zeile 6: Anzahl Knoten pro Element (Anzahl Spalten aus el.inp-1)
fclose (fid_geom);

%mat1.inp

fprintf(fid_mat, '%g\t', [5]); %Zeile 1: Fester Wert (Elementtyp)
fprintf(fid_mat, '\n'); %Zeilenumbruch
fprintf(fid_mat, '%g\t', [se1]); %Zeile 2: Anzahl an Integrationspunkten (Zeile 6 aus geom inp.)
fprintf(fid_mat, '\n');
fprintf(fid_mat, '%g\t', [4]); %Zeile 3: Fester Wert (Materialanzahl)
fprintf(fid_mat, '\n');
fprintf(fid_mat, '%g\t', [0]); %Zeile 4: Fester Wert (Inelastizität)
fprintf(fid_mat, '\n');
fprintf(fid_mat, '%g\t', [Emod]); %Zeile 5: E-Modul in MPa
fprintf(fid_mat, '\n');
fprintf(fid_mat, '%g\t', [nu]); %Zeile 6: Querkontraktionszahl (Poissonzahl)
fclose (fid_mat);


fprintf('\n');
fprintf('B E E N D E T - O R D N E R   P R U E F E N ');
fprintf('\n');
end












