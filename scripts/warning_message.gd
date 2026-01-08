extends Label

const menu : PackedScene = preload("res://scenes/title.tscn")

func _ready() -> void:
	$AnimationPlayer.play("fade in")
	$AnimationPlayer.animation_finished.connect(animDone)
	
func animDone(animName : StringName) -> void:
	if animName == "fade in":
		get_tree().change_scene_to_packed(menu)
