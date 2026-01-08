extends Node2D

func _ready() -> void:
	get_tree().paused = false
	$blip.play()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/title.tscn")
