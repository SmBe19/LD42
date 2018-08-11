extends Node

signal road_built
signal city_built

var Road = preload("res://Road.tscn")

var selection = null
var road_building_active = false
var city_building_active = false

func activate_road_building(active):
	road_building_active = active

func activate_city_building(active):
	city_building_active = active

func create_road(city1, city2):
	if not road_building_active:
		return false
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
	if not road_building_active:
		if selection != null:
			selection.set_marked(false)
			selection = null
		return
	if selection == null:
		selection = city
		city.set_marked(true)
		return
	selection.set_marked(false)
	if city == selection:
		selection = null
		return
	create_road(selection, city)
	emit_signal("road_built")
	selection = null
	