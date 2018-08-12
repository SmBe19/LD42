extends Sprite

const trees = [
	preload("res://img/tree1.png"),
	preload("res://img/tree2.png"),
]

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var intersection_count = 0

func _ready():
	self.texture = trees[randi() % len(trees)]
	self.flip_h = randi() % 2 == 0
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
