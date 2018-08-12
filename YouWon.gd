extends Node

var strings = [
	"Nature 1 : 0 Humans",
	"Nature is great again!",
	"You win!",
	"You won!",
	"Nature rises again!",
	"Nature defeated humanity!",
	"Humanity eradicated!",
]

func _on_MainMenu_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

func _on_Restart_pressed():
	get_tree().change_scene("res://Root.tscn")

func _ready():
	$Panel/Label.text = strings[randi() % strings.size()]

func _on_Timer_timeout():
	$Panel.visible = true
