#!/usr/bin/python

# Dies ist ein Skript fuer ein Macro in ParaView, das zu einer ausgewaehlten vtu/pvd
# einen ProgrammableFilter anlegt,
# welcher die von-Mises-Vergleichsspannung aus Knoten-Spannungswerten berechnet.

from paraview.simple import *   # FindSource(), GetActiveSource()

src = GetActiveSource()

# create a new 'Programmable Filter'
programmableFilter_mises = ProgrammableFilter(Input=src)
programmableFilter_mises.Script = ''
programmableFilter_mises.RequestInformationScript = ''
programmableFilter_mises.RequestUpdateExtentScript = ''
programmableFilter_mises.PythonPath = ''

# Properties modified on programmableFilter_mises
programmableFilter_mises.Script = """
from paraview import vtk
import math

# evtl. abzuaendern: - Name des Ursprungs-DataArrays (data_array_name)
#                    - Reihenfolge der Voigt-Notation

# Input einlesen und Output initialisieren
pdi = self.GetInputDataObject(0,0)
pdo = self.GetOutputDataObject(0)

# Auszulesendes DataArray festlegen und dessen Anzahl an Komponenten holen
data_array_name = 'Spannungen'
input_array = pdi.GetPointData().GetArray(data_array_name)
numComp = input_array.GetNumberOfComponents()

# Knoten des Inputs auf Output uebertragen
pdo.SetPoints(pdi.GetPoints())

# Anzahl der Knoten des Inputs holen
numPts = pdo.GetNumberOfPoints()

mises_array = vtk.vtkDoubleArray()
mises_array.SetName('sig_vonMises')

for point in range(numPts):

  if numComp == 3:
    sig_xx = input_array.GetComponent(point,0)
    sig_yy = input_array.GetComponent(point,1)
    sig_xy = input_array.GetComponent(point,2)
    s_mises = math.sqrt( sig_xx**2 + sig_yy**2 - sig_xx*sig_yy + 3*sig_xy**2 )

  elif numComp == 6:
    sig_xx = input_array.GetComponent(point,0)
    sig_yy = input_array.GetComponent(point,1)
    sig_zz = input_array.GetComponent(point,2)
    sig_xy = input_array.GetComponent(point,3)
    sig_yz = input_array.GetComponent(point,4)
    sig_xz = input_array.GetComponent(point,5)
    s_mises = math.sqrt(0.5*( (sig_xx-sig_yy)**2 + (sig_xx-sig_zz)**2 + (sig_yy-sig_zz)**2 + 6*(sig_yz**2 + sig_xz**2 + sig_xy**2)))

  mises_array.InsertNextValue(s_mises)

pdo.GetPointData().AddArray(mises_array)
"""



# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

# show data in view
programmableFilter_misesDisplay = Show(programmableFilter_mises, renderView1)

# set scalar coloring
ColorBy(programmableFilter_misesDisplay, ('POINTS', 'sig_vonMises'))

# rescale color and/or opacity maps used to include current data range
programmableFilter_misesDisplay.RescaleTransferFunctionToDataRange(True, False)

# show color bar/color legend
programmableFilter_misesDisplay.SetScalarBarVisibility(renderView1, True)

# get color transfer function/color map for 'Mises'
sig_vonmisesLUT = GetColorTransferFunction('sig_vonMises')

# get opacity transfer function/opacity map for 'Mises'
sig_vonmisesPWF = GetOpacityTransferFunction('sig_vonMises')

# rename source object
RenameSource('vonMises Vergleichsspannung', programmableFilter_mises)

# hide data in view
Hide(src, renderView1)

# update the view to ensure updated data information
renderView1.Update()
