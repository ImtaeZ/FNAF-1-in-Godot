extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("sliding")
	$schoolbell.play()
	await get_tree().create_timer(3).timeout
	$yay.play()
	await get_tree().create_timer(7).timeout
	get_tree().change_scene_to_file("res://scenes/title.tscn")
