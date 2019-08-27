#!/usr/bin/perl

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%                                                                  %
#%    DAEdalon Finite-Element-Project                               %
#%                                                                  %
#%    Copyright 2002/2003 Steffen Eckert                            %
#%    Contact: http://www.daedalon.org                              %
#%                                                                  %
#%                                                                  %
#%    This file is part of DAEdalon.                                %
#%                                                                  %
#%    DAEdalon is free software; you can redistribute it            %
#%    and/or modify it under the terms of the GNU General           %
#%    Public License as published by the Free Software Foundation;  %
#%    either version 2 of the License, or (at your option)          %
#%    any later version.                                            %
#%                                                                  %
#%    DAEdalon is distributed in the hope that it will be           %
#%    useful, but WITHOUT ANY WARRANTY; without even the            %
#%    implied warranty of MERCHANTABILITY or FITNESS FOR A          %
#%    PARTICULAR PURPOSE.  See the GNU General Public License       %
#%    for more details.                                             %
#%                                                                  %
#%    You should have received a copy of the GNU General            %
#%    Public License along with Foobar; if not, write to the        %
#%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,   %
#%    Boston, MA  02111-1307  USA                                   %
#%                                                                  %
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


$infile = $ARGV[0];
$nodefile = $ARGV[1];

$outdirlin="../output/";
$outdirwin="..\\output\\";


if ($nodefile eq "")
  {
   print "\nErzeugung einer Last-Zeittabelle aus DAEdalon-Ausgabefiles NAME_time.out\ndurch Summation der Reaktionskraefte ueber alle im Knotenfile (erzeugt z.B.\nmit sel_nodes.pl) enthaltenen Knoten und Zuordnung zur zugehörigen Zeit.\nWird in DAEdalon die Last/Verschiebung linear mit der Zeit skaliert\n(Defaulteinstellung in loadfunc.m), lassen sich mit der Ausgabe des Scipts\nLast-Verschiebungskurven erzeugen.\n";
   print "Verwendung:\n";
   print "1. Eingabeparameter: Inputfiles (NAME (ohne time.out),\n   muessen in ../output liegen)\n";
   print "2. Eingabeparameter: Knotenfile (pro Zeile ein Knoten,\n   muss in ../output liegen)\n";
   exit
}

$tol=0.001;

# Betriebssystem auslesen
$ostype = $ENV{OSTYPE};

# 
if ($ostype eq 'linux')
  {
  print "Betriebssystem: $ostype \n";
  $outdir = $outdirlin;
}
else
  {
    print "Betriebssystem ist NICHT linux, Programm verwendet Windowseinstellungen\n";
$outdir = $outdirwin;
}

open (nodes, "<$outdir$nodefile") || die
  print "Datei $outdir$nodefile existiert nicht.\n";
@nodestring=<nodes>;
print "Knotenfile $outdir$nodefile geöffnet, folgende Knoten wurden eingelesen:\n";
close (nodes);
chomp(@nodestring);
print "@nodestring\n";

# Verzeichnis ../output auslesen und in @allfiles ablegen
opendir(dir,"$outdir") || die " Verzeichnis nicht gefunden\n";
@allfiles = readdir(dir);
closedir(dir);
chomp(@allfiles);


# gesuchte files aus @allfiles raussuchen und in @selfiles ablegen

$len=@allfiles;

# hoffentlich stimmt der reguläre Ausdruck zum Raussuchen der Files
$compstring = "^$infile\_[0-9]*[.][0-9]+[.]out";

$numfiles=0;

for($i=$len-1;$i>=0;$i--)
  {

    if ($allfiles[$i] =~ m/$compstring/)
      {	
	$selfiles[$numfiles]=$allfiles[$i];
	$numfiles++;
      }
  }

chomp(@selfiles);

for ($i=0;$i<$numfiles;$i++)

  {
    open (inp, "<$outdir$selfiles[$i]") || die
      print "Datei $selfiles[$i] existiert nicht.\n";
    @list=<inp>;
    print "$outdir$selfiles[$i] eingelesen\n";
    close (inp);
    chomp(@list);
   


    # Zeit auslesen
    @help1 = split("=",$list[0]);
    $time  = $help1[1];

    # jetzt ersten beiden Zeilen rausschmeissen
    shift(@list);
    shift(@list);

    $len = @nodestring;

    # Werte für alle Knoten in $nodestring raussuchen
    $reac_x=0.0;
    $reac_y=0.0;

    for ($j=0;$j<$len;$j++)
      {
      @zeile=split(" ",$list[$nodestring[$j]-1]);
      chomp(@zeile);
      # Achtung, die Spalten stimmen nur für 2D
      $reac_x = $reac_x + $zeile[5];
      $reac_y = $reac_y + $zeile[6];
    } # Ende Werte an aktuellen Knoten raussuchen

    # Feld mit den Eintraegen: time, reac_x, reac_y
    $reac_mat[$i][0] = $time;
    $reac_mat[$i][1] = $reac_x;
    $reac_mat[$i][2] = $reac_y;

  } #Ende Schleife über alle Files


print "Gesamtanzahl der eingelesenen Files: $numfiles\n";


# sortieren nach der Zeit
@reac_sort = sort {$a->[0] <=> $b->[0]} @reac_mat;

# schreiben in outputfile
$outfile=join("",$outdir,"sig_u_",$infile,".plt");
open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";

for ($i=0;$i<$numfiles;$i++)
  {
    for ($j=0;$j<3;$j++)
    {
      print out "$reac_sort[$i][$j] ";
    }
    print out "\n";
  }
close (out);

print "$outfile erzeugt\n";

