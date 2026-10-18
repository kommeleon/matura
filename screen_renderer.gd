extends Node2D

var camera_pos = Vector3(0, 3, 0)
var camera_rot = Vector2(0, 0)
var speed = 15
var sensitivity = 5
var frame_count = 0
var fps_sum = 0.0
var time_passed = 0.0
var scene = 0

var renderer = 0
var renderers = ["res://renderers/wireframe.gd", "res://renderers/raycast.gd","res://renderers/voxel_rasterizer.gd"]

var current_renderer

enum State {IDLE, RECORDING, BENCHMARKING}
var current_state = State.IDLE

var recorded_frames = []
var playback_index = 0
var benchmark_renderer_index = 0
var benchmark_results = {}

var recording_time = 0.0
var playback_time = 0.0
var time_since_last_sample = 0.0

var last_time_usec = 0

func _ready():
	last_time_usec = Time.get_ticks_usec() # Initialisiert die Systemuhr
	load_renderer(renderers[0]) # Den renderer starten
	load_recording() # Lädt die letzte Aufnahme der Bewegungen automatisch, falls vorhanden

func load_renderer(script_path: String):
	if current_renderer:
		current_renderer.queue_free() # Den alten renderer entfernen
	
	var RendererScript = load(script_path) # Die Datei laden
	current_renderer = RendererScript.new() 

	add_child(current_renderer) # Die Datei zur jetzigen Szene hinzufügen

func _input(event):
	# Manuelle Eingaben während des Benchmarks blockieren
	if current_state == State.BENCHMARKING:
		return
	
	if event is InputEventMouseMotion:
		camera_rot.y -= event.relative.x * sensitivity/-1000
		camera_rot.x += event.relative.y * sensitivity/1000
		camera_rot.x = clamp(camera_rot.x, -1.57, 1.57) # keine Überrotation
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Damit der Zeiger nicht aus dem Fenster gehen kann
	
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Wenn man Esc drückt kann man die Maus wieder frei bewegen
	
	if event.is_action_pressed("ui_accept"): # Enter für nächste Szene
		scene = (scene + 1) % current_renderer.arrays_to_render.size()
		# Bringt den Spieler am Startpunkt der jeweiligen Szene:
		if scene == 0:
			camera_pos = Vector3(0, 3, 0)
		if scene == 1:
			camera_pos = Vector3(45.5, 3, 0)
		if scene == 2:
			camera_pos = Vector3(135, 3, 0)
			
	if event.is_action_pressed("next_renderer"): # Tab für nächsten renderer
		renderer = (renderer + 1) % renderers.size()
		load_renderer(renderers[renderer])
	
	# Aufnahmesteuerung über Tasten
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("record"):
			if current_state == State.IDLE:
				start_recording()
			elif current_state == State.RECORDING:
				stop_recording()
		elif event.is_action_pressed("benchmark"):
			# Benötigt mindestens 2 Frames zum Interpolieren (lerp)
			if current_state == State.IDLE and recorded_frames.size() > 1:
				start_benchmark()

func _process(delta):
	# Anstatt delta Zeit nutzen um FPS zu berechnen nutzt man die System-Uhr, da
	# Godot delta auf 1/7 einer Sekunde beschränkt.
	var current_time_usec = Time.get_ticks_usec()
	var true_delta = (current_time_usec - last_time_usec) / 1000000.0
	last_time_usec = current_time_usec
	
	if current_state == State.BENCHMARKING:
		process_benchmark(true_delta)
	else:
		process_movement(true_delta)
		if current_state == State.RECORDING:
			record_current_frame()
			recording_time += true_delta # Zeit für den nächsten Frame erhöhen
	
	current_renderer.scene = scene
	
	calculate_fps(true_delta)
	
	# Die nötigen Variablen den renderer geben, damit er es rendern kann
	current_renderer.camera_pos = camera_pos
	current_renderer.camera_rot = camera_rot
	current_renderer.queue_redraw()

func calculate_fps(true_delta):
	var current_fps = 1.0 / true_delta
	frame_count += 1
	fps_sum += current_fps
	time_passed += true_delta

	if time_passed >= 0.5:
		var fps_avg = fps_sum / frame_count
		var status = "IDLE"
		if current_state == State.RECORDING: status = "RECORDING"
		elif current_state == State.BENCHMARKING: status = "BENCHMARKING"
		
		print("[%s] Average FPS: %f" % [status, fps_avg])
		time_passed = 0
		fps_sum = 0
		frame_count = 0

func process_movement(true_delta):
	var basis = Basis().rotated(Vector3(0, 1, 0), camera_rot.y) # Rotation der Kamera für Bewegung
	var forward = basis.z
	var side = basis.x
	
	# Bewegung in x und z:
	if Input.is_action_pressed("ui_up"):
		camera_pos += forward * speed * true_delta
	if Input.is_action_pressed("ui_down"):
		camera_pos -= forward * speed * true_delta
	if Input.is_action_pressed("ui_left"):
		camera_pos -= side * speed * true_delta
	if Input.is_action_pressed("ui_right"):
		camera_pos += side * speed * true_delta
	
	# Bewegung in y:
	if Input.is_action_pressed("up"):
		camera_pos.y += speed * true_delta
	if Input.is_action_pressed("down"):
		camera_pos.y -= speed * true_delta

# Aufnahme System
# Von KI(Gemini) geschrieben, da ich
# nicht weiss wie man Dateien ausserhalb von Godot
# in einem Programm bearbeitet und ich wollte,
# dass das System zum messen meines Programmes
# so gut wie möglich funktioniert.
func start_recording():
	current_state = State.RECORDING
	recorded_frames.clear()
	recording_time = 0.0
	print("-> Aufnahme gestartet...")

func stop_recording():
	current_state = State.IDLE
	save_recording()
	print("-> Aufnahme gestoppt. %d Frames gespeichert." % recorded_frames.size())

func record_current_frame():
	# Zeitstempel (t) hinzufügen, um später zwischen aufgenommenen Punkten zu interpolieren
	recorded_frames.append({
		"t": recording_time,
		"px": camera_pos.x, "py": camera_pos.y, "pz": camera_pos.z,
		"rx": camera_rot.x, "ry": camera_rot.y,
		"sc": scene
	})

func save_recording():
	if OS.has_feature("web"):
		# Falls in Web aufgenommen, die Aufnahme als Variable im RAM speichern.
		print("-> Web-Aufnahme beendet.")
		return 
		
	# Desktop: Im Projektordner dauerhaft speichern
	var dir = DirAccess.open("res://")
	
	var path = "res://Exportierte Daten/movement_record.json"
	
	# Datei löschen, bevor eine neue gespeichert wird
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(recorded_frames))
		file.close()
		print("-> Bewegung gespeichert unter: ", path)

func load_recording():
	# Lädt immer die vorgefertigte Datei aus dem Editor, falls vorhanden.
	# Im Web stellt dies sicher, dass bei jedem Neuladen der Seite der Original-Testlauf geladen wird.
	var path = "res://Exportierte Daten/movement_record.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var data = JSON.parse_string(file.get_as_text())
			if typeof(data) == TYPE_ARRAY:
				recorded_frames = data
				print("-> Vorgefertigte Aufnahme geladen. Bereit für Benchmark. (%d Frames)" % recorded_frames.size())
			file.close()
	else:
		print("-> Keine vorgefertigte Aufnahme gefunden unter: ", path)


# Benchmarking System
# Von KI(Gemini) geschrieben, da ich
# die verschiedenen Export-Systeme in
# Godot nicht kenne und eine Web-Version von
# meinen Programm haben wollte.
func start_benchmark():
	print("-> Benchmark gestartet! Bitte warten...")
	current_state = State.BENCHMARKING
	benchmark_renderer_index = 0
	playback_index = 0
	playback_time = 0.0
	time_since_last_sample = 0.0
	benchmark_results.clear()
	
	# Ersten Renderer einschalten
	renderer = benchmark_renderer_index
	load_renderer(renderers[benchmark_renderer_index])
	
	# FIX: Systemuhr direkt nach dem Ladevorgang zurücksetzen, damit kein riesiges true_delta entsteht!
	last_time_usec = Time.get_ticks_usec()

func process_benchmark(true_delta):
	playback_time += true_delta
	time_since_last_sample += true_delta
	
	# Index erhöhen, bis der aktuelle Zeitpunkt überschritten ist
	while playback_index < recorded_frames.size() - 1 and playback_time >= recorded_frames[playback_index + 1]["t"]:
		playback_index += 1
	
	if playback_index < recorded_frames.size() - 1:
		var frame_a = recorded_frames[playback_index]
		var frame_b = recorded_frames[playback_index + 1]
		
		var t_a = frame_a["t"]
		var t_b = frame_b["t"]
		
		# Gewichtung für die Interpolation berechnen (zwischen 0.0 und 1.0)
		var weight = 0.0
		if t_b > t_a:
			weight = (playback_time - t_a) / (t_b - t_a)
			
		# Kameraposition und Rotation interpolieren
		camera_pos = Vector3(
			lerp(frame_a["px"], frame_b["px"], weight),
			lerp(frame_a["py"], frame_b["py"], weight),
			lerp(frame_a["pz"], frame_b["pz"], weight)
		)
		camera_rot = Vector2(
			lerp(frame_a["rx"], frame_b["rx"], weight),
			lerp(frame_a["ry"], frame_b["ry"], weight)
		)
		scene = int(frame_a["sc"])

		# FPS des aktuellen Frames abspeichern mit Zeitstempel
		# Limitiert auf max. 20 Datenpunkte pro Sekunde, ansonsten wird die
		# Datei zu gross.
		if time_since_last_sample >= 0.05:
			time_since_last_sample = 0.0
			
			# Name des Renderers speichern
			var r_name = renderers[benchmark_renderer_index].get_file()
			if not benchmark_results.has(r_name):
				benchmark_results[r_name] = {}
			# Name der Szene speichern
			var s_name = "Scene_" + str(scene)
			if not benchmark_results[r_name].has(s_name):
				benchmark_results[r_name][s_name] = []
				
			# Speichere die Zeit und die FPS
			benchmark_results[r_name][s_name].append({
				"time": snapped(playback_time, 0.001), 
				"fps": snapped(1.0 / true_delta, 0.1)
			})
		
	else:
		# Nächster Renderer
		benchmark_renderer_index += 1
		if benchmark_renderer_index < renderers.size():
			playback_index = 0
			playback_time = 0.0
			time_since_last_sample = 0.0
			renderer = benchmark_renderer_index
			load_renderer(renderers[benchmark_renderer_index])
			
			# Systemuhr direkt nach dem Ladevorgang zurücksetzen, damit Godot Zeit hat um die Renderer zu laden.
			last_time_usec = Time.get_ticks_usec()
		else:
			export_benchmark_results()
			current_state = State.IDLE
			
			# Zurück zum Start-Renderer
			renderer = 0
			load_renderer(renderers[0])

func export_benchmark_results():
	# CSV Header
	var csv_string = "Renderer,Scene,Time,FPS\n"
	
	# Dictionary auslesen und in Zeilen umwandeln
	for r_name in benchmark_results.keys():
		for s_name in benchmark_results[r_name].keys():
			for data_point in benchmark_results[r_name][s_name]:
				# Format: wireframe.gd, Scene_1, 2.503, 60.0
				csv_string += "%s,%s,%f,%f\n" % [r_name, s_name, data_point["time"], data_point["fps"]]
	
	if OS.has_feature("web"):
		# 1. Browser-Download anfordern
		print("-> Web-Export erkannt. Starte CSV-Dateidownload im Browser...")
		var buffer = csv_string.to_utf8_buffer()
		JavaScriptBridge.download_buffer(buffer, "benchmark_results.csv")
		
		# 2. Fallback für Web
		var file = FileAccess.open("user://benchmark_results.csv", FileAccess.WRITE)
		if file:
			file.store_string(csv_string)
			file.close()
	else:
		# Desktop Editor Export
		var dir = DirAccess.open("res://")
		if not dir.dir_exists("Exportierte Daten"):
			dir.make_dir("Exportierte Daten")
			
		var path = "res://Exportierte Daten/benchmark_results.csv"
		
		# Alte Datei explizit löschen, damit sie im Editor überschrieben wird
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			file.store_string(csv_string)
			file.close()
			print("-> Benchmark beendet! Lokal überschrieben unter: ", path)
