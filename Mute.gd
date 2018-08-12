extends TextureButton

func _on_Mute_pressed():
	$"/root/Root/BackgroundMusic".playing = not $"/root/Root/BackgroundMusic".playing
