extends Node2D
var cube = [Vector3(0,0,1), Vector3(0,0,2), Vector3(1,0,2), Vector3(1,0,1), Vector3(0,1,1), Vector3(0,1,2), Vector3(1,1,2), Vector3(1, 1, 1)]
var edges = [[0,1], [1,2], [2,3], [3,0],[4,5], [5,6], [6,7], [7,4],[0,4], [1,5], [2,6], [3,7]]
var camera_pos = Vector3(0,0,0)
var camera_rot = Vector2(0,0)
var speed = 1
var sensitivity = 5

func _camera_rot_2d():
	var basis = Basis().rotated(Vector3(0, 1, 0), camera_rot.y) # Rotation der Kamera nach links oder rechts
	basis = basis.rotated(basis.x, camera_rot.x) # Rotation der Kamera nach oben oder unten
	return basis

func _3d_to_2d(points_3d: Array) -> Array:
	var converted_points = []
	for point in points_3d:
		if point.z < 0.1: # Falls Punkt hinter Kamera, irgendswo hin teleportieren
			converted_points.append(Vector2(-10000, -10000))
		else:
			var x_2d = point.x / point.z
			var y_2d = point.y / point.z
			converted_points.append(Vector2(x_2d, y_2d))
	return converted_points

func _points_from_cam(points_3d: Array, camera_pos: Vector3) -> Array:
	var distance_points = []
	var basis = _camera_rot_2d()
	var cam_inv = basis.inverse() # Sicht invertieren (nach links schauen, sachen bewegen sich nach rechts
	for point in points_3d: # Abstand messen von Punkten zur Kamera:
		var relative_vector = point - camera_pos
		distance_points.append(cam_inv * relative_vector)
	return distance_points
	
func _rendered_points(array,camera_pos):
	# alle Funktionen auf die Punkte anwenden
	return _3d_to_2d(_points_from_cam(array,camera_pos))

func _input(event):
	if event is InputEventMouseMotion:
		camera_rot.y -= event.relative.x * sensitivity/-1000
		camera_rot.x -= event.relative.y * sensitivity/1000
		camera_rot.x = clamp(camera_rot.x, -1.57, 1.57) # keine Überrotation


func _process(delta):
	var basis = _camera_rot_2d() # Rotation der Kamera für Bewegung
	var forward = -basis.z 
	var side = basis.x
	if Input.is_action_pressed("ui_up"):
		camera_pos -= forward * speed * delta
	if Input.is_action_pressed("ui_down"):
		camera_pos += forward * speed * delta
	if Input.is_action_pressed("ui_left"):
		camera_pos -= side * speed * delta
	if Input.is_action_pressed("ui_right"):
		camera_pos += side * speed * delta
	
	queue_redraw()

func _draw():
	var points_to_draw = _rendered_points(cube, camera_pos)
	var screen_center = get_viewport_rect().size / 2
	var scale_amount = 200.0
	
	var screen_points = []
	for i in points_to_draw:
		screen_points.append((i * scale_amount) + screen_center)

	for i in edges:
		var p1 = screen_points[i[0]]
		var p2 = screen_points[i[1]]
		if p1.x > -5000 and p2.x > -5000:
			draw_line(p1, p2, Color.WHITE, 2.0)
