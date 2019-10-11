# DAEdalon_v2.11_update
"Fork" of DAEdalon v2.11 with update for newer Matlab versions.

Solves error with function handle for creation of DAEdalon GUI on newer Matlab versions (tested for versions >= R2018a).

## Known restrictions
  - Does not run with GNU Octave (tested for version 5.1.0).
  - misses file './gui/gui_check.txt', since this file changes on every DAEdalon GUI call
  - misses folder '../ownstuff' (purpose / necessary ?!)

## Solution
  - create file './gui/gui_check.txt' containing '0'
  - copy folder '../ownstuff' from original DAEdalon v2.11
