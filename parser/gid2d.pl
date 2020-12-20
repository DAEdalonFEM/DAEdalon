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
$outdirlin="../input/";
# zu Testzwecken umbenannt
$outdirwin="..\\input\\";

# Betriebssystem auslesen
$ostype = $ENV{OSTYPE};
# shell auslesen, wird zur Bestimmung des Betriebssystems genutzt
# da Red Hat die Variable OSTYPE nicht setzt. 
$shell = $ENV{SHELL};
print "Verwendete Shell: $shell\n";

# alte Files in $outdir löschen
#if ($ostype eq 'linux')
if (($shell eq '/bin/ksh') || ($shell eq '/bin/bash'))
  {
    print "Betriebssystem: $ostype \n";

    $outdir=$outdirlin;

    # Vorhandene *.inp-Files in $outdir löschen
    `rm $outdir*.inp`;
  }
else
  {
    print "Betriebssystem ist NICHT linux, Programm verwendet Windowseinstellungen\n";

    $outdir=$outdirwin;

    # Vorhandene *.inp-Files in $outdir löschen
    $command = join("","del ",$outdirwin,"*.inp");
    system($command);
  }

# Eingabefile zeilenweise in @list einlesen
open (inp, "<$infile") || die "Datei $infile existiert nicht.\n";
@list=<inp>;
close (inp);

# Suchen nach 'geom' und erzeugen von geom.inp
$outfile=join("",$outdir,"geom.inp");
open (out, ">$outfile") || die "Datei $outfile kann nicht angelegt werden.\n";
$matchflag='false';
foreach(@list)
  {
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
        last;
      }
    if ($matchflag eq 'true')
      {
        print out $_;
      }
    if ($_ =~ m/geom/)
      {
        $matchflag='true';
      };
  }
close out;
print "$outfile erzeugt\n";

# Suchen nach 'node' und erzeugen von node.inp
$outfile=join("",$outdir,"node.inp");
open (out, ">$outfile") || die "Datei $outfile kann nicht angelegt werden.\n";
$matchflag='false';
foreach(@list)
  {
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
        last;
      }
    if ($matchflag eq 'true')
      {
        print out $_;
      }
    if ($_ =~ m/node/)
      {
        $matchflag='true';
      };
  }
close out;
print "$outfile erzeugt\n";

# Suchen nach 'el' und erzeugen von el.inp
$outfile=join("",$outdir,"el.inp");
open (out, ">$outfile") || die "Datei $outfile kann nicht angelegt werden.\n";
$matchflag='false';
foreach(@list)
  {
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
        last;
      }
    if ($matchflag eq 'true')
      {
        print out $_;
      }
    if ($_ =~ m/el/)
      {
        $matchflag='true';
      };
  }
close out;
print "$outfile erzeugt\n";

# Suchen nach 'force' und erzeugen von force.inp
$outfile=join("",$outdir,"force.inp");
open (out, ">$outfile") || die "Datei $outfile kann nicht angelegt werden.\n";
$matchflag='false';
foreach(@list)
  {
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
        last;
      }
    if ($matchflag eq 'true')
      {
        print out $_;
      }
    if ($_ =~ m/force/)
      {
        $matchflag='true';
      };
  }
close out;
print "$outfile erzeugt\n";

# Suchen nach 'displ' und erzeugen von displ.inp
$outfile=join("",$outdir,"displ.inp");
open (out, ">$outfile") || die "Datei $outfile kann nicht angelegt werden.\n";
$matchflag='false';
foreach(@list)
  {
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
        last;
      }
    if ($matchflag eq 'true')
      {
        print out $_;
      }
    if ($_ =~ m/displ/)
      {
        $matchflag='true';
      };
  }
close out;
print "$outfile erzeugt\n";

# Suchen nach 'mat..' und erzeugen von mat.inp
@matlist = grep(/mat/,@list);
$anz_mat = @matlist;

for ($i=1; $i<=$anz_mat; $i++)
 {
  $outfile=join("",$outdir,"mat",$i,".inp");
  open (out, ">$outfile") || die "Datei $outfile kann nicht angelegt werden.\n";
  $matchflag='false';
  foreach(@list)
   {
     if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
       {
         $matchflag = 'false';
       }
     if ($matchflag eq 'true')
       {
         print out $_;
       }
     if ($_ =~ m/mat$i/)
       {
         $matchflag='true';
       };
   }
  close out;
print "$outfile erzeugt\n";
 }
