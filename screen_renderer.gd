extends Node2D

var camera_pos = Vector3(0,0,0)
var camera_rot = Vector2(0,0)
var speed = 15
var sensitivity = 5
var frame_count = 0
var fps_sum = 0.0
var time_passed = 0.0

var current_renderer

func _ready():
	load_renderer("res://wireframe.gd") # Den renderer starten

func load_renderer(script_path: String):
	if current_renderer:
		current_renderer.queue_free() # Den alten renderer entfernen
	
	var RendererScript = load(script_path) # Die Datei laden
	current_renderer = RendererScript.new() 

	add_child(current_renderer) # Die Datei zur jetzigen Szene hinzufügen

func _input(event):
	if event is InputEventMouseMotion:
		camera_rot.y -= event.relative.x * sensitivity/-1000
		camera_rot.x += event.relative.y * sensitivity/1000
		camera_rot.x = clamp(camera_rot.x, -1.57, 1.57) # keine Überrotation

	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Damit der Zeiger nicht aus dem Fenster gehen kann

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Wenn man Esc drückt kann man die Maus wieder Frei bewegen
	
	if event.is_action_pressed("ui_accept"):
		if current_renderer.scene == current_renderer.arrays_to_render.size():
			current_renderer.scene = 1
		else:
			current_renderer.scene += 1


func _process(delta):
	var basis = Basis().rotated(Vector3(0, 1, 0), camera_rot.y) # Rotation der Kamera für Bewegung
	var forward = basis.z
	var side = basis.x
	
	# Bewegung in x und z:
	if Input.is_action_pressed("move_forward"):
		camera_pos.x += forward.x * speed * delta
		camera_pos.z += forward.z * speed * delta
	if Input.is_action_pressed("move_backward"):
		camera_pos.x -= forward.x * speed * delta
		camera_pos.z -= forward.z * speed * delta
	if Input.is_action_pressed("move_left"):
		camera_pos.x -= side.x * speed * delta
		camera_pos.z -= side.z * speed * delta
	if Input.is_action_pressed("move_right"):
		camera_pos.x += side.x * speed * delta
		camera_pos.z += side.z * speed * delta

	var current_fps = 1.0 / delta
	frame_count += 1
	fps_sum += current_fps

	time_passed += delta
	if time_passed >= 0.5:
		var fps_avg = fps_sum / frame_count
		print("Average FPS: ", fps_avg)
		time_passed = 0
		fps_sum = 0
		frame_count = 0
	camera_pos.y = clamp(camera_pos.y, 3, 100) # Damit der Spieler nicht über den Boden gehen kann
	
	# Die nötigen Variablen den renderer geben, damit er es rendern kann
	current_renderer.camera_pos = camera_pos
	current_renderer.camera_rot = camera_rot
	current_renderer.queue_redraw()
