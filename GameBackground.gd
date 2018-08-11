extends Node2D

const spacing = 100

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var Tree = preload("res://Tree.tscn")

var processed = Rect2(0,0,0,0)
onready var camera = $"/root/Root/Camera"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	camera.connect("updated_camera_limits", self, "on_updated_camera_limits")


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func on_updated_camera_limits():
	for xo in range(camera.limit_left - camera.limit_left % spacing, camera.limit_right, spacing):
		for yo in range(camera.limit_top - camera.limit_top % spacing, camera.limit_bottom, spacing):
			if processed.has_point(Vector2(xo, yo)):
				continue
			var x = xo + rand_range(-0.5*spacing, 0.5*spacing)
			var y = yo + rand_range(-0.5*spacing, 0.5*spacing)
			var tree = Tree.instance()
			tree.position = Vector2(x, y)
			add_child(tree)
	
	processed = Rect2(
		camera.limit_left,
		camera.limit_top,
		camera.limit_right - camera.limit_left,
		camera.limit_bottom - camera.limit_top)