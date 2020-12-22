%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                  %
%    DAEdalon Finite-Element-Project                               %
%                                                                  %
%    Copyright 2019 D. Kuechle                                     %
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


function inp_convert()

% Als Funktion implementiert, damit Variablen anschliessend geloescht werden.

%START
fprintf('\nP R AE P R O Z E S S O R   S C H N I T T S T E L L E\n');
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
[Inputdatei,inpOrdner]=uigetfile('*.inp','Inputdatei im Abaqus-Format fuer DAEdalon festlegen');
while inpOrdner==0
    answer0=questdlg('Praeprozessor beenden?', ...
	'WARNUNG', ...
	'Ja','Nein','Nein');

    switch answer0
        case 'Ja'
            %Abbruch des Codes, wenn Ja gewaehlt wird
            return;

        case 'Nein'
            [Inputdatei,inpOrdner]=uigetfile('*.inp','Inputdatei im Abaqus-Format fuer DAEDALON festlegen');

    end
end

%OUTPUT ORDNER FESTLEGE
%Ordnerpfad speichern
outOrdner=uigetdir('input','Outputordner fuer DAEdalon-*.inp festlegen');
while outOrdner==0
    answer01=questdlg('Praeprozessor beenden?', ...
	'WARNUNG', ...
	'Ja','Nein','Nein');

    switch answer01
        case 'Ja'
            %Abbruch des Codes, wenn Ja gewaehlt wird
            return;

        case 'Nein'
            outOrdner=uigetdir('input','Outputordner fuer DAEdalon-*.inp festlegen');

    end
end

%Abfrage, ob schon Dateien vorhanden sind
if (isfile([outOrdner,filesep,'node.inp']) ==1 )
    answer1 = questdlg('Im Ordner wurden schon Dateien gefunden. Diese ueberschreiben?', ...
	'WARNUNG', ...
	'Ja','Nein','Nein');

     switch answer1
        case 'Ja'
            disp("Vorhandene Dateien werden ueberschrieben.");

        case 'Nein'
            disp("Alte Dateien werden behalten.");
            %Abbruch des Codes, wenn 'Nein' gewaehlt wird
            return;
     end

     %Falls Eingabefenster geschlossen wird, Dateien ueberschreiben
     if (isempty(answer1)==1)
         uiwait(msgbox('Fenster wurde geschlossen. Alte Dateien werden ueberschrieben.','WARNUNG')); %warten bis aktion an Fenster durchgefuehrt wird
     end

end

%ABFRAGE Emodul & nu : Solange bis Werte fuer Emodul & Poissonszahl i.O.
while Emod<=Emodmin || nu>numax || nu<numin

  prompttxt1 = 'E-Modul E > 0 (Einheiten beachten! Bsp.: mm -> MPa, m -> Pa)';
  prompttxt2 = 'Querkontraktionszahl nu=[-1, 0.5]';
  promptwarn = 'Eingabe ausserhalb des Definitionsbereichs! ';

  if Emod==-inf  && nu==inf
    prompt = {prompttxt1, prompttxt2};
    dlgtitle = 'INPUT';
    definput = {'210000','0.3'};
  else
    if Emod<=Emodmin && nu<numax && nu>numin
      prompt = {strcat(promptwarn,prompttxt1), prompttxt2};
      dlgtitle = 'INPUT';
      definput = {'210000',num2str(nu)};
    else
      if Emod>Emodmin && nu>numax || Emod>Emodmin && nu<numin
        prompt = {strcat(promptwarn,prompttxt1), prompttxt2};
        dlgtitle = 'INPUT';
        definput = {num2str(Emod),'0.3'};
      else
        prompt = {strcat(promptwarn,prompttxt1), prompttxt2};
        dlgtitle = 'INPUT';
        definput = {'210000','0.3'};
      end
    end
  end
  dlgtitle = 'INPUT';
  answer2 = inputdlg(prompt,dlgtitle,[1 40],definput);
  while isempty(answer2)==1
      answer02=questdlg('Praeprozessor beenden?', ...
	       'WARNUNG', ...
	       'Ja','Nein','Nein');

      switch answer02
          case 'Ja'
              %Abbruch des Codes, wenn Ja gewaehlt wird
              return;

          case 'Nein'
              answer2 = inputdlg(prompt,dlgtitle,[1 40],definput);
      end
  end

  Emod = str2num(answer2{1});
  nu = str2num(answer2{2});

end % while

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

%Status der Konvertierung
msgbox_begin=msgbox('Inputdatei wird konvertiert.');

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
            %Umschreiben in gekuertztes Array und Kommata loeschen
            m_node{count,1}=strrep(a{length(a),1},',','');
            %Voranngestellte Durchnummerierung in erster Spalte des Strings im Array loeschen (z.B 45,46,47,48...)
            empt=strfind(m_node{count,1},' ');
            %Engueltige Nodes rausschreiben in Cell-Array
            node{count,1}=m_node{count,1}((empt(1)+1):end) ;
        end
    end % start

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
            %Voranngestellte Durchnummerierung in erster Spalte des Strings im Array loeschen (z.B 45,46,47,48...)
            empt=strfind( m_el{count,1},' ');
            %Engueltige Nodes rausschreiben in Cell-Array
            el{count,1}=[num2str(material),' ',m_el{count,1}((empt(1)+1):end)];
        end
    end % start2

end % while

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
fprintf('Erzeugt: %s\n',pfad_geom);

%mat1.inp
fprintf(fid_mat, '%g\t', [5]); %Zeile 1: Fester Wert (Elementtyp)
fprintf(fid_mat, '\n'); %Zeilenumbruch
fprintf(fid_mat, '%g\t', [se1]); %Zeile 2: Anzahl an Integrationspunkten (Zeile 6 aus geom inp.)
fprintf(fid_mat, '\n');
fprintf(fid_mat, '%g\t', [4]); %Zeile 3: Fester Wert (Materialanzahl)
fprintf(fid_mat, '\n');
fprintf(fid_mat, '%g\t', [0]); %Zeile 4: Fester Wert (Inelastizitaet)
fprintf(fid_mat, '\n');
fprintf(fid_mat, '%g\t', [Emod]); %Zeile 5: E-Modul in MPa
fprintf(fid_mat, '\n');
fprintf(fid_mat, '%g\t', [nu]); %Zeile 6: Querkontraktionszahl (Poissonzahl)
fclose (fid_mat);
fprintf('Erzeugt: %s\n',pfad_mat);

close(msgbox_begin);

text_end = 'Konvertierung beendet - Ordner pruefen';
fprintf('\n%s\n',text_end);
msgbox_end=msgbox(text_end);
pause(5);
close(ancestor(msgbox_end, 'figure'));

end % function
