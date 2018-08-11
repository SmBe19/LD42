extends Node2D


var city1 = null
var city2 = null

func init(city1, city2):
	self.position = 0.5 * (city1.position + city2.position)
	var distance = (city2.position - city1.position)
	self.rotation = distance.angle()
	self.scale.x = distance.length() / 64.0
	self.city1 = city1
	self.city2 = city2
	city1.neighbors.push_back(city2)
	city2.neighbors.push_back(city1)

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
