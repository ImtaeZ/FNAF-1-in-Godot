extends Area2D

func _ready() -> void:
	input_event.connect(noseInput)

func noseInput(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "noseboop":
			if not $"boop sound".playing:
				$"boop sound".play()
				#$"../LightOut".lightout()
