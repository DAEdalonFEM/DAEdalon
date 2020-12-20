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
#%    Public License along with DAEdalon; if not, write to the      %
#%    Free Software Foundation, Inc., 59 Temple Place, Suite 330,   %
#%    Boston, MA  02111-1307  USA                                   %
#%                                                                  %
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


$infile = $ARGV[0];
$outfile =  $ARGV[1];
$x_coor = $ARGV[2];
$y_coor = $ARGV[3];
$tol = $ARGV[4];

$outdirlin="../output/";
$outdirwin="..\\output\\";

if ($y_coor eq "")
  {
   print "\nRaussuchen von Knoten mit vorgegbenen Koordinaten (in der\nReferenzkonfiguration) aus einem von DAEdalon erzeugten Ausgabefile\nNAME_time.out.\n";
   print "Verwendung:\n";
   print "1. Eingabeparameter: Inputfile (NAME_time.out, muss in ../output liegen)\n";
   print "2. Eingabeparameter: Outputfile (wird in ../output geschrieben)\n";
   print "3. Eingabeparameter: x-Koordinate der rauszusuchenden Knoten\n";
   print "4. Eingabeparameter: y-Koordinate der rauszusuchenden Knoten\n";
   print "5. Eingabeparameter (optional): Toleranz mit der die Koordinaten\n   abgefragt werden, Defaultwert ist 1.0E-3.\n";
   print "ACHTUNG:\nFalls bei 3. oder 4. all eingegeben wird, ist die entsprechende\nKoordinate beliebig.\n";
exit
}


if ($tol eq "")
  { $tol=0.001; }
else
  { print "Toleranz auf $tol gesetzt.\n"; }

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

open (inp, "<$outdir$infile") || die
  print "Datei $infile existiert nicht.\n";
@list=<inp>;
print "$outdir$infile eingelesen\n";
close (inp);
chomp(@list);

# ersten beiden Zeilen rausschmeissen
shift(@list);
shift(@list);

$len = @list;

$x_flag=1;
$y_flag=1;

if ($x_coor eq 'all')
  { $x_flag = 0; }

if ($y_coor eq 'all')
  { $y_flag = 0; }


# Ausgabefile öffnen und gegebenenfalls Knoten reinschreiben
open (out, ">$outdir$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";
print "Knoten:";

for ($i=0;$i<$len;$i++)
  {
    @zeile=split(" ",$list[$i]);
    chomp(@zeile);
    # Vergleichen der Knontenkoordinaten mit den Sollwerten
    # Achtung, die Spalten stimmen nur für 2D

    $x_value = $x_flag*abs($x_coor - $zeile[1]);
    $y_value = $y_flag*abs($y_coor - $zeile[2]);

    if (($x_value < $tol) && ($y_value < $tol))
      {
	print " $zeile[0] ";
	print out "$zeile[0]\n";
      }
  } # Ende Schleife über alle Knoten
close (out);
print "\nin $outdir$outfile geschrieben.\n";


