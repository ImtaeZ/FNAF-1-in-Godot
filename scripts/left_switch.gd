extends AnimatedSprite2D

@onready var bonnie_ai = $"../BonnieAI"
var is_busy : bool = false

func _ready() -> void:
	$door.input_event.connect(doorInput)
	$light.input_event.connect(lightInput)
	$"light noise".stream_paused = true
	
func doorInput(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "left switch":
			if $"../left door".frame == 0 or $"../left door".frame == 13:
				$"door noise".play()
				# change switch frame
				match frame:
					0: frame = 1
					1: frame = 0
					2: frame = 3
					3: frame = 2
					
				# door animation
				if $"../left door".frame == 0:
					$"../left door".play()
				elif $"../left door".frame == 13:
					$"../left door".play_backwards()
				
func lightInput(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if is_busy:
		return
	
	if event.is_action_pressed("guiclick"):
		if name == "left switch":
			is_busy = true
			
			# change switch frame
			match frame:
				0: frame = 2
				2: frame = 0
				1: frame = 3
				3: frame = 1
				
			if $"../main office".frame == 1:
				if bonnie_ai.current_state == 1:
					await BonnieWindow()
				else:
					await LightBlip()
				
			is_busy = false
			
func BonnieWindow() -> void:
	$"../windowscare".play()
	$"../main office".frame = 3
	await get_tree().create_timer(0.05).timeout
	$"../main office".frame = 1
	await get_tree().create_timer(0.1).timeout
	$"../main office".frame = 3
	await get_tree().create_timer(0.4).timeout
	$"../main office".frame = 1
	
	if frame == 2:
		frame = 0
	elif frame == 3:
		frame = 1
		
func LightBlip() -> void:
	$"light noise".stream_paused = false
	$"../main office".frame = 0
	await get_tree().create_timer(0.05).timeout
	$"../main office".frame = 1
	await get_tree().create_timer(0.1).timeout
	$"../main office".frame = 0
	await get_tree().create_timer(0.4).timeout
	$"../main office".frame = 1
	$"light noise".stream_paused = true
	
	if frame == 2:
		frame = 0
	elif frame == 3:
		frame = 1
