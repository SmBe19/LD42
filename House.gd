extends Sprite

const houses_small = [
	preload("res://img/hous_small_1.png"),
	preload("res://img/hous_small_2.png"),
	preload("res://img/hous_small_3.png"),
]

const houses_big = [
	preload("res://img/House_large_1.png"),
]

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.texture = houses_small[randi() % len(houses_small)]
	self.offset.y = -self.texture.get_height() / 2
	pass

func upgrade():
	self.texture = houses_big[randi() % len(houses_big)]
	self.offset.y = -self.texture.get_height() / 2
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
