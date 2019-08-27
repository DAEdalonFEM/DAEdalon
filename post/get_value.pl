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
$node = $ARGV[1];
$column = $ARGV[2];

$outdirlin="../output/";
$outdirwin="..\\output\\";


if ($column eq "")
  {
   print "\nRausschreiben einer Knoten-/Elementgroeße (Zeile) aus DAEdalon-Ausgabefiles\nNAME_time.out mit gleichem Namen (NAME) zu allen Zeitschritten (time).\n";
   print "Verwendung:\n";
   print "1. Eingabeparameter: Inputfiles (NAME (ohne time.out),\n   muessen in ../output liegen)\n";
   print "2. Eingabeparameter: Zeilennummer (Knotennummer/Elementnummer) fuer die\n   der Wert rausgesucht werden soll (gezaehlt wird ab Zeile drei)\n";
   print "3. Eingabeparameter: Spaltennummer in NAMEtime.out, in der rauszusuchende\n   Groeße steht\n";
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

#open (nodes, "<$outdir$nodefile") || die
#  print "Datei $outdir$nodefile existiert nicht.\n";
#@nodestring=<nodes>;
#print "Knotenfile $outdir$nodefile geöffnet, folgende Knoten wurden eingelesen:\n";
#close (nodes);
#chomp(@nodestring);
#print "@nodestring\n";



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

#    $len = @nodestring;

    # Werte für alle Knoten in $nodestring raussuchen
    $value=0.0;

#    for ($j=0;$j<$len;$j++)
#      {
      @zeile=split(" ",$list[$node-1]);
      chomp(@zeile);
      # Achtung, die Spalten stimmen nur für 2D
      $value =  $zeile[$column-1];

#    } # Ende Werte an aktuellen Knoten raussuchen

    # Feld mit den Eintraegen: time, reac_x, reac_y
    $reac_mat[$i][0] = $time;
    $reac_mat[$i][1] = $value;

  } #Ende Schleife über alle Files


print "Gesamtanzahl der eingelesenen Files: $numfiles\n";


# sortieren nach der Zeit
@reac_sort = sort {$a->[0] <=> $b->[0]} @reac_mat;

# schreiben in outputfile
$outfile=join("",$outdir,"get_value_",$infile,".plt");
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

