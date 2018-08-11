extends Spatial

signal finished_removing
signal finished_rotating

func goto_jump():
	$Flip.play("Jump")

func send_finished_removing():
	emit_signal("finished_removing")
	
func send_finished_rotating():
	emit_signal("finished_rotating")
