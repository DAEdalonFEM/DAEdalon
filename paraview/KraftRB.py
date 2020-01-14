#!/usr/bin/python

from paraview.simple import *   # fuer GetActiveSource(), GetActiveViewOrCreate(), ...
import math

src = GetActiveSource()           # aktives Paraview-Element als Quelle definieren
data = servermanager.Fetch(src)   # Daten der Quelle holen

lim = data.GetPoints().GetBounds()  # Dimensionen eines bauteilumfassenden Quaders [xmin, xmax, ymin, ymax, zmin, zmax]

k = 0
dim = []
# Schreibe in 'dim' die Kantenlaengen des o.g. Quaders 'lim'
while k < len(lim):
  limtemp = lim[k+1]-lim[k]
  dim.append(abs(limtemp))
  k = k+2

f = []  # Liste fuer Kraftkomponenten eines Knotens
nodeforces = []  # Liste fuer Kraftbetraege aller Knoten
numPts = data.GetNumberOfPoints()
kraftarray = data.GetPointData().GetArray('Kraft_RB')
numComps = kraftarray.GetNumberOfComponents()
# Durchlaufe alle Knoten
for i in range(numPts):
  # Hole pro Knoten die Kraft in die einzelnen Koordinatenrichtungen
  for j in range(numComps):

    # Kraftkomponente j des Knotens i
    fcomp = kraftarray.GetComponent(i,j)

    # Fuege die quadrierte Knotenkraftkomponente der Liste 'f' an
    f.append(fcomp*fcomp)

  # Berechne den Betrag der Knotenkraft und fuege ihn an die Liste 'nodeforces' an
  nodeforces.append(math.sqrt(sum(f)))

  # Leere die Liste mit den Knotenkraftkomponenten fuer den naechsten Knoten i
  f = []

# Skaliere die betragsmaessig maximale Knotenkraft auf die kleinste Kantenlaenge des o.g. Quaders (kleinste Bauteilabmessung)
scalefactor=min(dim)/max(nodeforces)

# create a new 'Glyph'
glyph1 = Glyph(Input=src,
    GlyphType='Arrow')
glyph1.OrientationArray = ['POINTS', 'Disp']
glyph1.ScaleArray = ['POINTS', 'Disp']
glyph1.ScaleFactor = scalefactor
glyph1.GlyphTransform = 'Transform2'

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')
# uncomment following to set a specific view size
# renderView1.ViewSize = [2154, 812]

# show data in view
glyph1Display = Show(glyph1, renderView1)

# get color transfer function/color map for 'Dehnungen'
dehnungenLUT = GetColorTransferFunction('Dehnungen')

# show color bar/color legend
glyph1Display.SetScalarBarVisibility(renderView1, True)

# update the view to ensure updated data information
renderView1.Update()

# get opacity transfer function/opacity map for 'Dehnungen'
dehnungenPWF = GetOpacityTransferFunction('Dehnungen')

# Properties modified on glyph1
glyph1.OrientationArray = ['POINTS', 'Kraft_RB']

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on glyph1
glyph1.ScaleArray = ['POINTS', 'Kraft_RB']

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on glyph1
#glyph1.ScaleFactor = 0.001

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on glyph1
glyph1.GlyphMode = 'All Points'

# update the view to ensure updated data information
renderView1.Update()

# set scalar coloring
ColorBy(glyph1Display, ('POINTS', 'Kraft_RB', 'Magnitude'))

# Hide the scalar bar for this color map if no visible data is colored by it.
HideScalarBarIfNotNeeded(dehnungenLUT, renderView1)

# rescale color and/or opacity maps used to include current data range
glyph1Display.RescaleTransferFunctionToDataRange(True, False)

# show color bar/color legend
glyph1Display.SetScalarBarVisibility(renderView1, True)

# get color transfer function/color map for 'Force'
forceLUT = GetColorTransferFunction('Kraft_RB')

# get opacity transfer function/opacity map for 'Force'
forcePWF = GetOpacityTransferFunction('Kraft_RB')

# rename source object
RenameSource('Kraftrandbedingungen', glyph1)







