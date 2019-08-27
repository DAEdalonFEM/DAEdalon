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


$infile=$ARGV[0];
$outdirlin="../input/";
$outdirwin="..\\input\\";

if ($infile eq "")
  {
   print "\nfeap2DAEdalon Eingabefile-Parser von StE 03.2002\n";
   print "Der Parser kennt zur Zeit folgende Schluesselwoerter:\n";
   print "feap\n";
   print "coor\n";
   print "elem\n";
   print "mate\n";
   print "boun\n";
   print "ebou\n";
   print "disp\n";
   print "edis\n";
   print "forc\n";
   print "dis0\n";
   print "vel0\n";
   print "cons kann nicht verwendet werden\n";
   print "idis und ivel sind keine FEAP-Schlüsselworte, gleiche \n";
   print "Syntax wie disp zur Vorgabe von Anfangsverschiebungen \n";
   print "und -geschwindigkeiten bei dynamischer Rechnung.\n";
   
   print "Als Übergabeparameter das Eingabefile verwenden.\n";
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

    # Vorhandene *.inp-Files in $outdir löschen
    `rm $outdir*.inp`;

    # force.inp als leeres File anlegen
    $outfile=join("",$outdir,"force.inp");
    `touch $outfile`;
    print "$outfile erzeugt\n";
  }
else
  {
    print "KEIN Linux/Unix-Betriebssystem, Programm verwendet Windowseinstellungen\n";

    $outdir=$outdirwin;

    # Vorhandene *.inp-Files in $outdir löschen
    $command = join("","del ",$outdirwin,"*.inp");
    system($command);

    # force.inp als leeres File anlegen
     $command = join("","copy dummy ",$outdirwin,"force.inp");
    system($command);
    print "$outdirwin","force.inp erzeugt\n";
}

# Eingabefile zeilenweise in @list einlesen
open (inp, "<$infile") || die
print "Datei $infile existiert nicht.\n";
@list=<inp>;
close (inp);

# Kommentarzeilen (# bzw %) rausschmeissen
$nlcount=0;
foreach(@list)
  {
    if ($_ !~ m/^ *[#%]/)
	{
	  $newlist[$nlcount] = $_;
	  $nlcount++;
	}
  }
@list = @newlist;

# Suchen nach 'feap' und erzeugen von geom.inp
$outfile=join("",$outdir,"geom.inp");
open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";
$matchflag='false';
foreach(@list)
  {
    if ($matchflag eq 'true')
      {
	@zeile=split(",",$_);
	chomp(@zeile);
	$len=@zeile;
	for ($i=0;$i<$len;$i++)
	  {
	    if ($zeile[$i] =~ m/^ *$/)
	      {
		$zeile[$i]=0;
	      }
	    print out "$zeile[$i]\n";
	  }
	$mat_anz=$zeile[2];
	$matchflag='false';
      }
    if ($_ =~ m/feap/)
      {
	$matchflag='true'
      };
  }
close (out);
print "$outfile erzeugt\n";

# Suchen nach 'coor' und erzeugen von node.inp
#$outfile=join("",$outdir,"node.inp");
#open (out, ">$outfile") || die
#print "Datei $outfile kann nicht angelegt werden.\n";

$matchflag='false';
$node_len=0;
foreach(@list)
  {
    #      unterhalb von coor      leere Zeile
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(" *, *| +",$_);
	chomp(@zeile);

	# Leerzeichen am Zeilenanfang rausschmeissen
	if ($zeile[0] !~ m/[0-9]+/)
	  {
	    shift @zeile;
	  }

$len=@zeile;
# alle zeilen in @node schreiben
	for ($i=0;$i<$len;$i++)
	  {
	    $node[$node_len][$i]=$zeile[$i];
	  }
	$node_len++;
      };
    if ($_ =~ m/coor/)
      {
	$matchflag='true';
      };
  }

# umsortieren
# sortieren einer Matrix nach den Eintraegen der 1. (0.) Spalte
@node_sort = sort {$a->[0] <=> $b->[0]} @node;

#for ($i=0;$i<$node_len;$i++)
#  {
#print  "$node_sort[$i][0]\n";
#    }



# Schreiben in node.inp und pointermatrix aufbauen

$outfile=join("",$outdir,"node.inp");
open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";

for ($i=0;$i<$node_len;$i++)
  {
    # pointermatrix:
    # $old2new[A] = B; mit A=alte Knotennummer, B=neue Kontennummer
    $old2new[$node_sort[$i][0]]=$i+1;

    for ($j=2;$j<$len;$j++)
      {
	print out "$node_sort[$i][$j]"," ";
	#print  "$node_sort[$i][$j]"," ";	
      }
    print out "\n";
#    print  "$node_sort[$i][0]  $old2new[$node_sort[$i][0]] \n";
    #print  "\n";
}
close (out);
print "$outfile erzeugt\n";

# Suchen nach 'elem' und erzeugen von el.inp
$outfile=join("",$outdir,"el.inp");
open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";
$matchflag='false';
foreach(@list)
  {
    #   unterhalb von elem   leere Zeile
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(" *, *| +",$_);
	chomp(@zeile);
	
	# Leerzeichen am Zeilenanfang rausschmeissen
	if ($zeile[0] !~ m/[0-9]+/)
	  {
	    shift @zeile;
	  }

	#print "$zeile[0] $zeile[1] $zeile[2]\n";

# die erste Spalte loeschen und Rest in el.inp schreiben
	shift @zeile;
	$len=@zeile;
	for ($j=0;$j<$len;$j++)
	  {
	    print out "$old2new[$zeile[$j]]"," ";
	  }
	print out "\n";
      };
    if ($_ =~ m/elem/)
      {
	$matchflag='true';
      };
  }
close (out);
print "$outfile erzeugt\n";

# Suchen nach 'boun' und Aufbau von u
$u_len=0;
$matchflag='false';
foreach(@list)
  {
    #   unterhalb von boun    leere Zeile
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(",",$_);
	chomp(@zeile);
	$len=@zeile;
	if ($zeile[1]!=0)
	  {
	    print "ngen wird noch nicht unterstuetzt\n";
	    exit		
	  }
	for ($i=2;$i<$len;$i++)
	  {
	    # falls kein Eintrag, setze Wert = 0
	    if ($zeile[$i] =~ m/^ *$/)
	      {
		$zeile[$i]=0;
	      }
	    if ($zeile[$i] != 0)
	      {
		# Knotennummer
		$u[$u_len][0]=$old2new[$zeile[0]];
		# gesperrter Freiheitsgrad
		$u[$u_len][1]=$i-1;
		# sperren
		$u[$u_len][2]=0.0;
		$u_len++;
	      } # endif
	  }  # $i
      }
    if ($_ =~ m/boun/)
      {
	$matchflag='true';
      }
  } # foreach (@list)


# Suchen nach 'ebou' und Eintragen in u
$matchflag='false';
foreach(@list)
  {
    #   unterhalb von ebou    leere Zeile
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(",",$_);
	chomp(@zeile);
	$len=@zeile;

	for ($i=2;$i<$len;$i++)
	  {
	    # falls kein Eintrag, setze Wert = 0
	    if ($zeile[$i] =~ m/^ *$/)
	      {
		$zeile[$i]=0;
	      }
	    if ($zeile[$i] != 0)
	      {
		$koor=$zeile[0];
		$koor_value=$zeile[1];
		if ($zeile[$i] < 0)
		  {
	    print "constraint-Werte < 0 in ebou noch nicht unterstuetzt\n";
	    exit		
		  }
		for ($j=0;$j<$node_len;$j++)
		  {
		    if ( abs($node_sort[$j][$koor+1]-$koor_value) < $tol)
		      {
			# Knotennummer
			$u[$u_len][0]=$j+1;
			# gesperrter Freiheitsgrad
			#u[$u_len][1]=$koor; geaendert 15.4.02
		        $u[$u_len][1]=$i-1 ;
			# sperren
			$u[$u_len][2]=0.0;
			$u_len++;			
		      }
		  } # $j
	      } # endif
	  }  # $i
      }
    if ($_ =~ m/ebou/)
      {
	$matchflag='true';
      }
  } # foreach (@list)



# Suchen nach 'disp' und Aufbau von u
$matchflag='false';
foreach(@list)
  {
    #   unterhalb von disp  leere Zeile
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(",",$_);
	chomp(@zeile);
	$len=@zeile;
	if ($zeile[1]!=0)
	  {
	    print "ngen wird noch nicht unterstuetzt\n";
	    exit		
	  }
	for ($i=2;$i<$len;$i++)
	  {
	    # falls kein Eintrag, setze Wert = 0
	    if ($zeile[$i] =~ m/^ *$/)
	      {
		$zeile[$i]=0;
	      }
	    if ($zeile[$i] != 0)
	      {
		# Knotennummer
		$u[$u_len][0]=$old2new[$zeile[0]];
		# Verschiebungsfreiheitsgrad
		$u[$u_len][1]=$i-1;
		# Wert eintragen
		$u[$u_len][2]=$zeile[$i];
		$u_len++;
	      } # endif
	  }  # $i
      }
    if ($_ =~ m/disp/)
      {
	$matchflag='true';
      }
  } # foreach (@list)




# Suchen nach 'edisp' und Eintragen in u
$matchflag='false';
foreach(@list)
  {
    #   unterhalb von edis leere Zeile
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(",",$_);
	chomp(@zeile);	
	$len=@zeile;
	for ($i=2;$i<$len;$i++)
	  {
	    # falls kein Eintrag, setze Wert = 0
	    if ($zeile[$i] =~ m/^ *$/)
	      {
		$zeile[$i]=0;
	      }
	    if ($zeile[$i] != 0)
	      {
		$koor=$zeile[0];
		$koor_value=$zeile[1];
		for ($j=0;$j<$node_len;$j++)
		  {
		    if ( abs($node_sort[$j][$koor+1]-$koor_value) < $tol)
		      {
			# Knotennummer
			$u[$u_len][0]=$j+1;
			#  Verschiebungsfreiheitsgrad
			#u[$u_len][1]=$koor; geaendert 15.4.02
		        $u[$u_len][1]=$i-1 ;
			# Wert eintragen
			$u[$u_len][2]=$zeile[$i];
			$u_len++;			
		      }
		  } # $j
	      } # endif
	  }  # $i
      }
    if ($_ =~ m/edis/)
      {
	$matchflag='true';
      }
  } # foreach (@list)


# Ausgabe von u in displ.inp
$outfile=join("",$outdir,"displ.inp");
open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";
for ($i=0;$i<$u_len;$i++)
  {
    for ($j=0;$j<3;$j++)
      {
	print out "$u[$i][$j]"," ";
      }
    print  out "\n";
  }
print "$outfile erzeugt\n";


###########################################################

# Suche nach dis0 zur Vorgabe von Anfangsverschiebungen für
# dynamische Berechnungen (kein FEAP-Schlüsselwort)
# gleiche Syntax wie disp, Eckert 04.05

# Suchen nach 'dis0' und Aufbau von u_0
$u_len = 0;
$matchflag='false';
foreach(@list)
  {
    #   unterhalb von dis0 leere Zeile
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(",",$_);
	chomp(@zeile);
	$len=@zeile;
	if ($zeile[1]!=0)
	  {
	    print "ngen wird noch nicht unterstuetzt\n";
	    exit		
	  }
	for ($i=2;$i<$len;$i++)
	  {
	    # falls kein Eintrag, setze Wert = 0
	    if ($zeile[$i] =~ m/^ *$/)
	      {
		$zeile[$i]=0;
	      }
	    if ($zeile[$i] != 0)
	      {
		# Knotennummer
		$u_0[$u_len][0]=$old2new[$zeile[0]];
		# Verschiebungsfreiheitsgrad
		$u_0[$u_len][1]=$i-1;
		# Wert eintragen
		$u_0[$u_len][2]=$zeile[$i];
		$u_len++;
	      } # endif
	  }  # $i
      }
    if ($_ =~ m/dis0/)
      {
	$matchflag='true';
      }
  } # foreach (@list)


# Ausgabe von u_0 in disp0.inp
$outfile=join("",$outdir,"disp0.inp");
open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";
for ($i=0;$i<$u_len;$i++)
  {
    for ($j=0;$j<3;$j++)
      {
	print out "$u_0[$i][$j]"," ";
      }
    print  out "\n";
  }
print "$outfile erzeugt\n";




# Suche nach vel0 zur Vorgabe von Anfangsgeschwindigkeiten für
# dynamische Berechnungen (kein FEAP-Schlüsselwort)
# gleiche Syntax wie disp, Eckert 04.05

# Suchen nach 'vel0' und Aufbau von u_0
$u_len = 0;
$matchflag='false';
foreach(@list)
  {
    #   unterhalb von dis0 leere Zeile
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(",",$_);
	chomp(@zeile);
	$len=@zeile;
	if ($zeile[1]!=0)
	  {
	    print "ngen wird noch nicht unterstuetzt\n";
	    exit		
	  }
	for ($i=2;$i<$len;$i++)
	  {
	    # falls kein Eintrag, setze Wert = 0
	    if ($zeile[$i] =~ m/^ *$/)
	      {
		$zeile[$i]=0;
	      }
	    if ($zeile[$i] != 0)
	      {
		# Knotennummer
		$v_0[$u_len][0]=$old2new[$zeile[0]];
		# Verschiebungsfreiheitsgrad
		$v_0[$u_len][1]=$i-1;
		# Wert eintragen
		$v_0[$u_len][2]=$zeile[$i];
		$u_len++;
	      } # endif
	  }  # $i
      }
    if ($_ =~ m/vel0/)
      {
	$matchflag='true';
      }
  } # foreach (@list)


# Ausgabe von v_0 in veloc0.inp
$outfile=join("",$outdir,"veloc0.inp");
open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";
for ($i=0;$i<$u_len;$i++)
  {
    for ($j=0;$j<3;$j++)
      {
	print out "$v_0[$i][$j]"," ";
      }
    print  out "\n";
  }
print "$outfile erzeugt\n";


##########################################################

# Suchen nach 'forc' und Aufbau von last
$matchflag='false';
$last_len=0;
foreach(@list)
  {
    #   unterhalb von forc leere Zeile
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(",",$_);
	chomp(@zeile);
	$len=@zeile;
	if ($zeile[1]!=0)
	  {
	    print "ngen wird noch nicht unterstuetzt\n";
	    exit		
	  }
	for ($i=2;$i<$len;$i++)
	  {
	    # falls kein Eintrag, setze Wert = 0
	    if ($zeile[$i] =~ m/^ *$/)
	      {
		$zeile[$i]=0;
	      }
	    if ($zeile[$i] != 0)
	      {
		# Knotennummer
		$last[$last_len][0]=$old2new[$zeile[0]];
		# Lastrichtung (dof)
		$last[$last_len][1]=$i-1;
		# Wert eintragen
		$last[$last_len][2]=$zeile[$i];
		$last_len++;
	      } # endif
	  }  # $i
      }
    if ($_ =~ m/forc/)
      {
	$matchflag='true';
      }
  } # foreach (@list)

# Ausgabe von last in force.inp
$outfile=join("",$outdir,"force.inp");
open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";
for ($i=0;$i<$last_len;$i++)
  {
    for ($j=0;$j<3;$j++)
      {
	print out "$last[$i][$j]"," ";
      }
    print  out "\n";
  }
print "$outfile erzeugt\n";



# Schleife über alle Materialblöcke
for ($mat_count=1;$mat_count<=$mat_anz;$mat_count++)
  {
# Suchen nach 'mate' und erzeugen von mat$i.inp
$outfile=join("",$outdir,"mat",$mat_count,".inp");

open (out, ">$outfile") || die
print "Datei $outfile kann nicht angelegt werden.\n";
$matchflag='false';
foreach(@list)
  {
    if ($matchflag eq 'true' && $_ =~ m/^\s*$/)
      {
	$matchflag='false';
      }
    if ($matchflag eq 'true')
      {
	@zeile=split(",",$_);
	chomp(@zeile);
	$len=@zeile;
	for ($i=0;$i<$len;$i++)
	  {
	    if ($zeile[$i] =~ m/^ *$/)
	      {
		$zeile[$i]=0;
	      }
	    print out "$zeile[$i]\n";
	  }
      }
    if ($_ =~ m/mate/)
      {
	@zeile=split(",",$_);
	chomp(@zeile);
	$mat2el=$zeile[1];
      }
    if ($_ =~ m/user/ && $mat2el == $mat_count)
      {
	$matchflag='true';
	@zeile=split(",",$_);
	chomp(@zeile);
	#Elementnummer:
	print out "$zeile[1]\n"
      }

  }
close (out);
print "$outfile erzeugt\n";
} # $mat_count
