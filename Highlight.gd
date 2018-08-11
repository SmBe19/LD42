extends Node2D

export (Color, RGB) var color = Color(0,0,0)


# class member variables go here, for example:
# var a = 2
# var b = "textvar"


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _draw():
	draw_circle(Vector2(0,0), 1.0, color)
	pass
