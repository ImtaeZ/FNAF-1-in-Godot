extends TextureRect

var camstate : int = 1
var is_busy : bool = false # 1. Create the "Lock" variable

func _ready() -> void:
	$cam.mouse_entered.connect(camInput)
	
func camInput() -> void:
	if is_busy:
		return

	is_busy = true

	# Open Camera
	if camstate == 1 :
		$"../CameraFlip".visible = true
		$"../CameraFlip".play()
		await $"../CameraFlip".animation_finished
		$"../CameraFlip".visible = false
		
		# Show the UI
		$"../static".visible = true
		$"../whiterect".visible = true
		$"../RedDot".visible = true
		#$"../RedDot".play()
		$"../map".visible = true
		$"../../ShowStage".visible = true
		camstate *= -1
		
	# Close Camera
	else :
		# Hide the UI immediately (feels snappier)
		$"../static".visible = false
		$"../whiterect".visible = false
		$"../RedDot".visible = false
		$"../map".visible = false
		$"../../ShowStage".visible = false
		camstate *= -1
		
		$"../CameraFlip".visible = true
		$"../CameraFlip".play_backwards()
		await $"../CameraFlip".animation_finished
		$"../CameraFlip".visible = false

	# 4. OPTIONAL: Add a tiny extra delay (Cooldown)
	# This prevents the camera from accidentally popping back up instantly
	await get_tree().create_timer(0.2).timeout

	# 5. UNLOCK IT
	is_busy = false
