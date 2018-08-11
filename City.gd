extends Node2D

var neighbors = []
var population = 100 setget set_population
var attractivity = 0 setget set_attractivity, get_attractivity

func set_population(pop):
	population = pop
	$Population.text = str(round(pop))
	
func set_attractivity(attr):
	print("no")
	attractivity = attr
	$Attractivity.value = attr

func get_attractivity():
	return attractivity - log(max(100,population)) + log(100)

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func connected(other):
	return other in neighbors

func _on_Button_pressed():
	$"../..".on_city_clicked(self)

func set_marked(marked):
	$Highlight.visible = marked
	pass
