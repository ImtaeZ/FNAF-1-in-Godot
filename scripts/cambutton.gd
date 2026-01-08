extends TextureRect

func _ready() -> void:
	$cam.mouse_entered.connect(camInput)
	
func camInput() -> void:
	$"../CameraFlip".visible = true
	$"../CameraFlip".play()
	await $"../CameraFlip".animation_finished
	$"../CameraFlip".visible = false
