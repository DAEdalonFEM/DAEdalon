@ECHO OFF

rem ErrorFile: %2\%1.err

copy ..\..\gid2d_mod.pl .\gid2d_mod.pl
call perl gid2d_mod.pl %1.dat
del %2\gid2d_mod.pl