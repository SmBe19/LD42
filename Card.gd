extends Node2D

enum { HIDDEN, ROTATING, SHOWING, REMOVING }

var state = HIDDEN

func _on_Button_pressed():
	match state:
		HIDDEN:
			$Viewport/Card/Flip.play("Rotate")
			state = ROTATING
		ROTATING:
			return
		SHOWING:
			$Viewport/Card/Flip.play("RemoveCard")
			state = REMOVING
		REMOVING:
			return


func _on_Card_finished_removing():
	state = HIDDEN


func _on_Card_finished_rotating():
	state = SHOWING
