#### import the simple module from the paraview
from paraview.simple import *   # fuer GetActiveSource(), GetActiveViewOrCreate(), ...

src = GetActiveSource()

# create a new 'Programmable Filter'
programmableFilter1 = ProgrammableFilter(Input=src)
programmableFilter1.Script = ''
programmableFilter1.RequestInformationScript = ''
programmableFilter1.RequestUpdateExtentScript = ''
programmableFilter1.PythonPath = ''

# Properties modified on programmableFilter1
programmableFilter1.Script = ''
programmableFilter1.RequestInformationScript = ''
programmableFilter1.RequestUpdateExtentScript = ''
programmableFilter1.PythonPath = ''

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

# show data in view
programmableFilter1Display = Show(programmableFilter1, renderView1)

# trace defaults for the display properties.
programmableFilter1Display.Representation = 'Surface'
programmableFilter1Display.ColorArrayName = [None, '']
programmableFilter1Display.OSPRayScaleFunction = 'PiecewiseFunction'
programmableFilter1Display.SelectOrientationVectors = 'None'
programmableFilter1Display.ScaleFactor = 2.0
programmableFilter1Display.SelectScaleArray = 'None'
programmableFilter1Display.GlyphType = 'Arrow'
programmableFilter1Display.GlyphTableIndexArray = 'None'
programmableFilter1Display.GaussianRadius = 0.1
programmableFilter1Display.SetScaleArray = [None, '']
programmableFilter1Display.ScaleTransferFunction = 'PiecewiseFunction'
programmableFilter1Display.OpacityArray = [None, '']
programmableFilter1Display.OpacityTransferFunction = 'PiecewiseFunction'
programmableFilter1Display.DataAxesGrid = 'GridAxesRepresentation'
programmableFilter1Display.PolarAxes = 'PolarAxesRepresentation'
programmableFilter1Display.ScalarOpacityUnitDistance = 0.9859634496486669

# hide data in view
Hide(src, renderView1)

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on programmableFilter1
programmableFilter1.Script = """from paraview import vtk
import math


# Input einlesen und Output initialisieren
pdi = self.GetInputDataObject(0,0)
pdo = self.GetOutputDataObject(0)
pdo.SetPoints(pdi.GetPoints())
numPts = pdo.GetNumberOfPoints()
numComp = 3

displ_fix_x = vtk.vtkDoubleArray()
displ_fix_x.SetName("displ_fix_x")
displ_fix_x.SetNumberOfComponents(numComp)
displ_fix_x.SetNumberOfTuples(numPts)

displ_fix_y = vtk.vtkDoubleArray()
displ_fix_y.SetName("displ_fix_y")
displ_fix_y.SetNumberOfComponents(numComp)
displ_fix_y.SetNumberOfTuples(numPts)

displ_fix_z = vtk.vtkDoubleArray()
displ_fix_z.SetName("displ_fix_z")
displ_fix_z.SetNumberOfComponents(numComp)
displ_fix_z.SetNumberOfTuples(numPts)

displ_load = vtk.vtkDoubleArray()
displ_load.SetName("displ_load")
displ_load.SetNumberOfComponents(numComp)
displ_load.SetNumberOfTuples(numPts)


for i in range(numPts):
    for j in range(numComp):

        # Werte mit Null initialisieren
        displ_fix_x.SetComponent(i,j,0)
        displ_fix_y.SetComponent(i,j,0)
        displ_fix_z.SetComponent(i,j,0)
        displ_load.SetComponent(i,j,0)

        # Werte ggf. ueberschreiben, falls 1,2,-2
        if pdi.GetPointData().GetArray('Verschiebung_RB').GetComponent(i,j)==1:
            if j==0:
                displ_fix_x.SetComponent(i,0,1)
            elif j==1:
                displ_fix_y.SetComponent(i,1,1)
            elif j==2:
                displ_fix_z.SetComponent(i,2,1)

        elif pdi.GetPointData().GetArray('Verschiebung_RB').GetComponent(i,j)==2:
            displ_load.SetComponent(i,j,2)
        elif pdi.GetPointData().GetArray('Verschiebung_RB').GetComponent(i,j)==-2:
            displ_load.SetComponent(i,j,-2)


pdo.GetPointData().AddArray(displ_fix_x)
pdo.GetPointData().AddArray(displ_fix_y)
pdo.GetPointData().AddArray(displ_fix_z)
pdo.GetPointData().AddArray(displ_load)


"""

data = servermanager.Fetch(src)

dim=[]
k=0
#dim sind die Dimensionen des Bauteils
lim=data.GetPoints().GetBounds()

while k <len(lim):
  limtemp=lim[k+1]-lim[k]
  dim.append(abs(limtemp))
  k=k+2

scale=min(dim)/10.0

# update the view to ensure updated data information
renderView1.Update()

# rename source object
RenameSource('Verschiebungs-RBen', programmableFilter1)


### GLYPH 1: displ_fix_x ###
# set active source
SetActiveSource(programmableFilter1)

# create a new 'Glyph'
glyph_displ_fix_x = Glyph(Input=programmableFilter1,
    GlyphType='Arrow')
glyph_displ_fix_x.OrientationArray = ['POINTS', 'No orientation array']
glyph_displ_fix_x.ScaleArray = ['POINTS', 'No scale array']
glyph_displ_fix_x.ScaleFactor = scale
glyph_displ_fix_x.GlyphTransform = 'Transform2'

# show data in view
glyph_displ_fix_xDisplay = Show(glyph_displ_fix_x, renderView1)

# trace defaults for the display properties.
glyph_displ_fix_xDisplay.Representation = 'Surface'
glyph_displ_fix_xDisplay.ColorArrayName = [None, '']
glyph_displ_fix_xDisplay.OSPRayScaleArray = 'displ_fix_x'
glyph_displ_fix_xDisplay.OSPRayScaleFunction = 'PiecewiseFunction'
glyph_displ_fix_xDisplay.SelectOrientationVectors = 'None'
glyph_displ_fix_xDisplay.ScaleFactor = 2.2
glyph_displ_fix_xDisplay.SelectScaleArray = 'None'
glyph_displ_fix_xDisplay.GlyphType = 'Arrow'
glyph_displ_fix_xDisplay.GlyphTableIndexArray = 'None'
glyph_displ_fix_xDisplay.GaussianRadius = 0.11
glyph_displ_fix_xDisplay.SetScaleArray = ['POINTS', 'displ_fix_x']
glyph_displ_fix_xDisplay.ScaleTransferFunction = 'PiecewiseFunction'
glyph_displ_fix_xDisplay.OpacityArray = ['POINTS', 'displ_fix_x']
glyph_displ_fix_xDisplay.OpacityTransferFunction = 'PiecewiseFunction'
glyph_displ_fix_xDisplay.DataAxesGrid = 'GridAxesRepresentation'
glyph_displ_fix_xDisplay.PolarAxes = 'PolarAxesRepresentation'

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on glyph_displ_fix_x
glyph_displ_fix_x.GlyphType = 'Line'
glyph_displ_fix_x.OrientationArray = ['POINTS', 'displ_fix_x']
glyph_displ_fix_x.ScaleArray = ['POINTS', 'displ_fix_x']
glyph_displ_fix_x.GlyphMode = 'All Points'

# change solid color
glyph_displ_fix_xDisplay.AmbientColor = [1.0, 0.0, 0.0]
glyph_displ_fix_xDisplay.DiffuseColor = [1.0, 0.0, 0.0]

# toggle 3D widget visibility (only when running from the GUI)
Show3DWidgets(proxy=glyph_displ_fix_x.GlyphType)

# update the view to ensure updated data information
renderView1.Update()

# rename source object
RenameSource('Null-Verschiebungen in x', glyph_displ_fix_x)


### GLYPH 2: displ_fix_y ###
# set active source
SetActiveSource(programmableFilter1)

# create a new 'Glyph'
glyph_displ_fix_y = Glyph(Input=programmableFilter1,
    GlyphType='Arrow')
glyph_displ_fix_y.OrientationArray = ['POINTS', 'No orientation array']
glyph_displ_fix_y.ScaleArray = ['POINTS', 'No scale array']
glyph_displ_fix_y.ScaleFactor = scale
glyph_displ_fix_y.GlyphTransform = 'Transform2'

# show data in view
glyph_displ_fix_yDisplay = Show(glyph_displ_fix_y, renderView1)

# trace defaults for the display properties.
glyph_displ_fix_yDisplay.Representation = 'Surface'
glyph_displ_fix_yDisplay.ColorArrayName = [None, '']
glyph_displ_fix_yDisplay.OSPRayScaleArray = 'displ_fix_y'
glyph_displ_fix_yDisplay.OSPRayScaleFunction = 'PiecewiseFunction'
glyph_displ_fix_yDisplay.SelectOrientationVectors = 'None'
glyph_displ_fix_yDisplay.ScaleFactor = 2.2
glyph_displ_fix_yDisplay.SelectScaleArray = 'None'
glyph_displ_fix_yDisplay.GlyphType = 'Arrow'
glyph_displ_fix_yDisplay.GlyphTableIndexArray = 'None'
glyph_displ_fix_yDisplay.GaussianRadius = 0.11
glyph_displ_fix_yDisplay.SetScaleArray = ['POINTS', 'displ_fix_y']
glyph_displ_fix_yDisplay.ScaleTransferFunction = 'PiecewiseFunction'
glyph_displ_fix_yDisplay.OpacityArray = ['POINTS', 'displ_fix_y']
glyph_displ_fix_yDisplay.OpacityTransferFunction = 'PiecewiseFunction'
glyph_displ_fix_yDisplay.DataAxesGrid = 'GridAxesRepresentation'
glyph_displ_fix_yDisplay.PolarAxes = 'PolarAxesRepresentation'

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on glyph_displ_fix_y
glyph_displ_fix_y.GlyphType = 'Line'
glyph_displ_fix_y.OrientationArray = ['POINTS', 'displ_fix_y']
glyph_displ_fix_y.ScaleArray = ['POINTS', 'displ_fix_y']
glyph_displ_fix_y.GlyphMode = 'All Points'

# change solid color
glyph_displ_fix_yDisplay.AmbientColor = [1.0, 0.0, 0.0]
glyph_displ_fix_yDisplay.DiffuseColor = [1.0, 0.0, 0.0]

# toggle 3D widget visibility (only when running from the GUI)
Show3DWidgets(proxy=glyph_displ_fix_y.GlyphType)

# update the view to ensure updated data information
renderView1.Update()

# rename source object
RenameSource('Null-Verschiebungen in y', glyph_displ_fix_y)


### GLYPH 3: displ_fix_z ###
# set active source
SetActiveSource(programmableFilter1)

# create a new 'Glyph'
glyph_displ_fix_z = Glyph(Input=programmableFilter1,
    GlyphType='Arrow')
glyph_displ_fix_z.OrientationArray = ['POINTS', 'No orientation array']
glyph_displ_fix_z.ScaleArray = ['POINTS', 'No scale array']
glyph_displ_fix_z.ScaleFactor = scale
glyph_displ_fix_z.GlyphTransform = 'Transform2'

# show data in view
glyph_displ_fix_zDisplay = Show(glyph_displ_fix_z, renderView1)

# trace defaults for the display properties.
glyph_displ_fix_zDisplay.Representation = 'Surface'
glyph_displ_fix_zDisplay.ColorArrayName = [None, '']
glyph_displ_fix_zDisplay.OSPRayScaleArray = 'displ_fix_z'
glyph_displ_fix_zDisplay.OSPRayScaleFunction = 'PiecewiseFunction'
glyph_displ_fix_zDisplay.SelectOrientationVectors = 'None'
glyph_displ_fix_zDisplay.ScaleFactor = 2.2
glyph_displ_fix_zDisplay.SelectScaleArray = 'None'
glyph_displ_fix_zDisplay.GlyphType = 'Arrow'
glyph_displ_fix_zDisplay.GlyphTableIndexArray = 'None'
glyph_displ_fix_zDisplay.GaussianRadius = 0.11
glyph_displ_fix_zDisplay.SetScaleArray = ['POINTS', 'displ_fix_z']
glyph_displ_fix_zDisplay.ScaleTransferFunction = 'PiecewiseFunction'
glyph_displ_fix_zDisplay.OpacityArray = ['POINTS', 'displ_fix_z']
glyph_displ_fix_zDisplay.OpacityTransferFunction = 'PiecewiseFunction'
glyph_displ_fix_zDisplay.DataAxesGrid = 'GridAxesRepresentation'
glyph_displ_fix_zDisplay.PolarAxes = 'PolarAxesRepresentation'

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on glyph_displ_fix_z
glyph_displ_fix_z.GlyphType = 'Line'
glyph_displ_fix_z.OrientationArray = ['POINTS', 'displ_fix_z']
glyph_displ_fix_z.ScaleArray = ['POINTS', 'displ_fix_z']
glyph_displ_fix_z.GlyphMode = 'All Points'

# change solid color
glyph_displ_fix_zDisplay.AmbientColor = [1.0, 0.0, 0.0]
glyph_displ_fix_zDisplay.DiffuseColor = [1.0, 0.0, 0.0]

# toggle 3D widget visibility (only when running from the GUI)
Show3DWidgets(proxy=glyph_displ_fix_z.GlyphType)

# update the view to ensure updated data information
renderView1.Update()

# rename source object
RenameSource('Null-Verschiebungen in z', glyph_displ_fix_z)


### GLYPH 4: displ_load ###
# set active source
SetActiveSource(programmableFilter1)

# create a new 'Glyph'
glyph_displ_load = Glyph(Input=programmableFilter1,
    GlyphType='Arrow')
glyph_displ_load.OrientationArray = ['POINTS', 'No orientation array']
glyph_displ_load.ScaleArray = ['POINTS', 'No scale array']
glyph_displ_load.ScaleFactor = scale
glyph_displ_load.GlyphTransform = 'Transform2'

# show data in view
glyph_displ_loadDisplay = Show(glyph_displ_load, renderView1)

# trace defaults for the display properties.
glyph_displ_loadDisplay.Representation = 'Surface'
glyph_displ_loadDisplay.ColorArrayName = [None, '']
glyph_displ_loadDisplay.OSPRayScaleArray = 'displ_load'
glyph_displ_loadDisplay.OSPRayScaleFunction = 'PiecewiseFunction'
glyph_displ_loadDisplay.SelectOrientationVectors = 'None'
glyph_displ_loadDisplay.ScaleFactor = 2.2
glyph_displ_loadDisplay.SelectScaleArray = 'None'
glyph_displ_loadDisplay.GlyphType = 'Arrow'
glyph_displ_loadDisplay.GlyphTableIndexArray = 'None'
glyph_displ_loadDisplay.GaussianRadius = 0.11
glyph_displ_loadDisplay.SetScaleArray = ['POINTS', 'displ_load']
glyph_displ_loadDisplay.ScaleTransferFunction = 'PiecewiseFunction'
glyph_displ_loadDisplay.OpacityArray = ['POINTS', 'displ_load']
glyph_displ_loadDisplay.OpacityTransferFunction = 'PiecewiseFunction'
glyph_displ_loadDisplay.DataAxesGrid = 'GridAxesRepresentation'
glyph_displ_loadDisplay.PolarAxes = 'PolarAxesRepresentation'

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on glyph_displ_load
glyph_displ_load.GlyphType = 'Arrow'
glyph_displ_load.OrientationArray = ['POINTS', 'displ_load']
glyph_displ_load.ScaleArray = ['POINTS', 'displ_load']
glyph_displ_load.GlyphMode = 'All Points'

# change solid color
glyph_displ_loadDisplay.AmbientColor = [0.0, 0.0, 1.0]
glyph_displ_loadDisplay.DiffuseColor = [0.0, 0.0, 1.0]

# toggle 3D widget visibility (only when running from the GUI)
Show3DWidgets(proxy=glyph_displ_load.GlyphType)

# update the view to ensure updated data information
renderView1.Update()

# rename source object
RenameSource('Nicht-Null-Verschiebungen', glyph_displ_load)

# set active source
SetActiveSource(programmableFilter1)

