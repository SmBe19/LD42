extends Camera2D

export var speed = 400.0

signal updated_camera_limits

func _process(delta):
	var vp = get_viewport_rect().size
	var pos = get_local_mouse_position()
	var x = (pos.x / float(vp.x)) * 2 - 1
	var y = (pos.y / float(vp.y)) * 2 - 1
	if x < -drag_margin_left:
		position.x -= delta * speed
	if x > drag_margin_right:
		position.x += delta * speed
	if y < -drag_margin_top:
		position.y -= delta * speed
	if y > drag_margin_bottom:
		position.y += delta * speed


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
	emit_signal("updated_camera_limits")