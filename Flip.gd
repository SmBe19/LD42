extends Spatial

signal finished_removing
signal finished_rotating

func set_card_image(texture):
	$Card/Content.texture = texture

func start_rotation():
	$Flip.play("Rotate")

func start_remove():
	$Flip.play("RemoveCard")

func goto_jump():
	$Flip.play("Jump")

func send_finished_removing():
	emit_signal("finished_removing")
	
func send_finished_rotating():
	emit_signal("finished_rotating")
