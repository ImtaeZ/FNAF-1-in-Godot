extends AnimatedSprite2D

@onready var chica_ai = $"../ChicaAI"
var is_busy : bool = false

func _ready() -> void:
	$door.input_event.connect(doorInput)
	$light.input_event.connect(lightInput)
	$"light noise".stream_paused = true
	
func doorInput(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "right switch":
			if $"../right door".frame == 0 or $"../right door".frame == 13:
				$"door noise".play()
				# change switch frame
				match frame:
					0: frame = 1
					1: frame = 0
					2: frame = 3
					3: frame = 2
					
				# door animation
				if $"../right door".frame == 0:
					$"../right door".play()
				elif $"../right door".frame == 13:
					$"../right door".play_backwards()
				
func lightInput(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if is_busy:
		return
	
	if event.is_action_pressed("guiclick"):
		if name == "right switch":
			is_busy = true
			
			# change switch frame
			match frame:
				0: frame = 3
				3: frame = 0
				1: frame = 2
				2: frame = 1
				
			if $"../main office".frame == 1:
				if chica_ai.current_state == chica_ai.State.EAST_HALL_CORNER:
					await ChicaWindow()
				else:
					await LightBlip()	
			
			is_busy = false

func ChicaWindow() -> void:
	$"../windowscare".play()
	$"../main office".frame = 4
	await get_tree().create_timer(0.05).timeout
	$"../main office".frame = 1
	await get_tree().create_timer(0.1).timeout
	$"../main office".frame = 4
	await get_tree().create_timer(0.4).timeout
	$"../main office".frame = 1
	
	if frame == 0:
		frame = 3
	elif frame == 1:
		frame = 2
		
func LightBlip() -> void:
	$"light noise".stream_paused = false
	$"../main office".frame = 2
	await get_tree().create_timer(0.05).timeout
	$"../main office".frame = 1
	await get_tree().create_timer(0.1).timeout
	$"../main office".frame = 2
	await get_tree().create_timer(0.4).timeout
	$"../main office".frame = 1
	$"light noise".stream_paused = true
	
	if frame == 0:
		frame = 3
	elif frame == 1:
		frame = 2
