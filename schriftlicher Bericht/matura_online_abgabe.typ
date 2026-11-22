#import "matura_template.typ": project
#import "@preview/codegds:0.1.0": gdscript-syntax
#set raw(syntaxes: gdscript-syntax)

#show: project.with(
  title: "Optimierung einer 3D Rendering Engine in Godot für ein First Person Shooter Computerspiel",
  subtitle: "",
  author: "Tomas Rivera",
  class: "M6e",
  advisor: "Andreas Steingötter",
  date: "Zürich, 23. November 2026",
  online-abgabe: true
)

#heading(numbering: none)[Motivation]
Aus Interesse an der Spieleentwicklung war ich schon immer
der Meinung, ein Programm versteht man erst dann richtig,
wenn man die einzelnen Teile selbst programmiert hat.

Ausserdem fasziniert es mich, wie ein Computer
aus einer dreidimensionalen Szene ein zweidimensionales Bild erzeugt.

Wenn ich verstehe, wie die Werkzeuge hinter meinen täglichen
Programmen aufgebaut sind, kann ich bei der Entwicklung
eigener Spiele viel besser und gezielter damit arbeiten.


= Einleitung
== Relevanz und Fragestellung
Bei modernen Videospielen, die kompetitiv gespielt werden und höchste Präzision verlangen,
besonders bei sogenannten "First-Person-Shootern" aus der Ich-Perspektive, wird
die Optimierung aller Teile des Programms immer wichtiger. Studien zeigen, dass bereits
wenige Millisekunden Verzögerung die Treffergenauigkeit und damit die Gewinnchancen
entscheidend verschlechtern können @latency @fps-latency.
Die Geschwindigkeit eines Spieles wird in Bildern pro Sekunde gemessen, sogenannten
"Frames per Second" oder FPS.

Einer der wichtigsten Teile dieser Spiele ist der Renderer, also der Teil des Programms,
der alle dreidimensionalen Objekte in einer Szene verarbeitet und dann auf ein
zweidimensionales Bild projiziert, das anschliessend auf dem Bildschirm gezeigt wird.
Er bildet somit die zentrale Schnittstelle für die visuelle Darstellung der Spielwelt.

Das Ziel meiner Maturitätsarbeit ist es, die Leistung von verschiedenen
Rendering-Algorithmen zu messen, indem ich selbst drei technisch
völlig unterschiedliche Rendering-Methoden programmiere. Untersucht werden folgende drei Verfahren:

- *Wireframe-Rendering:* Bei dieser Methode werden Objekte nur durch ihre
  Eckpunkte und Kanten als Drahtgittermodell dargestellt. Die Punkte werden
  mit einer einfachen Formel direkt auf den Bildschirm projiziert und mit
  Linien verbunden.
- *Raycasting:* Dieser Algorithmus sendet für jedes Pixel auf dem Bildschirm
  einen Strahl von der Kamera in die Szene. Jeder Strahl prüft alle
  Dreiecke der Szene auf Schnittpunkte, um das nächste Objekt zu finden und
  die Distanz vom Spieler zum Objekt zu bestimmen.
- *Voxel-Ray-Traversal:* Dieses Verfahren sendet ebenfalls einen Strahl pro
  Pixel aus, die Szene ist aber anstatt aus Dreiecken ein Gitter aus Blöcken
  (Voxeln). Der Strahl wandert schrittweise durch das Gitter und bricht
  beim ersten getroffenen Block sofort ab.

Wie genau diese Algorithmen funktionieren, wird im nächsten Kapitel erklärt.
Danach werde ich sie mithilfe von Beispielszenen miteinander vergleichen,
die Daten analysieren und ihre Vor- und Nachteile erörtern.

Daraus ergeben sich die beiden zentralen Leitfragen meiner Arbeit, die sich in
einen quantitativen und einen qualitativen Teil gliedern:

#block(breakable: false)[
	#align(center)[
		*1. Quantitative Fragestellung:* _Wie verhalten sich diese drei Rendering-Methoden
		bezüglich Rechenzeit, Bildwiederholrate (FPS) und Skalierbarkeit bei
		unterschiedlicher geometrischer Szenenkomplexität?_

		*2. Qualitative Fragestellung:* _Welche spezifischen Vor- und Nachteile bieten
		die drei Verfahren aufgrund ihrer Darstellungsform und Funktionsweise für den
		praktischen Einsatz in einem First-Person-Shooter?_
	]
]

== Wahl der Entwicklungsumgebung (Godot)
Um die Renderer zu programmieren, wählte ich die Spiel-Engine Godot @godot aus.
Gemäss Auswertungen der Plattform SteamDB @steamdb, welche die verwendeten Engines
der auf Steam veröffentlichten Spiele erfasst, ist Godot die meistgenutzte quelloffene
Spiel-Engine. Ausserdem ist es meiner Meinung nach im Vergleich zu anderen einfacher,
darin zu programmieren. 

Als Programmiersprache wird GDScript in Godot genutzt. GDScript ist
ähnlich wie Python @gdscript-docs-python und ist deswegen für die meisten leichter zu lesen
und einfacher zu lernen. Auch die umfassende Godot-Dokumentation @godot-docs
erwies sich während der Umsetzung als sehr hilfreich.

Da Godot eine Spiel-Engine ist, bietet sie auch eingebaute Funktionen wie
zum Beispiel `draw_polyline()`, um mehrere Punkte auf den Bildschirm zu verbinden.
Godot ist für zweidimensionale und dreidimensionale Spiele gemacht,
ich nutze aber bewusst nur die Funktionen für zwei Dimensionen.

Wie diese Architektur in Godot konkret umgesetzt wurde und wie die
Testszenen aufgebaut sind, wird in Kapitel 3 erläutert.

#pagebreak()


= Die Rendering-Algorithmen
Bei der Auswahl der Rendering-Algorithmen wurde darauf geachtet, drei grundlegend
unterschiedliche Ansätze zu untersuchen. Alle drei Verfahren arbeiten
mit eigenen Datenstrukturen und setzen die Projektion dreidimensionaler
Objekte auf zwei Dimensionen auf jeweils unterschiedliche Weise um.

== Terminologie
Kamera: Repräsentiert die Augen des Spielers. Die Kamera befindet sich deswegen dort,
wo der Kopf des Spielers ist. Ohne Rotation blickt sie entlang der $Z$-Achse in die
positive $Z$-Richtung. Dieser Blick lässt sich als Vektor mit $(x, y, z) = (0, 0, 1)$
zusammenfassen und wird auch Richtungsvektor genannt (siehe @kamera_erklärung).

#figure(
  image("Kamera Erklärung.png", width: 60%),
  caption: [Die Kamera (orange Pyramide) befindet sich an der Spitze im Ursprung
  und blickt durch die rechteckige Grundfläche (das Sichtfeld) entlang der
  positiven $Z$-Achse (blau).
  Die Grafik wurde mit Blender erstellt.],
) <kamera_erklärung>

Um die Kamera mit der Maus zu drehen, muss die zweidimensionale Mausbewegung in
eine dreidimensionale Rotation umgewandelt werden. Dies geschieht in zwei Schritten:

+ Bewegt man die Maus horizontal, wird der Richtungsvektor um die $Y$-Achse
  des Raumes nach links oder rechts rotiert. Dabei verändern sich die
  $X$- und $Z$-Komponenten des Richtungsvektors (siehe @kamera_roterierung_1).

  #figure(
    image("Kamera Rotation Erklärung 1.png", width: 50%),
    caption: [Die Kamera (orange) wird um 90° um die $Y$-Achse gedreht,
    sodass sie im Vergleich zu @kamera_erklärung aus ihrer eigenen Perspektive
    nach links schaut. Der neue Richtungsvektor ist jetzt $(x, y, z) = (1, 0, 0)$.
    Die Grafik wurde mit Blender erstellt.],
  ) <kamera_roterierung_1>

+ Bewegt man die Maus vertikal, wird die Kamera um ihre eigene, mitrotierte
  $X$-Achse nach oben oder unten geneigt. Da diese Achse aus Sicht der Kamera
  immer waagerecht bleibt, verändern sich dabei aus ihrer Perspektive die
  $Y$- und $Z$-Komponenten, ohne dass sich das Bild seitlich neigt (siehe @kamera_roterierung_2).

  #figure(
    image("Kamera Rotation Erklärung 2.png", width: 60%),
    caption: [Die Kamera (orange) wird um 90° von der Position bei @kamera_erklärung
    um die $X$-Achse gedreht, sodass sie nach oben schaut. Der neue Richtungsvektor
    ist jetzt $(x, y, z) = (0, 1, 0)$.
    Die Grafik wurde mit Blender erstellt.],
  ) <kamera_roterierung_2>

Da bei beiden Fällen die Blickrichtung entsprechend angepasst wird, lässt sich
der Richtungsvektor über diese zwei einfachen Mausbewegungen frei in allen
drei Raumdimensionen ausrichten.

Der Bildschirm ist der physische Bildschirm,
auf dem die Szene aus der Perspektive der Kamera gezeigt wird.

Objekte bestehen aus vielen Vielecken, die Polygone genannt werden.

== Wireframe-Rendering
Das Wireframe-Rendering gehört zu den ältesten und grundlegendsten
Methoden der 3D-Computergrafik @marschner-shirley.
Objekte werden nur mit ihren Kanten gezeichnet und sehen deswegen
aus, als wären sie aus Draht.

Der erste Schritt ist es, alle Koordinaten relativ zum Spieler
beziehungsweise zur Kamera zu berechnen.
Man macht die Kamera zum Nullpunkt $(0, 0, 0)$ des Raumes, indem man
ihre Position von den Positionen aller Objekte subtrahiert.

Anschliessend wird die Kameradrehung invertiert und auf alle Objekte angewendet,
da sich aus Sicht der Kamera die gesamte Szene nach links bewegt, wenn man nach
rechts blickt, und nach unten, wenn man nach oben blickt. Durch dieses Verschieben
und Drehen der Objekte bleibt die Kamera im Wireframe-Rendering selbst dauerhaft im
Ursprung und blickt immer entlang der positiven $Z$-Achse.

Danach kann man mit dieser Formel die
dreidimensionalen Punkte an den Koordinaten $(x, y, z)$ auf die
zweidimensionalen Koordinatenpunkte $(x', y')$ projizieren:

$ x' = x / z wide y' = y / z $ <eq:wireframe>

$x'$ und $y'$ sind die zweidimensionalen Koordinaten, die auf dem Bildschirm
gezeigt werden können. Das Prinzip der Formel ist die perspektivische
Umrechnung: Man teilt die Koordinaten $x$ und $y$ durch den Abstand $z$.
Je weiter ein Objekt von der Kamera ist, desto grösser ist $z$ und desto
kleiner sind $x'$ und $y'$, also erscheinen Objekte, die weiter weg sind, kleiner.

Bei einem horizontalen und vertikalen Sichtfeld von $90°$, $45°$ in
jede Richtung, gilt für alle sichtbaren Punkte $abs(x) lt.eq z$ und
$abs(y) lt.eq z$. Dadurch liefern $x'$ und $y'$ für den sichtbaren Bereich Werte
zwischen $-1$ und $+1$, Punkte ausserhalb dieses Bereichs werden nicht mehr auf
dem Bildschirm liegen. Abschliessend müssen diese Werte auf die
Bildschirmauflösung skaliert und um die halbe Bildschirmbreite beziehungsweise
Bildschirmhöhe verschoben werden, um am Mittelpunkt des Bildschirms zu sein.
Erst danach kann Godots Zeichenfunktion `draw_polyline()` die berechneten
Pixelpunkte verbinden.

Es gibt aber zwei Fälle, bei denen die Formel nicht funktioniert:

- Wenn ein Objekt hinter dem Spieler erscheint, falls zum Beispiel
  das Objekt am Koordinatenpunkt $(1,1,-1)$ hinter dem Spieler liegt, dann wird nach Anwendung
  der Formel das Objekt auf den Bildschirm bei den Koordinaten $(-1,-1)$
  projiziert. Das heisst, dass Objekte mit negativem $Z$-Wert, also Objekte hinter dem Spieler,
  invertiert auf dem Bildschirm gezeigt werden.
- Ein Objekt kann nicht die $Z$-Koordinate $0$ haben, da eine Division
  durch $0$ nicht definiert ist.

Um diese Probleme zu lösen, überprüft das Programm zuerst, ob alle Eckpunkte
eines Objektes hinter dem Spieler sind oder vor dem Spieler liegen.
Da die Kamera im Wireframe-Rendering durch die vorherige Transformation immer
in die positive $Z$-Richtung blickt, liegen alle Punkte mit positivem $Z$-Wert vor
der Kamera und alle Punkte mit negativem $Z$-Wert hinter der Kamera.

Daraus lässt sich kurz vor der Kamera eine Schnittebene definieren, 
die sogenannte Near-Clipping-Plane, die im Code bei $Z = 0.1$ liegt.
Sie verhindert, dass Punkte mit $Z lt.eq 0$ überhaupt in die Projektionsformel gelangen.

Falls nicht alle Eckpunkte vor oder hinter dem Spieler sind, also teilweise vor
und teilweise hinter der Kamera liegen, dann müssen alle Flächen des Objekts
entlang der Near-Clipping-Plane so "geschnitten" werden,
dass es keine Eckpunkte mehr hinter dem Spieler gibt. Dieser Vorgang heisst "Clipping".
Der Sutherland-Hodgman-Algorithmus @sutherland-hodgman führt das Clipping mit
den Flächen eines Objektes durch und geht dabei wie folgt vor:

Er geht alle Ecken einer Fläche durch
und vergleicht sie mit der nächsten Ecke. Dabei wird die aktuelle Ecke immer als $A$ und die
nächste als $B$ bezeichnet. Es gibt vier mögliche Fälle:

- Falls $A$ und $B$ sichtbar sind, dann wird $B$ gespeichert.

- Falls nur $A$ sichtbar ist, muss man berechnen, ab welchem Punkt $P$
  die Kante $A B$ nicht mehr sichtbar ist. Dafür nutzt man
  lineare Interpolation, die mit der
  Variable $t$, dem sogenannten Gewicht, berechnen kann, bei welchen Koordinaten ein
  Punkt zwischen zwei anderen Punkten liegt. $t = 1$ würde in diesem
  Fall bedeuten, dass der Punkt genau bei $B$ liegt, und $t = 0.5$ würde bedeuten,
  dass der Punkt genau zwischen $A$ und $B$ liegt.
  Die Formel für das Gewicht ist $quad t = (0.1 - A_z) / (B_z - A_z) quad$.
  Um danach zu berechnen, wo der Punkt liegt, nutzt man die Formel
  $quad P = A + t(B - A) quad$.
  Zusammengefasst ist die Formel
  $ P = A + (0.1 - A_z) / (B_z - A_z)(B - A) $ <eq:linear-interpolation>
  Der Punkt $P$ wird dann gespeichert.

- Falls nur $B$ sichtbar ist, wird die gleiche Formel wie beim letzten Fall angewendet.
  Der Punkt $P$ wird gespeichert und es wird ausserdem Punkt $B$ gespeichert. Dies ist
  so, weil die Formel $B$ immer mit $A$ vergleicht, also wenn $B$ sichtbar ist, wird $B$
  grundsätzlich gespeichert.

- Falls $A$ und $B$ nicht sichtbar sind, dann wird die Kante verworfen.

Ein mögliches Endergebnis ist in @sutherland_hodgman_erklärung dargestellt:

#figure(
  image("Sutherland Hodgman Erklärung.svg", width: 80%),
  caption: [Ein Beispiel, wie ein Polygon durch die
  Near-Clipping-Plane geclippt wird in zwei Dimensionen, in GeoGebra
  dargestellt. Das neue Polygon ist dunkelblau, die nicht
  genutzte Fläche ist hellblau.],
) <sutherland_hodgman_erklärung>

#page

== Raycasting
Der Begriff Raycasting leitet sich aus dem Englischen ab und bedeutet das
Aussenden von Strahlen. Für jedes Pixel auf dem Bildschirm sendet
der Algorithmus von der Kamera aus einen Strahl, der für jede Fläche 
auswertet, wie weit sie vom Spieler entfernt ist.

Dafür muss ein Strahl mit seiner Richtung *$arrow(d)$* als Vektor und seinem Ursprung *$o$*
als Koordinate definiert werden. Beide werden in Formeln später gebraucht.

$ s: o + t dot arrow(d) $

Wobei $t$ immer positiv ist, der Richtungsvektor $arrow(d)$ auf die Länge
1 normiert ist, sodass $t$ der Distanz entspricht und der
Ursprung des Strahles die aktuelle Position der Kamera ist.

Die Richtung des Strahles wird berechnet,
indem man die vier Ecken des Bildschirmes als Vektoren definiert, diese
mit der Rotationsmatrix der Kamera multipliziert und dann
je nach gewünschter Auflösung des Bildschirmes zwischen diesen Werten interpoliert,
also alle Werte zwischen den vier Ecken ausrechnet. Je mehr Strahlen berechnet werden,
desto höher ist die Auflösung.

Sobald sämtliche Sichtstrahlen berechnet sind, folgt das
Rendering der Szene. Im Gegensatz zum
Wireframe-Rendering werden Objekte nicht als Polygonflächen
gegeben, sondern in Dreiecken.

Sie müssen so gegeben sein, da man für dreidimensionales Raycasting den
Möller-Trumbore-Algorithmus @moeller-trumbore nutzt, der nur mit
Dreiecken funktioniert. Er kann mit den Eckpunkten eines Dreiecks
sowie dem Ursprung und der Richtung eines Strahles berechnen, ob der
Strahl das Dreieck trifft und wie weit der Strahl laufen musste, um
das Dreieck zu treffen.

Um zu verstehen, wie der Algorithmus funktioniert, muss man zuerst baryzentrische
Koordinaten verstehen. Man definiert zuerst zwei beliebige Kanten eines Dreiecks als Vektoren,
zum Beispiel bei einem Dreieck $A B C$ die Vektoren $arrow(A B)$ und $arrow(A C)$.
Indem man $u dot arrow(A B)$ und $v dot arrow(A C)$ multipliziert und zu $A$ addiert,
kann man alle Punkte innerhalb und ausserhalb des Dreiecks mit $u$ und $v$ 
definieren, mit der Formel $P = A + u dot arrow(A B) + v dot arrow(A C)$.

Wenn $u < 0$ oder $v < 0$ oder $u + v > 1$, dann weiss
man, dass ein Punkt ausserhalb des Dreiecks liegt (siehe @baryzentrische_koordinaten).


#figure(
  image("Baryzentrische Koordinate Erklärung.svg", width: 70%),
  caption: [Ein Beispiel für $u = 0.61$ und $v = 0.41$, das zeigt,
  dass ein Punkt mit $u+v > 1$ ausserhalb des Dreiecks liegt,
  in GeoGebra dargestellt.],
) <baryzentrische_koordinaten>


Der Möller-Trumbore-Algorithmus nutzt genau diese baryzentrischen Koordinaten,
um in vier Schritten zu überprüfen, ob ein Strahl ein Dreieck trifft.

Zuerst berechnet das Programm die beiden Kantenvektoren des Dreiecks $arrow(A B)$
und $arrow(A C)$ ausgehend vom ersten Eckpunkt $A$. Anschliessend wird
über das Kreuzprodukt und das Skalarprodukt die Determinante mit dieser Formel berechnet:

$ "det" = arrow(A B) dot (arrow(d) times arrow(A C)) $

Diese Zahl beschreibt geometrisch, wie schräg der 
Strahl zur Dreiecksfläche steht. Ist der Wert sehr nahe an Null, verläuft der
Strahl parallel zur Fläche des Dreiecks und kann es niemals schneiden.

Es wird dafür eine winzige Schranke namens $"Epsilon" = 0.0000001$
definiert. Um Rundungsfehler des Computers zu erkennen, prüft das Programm,
ob die Determinante zwischen $+"Epsilon"$ und $-"Epsilon"$ liegt, falls ja,
bricht die Funktion sofort ab, da kein Treffer  möglich ist.

Ist der Strahl nicht parallel, berechnet der Algorithmus die erste baryzentrische
Koordinate $u$. Die Formel dafür ist:

$ u = 1 / "det" dot (o - A) dot (arrow(d) times arrow(A C)) $

Das Programm prüft:
- Ist $u < 0$ oder $u > 1$, verfehlt der Strahl bereits die erste Begrenzung des
  Dreiecks. Das Programm bricht ab.

Liegt $u$ im gültigen Bereich, wird im nächsten Schritt die zweite baryzentrische Koordinate
$v$ ermittelt mit der Formel:

$  v = 1 / "det" dot arrow(d) dot ((o - A) times arrow(A B)) $

Hier folgt die Bedingung aus der Definition der baryzentrischen Koordinaten:

- Ist $v < 0$ oder ist die Summe aus $u + v > 1$, schiesst der Strahl über die dritte
  Kante des Dreiecks hinaus. Auch hier bricht das Programm direkt ab.

Hat der Strahl alle bisherigen Prüfungen bestanden, steht fest, dass er
die Fläche des Dreiecks durchdringt. Als Letztes muss nun berechnet werden,
wie weit der Treffpunkt von der Kamera entfernt ist mit der Formel:

$ "Distanz" = 1 / "det" dot arrow(A C) dot ((o - A) times arrow(A B)) $

Ist diese Distanz grösser als $"Epsilon"$, liegt der Schnittpunkt im
sichtbaren Bereich vor der Kamera. Ist die Distanz hingegen negativ, liegt
das Dreieck hinter dem Spieler und wird ignoriert.

Da ein Strahl in einer kompletten Szene mehrere Dreiecke hintereinander
durchdringen kann, speichert der Algorithmus für jeden Pixel den Treffer
mit der geringsten Distanz ab. Die Distanz bestimmt die Helligkeit des Pixels.

Durch dieses schrittweise Aussortieren spart der Algorithmus viel Rechenzeit,
da die aufwendigeren Rechnungen nur für jene Strahlen ausgeführt werden,
die das Dreieck tatsächlich treffen können.

Um den Code dafür zu schreiben, übersetzte ich den Code eines Wikipedia-Artikels
@raycasting_implementations von Java zu GDScript.




#pagebreak()


== Voxel-Ray-Traversal
Der Voxel-Ray-Traversal-Algorithmus, auch bekannt als der
Amanatides-Woo-Algorithmus @amanatides-woo, sendet ähnlich wie der Raycasting-Algorithmus
einen Strahl für jeden Pixel des Bildschirms aus. Jedoch nutzt er nicht
Dreiecke, sondern sogenannte volumetrische Pixel oder Voxel.
Um also diesen Algorithmus zu nutzen, muss
eine Szene als dreidimensionales Voxel-Gitter vorliegen.

Anstatt dass jeder ausgesendete Strahl bei allen Dreiecken der Szene 
überprüft, ob er ein Dreieck trifft, und dann berechnet, wie weit das getroffene
Dreieck ist, geht das Voxel-Ray-Traversal deutlich effizienter vor.
Es berechnet schrittweise alle Voxel des Gitters, durch die der Strahl verläuft, und
prüft für jeden einzelnen, ob er besetzt ist oder nicht.
Falls ja, stoppt der Strahl; falls nein, geht er weiter, bis er auf einen
besetzten Voxel trifft oder eine maximal definierte Anzahl an Schritten
erreicht hat.

Um die Strahlen zu berechnen, wird die genau gleiche Funktion
wie beim Raycasting-Algorithmus genutzt. Sie liefert
für die gewünschte Auflösung für jeden Pixel die
Richtung $arrow(d)$ des Strahles. Der Ursprung $o$ des Strahles ist weiterhin
die Position der Kamera.

Als Erstes muss das Programm wissen, in welchem Voxel des Gitters sich die Kamera
befindet. Dazu wird die Kameraposition $o$ durch die Grösse $g$ eines Voxels $V$
geteilt und anschliessend für jede Koordinate auf die nächste ganze Zahl abgerundet:

$ V = floor(o / g) $

Da der Algorithmus für jede Raumachse exakt gleich funktioniert und sich
theoretisch auf beliebig viele Dimensionen erweitern lässt, werden die
folgenden Schritte allgemein für eine beliebige Achse $i in {x, y, z}$
formuliert, anstatt sie für $x$, $y$ und $z$ getrennt aufzuführen.
Danach wird für jede Achse $i$ berechnet, wie weit der Strahl entlang seiner
Richtung laufen muss, um genau eine ganze Voxel-Einheit in diese Richtung zurückzulegen.
Dies ergibt sich aus dem Kehrwert der jeweiligen Richtungskomponente:

$ Delta_i = abs(1 / d_i) $

Ein Strahl kann sich entweder in positive oder negative Richtung bewegen, deswegen bestimmt der
Algorithmus für jede Achse die Schrittrichtung $S_i$ (entweder $+1$ bei positiver
Richtungskomponente $d_i > 0$ oder $-1$ bei negativer Richtungskomponente $d_i < 0$).
Als Nächstes wird der Abstand $L_i$ bis zur allerersten
Voxel-Grenze berechnet:

$ L_i = cases(
  (V_i + 1 - o_i / g) dot Delta_i & "falls " d_i > 0,
  (o_i / g - V_i) dot Delta_i & "falls " d_i < 0
) $

Nun beginnt der eigentliche Durchlauf in einer Schleife. In jedem Schritt vergleicht
der Algorithmus die aktuellen Grenzabstände $L_x$, $L_y$ und $L_z$ und wählt jene Achse aus,
deren folgende Voxel-Grenze am nächsten liegt (also den kleinsten Wert $L_i$ besitzt).
Entlang dieser Achse springt der Strahl in den benachbarten Voxel, indem die
Gitterkoordinate um die Schrittrichtung $S_i$ angepasst und der gesamte Grenzabstand
um die Schrittweite $Delta_i$ erhöht wird:

$ V_i = V_i + S_i wide "und" wide L_i = L_i + Delta_i $

Nach jedem Schritt prüft das Programm, ob der neu betretene Voxel $V$ in der Szene
als besetzt gespeichert ist. Sobald ein besetzter Voxel gefunden wird, bricht die
Schleife ab und die Distanz zwischen der Kameraposition und dem Mittelpunkt
dieses Voxels wird berechnet, um die Helligkeit des Pixels zu bestimmen.
Erreicht der Strahl stattdessen die maximal definierte Anzahl an Schritten
ohne Treffer, bricht die Schleife ebenfalls ab und der Pixel bleibt schwarz.

Der Algorithmus ist in zwei Dimensionen in @voxel-ray-traversal-erklärung abgebildet:

#figure(
  image("Voxel-Ray-Traversal Erklärung.svg", width: 100%),
  caption: [Voxel-Ray-Traversal in zwei Dimensionen
  dargestellt, die Kamera sendet einen Strahl aus und alle
  Quadrate, durch die der Strahl geht, sind grün. Die Grafik 
  wurde mit GeoGebra erstellt.],
) <voxel-ray-traversal-erklärung>


Zur Anschaulichkeit des Algorithmus diente zudem eine visuelle 
Erklärung auf YouTube @voxel_ray_traversal_video.







= Umsetzung in Godot
== Software-Architektur und Implementierung
Bei der Software-Architektur entschied ich mich für einen
objektorientierten Ansatz. Ich teilte meine Dateien so auf,
dass ich eine Haupt-Datei hatte, die die Renderer kontrollieren kann.
Diese Haupt-Datei war zuständig für die Kamerabewegung und Kamerarotation,
für das Weitergeben dieser Daten zu den Rendering-Algorithmen, den Input des Spielers
und das Benchmarking der verschiedenen Rendering-Algorithmen.
Die Dateien wurden mit einer Funktion als Instanz zu der Haupt-Datei angefügt.

Die Berechnungen für jeden Frame wurden mit der Godot-Funktion `_process(delta)`
durchgeführt. Delta ist die Zeit, die zwischen jedem Frame vergangen ist.
Jedes Mal, wenn ein neuer Frame erzeugt wird, ruft Godot automatisch die Funktion
`_process(delta)` auf. Alle Bewegungen, die zwischen den Frames berechnet werden,
werden mit der Variable `delta` multipliziert, da die Zeit (in diesem Fall `delta`)
multipliziert mit der Geschwindigkeit gleich der Strecke ist.

Der Vergleich zwischen Raycasting und Voxel-Ray-Traversal ist schwierig,
da sich strahlenbasierte Algorithmen, die einen Strahl pro Pixel berechnen,
nur bedingt direkt mit einem projektionsbasierten Verfahren wie dem
Wireframe-Rendering vergleichen lassen. Würde man die gleiche Auflösung wie beim
Wireframe einstellen, würden beide Algorithmen nicht schnell genug sein,
um spielbar zu sein.

Voxel-Ray-Traversal macht den Vergleich noch zusätzlich schwieriger, da
man die Voxelgrösse einstellen kann. Szenen, bei denen Raycasting und Wireframe
unzählige kleine Flächen zeigen müssen, werden für das Voxel-Ray-Traversal zu
Voxeln vereinfacht.

Der vollständige Quellcode des Projekts sowie alle nachfolgend beschriebenen 
Skripte sind öffentlich in einem GitHub-Repository unter https://github.com/kommeleon/matura
einsehbar.

Zusätzlich steht unter https://kommeleon.github.io/matura_web/ eine ausführbare Web-Version
des Programms zur Verfügung.


== Testaufbau
=== Aufbau Szenen in Blender
Um die Rendering-Algorithmen zu testen, modellierte ich zunächst drei Szenen
in Blender @blender und exportierte sie mithilfe des Blender-Python-Moduls
in die für Godot benötigten Datenstrukturen. Der Code dafür wurde mithilfe
von KI @gemini geschrieben.

Insgesamt erstellte ich drei Szenen in Blender, die verschiedene Ziele hatten.

+ Die erste Szene besteht aus 12 Objekten und ist ein Raum mit mehreren Zielscheiben.
  Sie soll einem typischen Raum in einem First-Person-Shooter ähneln. Sie hat 144 Dreiecke
  und besteht nach der Voxelisierung (bei $g = 1.0$) aus 10'247 besetzten Voxeln.
  (siehe @Szene_1_Blender)
  #figure(
    image("Szene 1.png", width: 70%),
    caption: [Die erste Szene in Blender gerendert mit farbigen Flächen
    und den Kanten schwarz, um die Objekte besser zu erkennen. Ausserdem
    wurden zwei Wände und die Decke entfernt, um die Objekte zu sehen.],
  ) <Szene_1_Blender>

+ Die zweite hat quaderförmige Plattformen, die in der Luft schweben, um zu testen, wie
  gut die Renderer funktionieren, wenn es nur wenige simple Objekte in der Szene gibt.
  Sie hat 84 Dreiecke und besteht nach der Voxelisierung aus 686 besetzten Voxeln.
  (siehe @Szene_2_Blender)
  #figure(
    image("Szene 2.png", width: 60%),
    caption: [Die zweite Szene in Blender gerendert mit farbigen Flächen
    und den Kanten schwarz, um die Objekte besser zu erkennen.],
  ) <Szene_2_Blender>

+ Die dritte besteht aus Objekten mit vielen Eckpunkten, um zu testen, wie gut die
  Renderer komplexe Objekte anzeigen können. Sie hat 6'133 Dreiecke und besteht nach
  der Voxelisierung aus 20'295 besetzten Voxeln.
  (siehe @Szene_3_Blender)
  #figure(
    image("Szene 3.png", width: 70%),
    caption: [Die dritte Szene in Blender gerendert mit farbigen Flächen
    und den Kanten schwarz, um die Objekte besser zu erkennen.],
  ) <Szene_3_Blender>

=== Datenstrukturen der Szenen
Für alle drei Renderer werden verschiedene Datenstrukturen benötigt, damit die
Renderer funktionieren.

- Wireframe-Rendering: Pro Objekt ein Dictionary. Es hat eine Liste für alle Koordinaten der Eckpunkte
  und eine Liste mit den Listen von Indizes der Punkte in der Reihe, in der sie sich zu 
  einer Fläche verbinden. Wireframe-Rendering kann Polygone anzeigen, also können die Flächen
  aus beliebig vielen Punkten bestehen.

  Ein Quadrat würde im Code beispielsweise so aussehen:

  ```gdscript
  var Quadrat = {
  "punkte": [Vector3(0,0,0), Vector3(1,0,0), Vector3(1,1,0), Vector3(0,1,0)],
  "fläche": [[0, 1, 2, 3]]
  }
  ```

- Raycasting: Pro Objekt eine Liste, die Listen mit Grösse drei enthält.
  Da der hier verwendete Möller-Trumbore-Algorithmus nur mit Dreiecken 
  funktioniert, ist es effizienter, jeden
  Eckpunkt mehrere Male aufzuschreiben, anstatt eine weitere Liste mit Indizes
  zu haben. Die Reihenfolge, mit der sich die Dreiecke verbinden, ist auch
  irrelevant, da alle Dreiecke sich immer nur auf eine Art verbinden können.

  Ein Quadrat müsste als zwei Dreiecke gegeben werden und würde im Code
  beispielsweise so aussehen:

  ```gdscript
  var Quadrat = [
  [Vector3(0, 0, 0), Vector3(1, 0, 0), Vector3(1, 1, 0)],
  [Vector3(0, 0, 0), Vector3(0, 1, 0), Vector3(1, 1, 0)]
  ]
  ```

- Voxel-Ray-Traversal: Für dieses Verfahren muss die gesamte Szene als
  Voxel-Gitter vorliegen. Damit bei
  allen Renderern die gleiche Szene verglichen wird, programmierte ich
  mithilfe von KI @gemini einen "Voxelizer", also eine Funktion, die
  die Szene zu Voxeln umwandelt.
  Die Voxel werden in einem Dictionary gespeichert, welches pro besetztem
  Voxel einen dreidimensionalen ganzzahligen Vektor speichert
  (`Vector3i()` anstatt `Vector3()`). Ausserdem steht
  noch "`true`" als Wert für jeden Voxel gespeichert, damit man im Programm
  einfacher abfragen kann, ob ein Wert im Dictionary vorhanden ist.

  Ein Voxel würde im Code beispielsweise so aussehen:

  ```gdscript
  var Voxels = {Vector3i(0, 0, 0): true}
  ```


== Simulation
Damit alle drei Renderer unter exakt denselben Bedingungen getestet werden, wurde für
das Programm ein Aufnahme- und Benchmarking-System programmiert. Dieses wurde mithilfe
von KI @gemini erstellt, um die Aufzeichnungen und den CSV-Export umzusetzen.
Während einer Aufnahme speichert das Programm zu jedem Frame die aktuelle
Kameraposition, die Kamerarotation, die aktive Szene sowie den genauen Zeitstempel.

Beim anschliessenden Benchmark wird diese aufgezeichnete Kamerafahrt
nacheinander für alle drei Renderer automatisch abgespielt. Da die
Verfahren stark unterschiedliche Bildwiederholraten erreichen, erfolgt
die Wiedergabe zeitbasiert. Zwischen den gespeicherten Zeitstempeln
werden Position und Rotation der Kamera mithilfe linearer Interpolation berechnet.
So durchlaufen alle drei Renderer trotz abweichender FPS exakt dieselbe Kamerabahn
in derselben Zeit.

Das Programm wartet nach jedem Renderer-Wechsel drei Aufwärm-Frames
ab, bevor die eigentliche Messung startet, um den Wechsel zwischen den
Renderern in den Statistiken nicht fälschlicherweise als schlechte Leistung
zu erfassen. Die Bildwiederholrate wird fortlaufend alle $0.05$ Sekunden gespeichert,
um nicht zu viele Datenpunkte zu erzeugen (beim Wireframe-Rendering 
entstünden sonst teilweise über 1'000 Datenpunkte pro Sekunde). 
Die resultierenden Messwerte werden als CSV-Datei exportiert.

Die Aufnahme, die zur Auswertung der Daten genutzt wurde, findet man unter:

https://github.com/kommeleon/matura/blob/main/schriftlicher%20Bericht/Benchmarking_Process.mp4

Für den Benchmark wurden das Raycasting mit einer Auflösung von $20 times 35 = 700$ Strahlen
und das Voxel-Ray-Traversal mit $50 times 88 = 4'400$ Strahlen,
einer Voxelgrösse von $g = 1.0$ sowie einer maximalen Schrittzahl von $150$
Schritten pro Strahl konfiguriert.

#pagebreak()

= Ergebnisse
In den folgenden drei Diagrammen ist die gemessene Bildwiederholrate (FPS)
auf einer logarithmischen Skala über die Zeit (in Sekunden) für alle drei
Szenen dargestellt. Dabei entspricht @Szene_1 der ersten Szene (Raum mit Zielscheiben),
@Szene_2 der zweiten Szene (schwebende Quader) und @Szene_3 der dritten Szene (komplexe Objekte).
Die exakten statistischen Kennwerte wie Durchschnitts-FPS, Median, 5%- und 1%-Lows sowie die
Frame-Times sind zusätzlich in @tab:benchmark zusammengefasst. Die 5%- und 1%-Lows entsprechen
dabei dem 5. beziehungsweise 1. Perzentil: Sie geben den Grenzwert an, unter dem nur die
tiefsten 5% beziehungsweise 1% aller gemessenen FPS-Werte liegen, und machen kurze
Leistungseinbrüche sichtbar.

Da sich die Bildwiederholraten zwischen den Szenen stark unterscheiden, deckt die
logarithmische Y-Achse in den drei Diagrammen jeweils einen angepassten Wertebereich
ab ($10$ bis $1'000$ FPS in @Szene_1, $1$ bis $10'000$ FPS in @Szene_2 und $0.1$ bis
$100$ FPS in @Szene_3).

#figure(
  image("Szene 1.svg", width: 100%),
  caption: [Alle Renderer in einem logarithmischen Diagramm für die erste Szene.],
) <Szene_1>

#figure(
  image("Szene 2.svg", width: 100%),
  caption: [Alle Renderer in einem logarithmischen Diagramm für die zweite Szene.],
) <Szene_2>

#figure(
  image("Szene 3.svg", width: 100%),
  caption: [Alle Renderer in einem logarithmischen Diagramm für die dritte Szene.],
) <Szene_3>

#figure(
  table(
  columns: (auto, auto, 1fr, 1fr, 1fr, 1fr, 1.2fr, 1.2fr),
  align: (left, left, right, right, right, right, right, right),
  stroke: none,
  table.hline(),
  table.header(
    [*Renderer*], [*Szene*], [*Avg FPS*], [*Median P50*],
    [*5% Low P5*], [*1% Low P1*], [*Avg Frame Time (ms)*], [*99th Frame Time (ms)*]
  ),
  table.hline(stroke: 0.5pt),
    [Wireframe], [Szene 1], [468.516], [463.450], [429.830], [425.459], [2.134], [2.350],
    [Wireframe], [Szene 2], [966.502], [994.300], [784.330], [761.542], [1.035], [1.313],
    [Wireframe], [Szene 3], [38.687], [38.400], [28.300], [27.844], [25.849], [35.914],
  table.hline(stroke: 0.3pt + gray),
    [Raycasting], [Szene 1], [12.520], [12.500], [12.230], [12.186], [79.875], [82.061],
    [Raycasting], [Szene 2], [21.582], [21.600], [21.325], [21.300], [46.335], [46.948],
    [Raycasting], [Szene 3], [0.300], [0.300], [0.300], [0.300], [3333.333], [3333.333],
  table.hline(stroke: 0.3pt + gray),
    [Voxel-Ray-Traversal], [Szene 1], [43.310], [42.800], [41.300], [40.900], [23.089], [24.450],
    [Voxel-Ray-Traversal], [Szene 2], [9.704], [9.500], [8.800], [8.800], [103.055], [113.636],
    [Voxel-Ray-Traversal], [Szene 3], [16.368], [15.850], [14.400], [14.300], [61.096], [69.930],
  table.hline(),
  ),
  caption: [Benchmark-Ergebnisse der drei Rendering-Algorithmen über alle Szenen.],
) <tab:benchmark> 

Die Ergebnisse wurden mit folgendem System aufgenommen:
- Prozessor (CPU): AMD Ryzen 7 3800X (8 Kerne / 16 Threads, bis zu 4.56 GHz)
- Arbeitsspeicher (RAM): 32 GB, DDR4 3600 MT/s
- Grafikkarte (GPU): AMD Radeon RX 9070 XT (16 GB VRAM)
- Motherboard: ASUS ROG Strix B550-F Gaming
- Betriebssystem: Fedora Linux 45 (Linux Kernel 7.3)
- Entwicklungsumgebung: Godot Engine 4.7.2

#v(10pt)

@wireframe_screenshot zeigt, wie Wireframe-Rendering, @raycasting_screenshot zeigt, wie
Raycasting und @voxel-ray-traversal_screenshot zeigt, wie Voxel-Ray-Traversal
in Godot die dritte Szene rendern.

#figure(
	image("Wireframe Screenshot.jpg", width: 100%),
	caption: [Darstellung von Szene 3 mit dem Wireframe-Renderer in Godot.],
) <wireframe_screenshot>

#figure(
	image("Raycasting Screenshot.jpg", width: 100%),
	caption: [Darstellung von Szene 3 mit dem Raycasting-Renderer in 
  Godot ($20 times 35$ Strahlen).],
) <raycasting_screenshot>

#figure(
	image("Voxel-Ray-Traversal Screenshot.jpg", width: 100%),
	caption: [Darstellung von Szene 3 mit dem Voxel-Ray-Traversal-Renderer 
  in Godot ($50 times 88$ Strahlen, Voxelgrösse $g = 1.0$).],
) <voxel-ray-traversal_screenshot>



#pagebreak()



= Interpretation
== Vergleichende Analyse der Algorithmen
Wie zu erwarten war, übertraf das Wireframe-Rendering in allen drei Szenen die
beiden strahlenbasierten Verfahren deutlich. Der Grund dafür liegt im grundlegenden
Rechenaufwand. Beim Wireframe-Rendering müssen nur die Eckpunkte der Objekte
projiziert und beschnitten werden; strahlenbasierte Algorithmen müssen für jedes
einzelne Pixel eine eigene Schnittpunkt- oder Gitterberechnung durchführen.

Beim Vergleich der beiden strahlenbasierten Verfahren zeigt sich ein klarer Unterschied.
Beim Raycasting muss jeder Strahl gegen jedes Dreieck der Szene geprüft werden, wodurch
die Rechenzeit direkt mit der Dreiecksanzahl steigt. Beim Voxel-Ray-Traversal hingegen
hängt die Leistung primär davon ab, wie viele Gitterzellen ein Strahl durchqueren muss,
bis er auf einen besetzten Voxel trifft. 

In der geschlossenen ersten Szene (@Szene_1)
stoppen die Strahlen früh an den nahen Wänden, weshalb das Verfahren hier seine beste
Leistung erzielt. In der offenen zweiten Szene (@Szene_2) laufen viele Strahlen ins
Leere und müssen bis zur maximalen Anzahl von 150 Schritten berechnet werden,
bevor sie abbrechen. Dadurch sinkt die Bildwiederholrate des Voxel-Ray-Traversals
in Szene 2 auf $9.7$ FPS und liegt damit unter jener des Raycastings ($21.6$ FPS).

Ein direkter Vergleich der reinen FPS-Werte greift hier jedoch zu kurz, da die beiden
Verfahren für visuelle Erkennbarkeit mit unterschiedlichen Auflösungen
betrieben wurden ($700$ Strahlen beim Raycasting gegenüber $4'400$ Strahlen beim
Voxel-Ray-Traversal). Teilt man die durchschnittliche Frame-Time aus @tab:benchmark
durch die jeweilige Anzahl Strahlen, erhält man die Rechenzeit pro Strahl in @tab:per_ray:

#figure(
	table(
		columns: (auto, auto, 1fr, 1fr, 1fr),
		align: (left, right, right, right, right),
		stroke: none,
		table.hline(),
		table.header(
			[*Renderer*], [*Strahlen / Frame*], [*Szene 1 ($mu$s)*], [*Szene 2 ($mu$s)*], [*Szene 3 ($mu$s)*]
		),
		table.hline(stroke: 0.5pt),
		[Raycasting], [700], [114.1], [66.2], [4'761.9],
		[Voxel-Ray-Traversal], [4'400], [5.2], [23.4], [13.9],
		table.hline(),
	),
	caption: [Durchschnittliche Rechenzeit pro Strahl in Mikrosekunden ($mu$s),
  berechnet aus der durchschnittlichen Frame-Time (@tab:benchmark)
  geteilt durch die Strahlenanzahl.],
) <tab:per_ray>

Diese Normierung zeigt, dass der Voxel-Ray-Traversal-Algorithmus pro Strahl in allen
drei Szenen effizienter arbeitet als das klassische Raycasting. Selbst im ungünstigsten
Fall der offenen zweiten Szene benötigt er mit $23.4$ $mu$s pro Strahl fast dreimal
weniger Zeit als das Raycasting mit $66.2$ $mu$s pro Strahl. Der niedrigere absolute
FPS-Wert in Szene 2 entsteht somit ausschliesslich durch die mehr als sechsmal
höhere Strahlenauflösung.

Der enorme Leistungsunterschied zeigt sich am besten in der dritten Szene mit
6'133 Dreiecken (@Szene_3). Beim klassischen Raycasting bricht die Bildwiederholrate hier
auf unter 1 FPS ein. Der Grund dafür ist, dass bei
einer Auflösung von $20 times 35$ Strahlen 700 Pixel gerendert werden und in Szene 3
der Möller-Trumbore-Algorithmus daher für jeden einzelnen Frame
rund 4.3 Millionen ($700 dot 6'133 = 4'293'100$) Schnittpunktprüfungen
durchführen muss.

Dieser Zusammenhang lässt sich direkt an den Messdaten aus @tab:benchmark überprüfen:
Von Szene 1 (144 Dreiecke) zu Szene 3 (6'133 Dreiecke) steigt die Anzahl der Dreiecke
um den Faktor $(6'133) / 144 approx 42.6$. Die durchschnittliche Frame-Time beim
Raycasting steigt im gleichen Vergleich von $79.9$ ms auf $3'333$ ms, also um den
Faktor $(3'333) / 79.9 approx 41.7$. Auch beim Vergleich von Szene 2 (84 Dreiecke,
$46.3$ ms) mit Szene 1 (144 Dreiecke, $79.9$ ms) stimmen der Dreiecksfaktor ($1.71$)
und der Zeitfaktor ($1.72$) nahezu exakt überein. Die Messungen bestätigen somit,
dass die Rechenzeit beim klassischen Raycasting direkt proportional zur
Dreiecksanzahl der Szene wächst.

Das Wireframe-Rendering bricht in dieser Szene ebenfalls stark ein (auf ca. 38 FPS), da es
deutlich mehr Eckpunkte und Polygonflächen projizieren und gegebenenfalls
an der Near-Clipping-Plane zuschneiden muss.
Das Voxel-Ray-Traversal läuft in derselben Szene hingegen stabil bei 15 bis
20 FPS. Das ist deshalb bemerkenswert, weil es mit 4'400 Strahlen ($50 times 88$)
mit einer über sechsmal höheren Auflösung arbeitet als das
Raycasting. Da der Strahl im Voxel-Gitter beim ersten getroffenen Block sofort
stoppt, ist die Rechenzeit hier weniger abhängig
von der ursprünglichen Dreiecksanzahl der Szene. Die höhere Auflösung
beim Voxel-Renderer wurde gewählt, damit die gröbere Blockstruktur der
Voxel visuell erkennbar bleibt.

Ein Blick auf die 5%- und 1%-Lows in @tab:benchmark zeigt zudem, wie stabil die
einzelnen Verfahren laufen. Besonders für kompetitive First-Person-Shooter sind
konstante Frame-Times wichtig, da plötzliche Einbrüche als störende Ruckler
wahrnehmbar sind und die Zielgenauigkeit beeinträchtigen können. Beim
Wireframe-Rendering weichen die 1%-Lows teilweise spürbar vom Durchschnitt ab
(in Szene 3 sinken sie beispielsweise von $38.7$ FPS auf $27.8$ FPS), weil je nach
Blickrichtung unterschiedlich viele Flächen im Sichtfeld liegen und gezeichnet oder
an der Near-Clipping-Plane beschnitten werden müssen.

Beim Raycasting liegen Durchschnitt und 1%-Low dagegen fast auf demselben Niveau,
da jeder Strahl unabhängig von der Blickrichtung stets alle Dreiecke der Szene
prüft. In @Szene_3 fallen ausserdem zwei Besonderheiten auf: Der einzelne tiefe
Messpunkt des Voxel-Ray-Traversals ganz zu Beginn der dritten Szene (rund $1.4$ FPS)
entsteht dadurch, dass die Szene beim Wechsel einmalig voxelisiert werden muss, bevor das
normale Rendering läuft. Beim Raycasting erscheinen zudem nur sechs Messpunkte mit
konstant $0.3$ FPS, da ein einzelner Frame über drei Sekunden dauert.

Dieser Befund deckt sich mit wissenschaftlichen Vergleichsstudien aus der
Computergrafik, wie etwa der Arbeit von Laine und Karras über "Efficient
Sparse Voxel Octrees" @laine. Wie die Arbeit zeigt, skaliert
die Rechenzeit von projektionsbasierten Verfahren wie dem
Wireframe-Rendering direkt mit der geometrischen Komplexität der Szene, also
der Anzahl der Polygone, während Voxel-Traversal-Verfahren am meisten von der
Bildschirmauflösung und der zurückgelegten Schrittweite abhängen, jedoch
nahezu unabhängig von der ursprünglichen Polygonanzahl arbeiten.

Ein Beispiel hierfür sind blockbasierte Spiele wie
Minecraft oder die vollständig auf Voxel-Raytracing basierende Spiel-Engine
von Teardown @gustafsson. Besteht eine Spielwelt aus zahlreichen
einzelnen Würfeln, muss ein reiner Wireframe-Renderer ohne
zusätzliche Optimierungen für jeden einzelnen Würfel sechs Seitenflächen
oder zwölf Dreiecke und deren Kanten im Raum projizieren.
Beim Voxel-Ray-Traversal hingegen entspricht jeder Block exakt einem einzigen
Eintrag im Gitter, und es spielt für die Rechenzeit keine Rolle, ob sich hinter
einer getroffenen Wand hunderte weitere Blöcke befinden: Sobald der Strahl
gemäss dem Amanatides-Woo-Algorithmus auf den ersten besetzten Voxel trifft,
bricht die Schleife sofort ab. Dadurch müssen verdeckte Blöcke gar nicht erst
verarbeitet werden.

Angesichts der Messergebnisse stellt sich die Frage, weshalb rechenintensive Verfahren
wie Raycasting oder Voxel-Ray-Traversal überhaupt in Betracht gezogen werden, wenn das
Wireframe-Rendering um ein Vielfaches performanter ist. Der entscheidende Nachteil des
reinen Wireframe-Renderings liegt jedoch in seiner Darstellungsform. Es projiziert
lediglich die Kanten von Objekten und erzeugt ein durchsichtiges Drahtgittermodell, ohne
dass andere Objekte verdeckt werden, wie in @wireframe_screenshot. Strahlenbasierte
Verfahren hingegen liefern für jedes Pixel exakte Informationen über die
getroffene Oberfläche und zeigen nur die Objekte, die für den Spieler sichtbar sind
(siehe @raycasting_screenshot und @voxel-ray-traversal_screenshot). Dabei wird jedoch
der Kompromiss zwischen Auflösung und Rechenzeit deutlich: Beim Raycasting sind feine
Strukturen wie der Baum aufgrund der tiefen Auflösung kaum noch erkennbar, während das
Voxel-Ray-Traversal zwar klare Umrisse liefert, Details aber durch die Voxelgrösse
$g = 1.0$ vergröbert.

Moderne Spiel-Engines lösen dieses Verdeckungsproblem des reinen
Wireframe-Renderings in der Regel nicht durch vollflächiges Raycasting,
sondern durch sogenannte Rasterisierung @marschner-shirley. Dabei werden
die Eckpunkte der Dreiecke zunächst genau wie beim Wireframe-Rendering auf
die zweidimensionale Bildschirmfläche projiziert, anschliessend
flächig mit Pixeln ausgefüllt. Es speichert für jedes
Pixel die bisher geringste Distanz zur Kamera, sodass näher liegende Objekte
weiter entfernte korrekt verdecken. Auf diese Weise verbindet die
Rasterisierung die hohe Geschwindigkeit projektionsbasierter Verfahren mit
einer vollständigen Bilddarstellung.

Zudem basiert die mathematische Schnittpunktberechnung des Raycastings (wie der Möller-Trumbore-
Algorithmus, der hier genutzt wurde) auf demselben Prinzip, das in Spiel-Engines für die physikalische
Kollisionsabfrage verwendet wird, beispielsweise um Bahnen von Projektilen (auch als
Hitscan bekannt) zu berechnen oder den Bodenabstand einer Spielfigur zu ermitteln.
In der Praxis werden solche Techniken daher oft getrennt kombiniert: Die visuelle
Geometrie wird projiziert und rasterisiert, während Raycasting gezielt für
die Interaktion mit der Umgebung eingesetzt wird.



== Limitationen der Godot Implementierung
Beim Vergleich der FPS-Werte gibt es Limitationen bei der Implementierung, die
berücksichtigt werden müssen. Die wichtigste ist, dass alle Implementierungen
in der Programmiersprache GDScript geschrieben worden sind. GDScript-Code
wird auf der CPU ausgeführt, was bei Algorithmen für Grafik besonders
ineffizient ist. Das ist auch der Grund, weshalb Computer eine Grafikkarte
haben, die dafür gemacht ist, tausende Pixel parallel zu
berechnen. Grafik-Algorithmen in modernen Videospielen werden entweder in
maschinennahen Programmiersprachen wie C++ oder Rust programmiert oder
über sogenannte Shader direkt auf der Grafikkarte berechnet.

Ausserdem musste aus Leistungsgründen die Bildschirmauflösung beim Raycasting
und beim Voxel-Ray-Traversal arbiträr gewählt werden, da bereits bei 480p
($640 times 480$ Pixel) über 300'000 Strahlen pro 
Frame auf der CPU berechnet werden müssten, was keine flüssige 
Bildwiederholrate mehr erlaubt.

Da die drei Algorithmen qualitativ unterschiedliche Darstellungen erzeugen,
wurden die Strahlenauflösungen ($20 times 35$ beim Raycasting gegenüber
$50 times 88$ beim Voxel-Ray-Traversal) sowie die Voxelgrösse als Kompromiss
zwischen visueller Erkennbarkeit und Spielbarkeit gewählt. Dennoch
zeigen die relativen Leistungsverläufe über die drei Szenen hinweg präzise auf,
wie unterschiedlich die Algorithmen auf verschiedene Arten von Räumen reagieren.

#pagebreak()

= Zusammenfassung und Schlusswort

Das Ziel dieser Maturitätsarbeit war es, das Laufzeitverhalten und die
Effizienz von drei grundlegend verschiedenen 3D-Rendering-Algorithmen,
Wireframe-Rendering, Raycasting und Voxel-Ray-Traversal, in der
Spiel-Engine Godot zu untersuchen und deren Eignung für den praktischen
Einsatz in First-Person-Shootern zu beurteilen. Dazu wurden alle drei
Algorithmen in GDScript implementiert, wobei bewusst auf
die vorgefertigten 3D-Funktionen der Engine verzichtet und ausschliesslich
mit mathematischen Projektions- bzw. Schnittpunktberechnungen
gearbeitet wurde. Um einen objektiven und reproduzierbaren
Vergleich zu gewährleisten, wurde eine aufgezeichnete
Kamerafahrt über drei unterschiedlich
aufgebaute Testszenen abgespielt: einen typischen geschlossenen FPS-Raum
(144 Dreiecke), eine offene Szene mit schwebenden Quadern (84 Dreiecke) und
eine geometrisch hochkomplexe Szene (6'133 Dreiecke). Die Auswertung
der Messergebnisse erlaubt eine klare Beantwortung der zentralen Fragestellung:

- Wireframe-Rendering erwies sich in einfachen bis mittelschweren Szenen mit
  Abstand als das schnellste Verfahren (es erreichte bis über 1000 FPS), da lediglich die
  Eckpunkte der Polygone projiziert und an der Near-Clipping-Plane mittels des
  Sutherland-Hodgman-Algorithmus beschnitten werden müssen. Allerdings skaliert
  die Rechenlast direkt mit der Anzahl der Kanten, weshalb die Leistung in der
  dritten Szene stark einbrach. Zudem liefert das Verfahren durch die fehlende
  Verdeckungsberechnung nur ein durchsichtiges Drahtgittermodell, was es als
  alleinigen Renderer für moderne Spiele ungeeignet macht.

- Raycasting auf Basis des Möller-Trumbore-Algorithmus liefert zwar
  Tiefeninformationen der Dreiecksflächen, skaliert jedoch extrem schlecht
  mit einer steigenden Polygonanzahl, da jeder Strahl
  mit jedem Dreieck der Szene verglichen werden muss. In einem FPS-Spiel
  eignet sich dieser Ansatz daher nicht für das Bild-Rendering
  auf der CPU, ist aber für einzelne gerichtete Abfragen, wie etwa präzise
  Schussberechnungen oder Sichtlinienprüfungen, unverzichtbar.

- Voxel-Ray-Traversal nach Amanatides und Woo zeigte seine grösste Stärke
  in geschlossenen Räumen sowie bei komplexer Geometrie. Da die
  Szene ein dreidimensionales Gitter ist, ist die Laufzeit
  während des Renderings wenig abhängig von der Anzahl Voxel,
  sondern vielmehr vom Abstand des Spielers zu den Voxeln,
  da die Strahlen früher stoppen. Es war deswegen trotz höherer Auflösung
  als Raycasting um ein Vielfaches schneller. Einzig in
  grossen, leeren Räumen (Szene 2) verliert der Algorithmus an Effizienz, weil
  Strahlen sehr viele leere Gitterzellen durchschreiten müssen, bevor sie
  abbrechen.

Rückblickend hat sich mein zu Beginn gesetztes Ziel, die Werkzeuge hinter
modernen Spiel-Engines durch eigenes Programmieren von Grund auf zu verstehen,
ganz erfüllt. Die grösste Herausforderung bestand darin, die
mathematische Theorie der drei Algorithmen, insbesondere das Clipping hinter
der Kamera, in Code zu übersetzen und zu versuchen, einen fairen Vergleich
zwischen den Algorithmen zu schaffen.

Für weiterführende Arbeiten wäre es besonders spannend, diese Algorithmen als
Shader direkt auf die Grafikkarte (GPU) auszulagern oder die
strahlenbasierten Algorithmen wie Raycasting mit einer hierarchischen
Datenstruktur wie einer Bounding Volume Hierarchy (BVH) oder
bei Voxel-Ray-Traversal mit einem sogenannten Sparse Voxel Octree zu
kombinieren, um zu untersuchen, wie stark sich die Bildwiederholrate
bei hohen Auflösungen weiter steigern lässt.



#pagebreak()
#bibliography("quellen.bib")

