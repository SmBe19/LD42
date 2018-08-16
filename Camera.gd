extends Camera2D

export var speed = 400.0
export var drag_cutoff = 11
var pressed = [0, 0, 0, 0]
var ui_names = ["ui_left", "ui_right", "ui_up", "ui_down"]

var touch_down = false
var dragging = false
var drag_old_pos = Vector2(0, 0)

signal updated_camera_limits

func _process(delta):
	if not touch_down and OS.get_name() != "Android":
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
	
	position.x += (pressed[1] - pressed[0]) * delta * 2
	position.y += (pressed[3] - pressed[2]) * delta * 2

func _input(event):
	for i in range(ui_names.size()):
		if event.is_action_pressed(ui_names[i]):
			pressed[i] = speed
			get_tree().set_input_as_handled()
		elif event.is_action_released(ui_names[i]):
			pressed[i] = 0
			get_tree().set_input_as_handled()
	
	if OS.get_name() != "Android":
		if event is InputEventMouseButton:
			if event.is_pressed():
				touch_down = true
				dragging = false
				drag_old_pos = get_local_mouse_position()
			else:
				if dragging:
					get_tree().set_input_as_handled()
				touch_down = false
				dragging = false
		elif event is InputEventMouseMotion:
			if touch_down:
				var pos = get_local_mouse_position()
				if dragging:
					position += drag_old_pos - pos
					drag_old_pos = pos
				elif pos.distance_to(drag_old_pos) >= drag_cutoff:
					dragging = true
	
	if OS.get_name() == "Android":
		if event is InputEventScreenDrag:
			position -= event.relative
			drag_old_pos += event.relative
			if drag_old_pos.length() >= drag_cutoff:
				dragging = true
		elif event is InputEventMouseButton:
			if event.is_pressed():
				drag_old_pos = Vector(0, 0)
			else:
				if dragging:
					get_tree().set_input_as_handled()
				dragging = false

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