extends Node2D

enum CARD_STATE { HIDDEN, ROTATING, SHOWING, REMOVING }
enum CARD_TYPE { CARD_ROAD, CARD_CITY, CARD_STORM, CARD_QUAKE, CARD_PLAGUE, CARD_HEAT, CARD_METEOR, CARD_TSUNAMI, CARD_BEAR, CARD_FIRE }

var state = HIDDEN
var custom_next = false
var current_card = CARD_ROAD

var card_probabilities = {
	CARD_ROAD: 4,
	CARD_CITY: 4,
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
	match card:
		CARD_ROAD:
			$"/root/Root/Game".activate_road_building(true)
			custom_next = true
		CARD_CITY:
			$"/root/Root/Game".activate_city_building(true)
			custom_next = true
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
			if not custom_next:
				remove_card()
		REMOVING:
			return

func remove_card():
	$Viewport/Card.start_remove()
	custom_next = false
	state = REMOVING
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

func _ready():
	randomize()
	$"/root/Root/Game".connect("road_built", self, "_on_road_built")
	$"/root/Root/Game".connect("city_built", self, "_on_city_built")
