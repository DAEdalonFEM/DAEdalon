# Befehlsreferenz für DAEdalon

## Programmablauf und Steuerung:

Befehl | Beschreibung
--- | ---
`dae` | Starten von DAEdalon (Starten der GUI).
`lprob` | Initialisierung einiger Variablen, Einlesen der Eingabefiles, Initialierung der Historyfelder
`stiffness` | Assemblierung der Systemmatrix **k** und des Residuumvektors **r**
`syst` | Aufbau der globalen rechten Seite (aus Residuum und externen Lasten) sowie Einarbeitung der Verschiebungsrandbedingungen in **k** und **r**
`solv` | Lösen des linearen Gleichungssystems **k** $\Delta$**u** = **r**
`residuum` | Berechnung des Residuums $\sqrt{\Delta **u** \cdot \Delta **u**}$
`time` | Zeit um das Zeitinkrement `dt` inkrementieren (&rarr; Inkrementieren der Randverschiebungen, -lasten, da diese mit `tim` skaliert werden (sofern `load_flag = 1` gesetzt ist)). Erzeugen von Ausgabe- und Restartfiles sowie Ausführen von User-Scripts, falls die notwendigen Variablen zugewiesen sind. Die aktuelle Zeit wird in `tim` gespeichert.
`go` | Ausführen der Befehle `stiffness`, `syst`, `solv`, `residuum`
`loop(XX)` | Führt XX Zeitschritte durch. Innerhalb des Zeitschrittes werden maximal 15 Newton-Iterationen ausgeführt. Sobald das Residuum < 1e-10 ist, wird die Zeit um `dt` inkrementiert und das neue Gleichgewicht ausiteriert
`sf` | Schaltet den Sparse-Solver ein bzw. aus
`lf` | Schaltet die Skalierung der Randlasten und -verschiebungen mit der Zeit ein bzw. aus
`mf` | Schalter zum Rausschreiben eines Movies in `movie_array`
`opti` | Optimierung der Bandbreite durch Knotenneunummerierung

## Plotbefehle:
Befehl | Beschreibung
--- | ---
`mesh0` | Ausgabe des undeformierten Netzes
`meshx` | Ausgabe des deformierten Netzes
`disvec` | Ausgabe aller Verschiebungen als Vektoren
`defo_scal=VALUE` | Verschiebungen werden mit `VALUE` skaliert dargestellt &rarr; `meshx`, `disvec`
`nodenum` | Knotennummern darstellen
`elnum` | Elementnummern darstellen
`clearplot`, `clp` | Löschen des Plotfensters
`reac` | Reaktionskräfte an Knoten mit vorgegebenen Randverschiebungen einzeichnen
`boun` | Verschiebungsrandbedingungen einzeichnen:<br>grün: Null-Verschiebungen <br>pink (als Pfeil): Nicht-Null-Verschiebungen
`forc` | Vorgegebene Randlasten in blauen Pfeilen einzeichnen
`dispx`, `dispy` | Ersetzt durch allgemeineren Befehl `ucont(X)`
`cont(X)` | Contourplot der Größe `X`, die auf Elementebene in `cont_mat_gp` in Spalte `X` abgelegt ist. Normalerweise sind die ersten 6 Einträge `cont_mat_gp(1:6) = [eps_x, eps_y, 2eps_xy, sig_x, sig_y, sig_xy]`. In `cont_mat_node` befinden sich die auf die globalen Knoten projizierten GP-Werte
`cont_sm(X1, X2)` | Wie `cont(X)`. Bei der Verwendung mehrerer Materialdatensätze wird Contourgröße `X1` nur für Elemente aus Materialdatensatz `X2` dargestellt
`ucont(X)` | Contourplot der Verschiebungen (bzw. Knotenfreiheitsgrade) des Freiheitsgrades `X`
`ucont_sm(X1, X2)` | Wie `cont_sm(X1, X2)`, zur Darstellung der Verschiebungen (bzw. Knotenfreiheitsgrade) des Freiheitsgrades `X1` für Elemente aus Materialdatensatz `X2`
`mats` | Mehrere Materialdatensätze verschiedenfarbig darstellen

## Ausgabe von verschiedenen Größen:

Befehl | Beschreibung
--- | ---
`out("NAME")` | Schreibt das Ausgabefile `./output/NAME_tim.out` (Knotengrößen: $x, u, \sigma, \varepsilon, \dots$)
`histout("NAME")` | Schreibt das Ausgabefile `./output/NAME_tim.out` (History-Feld an den GPen)
`out_file_name="NAME"` | Wird `out_file_name` ein Name zugewiesen, so wird in `time.m` automatisch `out("NAME")` aufgerufen
`histout_file_name="NAME"` | Wie `out_file_name`, aber für `histout("NAME")`
`u2f2f("NAME")` | Schreibt die aktuellen Knotenverschiebungen in die Datei `./parser/NAME.f2f`. Das Format ist so gewählt, dass die Datei direkt in ein FEAP-Eingabefile eingebaut und mit `f2f.pl` weiter verarbeitet werden kann
`dis(KNOTENNUMMER)` | Ausgabe der Knotenkoordinaten und aller Freiheitsgrade einer `KNOTENNUMMER`

*Anmerkung*:
Soll nicht nach jedem Zeitschritt ein Output-File geschrieben werden, muss die Variable `out_incr` (default = 1) entsprechend geändert werden. Durch sie wird festgelegt, nach wie vielen Zeitschritten jeweils ein neues Output-File geschrieben wird.

## Restart-Files:
Befehl | Beschreibung
--- | ---
`rst_write("NAME")` | Schreibt das Restart-File `./rt_files/NAME_tim.mat` (History-Feld an den GPen)
`rst_file_name="NAME"` | Wird `rst_file_name` ein Name zugewiesen, so wird in `time.m` automatisch `rst_write("NAME")` aufgerufen
`restart("NAME")` | Rechnung durch Aufruf von Restart-File `NAME` vorsetzen

*Anmerkung*:
Solle nicht nach jedem 20. Zeitschritt ein Restart-File geschrieben werden, existiert die Variable `rst_incr` (default = 20). Durch sie wird festgelegt, nach wie vielen Zeitschritten jeweils ein neues Restart-File geschrieben wird.

## Ausführen eines User-Scripts
Durch Setzen der Variable `userSkript="USERFILE.m"` wird das m-File `USERFILE.m` automatisch bei jedem Aufruf von `time` (also zu Beginn jedes Zeitschritts, außer wenn `tim=0`) aufgerufen

## GUI
Die GUI startet normalerweise automatisch beim Aufruf von `dae.m` durch den Befehl `dae`.
Wird nach Eingabe von `dae` die GUI nicht gestartet, kann das im Plotfenster in der Menüleiste
unter DAEControl manuell getan werden.
Mit der dort festgelegten Einstellung wird DAEdalon auch beim Neuaufruf gestartet (mit GUI oder ohne GUI).
Das automatische Öffnen der DAEdalon Homepage durch Klick auf DAEOnline funktioniert zur Zeit nur unter Linux.

Die GUI ist in fünf Hauptgruppen unterteilt. Durch Anklicken kommt man in die einzelnen Untermenüs.
Über die GUI können nicht nur die meisten DAEdalon Funktionen,
sondern auch das Preprocessing-Script `f2f.pl` und die Postprocessing-Scripte aufgerufen werden.

## Dynamik
Die Implementierung folgt im wesentlichen dem Vorgehen in Wriggers und Hughes.
Dämpfung wird durch Rayleigh-Dämpfung beschrieben (siehe separate Dokumentation zu Dynamik).
Alle für dynamische Berechnungen zusätzlich notwendigen Dateien (außer den Elementen) befinden sich
in `./dynamics`. Alle bisher vorhandenen Materialgesetze können ohne Änderung verwendet werden.
Es ist jedoch darauf zu achten, dass im Eingabefile als letzte drei Parameter jedes Materialdatensatzes
die Dichte des Materials und die beiden Rayleigh-Dämpfungskonstanten eingetragen sein müssen.
Beispieleingabefiles sind `balken_dyn` und `balken3_dyn`.

Befehl | Beschreibung
--- | ---
`dyn_init` | Initialisierung der benötigten Variablen, Ausschalten der Skalierung von Randlasten und -verschiebungen mit der Zeit (`load_flag = 0`)
`dyn_loop(XX)` | Durchführen von XX Zeitschritten, analog zu `loop(XX)`

## Bogenlängenverfahren
Für lastgesteuerte Probleme bietet sich das Bogenlängenverfahren an, bei dem eine plastische
Bogenlänge als Inkrement angegeben wird. Die Implementierung hält sich im Wesentlichen an das
Vorgehen in Wriggers. Als Verfahren wurde das von Riks gewählt.

Befehl | Beschreibung
--- | ---
`arcLoop(XX, YY)` | `XX`: Abbruchkriterium, wenn maximal zugelassenes Lastinkrement überschritten wird <br>`YY`: Anzahl der maximal durchzuführenden Loops
