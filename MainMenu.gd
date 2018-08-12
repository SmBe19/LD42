extends Node

func _on_Start_pressed():
	get_tree().change_scene("res://Root.tscn")

func _on_Help_pressed():
	$HelpPanel.visible = not $HelpPanel.visible

func _on_Quit_pressed():
	get_tree().quit()

func _on_Close_pressed():
	$HelpPanel.visible = false
