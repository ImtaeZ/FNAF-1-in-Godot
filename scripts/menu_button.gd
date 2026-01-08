extends Label
const nightstart : PackedScene = preload("res://scenes/nightstart.tscn")

func _ready() -> void:
	mouse_entered.connect(mouseEntered)
	
func mouseEntered() -> void:
	if get_tree().paused == false:
		if $"../arrow".position.y != position.y:
			$"../select".play()
		$"../arrow".position.y = position.y
	
func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "New Game":
			get_tree().paused = true
			$"../newspaper".visible = true
			$"../newspaper/AnimationPlayer".play("fade")
			$"../newspaper/AnimationPlayer".animation_finished.connect(animDone)

func animDone(animName : StringName) -> void:
	if animName == "fade":
		get_tree().change_scene_to_packed(nightstart)
