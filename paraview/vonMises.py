#!/usr/bin/python

# Dies ist ein Skript fuer ein Macro in ParaView, das die von-Mises-Vergleichsspannung berechnet

from paraview.simple import *   # FindSource(), GetActiveSource()

src = GetActiveSource()

# create a new 'Programmable Filter'
programmableFilter1 = ProgrammableFilter(Input=src)
programmableFilter1.Script = ''
programmableFilter1.RequestInformationScript = ''
programmableFilter1.RequestUpdateExtentScript = ''
programmableFilter1.PythonPath = ''

# Properties modified on programmableFilter1
programmableFilter1.Script = """
from paraview import vtk

# evt. abzuaendern: - Name des Ursprungs-DataArrays (data_array_name)
#                   - Reihenfolge der Voigt-Notation

pdi = self.GetInputDataObject(0,0)
pdo = self.GetOutputDataObject(0)

data_array_name = 'Spannungen'
input_array = pdi.GetPointData().GetArray(data_array_name)
numComp = input_array.GetNumberOfComponents()

pdo.SetPoints(pdi.GetPoints())
numPts = pdo.GetNumberOfPoints()

numArr = pdi.GetPointData().GetNumberOfArrays()

mises_array = vtk.vtkDoubleArray()
mises_array.SetName('S_mises')

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
programmableFilter1.RequestInformationScript = ''
programmableFilter1.RequestUpdateExtentScript = ''
programmableFilter1.PythonPath = ''

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

# show data in view
programmableFilter1Display = Show(programmableFilter1, renderView1)

# hide data in view
Hide(src, renderView1)

# update the view to ensure updated data information
renderView1.Update()
