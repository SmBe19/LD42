extends Node2D

var neighbors = []
var population = 100
var attractivity = 0 setget set_attractivity

func set_attractivity(attr):
	attractivity = attr
	$Attractivity.value = attr

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
