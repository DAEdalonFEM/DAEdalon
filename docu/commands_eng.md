# Commands for DAEdalon

## Running the program:
Command | Description
--- | ---
`dae` | start DAEdalon's GUI
`lprob` | initialize some global variables, read the input files, initialize the history fields
`stiffness` | assemble the system matrix **k** as well as the residual vector **r**
`syst` | construct the global right hand side (residual and external loads) and assemble displacement boundary conditions into **k** and **r**
`solv` | solve the linear system **k** $\Delta$**u** = **r**
`residuum` | calculate the residual $\sqrt{\Delta **u** \cdot \Delta **u**}$
`time` | increment the time by `dt` (&rarr; increments the boundary displacements and loads, since they are scaled by `tim` (if `load_flag = 1` has been set)). Create output and restart files, execute user scripts, if the necessary variables have been set (see below). The current time is stored in `tim`
`go` | execute the commands `stiffness`, `syst`, `solv`, `residuum`
`loop(XX)` | loops over XX time steps. In each time step a maximum of 15 Newton iterations are done. If the tolerance for convergence (1e-10) is reached, the time will be incremented by `dt`, proceeding with the solution of the next time step.
`sf` | switches sparse solver on or off
`lf` | switches scaling of boundary displacements and loads on or off
`mf` | switch to generate a movie `movie_array` ???
`opti` | node renumbering for bandwidth optimization

## Plot commands:
Command | Description
--- | ---
`mesh0` | plot the undeformed mesh
`meshx` | plot the deformed mesh
`disvec` | plot all displacements as vectors
`defo_scal=VALUE` | scale displatements by `VALUE` &rarr; `meshx`, `disvec`
`nodenum` | print node numbers
`elmnum` | print element numbers
`clearplot`, `cp` | clear the plot
`reac` | plot reaction forces at nodes with prescribed boundary displacements
`boun` | plot displacement boundary conditions:<br>green: zero displacements <br>pink (as vector): non-zero displacements
`forc` | plot boundary loads (blue vectors)
`dispx`, `dispy` | replaces the command `ucont(X)`
`cont(X)` | create contour plot of entry `X`, which on element level is stored in `cont_mat_gp` in column `X`. Normally, the first six entries are `cont_mat_gp(1:6) = [eps_x, eps_y, 2eps_xy, sig_x, sig_y, sig_xy]`. After projection of the GP values to global nodes, the values are stored in `cont_mat_node`
`cont_sm(X1, X2)` | see `cont(X)`. If more than one material set is defined, plot contour value `X1` for material set `X2`
`ucont(X)` | contour plot of displacement (or better: nodal degree of freedom) `X`
`ucont_sm(X1, X2)` | see `cont_sm(X1, X2)`. If more than one material set is defined, plot displacement value (or better: nodal degree of freedom) `X1` for material set `X2`
`mats` | plot material sets in different colors

## Generating output files and printing information:
Command | Description
--- | ---
`out("NAME")` | generate output file `./output/NAME_tim.out` (for nodal values: $x, u, \sigma, \varepsilon, \dots$)
`histout("NAME")` | generate output file `./output/NAME_tim.out` (for history field at GPs)
`out_file_name="NAME"` | if `out_file_name` is set, `out("NAME")` will automatically be called during `time.m`
`histout_file_name="NAME"` | see `out_file_name`, for `histout("NAME")`
`u2f2f("NAME")` | generate output file `./parser/NAME.f2f` with current nodal displacements. The output can be directly used as input for FEAP and processed by the command `f2f.pl`
`dis(NODE_NUMBER)` | print (???) the coordinates and all degrees of freedom at node `NODE_NUMBER`

*Note*:
By default, after every time step an output file will be written. By changing the variable `out_incr` (default = 1)
output may be written after every nth time step.

## Restart files:
Command | Description
--- | ---
`rst_write("NAME")` | generate restart file `./rt_files/NAME_tim.mat` (for history field at GPs)
`rst_file_name="NAME"` | if `rst_file_name` is set, `rst_write("NAME")` will automatically by called during `time.m`
`restart("NAME")` | restart from restart file `NAME`

*Note*:
By default, after every 20th time step a restart file will be written. By changing the variable `rst_incr` (default = 20)
a restart file may be written after every nth time step.

## Executing user scripts
By setting the variable `userSkript="USERFILE.m"`, the file called `USERFILE.m` will automatically be called during `time` (and at the beginning of every time step, except for `tim=0`)

## GUI
The GUI will start after running the command `dae`.
If the function window will not appear automatically, one may manually click `DAEControl` in the main window.
Opening the DAEdalon webpage by clicking `DAEOnline` in the main window may currently only work on linux machines.

The function window is divided into five main groups. Enter each main group by clicking on the respective name.
Not only the DAEdalon commands from above, but also additional commands, e.g. a preprocessing script `f2f.pl`
or postprocessing scripts, may be called from here.

## Dynamics
For the implementation, please see Wriggers or Hughes as references.
Damping is realized by Rayleigh damping (please see the separate documentation).
All necessary files are included in the `./dynamics` subdirectory, except the element files.
All implementes materials may be used for dynamic scenarios as well, with no changes needed.

Please note, that the last three parameters in the material input files have to describe the material density
and the two Rayleigh damping constants. Please see the example files `balken_dyn` and `balken3_dyn`.

Command | Description
--- | ---
`dyn_init` | initialize the necessary variables, switch off scaling of boundary loads and displacements with time (`load_flag = 0`)
`dyn_loop(XX)` | execute XX time steps, see `loop(XX)`

## Arc length method
For load-driven problems, the arc length method may utilized.
The implementation is based on the approach given in Wriggers.
Here, Riks method is used.

Command | Description
--- | ---
`arcLoop(XX, YY)` | `XX`: termination criterion, if max. load increment is exceeded <br>`YY`: max. number of loopls
