extends Node2D

const House = preload("res://House.tscn")
const PHI = 0.5*(sqrt(5)+1)

onready var bg = $"/root/Root/Game/GameBackground"

onready var random_offset = rand_range(0, TAU)
var neighbors = []
var population = 20 setget set_population
var age = 0.0
var events = []
var event_score = 0.0
var base_attractivity = 1.0
var attractivity = 1.0 setget set_attractivity, get_attractivity

func set_population(pop):
	var pospop = max(0, pop)
	var diff = pospop - population
	population = max(0, pospop)
	$"/root/Root/Game".population += diff
	$Population.text = str(round(pop))
	var houses_req = pop / 30
	while $Houses.get_child_count() < houses_req:
		var house = House.instance()
		var i = $Houses.get_child_count() + 1
		var r = 10 * pow(i, 0.7)
		house.position = polar2cartesian(r, r*PHI + random_offset)
		$Houses.add_child(house)
		if i > 2:
			if randf() < 0.9:
				var hs = $Houses.get_child(randi() % (i / 2))
				print("upgrade ", hs)
				hs.upgrade()
				pass
			pass

func _process(delta):
	age += delta
	var attr = get_attractivity()
	self.population += self.population * attr * attr * delta * 0.01
	$Attractivity.value = attr
	$Highlight.scale = Vector2(1,1) * (10 * sqrt($Houses.get_child_count() + 1) + 20)

func set_attractivity(attr):
	null.fail()
	
func get_attractivity():
	return clamp((base_attractivity + 0.7 * neighbors.size() + log(10 + (age + sin(age)) / 7) - event_score - log(max(100,population)) + log(100) - log(10)) / 10.0, 0, 1)

func connected(other):
	return other in neighbors

func _on_Button_pressed():
	$"../..".on_city_clicked(self)

func set_marked(marked):
	$Highlight.visible = marked

func _ready():
	bg.call_deferred('clear_trees', self, 160, 160)
	base_attractivity = randf() * 3 + 2
	$"/root/Root/Game".population += population
	set_population(population + 1 + randi() % 130)
