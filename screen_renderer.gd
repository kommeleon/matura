extends Node2D
var cube = [Vector3(0,0,1),Vector3(0,0,2),Vector3(1,0,2),Vector3(1,0,1),Vector3(0,1,1),Vector3(0,1,2),Vector3(1,1,2),Vector3(1, 1, 1)]
var camera_pos = Vector3(0,0,0)
func _3d_to_2d(points_3d: Array) -> Array:
	var flat_points = []
	for point in points_3d:
		var z_safe = max(point.z, 0.01)
		var x_2d = point.x / z_safe
		var y_2d = point.y / z_safe
		flat_points.append(Vector2(x_2d, y_2d))
	return flat_points

func _points_from_cam(points_3d: Array, camera_pos: Vector3) -> Array:
	var distance_points = []
	for point in points_3d:
		var relative_vector = point - camera_pos
		distance_points.append(relative_vector)
	return distance_points
	
func _rendered_points(array,camera_pos):
	return _3d_to_2d(_points_from_cam(array,camera_pos))


func _process(delta):
	camera_pos.z += delta * 0.1
	camera_pos.x += delta * 0.1
	camera_pos.y += delta * 0.1
	queue_redraw()

func _draw():
	var points_to_draw = _rendered_points(cube, camera_pos)
	
	var screen_center = get_viewport_rect().size / 2
	var scale_amount = 200.0
	
	for p in points_to_draw:
		var final_pos = (p * scale_amount) + screen_center
		draw_circle(final_pos, 5.0, Color.WHITE)
