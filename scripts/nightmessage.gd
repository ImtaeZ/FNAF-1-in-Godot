extends Label

const office : PackedScene = preload("res://scenes/office.tscn")

func _ready() -> void:
	get_tree().paused = false
	$AnimationPlayer.play("fade out")
	$"../blip".play()
	$AnimationPlayer.animation_finished.connect(animDone)
	
func animDone(animName : StringName) -> void:
	if animName == "fade out":
		get_tree().change_scene_to_packed(office)
