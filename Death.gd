extends Node2D

func display_death(amount):
	$Animation.play("Show")
	$Text.text = str(round(amount))
	$DeathParticles.amount = abs(round(amount * PI))
	$DeathParticles.emitting = true
	$Timer.start()
	yield($Timer, "timeout")
	$DeathParticles.emitting = false
	$Animation.play("Hide")
