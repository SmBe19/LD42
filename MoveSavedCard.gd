extends Spatial

func set_card_image(texture):
	$Card/Content.texture = texture

func show_card():
	$Move.play("Show")

func remove_card():
	$Move.play("Remove")