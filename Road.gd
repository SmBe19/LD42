extends Node2D

const flow_rate = 1

var city1 = null
var city2 = null

func init(city1, city2):
	self.position = 0.5 * (city1.position + city2.position)
	var distance = (city2.position - city1.position)
	self.rotation = distance.angle()
	
	$Sprite.scale.x = distance.length() / 64.0
	
	self.city1 = city1
	self.city2 = city2
	city1.neighbors.push_back(city2)
	city2.neighbors.push_back(city1)
	
	$Cars.lifetime = distance.length() / 100
	$Cars.process_material = $Cars.process_material.duplicate()
	$Cars.process_material.set_shader_param("dist", distance.length())

func _ready():
	

	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var grad = city2.attractivity - city1.attractivity
	var pd = flow_rate * grad * delta
	pd = min(pd,  city1.population)
	pd = max(pd, -city2.population)
	city1.population -= pd
	city2.population += pd
	print($Cars.process_material)
	$Cars.process_material.set_shader_param("density", 1.0-0.5*exp(-abs(pd)))
	pass
