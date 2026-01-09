extends Node

@export var ai_level : int = 20
const gameover : PackedScene = preload("res://scenes/gameover.tscn")

enum State { AWAY, AT_DOOR, JUMPSCARE }
var current_state = State.AWAY

@onready var door_sprite = $"../left door" 
@onready var main_script = $".." 

# FIX 1: Store the NODE, not the variable value
@onready var camera_button = $"../WinningTimer/cambutton" 

func _ready() -> void:
	$MoveTimer.timeout.connect(_on_move_opportunity)

func _on_move_opportunity() -> void:
	var roll = randi_range(1, 20)
	
	if roll <= ai_level:
		print("Bonnie Move Successful! (Rolled: ", roll, ")")
		handle_movement()
	else:
		print("Bonnie failed to move. (Rolled: ", roll, ")")

func handle_movement() -> void:
	match current_state:
		State.AWAY:
			print("Bonnie moved to the Door!")
			current_state = State.AT_DOOR
			
		State.AT_DOOR:
			if is_door_closed():
				print("Bonnie blocked! Returning to start.")
				current_state = State.AWAY
			else:
				print("JUMPSCARE!")
				current_state = State.JUMPSCARE
				BonnieJumpscare()

func is_door_closed() -> bool:
	if door_sprite.frame == 0:
		return false # Door is OPEN
	else:
		return true # Door is CLOSED

func BonnieJumpscare() -> void:
	# Stop winning timer
	$"../WinningTimer/clock/Timer".stop()
	
	$MoveTimer.stop()
	$"../ChicaAI/MoveTimer".stop()
	
	$"../main office/Camera2D".lock_to_center()
	$"../JumpScare noise".play()
	$"../BonnieJumpscare".visible = true
	$"../BonnieJumpscare".play()
	
	if camera_button.camstate != 1:
		$"../WinningTimer/static".visible = false
		$"../WinningTimer/whiterect".visible = false
		$"../WinningTimer/RedDot".visible = false
		$"../WinningTimer/map".visible = false
		camera_button.camstate = 1 
		$"../WinningTimer/CameraFlip".visible = true
		$"../WinningTimer/CameraFlip".play_backwards()
		$"../WinningTimer/CameraFlip/flipnoise".play()
		await $"../WinningTimer/CameraFlip".animation_finished
		$"../WinningTimer/CameraFlip".visible = false
		$"../WinningTimer/CameraFlip/flipnoise".stop()
		$"../WinningTimer/cambutton/cam".visible = false
	
	await get_tree().create_timer(1.0, true).timeout
	$"../JumpScare noise".stop()
	
	$"../BonnieJumpscare".visible = false
	$"../BonnieJumpscare".stop()
	$"../main office/Camera2D".set_process(true)
	get_tree().change_scene_to_packed(gameover)
