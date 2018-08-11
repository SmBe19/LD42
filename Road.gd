extends Node2D

const flow_rate = 1

onready var bg = $"/root/Root/Game/GameBackground"

var city1 = null
var city2 = null

var distance

func init(city1, city2):
	self.position = 0.5 * (city1.position + city2.position)
	var diff = (city2.position - city1.position)
	self.rotation = diff.angle()
	distance = diff.length()

	$Sprite.region_rect.size.y = distance
	$Button.margin_left = -distance/2
	$Button.margin_right = distance/2 - 64

	self.city1 = city1
	self.city2 = city2
	city1.neighbors.push_back(city2)
	city2.neighbors.push_back(city1)

	$Cars.lifetime = distance / 100
	$Cars.process_material = $Cars.process_material.duplicate()
	$Cars.process_material.set_shader_param("dist", distance)

func queue_free():
	.queue_free()
	city1.neighbors.erase(city2)
	city2.neighbors.erase(city1)

func _ready():
	bg.call_deferred('clear_trees', self, distance, 80)

func _process(delta):
	var grad = city2.attractivity - city1.attractivity
	var pd = flow_rate * grad * delta
	pd = min(pd,  city1.population)
	pd = max(pd, -city2.population)
	city1.population -= pd
	city2.population += pd
	$Cars.process_material.set_shader_param("flow", 0.1 * pd / delta)


func _on_Button_pressed():
	$"../..".on_road_clicked(self)
