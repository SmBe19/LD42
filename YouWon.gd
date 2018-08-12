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

var kill_strings = [
	"You killed {} humans.",
	"You are responsible for {} deaths.",
	"{} human beings are now dead. Because of you.",
	"Before you eradicated them, the foul humans managed to produce {} of their kind.",
	"In your career you eradicated {} humans.",
	"{} x 10 tonnes of CO2 less per year.",
	"You saved the planet and killed {} beings in the process. Congratulations.",
	"Congratulations on {} successfull assassinations.",
]

func _on_MainMenu_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

func _on_Restart_pressed():
	get_tree().change_scene("res://Root.tscn")

func _ready():
	$Panel/Label.text = strings[randi() % strings.size()]
	var deaths = $"/root/Root/Game".total_killed
	$Panel/KillLabel.text = kill_strings[randi() % kill_strings.size()].replace("{}", str(round(deaths)))

func _on_Timer_timeout():
	$Panel.visible = true
