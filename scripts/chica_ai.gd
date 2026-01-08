extends Node

@export var ai_level : int = 20
const gameover : PackedScene = preload("res://scenes/gameover.tscn")

enum State { AWAY, AT_DOOR, JUMPSCARE }
var current_state = State.AWAY

@onready var door_sprite = $"../right door" 
@onready var main_script = $".." 

func _ready() -> void:
	$MoveTimer.timeout.connect(_on_move_opportunity)

func _on_move_opportunity() -> void:
	var roll = randi_range(1, 20)
	
	if roll <= ai_level:
		print("Chica Move Successful! (Rolled: ", roll, ")")
		handle_movement()
	else:
		print("Chica failed to move. (Rolled: ", roll, ")")

func handle_movement() -> void:
	match current_state:
		State.AWAY:
			print("Chica moved to the Door!")
			current_state = State.AT_DOOR
			
		State.AT_DOOR:
			# Move from DOOR -> ???
			if is_door_closed():
				# BLOCKED! Go back to AWAY
				print("Chica blocked! Returning to start.")
				current_state = State.AWAY
			else:
				# SUCCESS! Attack!
				print("JUMPSCARE!")
				current_state = State.JUMPSCARE
				ChicaJumpscare()

func is_door_closed() -> bool:
	if door_sprite.frame == 0:
		return false # Door is OPEN
	else:
		return true # Door is CLOSED

func ChicaJumpscare() -> void:
	$"../BonnieAI/MoveTimer".stop()
	
	$"../main office/Camera2D".lock_to_center()
	$"../JumpScare noise".play()
	$"../ChicaJumpscare".visible = true
	$"../ChicaJumpscare".play()
	
	await get_tree().create_timer(1).timeout
	$"../JumpScare noise".stop()
	
	$"../ChicaJumpscare".visible = false
	$"../ChicaJumpscare".stop()
	$"../main office/Camera2D".set_process(true)
	get_tree().change_scene_to_packed(gameover)
