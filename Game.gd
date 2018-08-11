extends Node

var Road = preload("res://Road.tscn")

var selection = null

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func create_road(city1, city2):
	if city1.connected(city2):
		print("already connected")
		return false
	var road = Road.instance()
	road.init(city1, city2)
	$Roads.add_child(road)
	city1.attractivity += 0.3
	print("connecting " + city1.name + " and " + city2.name)
	return true

func on_city_clicked(city):
	if selection == null:
		selection = city
		city.set_marked(true)
		return
	selection.set_marked(false)
	if city == selection:
		selection = null
		return
	create_road(selection, city)
	selection = null
