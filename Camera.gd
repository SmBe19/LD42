extends Camera2D

func _process(delta):
	position = get_global_mouse_position()

func update_camera_limits():
	var minx = 0x3fffffff
	var maxx = -0x3fffffff
	var miny = 0x3fffffff
	var maxy = -0x3fffffff
	for city in $"../Game/Cities".get_children():
		minx = min(minx, city.position.x)
		maxx = max(maxx, city.position.x)
		miny = min(miny, city.position.y)
		maxy = max(maxy, city.position.y)
	limit_left = minx - 1000
	limit_right = maxx + 1000
	limit_top = miny - 500
	limit_bottom = maxy + 500