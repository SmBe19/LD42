extends Node2D

onready var bg = $"/root/Root/Game/GameBackground"

var neighbors = []
var population = 100 setget set_population
var age = 0.0
var events = []
var event_score = 0.0
var base_attractivity = 1.0
var attractivity = 1.0 setget set_attractivity, get_attractivity

func set_population(pop):
	population = pop
	$Population.text = str(round(pop))

func set_attractivity(attr):
	null.fail()

func _process(delta):
	age += delta
	$Attractivity.value = get_attractivity()

func get_attractivity():
	return (base_attractivity + 0.3 * neighbors.size() + log(10 + (age + sin(age)) / 10) - event_score - log(max(100,population)) + log(100) - log(10)) / 10.0

func connected(other):
	return other in neighbors

func _on_Button_pressed():
	$"../..".on_city_clicked(self)

func set_marked(marked):
	$Highlight.visible = marked

func _ready():
	bg.call_deferred('clear_trees', self, 160, 160)
	base_attractivity = randf() * 3 + 2
