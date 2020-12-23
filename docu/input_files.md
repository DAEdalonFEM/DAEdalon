## DAEdalon input files

The input files are read from the directory `./input`.

### Nodal coordinates: `nodes.inp`
Every line of `nodes.inp` represents one node.

`x-coord` | `y-coord` | `z-coord`
--- | --- | ---
0.0 | 0.0 | 0.0
1.0 | 0.0 | 0.0
...

### Element connectivity: `el.inp`
Every line of `el.inp` represents one element.
The first column refers to the material input file `matX.inp`.

`material set number` | `first node` | `second node` | ... | `last node`
--- | --- | --- | --- | ---
1 | 1 | 3 | 85 | 18
1 | 20 | 25 | 43 | 44
...

### Material parameters and element type: `mat1.inp`, `mat2.inp`, ...
The number in the file name will serve as the material set identifier, see first column in `el.inp`.

Parameter | Description
--- | ---
4 | element type, here: `elem4.m`
4 | number of integration points (only for storage/history/plot reason)
1 | material model number, here: `mat1.m` (don't confuse with mat1.inp)
0 | material parameter 1, reserved for inelasticity
2.1e5 | material parameter 2, here: Young's modulus for `mat1.m`
0.3 | material parameter 3, here: Poisson ratio for `mat1.m`

### Geometric properties: `geom.inp`
Parameter | Description
--- | ---
0 | number of nodes (if zero, nodes will be counted from `nodes.inp`)
0 | number of elements (if zero, elements will be counted from `el.inp`)
1 | total number of material sets = total number of matX.inp files
2 | number of physical dimensions
2 | number of degrees of freedom per node
4 | number of nodes per element

### Prescribed displacements: `displ.inp`
Every line of `displ.inp` represents one node and one degree of freedom.

`node number` | `degree of freedom` | `displacement value`
--- | --- | ---
1 | 1 | 0.0
1 | 2 | 0.0
20 | 2 | 5.0
...

### Nodal forces: `force.inp`
Every line of `force.inp` represents one node and one degree of freedom.

`node number` | `degree of freedom` | `force value`
--- | --- | ---
8 | 2 | -100.0
25 | 1 | 20.0
...
