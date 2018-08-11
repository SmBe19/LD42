extends Node

signal road_built
signal city_built
signal city_clicked(city)
signal road_clicked(road)

export var city_count = 5
export var min_dist = 200

var Road = preload("res://Road.tscn")
var City = preload("res://City.tscn")

var population = 0 setget set_population

var selection = null
var road_building_active = false
var city_building_active = false

var init_cam_pos

func set_population(pop):
	population = pop
	$"/root/Root/HUD/FixHUD/Population/PopLabel".text = str(round(pop))

func activate_road_building(active):
	road_building_active = active

func activate_city_building(active):
	city_building_active = active

func activate_item_preview(active):
	$ItemPrototype.visible = active

func create_city(x, y):
	var city = City.instance()
	city.position.x = x
	city.position.y = y
	$Cities.add_child(city)
	return city

func get_nearest(city, omit):
	var mi = null
	var miv = 0x3fffffff
	for acity in $Cities.get_children():
		if acity == city or acity in omit:
			continue
		var dist = city.position.distance_to(acity.position)
		if dist < miv:
			miv = dist
			mi = acity
	return mi

func create_city_with_roads(x, y):
	var city = create_city(x, y)
	var mi1 = get_nearest(city, [])
	var mi2 = get_nearest(city, [mi1])
	create_road(city, mi1)
	create_road(city, mi2)
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
	print("connecting " + city1.name + " and " + city2.name)
	return true

func on_city_clicked(city):
	if not road_building_active:
		if selection != null:
			selection.set_marked(false)
			selection = null
		emit_signal("city_clicked", city)
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

func on_road_clicked(road):
	emit_signal("road_clicked", road)

func local_to_global(local):
	var cam = $"/root/Root/Camera".get_camera_screen_center()
	return local + cam - init_cam_pos

func _input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed():
			if city_building_active:
				var global = local_to_global(event.position)
				var x = global.x
				var y = global.y
				get_tree().set_input_as_handled()
				if city_dist(global.x, global.y) > min_dist:
					create_city_with_roads(global.x, global.y)
					emit_signal("city_built")
	elif event is InputEventMouseMotion:
		if city_building_active:
			var global = local_to_global(event.position)
			if city_dist(global.x, global.y) > min_dist:
				$ItemPrototype/Sprite.modulate = Color(1, 1, 1, 1)
			else:
				$ItemPrototype/Sprite.modulate = Color(0.8, 0.2, 0.2, 0.5)

func _ready():
	init_cam_pos = $"/root/Root/Camera".get_camera_screen_center()
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
				if randi() % 3 == 0:
					create_road(a, b)
	$"/root/Root/Camera".update_camera_limits()