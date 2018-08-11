extends Node2D

enum CARD_STATE { HIDDEN, ROTATING, SHOWING, REMOVING }
enum CARD_TYPE { CARD_ROAD, CARD_CITY, CARD_STORM, CARD_QUAKE, CARD_PLAGUE, CARD_HEAT, CARD_METEOR, CARD_TSUNAMI, CARD_BEAR, CARD_FIRE }

var state = HIDDEN
var current_card = CARD_ROAD

var current_event = null
var allow_city = false
var allow_road = false
var pop_kill_abs = 0
var pop_kill_rel = 0
var event_score = 0

var card_probabilities = {
	CARD_ROAD: 3,
	CARD_CITY: 3,
	CARD_STORM: 1,
	CARD_QUAKE: 1,
	CARD_PLAGUE: 1,
	CARD_HEAT: 1,
	CARD_METEOR: 1,
	CARD_TSUNAMI: 1,
	CARD_BEAR: 1,
	CARD_FIRE: 1,
}

var card_textures = {
	CARD_ROAD: preload("res://img/card_road.png"),
	CARD_CITY: preload("res://img/card_city.png"),
	CARD_STORM: preload("res://img/card_storm.png"),
	CARD_QUAKE: preload("res://img/card_quake.png"),
	CARD_PLAGUE: preload("res://img/card_plague.png"),
	CARD_HEAT: preload("res://img/card_heat.png"),
	CARD_METEOR: preload("res://img/card_meteor.png"),
	CARD_TSUNAMI: preload("res://img/card_tsunami.png"),
	CARD_BEAR: preload("res://img/card_bear.png"),
	CARD_FIRE: preload("res://img/card_fire.png"),
}

var card_icons = {
	CARD_ROAD: preload("res://img/new_road.png"),
	CARD_CITY: preload("res://img/new_city.png"),
	CARD_STORM: preload("res://img/icon_storm.png"),
	CARD_QUAKE: preload("res://img/icon_quake.png"),
	CARD_PLAGUE: preload("res://img/icon_plague.png"),
	CARD_HEAT: preload("res://img/icon_heat.png"),
	CARD_METEOR: preload("res://img/icon_meteor.png"),
	CARD_TSUNAMI: preload("res://img/icon_tsunami.png"),
	CARD_BEAR: preload("res://img/icon_bear.png"),
	CARD_FIRE: preload("res://img/icon_fire.png"),
}

func do_card_action(card):
	$"/root/Root/Game".activate_item_preview(true)
	
	current_event = card
	allow_city = true
	allow_road = false
	pop_kill_abs = 5
	pop_kill_rel = 0
	event_score = 0

	match card:
		CARD_ROAD:
			$"/root/Root/Game".activate_road_building(true)
		CARD_CITY:
			$"/root/Root/Game".activate_city_building(true)
		CARD_STORM:
			pop_kill_rel = 0.05
			event_score = 0.2
		CARD_QUAKE:
			allow_road = true
			pop_kill_rel = 0.1
			event_score = 0.8
		CARD_PLAGUE:
			pop_kill_rel = 0.7
			event_score = 1.4
		CARD_HEAT:
			pop_kill_abs = 20 + randi() % 10
			event_score = 0.1
		CARD_METEOR:
			allow_road = true
			pop_kill_abs = 50 + randi() % 20
			event_score = 0.2
		CARD_TSUNAMI:
			allow_road = true
			pop_kill_abs = 20 + randi() % 10
			event_score = 0.8
		CARD_BEAR:
			pop_kill_rel = 0.2
			pop_kill_abs = 75 + randi() % 25
			event_score = 0.4
		CARD_FIRE:
			pop_kill_rel = 0.4
			event_score = 0.8
		_:
			print("do card action: ", card)

func choose_card():
	var rval = randf()
	var probsum = 0
	for typ in CARD_TYPE.values():
		probsum += card_probabilities[typ]
	rval *= probsum
	for typ in CARD_TYPE.values():
		if rval <= card_probabilities[typ]:
			if typ == CARD_ROAD and not can_build_road():
				rval -= card_probabilities[typ]
				continue
			$Viewport/Card.set_card_image(card_textures[typ])
			$"/root/Root/Game/ItemPrototype/Sprite".texture = card_icons[typ]
			return typ
		rval -= card_probabilities[typ]

func can_build_road():
	var c = $"/root/Root/Game/Cities".get_child_count()
	var r = $"/root/Root/Game/Roads".get_child_count()
	return (c * (c-1))/2 != r

func _on_Button_pressed():
	match state:
		HIDDEN:
			current_card = choose_card()
			do_card_action(current_card)
			$Viewport/Card.start_rotation()
			state = ROTATING
		ROTATING:
			return
		SHOWING:
			return
		REMOVING:
			return

func remove_card():
	$Viewport/Card.start_remove()
	state = REMOVING
	allow_city = false
	allow_road = false
	$"/root/Root/Game".activate_item_preview(false)

func _on_Card_finished_removing():
	state = HIDDEN

func _on_Card_finished_rotating():
	state = SHOWING
	
func _on_road_built():
	$"/root/Root/Game".activate_road_building(false)
	remove_card()

func _on_city_built():
	$"/root/Root/Game".activate_city_building(false)
	$"/root/Root/Camera".update_camera_limits()
	remove_card()

func _on_city_clicked(city):
	if allow_city:
		var pop = city.population
		pop -= pop_kill_abs
		pop -= pop_kill_rel * pop
		city.population = max(0, pop)
		city.event_score += event_score
		city.events.append(current_event)
		remove_card()

func _on_road_clicked(road):
	if allow_road:
		road.queue_free()
		remove_card()

func _ready():
	randomize()
	$"/root/Root/Game".connect("road_built", self, "_on_road_built")
	$"/root/Root/Game".connect("city_built", self, "_on_city_built")
	$"/root/Root/Game".connect("city_clicked", self, "_on_city_clicked")
	$"/root/Root/Game".connect("road_clicked", self, "_on_road_clicked")
