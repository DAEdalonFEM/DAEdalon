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


$infile=$ARGV[0];


$indir="./";
$outdirlin="./";
$outdirwin=".\\";

if ($infile eq "")
  {
   print "\ngid2feap Eingabefile-Parser von StE 08.2002\n";
   exit
}

$tol=0.001;

# Betriebssystem auslesen
$ostype = $ENV{OSTYPE};
# shell auslesen, wird zur Bestimmung des Betriebssystems genutzt
# da Red Hat die Variable OSTYPE nicht setzt. 
$shell = $ENV{SHELL};
print "Verwendete Shell: $shell\n";

# alte Files in $outdir löschen und force.inp anlegen
#if ($ostype eq 'linux')
if (($shell eq '/bin/ksh') || ($shell eq '/bin/bash'))
  {
    print "Betriebssystem: $ostype \n";

    $outdir=$outdirlin;
  }
else
  {
    print "Betriebssystem ist NICHT linux, Programm verwendet Windowseinstellungen\n";

    $outdir=$outdirwin;
  }

# Eingabefile zeilenweise in @list einlesen
$pathinfile=join("",$indir,$infile);
print "$pathinfile\n";
open (inp, "<$pathinfile") || die
print "Datei $infile existiert nicht.\n";
@list=<inp>;
close (inp);



# Suchen nach 'Coordinates' und erzeugen von Coordinates.feap
$matchflag='false';
$node_len=0;
foreach(@list)
  {
    # Ende des Coordinates-Block
    if  ($_ =~ m/end coordinates/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(" ",$_);
	chomp(@zeile);
	$node_row_len=@zeile;


# zwischen erster und zweiter Spalte 0 einfügen und in @node schreiben
	for ($i=1;$i<$node_row_len;$i++)
	  {
	    $node[$node_len][0]=$zeile[0];
	    $node[$node_len][1]=0;
	    $node[$node_len][$i+1]=$zeile[$i];
	  }
	$node_len++;
      };
    if ($_ =~ m/Coordinates/)
      {
	$matchflag='true';
      };
  }

# Suchen nach 'Elements' und erzeugen von el.inp
$matchflag='false';
$elem_len=0;
foreach(@list)
 
{
    #   Ende des Elements-Block
    if  ($_ =~ m/end elements/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(" ",$_);
	chomp(@zeile);
	$elem_row_len=@zeile;
# zwischen erster und zweiter Spalte 0 einfügen und in @elem schreiben
	for ($i=1;$i<$elem_row_len;$i++)
	  {
	    $elem[$elem_len][0]=$zeile[0];
	    $elem[$elem_len][1]=1;
	    $elem[$elem_len][$i+1]=$zeile[$i];
	  }
	$elem_len++;
      };
    if ($_ =~ m/Elements/)
      {
	$matchflag='true';
      };
  }


# Ausgabe in File: $infile.feap
$outges =join("",$outdir,$infile,".feap");
open (feap, ">$outges") || die
  print "Datei $outges kann nicht angelegt werden.\n";

$ndf=$node_row_len-1;

# feap-kopf
print feap "feap\n";
print feap ",,1,,","$ndf",",\n";
print feap "\n";

# Koordinaten
print feap "coor\n";
for ($i=0;$i<$node_len;$i++)
  {
    for ($j=0;$j<$node_row_len+1;$j++)
      {
	print feap "$node[$i][$j]"," ";
      }
    print feap "\n";
}
print feap "\n";

# Elemente
print feap "elem,old\n";
for ($i=0;$i<$elem_len;$i++)
  {
    for ($j=0;$j<$elem_row_len+1;$j++)
      {
	print feap "$elem[$i][$j]"," ";
      }
    print feap "\n";
}
print feap "\n";

close (feap);
print "$outges erzeugt\n";
