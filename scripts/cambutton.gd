extends TextureRect

var camstate : int = 1
var is_busy : bool = false

func _ready() -> void:
	$cam.mouse_entered.connect(camInput)
	
func camInput() -> void:
	if is_busy:
		return

	is_busy = true

	# --- OPEN CAMERA ---
	if camstate == 1 :
		$"../CameraFlip".visible = true
		$"../CameraFlip".play()
		$"../CameraFlip/flipnoise".play()
		
		# 1. Update the image BEFORE the animation finishes so it's ready
		# This handles showing the correct room (Stage, Dining, etc.) automatically
		
		await $"../CameraFlip".animation_finished
		$"../CameraFlip".visible = false
		$"../CameraFlip/flipnoise".stop()
		
		$"../map".update_camera_view($"../map".current_camera)
		# Show the UI
		$"../static".visible = true
		$"../whiterect".visible = true
		$"../RedDot".visible = true
		$"../map".visible = true
		
		# REMOVED: $"../../ShowStage".visible = true 
		# Reason: The 'update_camera_view' line above already handled this!
		
		camstate *= -1
		
	# --- CLOSE CAMERA ---
	else :
		# Hide the UI immediately
		$"../static".visible = false
		$"../whiterect".visible = false
		$"../RedDot".visible = false
		$"../map".visible = false
		$"../static2".visible = false
		$"../static2/static sound".stop()
		
		# 2. HIDE THE CURRENT ROOM
		# We ask the map script: "Who is currently active?" and hide that specific sprite.
		if $"../map".active_sprite != null:
			$"../map".active_sprite.visible = false
		
		camstate *= -1
		
		$"../CameraFlip".visible = true
		$"../CameraFlip".play_backwards()
		$"../CameraFlip/flipnoise".play()
		await $"../CameraFlip".animation_finished
		$"../CameraFlip".visible = false
		$"../CameraFlip/flipnoise".stop()

	await get_tree().create_timer(0.1).timeout
	is_busy = false
