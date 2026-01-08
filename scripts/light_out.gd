extends AnimatedSprite2D

const gameover : PackedScene = preload("res://scenes/gameover.tscn")

func lightout() -> void:
	$"../BonnieAI/MoveTimer".stop()
	$"../ChicaAI/MoveTimer".stop()
	
	if $"../left door".frame != 0 or $"../right door".frame != 0:
		print("close door")
		$"../left switch/door noise".play()
		$"../right switch/door noise".play()
	$"../WinningTimer/cambutton".visible = false
	$"../main office".frame = 5
	$"powerdown noise".play()
	$"../fan".visible = false
	$"../fan noise".stop()
	$"../left switch/light noise".stop()
	$"../right switch/light noise".stop()
	$"../left switch".visible = false
	$"../left door".visible = false
	$"../right switch".visible = false
	$"../right door".visible = false
	await get_tree().create_timer(3).timeout
	
	# Freddy Blip
	visible = true
	$".".play()
	$muscibox.play()
	var timer : float = 0.0
	var max_time : float = randf_range(10.0, 15.0) # Randomize how long the music lasts
	while timer < max_time:
		var flicker_wait = randf_range(0.05, 0.2)
		
		if randf() > 0.3:
			visible = true
		else:
			visible = false
		await get_tree().create_timer(flicker_wait).timeout
		timer += flicker_wait
	$".".stop()
	$muscibox.stop()
	visible = false
	
	# Freddy JUMPSCARE UR ASS
	$light.play()
	timer = 0.0
	max_time = 2
	while timer < max_time:
		var flicker_wait = randf_range(0.05, 0.2)
		
		if randf() > 0.5:
			$"../main office".visible = true
			$light.play()
		else:
			$"../main office".visible = false
			$light.stop()
		await get_tree().create_timer(flicker_wait).timeout
		timer += flicker_wait
		
	$light.stop()
	$"../main office".visible = false 
	$"../main office/Camera2D".lock_to_center()
	var randomtime = randi_range(1,5)
	await get_tree().create_timer(randomtime).timeout
	$"../freddyjumpscare".visible = true
	$"../freddyjumpscare".play()
	$"../freddyjumpscare/freddy jumpscarenoise".play()
	await get_tree().create_timer(1).timeout
	$"../freddyjumpscare".visible = false
	$"../freddyjumpscare".stop()
	$"../freddyjumpscare/freddy jumpscarenoise".stop()
	$"../main office/Camera2D".set_process(true)
	get_tree().change_scene_to_packed(gameover)
