extends Node2D

enum CARD_STATE { HIDDEN, ROTATING, SHOWING, REMOVING }
enum CARD_TYPE { CARD_ROAD, CARD_CITY, CARD_STORM, CARD_QUAKE, CARD_PLAGUE, CARD_HEAT, CARD_METEOR, CARD_TSUNAMI, CARD_BEAR, CARD_FIRE }

var state = HIDDEN
var current_card = CARD_ROAD
var saved_card = CARD_ROAD
var is_card_saved = false

var current_event = null
var allow_city = false
var allow_road = false
var pop_kill_abs = 0
var pop_kill_rel = 0
var event_score = 0

var card_probabilities = {
	CARD_ROAD: 2,
	CARD_CITY: 2,
	CARD_STORM: 1,
	CARD_QUAKE: 1,
	CARD_PLAGUE: 0.7,
	CARD_HEAT: 1.7,
	CARD_METEOR: 1,
	CARD_TSUNAMI: 1,
	CARD_BEAR: 0.5,
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

var card_sounds = {
	CARD_ROAD: preload("res://snd/build.wav"),
	CARD_CITY: preload("res://snd/build.wav"),
	CARD_STORM: preload("res://snd/wave.wav"),
	CARD_QUAKE: preload("res://snd/quake.wav"),
	CARD_PLAGUE: preload("res://snd/ambulance.wav"),
	CARD_HEAT: preload("res://snd/hot.wav"),
	CARD_METEOR: preload("res://snd/meteor.wav"),
	CARD_TSUNAMI: preload("res://snd/water.wav"),
	CARD_BEAR: preload("res://snd/bear.wav"),
	CARD_FIRE: preload("res://snd/firetruck.wav"),
}

var some_card_audio = [
	preload("res://snd/card.wav"),
	preload("res://snd/card2.wav"),
	preload("res://snd/card3.wav"),
]

func play_card_audio(card):
	$ActionSound.stream = card_sounds[card]
	$ActionSound.play(0)

func play_some_card_audio():
	$CardSound.stream = some_card_audio[randi() % some_card_audio.size()]
	$CardSound.play(0)

func do_card_action(card):
	$"/root/Root/Game".activate_item_preview(true)
	$"/root/Root/Game/ItemPrototype/Sprite".texture = card_icons[card]
	
	current_event = card
	allow_city = true
	allow_road = false
	pop_kill_abs = 5
	pop_kill_rel = 0
	event_score = 0

	match card:
		CARD_ROAD:
			allow_city = false
			$"/root/Root/Game".activate_road_building(true)
		CARD_CITY:
			allow_city = false
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
			event_score = 1.7
		CARD_HEAT:
			pop_kill_abs = 20 + randi() % 10
			pop_kill_rel = 0.05
			event_score = 0.1
		CARD_METEOR:
			allow_road = true
			pop_kill_abs = 50 + randi() % 50
			event_score = 2.0
		CARD_TSUNAMI:
			allow_road = true
			pop_kill_abs = 20 + randi() % 10
			event_score = 0.8
		CARD_BEAR:
			pop_kill_rel = 0.5
			pop_kill_abs = 50 + randi() % 150
			event_score = 1.2
		CARD_FIRE:
			pop_kill_rel = 0.4
			event_score = 0.8
		_:
			print("do card action: ", card)

func choose_card():
	card_probabilities[CARD_ROAD] = road_probability()
	var rval = randf()
	var probsum = 0
	for typ in CARD_TYPE.values():
		probsum += card_probabilities[typ]
	rval *= probsum
	
	# Cheats
	var good_prob = card_probabilities[CARD_ROAD] + card_probabilities[CARD_CITY]
	if Input.is_action_pressed("ui_page_up"):
		rval = (rval / probsum) * good_prob
	elif Input.is_action_pressed("ui_page_down"):
		rval = (rval / probsum) * (probsum - good_prob) + good_prob
	# End Cheats
	
	for typ in CARD_TYPE.values():
		if rval <= card_probabilities[typ]:
			if typ == CARD_ROAD and not can_build_road():
				rval -= card_probabilities[typ]
				continue
			$Viewport/Card.set_card_image(card_textures[typ])
			return typ
		rval -= card_probabilities[typ]

func road_probability():
	var c = $"/root/Root/Game/Cities".get_child_count()
	var r = $"/root/Root/Game/Roads".get_child_count()
	return max(0.1, (1 - (log(r) / log(c) - 1)) * card_probabilities[CARD_CITY] * 0.4)

func can_build_road():
	var c = $"/root/Root/Game/Cities".get_child_count()
	var r = $"/root/Root/Game/Roads".get_child_count()
	return (c * (c-1))/2 != r

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_Button_pressed()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_save"):
		_on_SaveButton_pressed()
		get_tree().set_input_as_handled()

func _on_Button_pressed():
	match state:
		HIDDEN:
			current_card = choose_card()
			$Viewport/Card.start_rotation()
			play_some_card_audio()
			state = ROTATING
		ROTATING:
			return
		SHOWING:
			return
		REMOVING:
			return

func remove_card():
	$Viewport/Card.start_remove()
	play_some_card_audio()
	state = REMOVING
	allow_city = false
	allow_road = false
	$"/root/Root/Game".activate_item_preview(false)
	$"/root/Root/Game".activate_city_building(false)
	$"/root/Root/Game".activate_road_building(false)

func _on_Card_finished_removing():
	state = HIDDEN

func _on_Card_finished_rotating():
	state = SHOWING
	play_some_card_audio()
	do_card_action(current_card)
	
func _on_road_built():
	play_card_audio(current_card)
	remove_card()

func _on_city_built():
	play_card_audio(current_card)
	$"/root/Root/Camera".update_camera_limits()
	remove_card()

func add_event_icon(city, icon):
	var event_sprite = Sprite.new()
	event_sprite.texture = icon
	event_sprite.scale.x = 0.5
	event_sprite.scale.y = 0.5
	var events = city.get_node("Events")
	var eventsBG = city.get_node("EventsBG")
	events.add_child(event_sprite)
	var freed = 0
	while events.get_child_count() - freed > 3:
		events.get_children()[0].queue_free()
		freed += 1
	var childs = events.get_children()
	var left = -40 * (childs.size() - freed) / 2 + 20
	eventsBG.rect_position.x = left - 24
	eventsBG.rect_size.x = 40 * (childs.size() - freed) + 8
	eventsBG.visible = (childs.size() - freed) > 0
	for i in range(freed, childs.size()):
		childs[i].position.x = left + (i - freed) * 40

func _on_city_clicked(city):
	if allow_city:
		play_card_audio(current_card)
		var multiplier = 1
		for i in range(min(3, city.events.size())):
			if city.events[-i-1] == current_event:
				multiplier += 1
		print("Multiplier: ", multiplier)
		var pop = city.population
		var death = 0
		death +=  pop_kill_abs * multiplier
		death += pop_kill_rel * pop * multiplier
		death = min(death, pop)
		pop -= death
		city.get_node("Death").display_death(-death)
		city.population = max(0, pop)
		city.event_score += (event_score + sqrt(death) / 20) * multiplier
		city.events.append(current_event)
		add_event_icon(city, card_icons[current_event])
		remove_card()

func _on_road_clicked(road):
	if allow_road:
		play_card_audio(current_card)
		road.queue_free()
		remove_card()

func _ready():
	randomize()
	$"/root/Root/Game".connect("road_built", self, "_on_road_built")
	$"/root/Root/Game".connect("city_built", self, "_on_city_built")
	$"/root/Root/Game".connect("city_clicked", self, "_on_city_clicked")
	$"/root/Root/Game".connect("road_clicked", self, "_on_road_clicked")


func _on_SaveButton_pressed():
	if is_card_saved:
		if state == HIDDEN:
			$"../SavedCard/Viewport/SavedCard".remove_card()
			current_card = saved_card
			is_card_saved = false
			$Viewport/Card.set_card_image(card_textures[current_card])
			$Viewport/Card.start_show()
			play_some_card_audio()
			state = ROTATING
	else:
		if state == SHOWING:
			saved_card = current_card
			is_card_saved = true
			$"../SavedCard/Viewport/SavedCard".set_card_image(card_textures[saved_card])
			$"../SavedCard/Viewport/SavedCard".show_card()
			remove_card()
