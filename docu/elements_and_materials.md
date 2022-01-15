## Available element formulations

The elements are stored in the subdirectory `./elem`

### Truss elements
Element number | Dimensions | Number of nodes | Form | Shape functions | Description
--- | :---: | :---: | --- | --- | ---
`elem10` | 3D | 2 nodes | Truss | linear | small strains

### 2D elements
Element number | Dimensions | Number of nodes | Form | Shape functions | Description
--- | :---: | :---: | --- | --- | ---
`elem2` | 2D | 3 nodes | Triangle | linear | small strains
`elem3` | 2D | 6 nodes | Triangle | quadratic | small strains
`elem6` | 2D | 6 nodes | Triangle | quadratic | small strains, plane strain derived from 3D formulation
`elem34` | 2D | 6 nodes | Triangle | quadratic | large strains, numerical tangent
`elem4` | 2D | 4 nodes | Quadrilateral | linear | small strains
`elem8` | 2D | 8 nodes | Quadrilateral | quadratic | (with reduced (2x2) integration)

### 2D elements (dynamics)
Element number | Dimensions | Number of nodes | Form | Shape functions | Description
--- | :---: | :---: | --- | --- | ---
`elem102` | 2D | 3 nodes | Triangle | linear | (dynamics) small strains, plane strain derived from 3D formulation
`elem104` | 2D | 4 nodes | Quadrilateral | linear | (dynamics) small strains
`elem106` | 2D | 6 nodes | Quadrilateral | quadratic | (dynamics) small strains, plane strain derived from 3D formulation

### 3D elements
Element number | Dimensions | Number of nodes | Form | Shape functions | Description
--- | :---: | :---: | --- | --- | ---
`elem5` | 3D | 4 nodes | Tetrahedral | linear | large strains
`elem7` | 3D | 10 nodes | Tetrahedral | quadratic | small strains
`elem11` | 3D | 8 nodes | Brick | linear | large strains

## Available material formulations

The materials are stored in the subdirectory `./mat`

Material number | Dimensions | Description | Material parameters
--- | :---: | --- | ---
`mat1` | 2D | Linear elasticity (plane stress or plane strain) | E, nu
`mat2` | 2D | St. Venant - Kirchhoff | E, nu
`mat4` | 3D | Linear elasticity | E, nu
`mat8` | 3D | Neo-Hooke | K = 2/D1, c10 = G/2
