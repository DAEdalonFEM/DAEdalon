#!/usr/bin/perl

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%                                                                  %
#%    DAEdalon Finite-Element-Project                               %
#%                                                                  %
#%    Copyright 2003 Steffen Eckert                                 %
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
#%    Public License along with DAEdalon; if not, write to the      %
#%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,   %
#%    Boston, MA  02111-1307  USA                                   %
#%                                                                  %
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


$infile = $ARGV[0];
$nodefile = $ARGV[1];
$columnfile = $ARGV[2];
$sort_row = $ARGV[3];

$outdirlin="../output/";
$outdirwin="..\\output\\";


if ($nodefile eq "")
  {
   print "\nRausschreiben beliebig vieler Eintraege (Spalten) zu allen im Knotenfile\nvorgebebenen Knoten (Zeilen) aus DAEdalon-Ausgabefiles NAME_time.out mit\ngleichem Namen (NAME) zu allen Zeitschritten (time). Das geschieht intern\ndurch Aufruf von get_val2.pl für alle im Knotenfile drinstehenden Knoten.\nAnschliessend wird der erzeugte Datensatz nach einer Spalte sortiert.\n";
   print "Verwendung:\n";
   print "1. Eingabeparameter:  Inputfiles (NAME (ohne time.out),\n   muessen in ../output liegen)\n";
   print "2. Eingabeparameter: Knotenfile (pro Zeile ein Knoten,\n   muss in ../output liegen)\n";
   print "3. Eingabeparameter: Spaltenfile (in dem die rauszuschreibenden Spalten\n   untereinander drin stehen (muss in ../output liegen))\n";
   print "4. Eingabeparameter (optional): Spalte nach der sortiert werden soll,\n   Defaultwert ist 1\n";
exit
}

if ($sort_row eq "")
  { $sort_row = 1; }


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

 $numnodes = @nodestring;

 $zeile = 0;

    for ($j=0;$j<$numnodes;$j++)
      {
	$aktnode = $nodestring[$j];
	system("get_val2.pl $infile $aktnode $columnfile");

	$intemp=join("",$outdir,"get_val2_",$infile,".plt");
	
	open (getval2, "<$intemp") || die
	  print "Datei $intemp  existiert nicht.\n";
	@gv2 = <getval2>;
	close (getval2);

	$len_gv2 =  @gv2;
	for ($ii=0;$ii<$len_gv2;$ii++)
	  {
	    $big_vec[$zeile] = $gv2[$ii];
	    $zeile++;
	  }

      }

# in Matrix umwandeln

for  ($i=0;$i<$zeile;$i++)
  { 
    @row = split(" ",$big_vec[$i]);

    $rowlen = @row;
    for ($j=0;$j<$rowlen;$j++)
      {
	$big_matrix[$i][$j] = $row[$j];
      }
  }

# sortieren nach Spalte $sort_row-1
@big_sort = sort {$a->[$sort_row-1] <=> $b->[$sort_row-1]} @big_matrix;

print "Sortieren nach Spalte $sort_row\n";

# schreiben in outputfile

$outfile=join("",$outdir,"merge_",$infile,".plt");
open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";

for ($i=0;$i<$zeile;$i++)
  {
    for ($j=0;$j<$rowlen;$j++)
      {
	print out "$big_sort[$i][$j]  ";
      }
    print out "\n";
}

close (out);

print "$outfile erzeugt\n";




