extends Node

signal road_built
signal city_built

export var city_count = 5
export var min_dist = 200

var Road = preload("res://Road.tscn")
var City = preload("res://City.tscn")

var selection = null
var road_building_active = false
var city_building_active = false

func activate_road_building(active):
	road_building_active = active

func activate_city_building(active):
	city_building_active = active

func create_city(x, y):
	var city = City.instance()
	city.position.x = x
	city.position.y = y
	$Cities.add_child(city)
	return city
	
func city_dist(x, y):
	var res = 0x3fffffff
	var vec2 = Vector2(x, y)
	for child in $Cities.get_children():
		res = min(res, vec2.distance_to(child.position))
	return res

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
	var success = create_road(selection, city)
	if success:
		emit_signal("road_built")
	selection = null

func _ready():
	randomize()
	var added_cities = []
	for i in range(city_count):
		var x
		var y
		var no_whiletrue = 0
		while true:
			x = randi() % 750 + 250
			y = randi() % 500 + 100
			no_whiletrue += 1
			if city_dist(x, y) > min_dist or no_whiletrue > 1000:
				break
		var city = create_city(x, y)
		added_cities.append(city)
	for a in added_cities:
		for b in added_cities:
			if a != b:
				create_road(a, b)