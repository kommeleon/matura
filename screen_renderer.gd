extends Node2D
var Ziel_1 = {
	'points': [Vector3(80.7073, 0.0030, 64.1592), Vector3(80.7073, 5.0770, 64.1592), Vector3(80.7073, 0.0030, 64.4974), Vector3(80.7073, 5.0770, 64.4974), Vector3(81.0456, 0.0030, 64.1592), Vector3(81.0456, 5.0770, 64.1592), Vector3(81.0456, 0.0030, 64.4974), Vector3(81.0456, 5.0770, 64.4974), Vector3(79.8764, 2.8000, 63.9183), Vector3(79.8764, 4.8000, 63.9183), Vector3(79.8764, 2.8000, 64.2027), Vector3(79.8764, 4.8000, 64.2027), Vector3(81.8764, 2.8000, 63.9183), Vector3(81.8764, 4.8000, 63.9183), Vector3(81.8764, 2.8000, 64.2027), Vector3(81.8764, 4.8000, 64.2027), Vector3(80.8764, 3.8000, 63.9183)],
	'faces': [[0, 1, 3, 2], [2, 3, 7, 6], [6, 7, 5, 4], [4, 5, 1, 0], [2, 6, 4, 0], [7, 3, 1, 5], [8, 9, 11, 10], [10, 11, 15, 14], [14, 15, 13, 12], [12, 16, 8], [10, 14, 12, 8], [15, 11, 9, 13], [8, 16, 9], [9, 16, 13], [16, 12, 13]]
}
var plane_010 = {
	'points': [Vector3(-34.6578, 0.0000, 0.7132), Vector3(34.6629, 0.0000, 0.7132), Vector3(-34.6578, 0.0000, 71.7887), Vector3(34.6629, 0.0000, 71.7887)],
	'faces': [[0, 1, 3, 2]]
}

var camera_pos = Vector3(0,3,0)
var camera_rot = Vector2(0,0)
var arrays_to_render = [Ziel_1, plane_010]
var speed = 5
var sensitivity = 5

func _camera_rot_2d():
	var basis = Basis().rotated(Vector3(0, 1, 0), camera_rot.y) # Rotation der Kamera nach links oder rechts
	basis = basis.rotated(basis.x, camera_rot.x) # Rotation der Kamera nach oben oder unten
	return basis
	
func _points_from_cam(points_3d: Array, camera_pos: Vector3) -> Array:
	var distance_points = []
	var basis = _camera_rot_2d()
	var cam_inverse = basis.inverse() # Sicht invertieren (nach links schauen, Sachen bewegen sich nach rechts)
	for point in points_3d: # Abstand messen von Punkten zur Kamera:
		var relative_vector = point - camera_pos
		distance_points.append(cam_inverse * relative_vector)
	return distance_points

func _clipping_behind_player(points_array,faces_array):
	var new_faces = []
	var new_points_array = points_array.duplicate()
	
	for face in faces_array:
		var all_points_visible = true
		for i in range(face.size()):
			if points_array[face[i]].z < 0.1:
				all_points_visible = false
		if all_points_visible:
			new_faces.append(face)
		else:
			var result = _calculate_interpolated_points(new_points_array,face)
			new_points_array = result["points_array"]
			new_faces.append(result["face"])
			
	return {
	"points_array": new_points_array,
	"faces_array": new_faces
	}


func _calculate_interpolated_points(points_array, face):
	var new_face = []
	var new_points_array = points_array.duplicate()
	
	# Mithilfe des Sutherland-Hodgman Algorithmus wird für jeder Punkt in faces_array mit seinen nächsten Punkt verglichen.
	# Da des Polygons in einer Richtung ablaufend (von A nach B) angeschaut werden, speichern sichtbare Kanten immer nur den Zielpunkt (B), um doppelte Punkte zu vermeiden.
	# Volle Erklärung: https://en.wikipedia.org/wiki/Sutherland%E2%80%93Hodgman_algorithm
	
	for i in range(face.size()):
		var point_a = points_array[face[i]]
		var point_b = points_array[face[(i + 1) % face.size()]]
		
		if point_a.z > 0.1 and point_b.z > 0.1: # Falls beide punkte sichtbar sind, kann man den Punkt B zu new_face hinzugefügt werden
			new_face.append(face[(i + 1) % face.size()])
			
		elif point_a.z > 0.1 and point_b.z < 0.1: # Falls ein der beiden Punkte nicht sichtbar ist
			# Man berechnet wo man den Polygon schneiden muss, indem man:
			var t = (0.1 - point_a.z) / (point_b.z - point_a.z) # t: der Prozent Abstand zwischen den Z-Werten Punkt A (0%), B (100%) und den Punkt wo man die Linie nicht mehr sehen kann.
			var new_point = point_a.lerp(point_b, t) # Die Koordinate des Punktes wo man die Linie nicht mehr sehene kann berechnet,
			new_points_array.append(new_point) # Den neu berechneten Punkt hinzufügt
			new_face.append(new_points_array.size() - 1)
			
		elif point_a.z < 0.1 and point_b.z > 0.1: # Man macht das gleiche wie beim vorherigen, ausser dass man noch den Punkt B hinzufügen muss.
			var t = (0.1 - point_a.z) / (point_b.z - point_a.z)
			var new_point = point_a.lerp(point_b, t)
			new_points_array.append(new_point)
			new_face.append(new_points_array.size() - 1)
			new_face.append(face[(i + 1) % face.size()])
			
	return {
	"points_array": new_points_array,
	"face": new_face
	}

func _3d_to_2d(points_3d: Array) -> Array:
	var converted_points = []
	for point in points_3d:
			var x_2d = point.x / point.z
			var y_2d = -point.y / point.z
			converted_points.append(Vector2(x_2d, y_2d))
	return converted_points


func _rendered_points(points_array,faces_array,camera_pos):
	# alle Funktionen auf die Punkte anwenden
	var result = _clipping_behind_player(_points_from_cam(points_array,camera_pos),faces_array)
	return {
		"points_array": _3d_to_2d(result["points_array"]),
		"faces_array": result["faces_array"]
}


func _input(event):
	if event is InputEventMouseMotion:
		camera_rot.y -= event.relative.x * sensitivity/-1000
		camera_rot.x += event.relative.y * sensitivity/1000
		camera_rot.x = clamp(camera_rot.x, -1.57, 1.57) # keine Überrotation


func _process(delta):
	var basis = Basis().rotated(Vector3(0, 1, 0), camera_rot.y) # Rotation der Kamera für Bewegung
	var forward = basis.z
	var side = basis.x
	
	# Bewegung in x und z:
	if Input.is_action_pressed("ui_up"):
		camera_pos.x += forward.x * speed * delta
		camera_pos.z += forward.z * speed * delta
	if Input.is_action_pressed("ui_down"):
		camera_pos.x -= forward.x * speed * delta
		camera_pos.z -= forward.z * speed * delta
	if Input.is_action_pressed("ui_left"):
		camera_pos.x -= side.x * speed * delta
		camera_pos.z -= side.z * speed * delta
	if Input.is_action_pressed("ui_right"):
		camera_pos.x += side.x * speed * delta
		camera_pos.z += side.z * speed * delta
	
	camera_pos.y = clamp(camera_pos.y, 3, 100) # Damit der Spieler nicht über den Boden gehen kann
	queue_redraw()

func _draw():

	var screen_center = get_viewport_rect().size / 2
	var scale_amount = 400.0
	var color = Color(1.0, 1.0, 1.0, 0.75)

	for array in arrays_to_render:
		var screen_points = []
		var points_to_draw = _rendered_points(array['points'], array['faces'], camera_pos)
		for i in points_to_draw["points_array"]:
			screen_points.append((i * scale_amount) + screen_center)
		
		for i in points_to_draw["faces_array"]:
			var face_points = []
			for index in i:
				face_points.append(screen_points[index])

			if face_points.size() >= 3: # Mindestens drei Vektoren für ein Polygon
				draw_polygon(face_points, [color])
				draw_polyline(face_points, color, 1, false)
