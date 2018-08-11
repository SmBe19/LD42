extends Node2D

enum CARD_STATE { HIDDEN, ROTATING, SHOWING, REMOVING }
enum CARD_TYPE { CARD_ROAD, CARD_CITY }

var state = HIDDEN
var current_card = CARD_ROAD
export var card_probabilities = {
	CARD_ROAD: 0.5,
	CARD_CITY: 0.5,
}
var card_textures = {
	CARD_ROAD: preload("res://img/card_road.png"),
	CARD_CITY: preload("res://img/card_city.png"),
}

func do_card_action(card):
	match card:
		CARD_ROAD:
			$"../../Game".activate_road_building(true)
		CARD_CITY:
			$"../../Game".activate_city_building(true)

func choose_card():
	var rval = randf()
	var probsum = 0
	for typ in CARD_TYPE.values():
		probsum += card_probabilities[typ]
	rval *= probsum
	for typ in CARD_TYPE.values():
		if rval <= card_probabilities[typ]:
			$Viewport/Card.set_card_image(card_textures[typ])
			return typ
		rval -= card_probabilities[typ]


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
			remove_card()
		REMOVING:
			return

func remove_card():
	$Viewport/Card.start_remove()
	state = REMOVING

func _on_Card_finished_removing():
	state = HIDDEN

func _on_Card_finished_rotating():
	state = SHOWING
	
func _on_road_built():
	$"../../Game".activate_road_building(false)
	remove_card()

func _on_city_built():
	$"../../Game".activate_city_building(false)
	remove_card()

func _ready():
	randomize()
	$"../../Game".connect("road_built", self, "_on_road_built")
	$"../../Game".connect("city_built", self, "_on_city_built")
