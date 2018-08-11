extends Sprite

const houses_small = [
	preload("res://img/hous_small_1.png"),
	preload("res://img/hous_small_2.png"),
	preload("res://img/hous_small_3.png"),
]

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.texture = houses_small[randi() % len(houses_small)]
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
