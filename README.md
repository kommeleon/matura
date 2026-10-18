# Maturitätsarbeit

## Option 1 Web

Ich habe mein Projekt auf Web Exportiert, falls man es ohne Download nutzen möchte.

Meiner Erfahrung nach funktioniert es am besten in Chromium basierten Browsern.

Es kann unter https://kommeleon.github.io/matura_web aufgerufen werden.

Wie es genutzt wird, wird weiter unten erklärt.

## Option 2 Desktop

### Download

Laden Sie sich die neueste Version der Godot Engine (derzeitig 4.7.2) auf https://godotengine.org/download herunter.

Drücken Sie auf den GitHub-Repository dieses Projektes oben rechts auf "Code" und dann auf "Download ZIP", wie im Screenshot gezeigt.

<img width="581" height="428" alt="image" src="https://github.com/user-attachments/assets/7082de6a-0194-48c8-9387-db674e0facca" />

&nbsp;

Extrahieren Sie anschliessend **nur** die Godot ZIP-Datei.

### Die Engine und das Projekt öffnen

Öffnen Sie die "Godot_v4.7.2-stable_win64.exe" (nicht die Datei mit "console" im Namen) Datei die sich im Godot Ordner befindet.

In der Godot Engine drücken Sie jetzt oben links auf "Import" und wählen die ZIP-Datei die Sie von GitHub installiert haben.

Dann können Sie im neuen Fenster sagen wo Sie möchten dass das Projekt installiert wird und können "Import" drücken.

Wenn Sie das Projekt dann importiert haben, können Sie unten links die verschiedenen Code-Dateien öffnen.

Im Ordner "renderers" findet man die einzelnen renderer und "screen_renderer.gd" ist die Datei die die renderer kontrolliert und zuständig für die Bewegung ist.

Da Godot nicht gut grosse Text-Dateien aushaltet kann man nur "screen_renderer.gd" anständig in Godot öffnen,
für die Dateien im "renderers" Ordner würde ich empfehlen sie in GitHub zu öffnen oder in einer IDE wie zum Beispiel Visual Studio Code
zu nutzen, weil man sonst zu lange braucht um die Dateien zu öffnen.

Um das Programm zu starten drücken Sie ganz oben rechts auf den Play-Knopf.

## Nutzen

Man bewegt sich mit WASD, die Szene wird mit der Eingabetaste geändert und der Renderer mit der Tabulatortaste.

Man bewegt sich nach oben und unten mit der Leertaste und die Umschalttaste.

Um die Renderer zu testen drückt man zuerst die R-Taste und nimmt die Bewegung und Änderung der Szene auf die man möchte.
Danach drück man die B-Taste und das Aufgenommene wird abgespielt. Die Bewegungen die ich genutzt habe um die Renderer zu
vergleichen ist schon geladen und wird abgespielt, falls man noch nichts aufgenommen hat und die B-Taste drückt.
Anschliessend hat man die Option eine .csv Datei mit den Daten lokal zu speichern.

Falls das Programm in Desktop am laufen ist, findet man sowohl die Aufnahme von Bewegungen und die .csv Datei im
Unterordner "Exportierte Daten".
